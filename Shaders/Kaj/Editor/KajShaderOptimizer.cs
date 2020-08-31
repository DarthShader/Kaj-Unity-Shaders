using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System;
using System.IO;
using System.Text.RegularExpressions;

// v2

namespace Kaj
{
    // Static methods to generate new shader files with in-place constants based on a material's properties
    // and link that new shader to the material automatically
    public class ShaderOptimizer
    {
        // For some reason, 'if' statements with replaced constant (literal) conditions cause some compilation error
        // So until that is figured out, branches will be removed by default
        // Set to false if you want to keep UNITY_BRANCH and [branch]
        public static bool RemoveUnityBranches = false;

        // LOD Crossfade Dithing doesn't have multi_compile keyword correctly toggled at build time (its always included) so
        // this hard-coded material property will uncomment //#pragma multi_compile _ LOD_FADE_CROSSFADE in optimized .shader files
        public static readonly string LODCrossFadePropertyName = "_DitheredLODCrossfade";

        // IgnoreProjector and ForceNoShadowCasting don't work as override tags, so material properties by these names
        // will determine whether or not //"IgnoreProjector"="True" etc. will be uncommented in optimized .shader files
        public static readonly string IgnoreProjectorPropertyName = "_IgnoreProjector";
        public static readonly string ForceNoShadowCastingPropertyName = "_ForceNoShadowCasting";

        // Material property suffix that controls whether the property of the same name gets baked into the optimized shader
        // i.e. if _Color exists and _ColorAnimated = 1, _Color will not be baked in
        public static readonly string AnimatedPropertySuffix = "Animated";

        // Properties can be assigned to preprocessor defined keywords via the optimizer (//KSOPropertyKeyword)
        // This is mainly targeted at culling interpolators and lines that rely on that input.
        // (The compiler is not smart enough to cull VS output that isn't used anywhere in the PS)
        // Additionally, simply enabling the optimizer can define a keyword, whose name is stored here.
        // This keyword is added to the beginning of all passes, right after CGPROGRAM
        public static readonly string OptimizerEnabledKeyword = "OPTIMIZER_ENABLED";

        // In-order list of inline sampler state names that will be replaced by InlineSamplerState() lines
        public static readonly string[] InlineSamplerStateNames = new string[]
        {
            "_linear_repeat",
            "_linear_clamp",
            "_linear_mirror",
            "_linear_mirroronce",
            "_point_repeat",
            "_point_clamp",
            "_point_mirror",
            "_point_mirroronce",
            "_trilinear_repeat",
            "_trilinear_clamp",
            "_trilinear_mirror",
            "_trilinear_mirroronce"
        };

        // Would be better to dynamically parse the "C:\Program Files\UnityXXXX\Editor\Data\CGIncludes\" folder
        // to get version specific includes but eh
        public static readonly string[] DefaultUnityShaderIncludes = new string[]
        {
            "UnityUI.cginc",
            "AutoLight.cginc",
            "GLSLSupport.glslinc",
            "HLSLSupport.cginc",
            "Lighting.cginc",
            "SpeedTreeBillboardCommon.cginc",
            "SpeedTreeCommon.cginc",
            "SpeedTreeVertex.cginc",
            "SpeedTreeWind.cginc",
            "TerrainEngine.cginc",
            "TerrainSplatmapCommon.cginc",
            "Tessellation.cginc",
            "UnityBuiltin2xTreeLibrary.cginc",
            "UnityBuiltin3xTreeLibrary.cginc",
            "UnityCG.cginc",
            "UnityCG.glslinc",
            "UnityCustomRenderTexture.cginc",
            "UnityDeferredLibrary.cginc",
            "UnityDeprecated.cginc",
            "UnityGBuffer.cginc",
            "UnityGlobalIllumination.cginc",
            "UnityImageBasedLighting.cginc",
            "UnityInstancing.cginc",
            "UnityLightingCommon.cginc",
            "UnityMetaPass.cginc",
            "UnityPBSLighting.cginc",
            "UnityShaderUtilities.cginc",
            "UnityShaderVariables.cginc",
            "UnityShadowLibrary.cginc",
            "UnitySprites.cginc",
            "UnityStandardBRDF.cginc",
            "UnityStandardConfig.cginc",
            "UnityStandardCore.cginc",
            "UnityStandardCoreForward.cginc",
            "UnityStandardCoreForwardSimple.cginc",
            "UnityStandardInput.cginc",
            "UnityStandardMeta.cginc",
            "UnityStandardParticleInstancing.cginc",
            "UnityStandardParticles.cginc",
            "UnityStandardParticleShadow.cginc",
            "UnityStandardShadow.cginc",
            "UnityStandardUtils.cginc"
        };

        public static readonly char[] ValidSeparators = new char[] {' ','\t','\n',';',',','.','(',')','[',']','{','}','>','<','=','!','&','|','^','+','-','*','/','#' };

        public static readonly string[] ValidPropertyDataTypes = new string[]
        {
            "float",
            "float2",
            "float3",
            "float4",
            "half",
            "half2",
            "half3",
            "half4",
            "fixed",
            "fixed2",
            "fixed3",
            "fixed4"
        };

        public enum PropertyType
        {
            Vector,
            Float
        }

        public class PropertyData
        {
            public PropertyType type;
            public string name;
            public Vector4 value;
        }

        public class Macro
        {
            public string name;
            public string[] args;
            public string contents;
        }

        public class ParsedShaderFile
        {
            public string filePath;
            public string contents;
        }

        public static bool Lock(Material material, MaterialProperty[] props)
        {
            // File filepaths and names
            Shader shader = material.shader;
            string shaderFilePath = AssetDatabase.GetAssetPath(shader);
            string materialFullName = AssetDatabase.GetAssetPath(material);
            // Remove the assets folder prefix safely (all mats should be in the assets folder anyway)
            if (materialFullName.StartsWith("Assets/"))
                materialFullName = materialFullName.Remove(0, "Assets/".Length);
            materialFullName = materialFullName.Remove(materialFullName.Length-".mat".Length, ".mat".Length);
            string smallguid = Guid.NewGuid().ToString().Split('-')[0];
            string newShaderName = shader.name + ".Optimized/" + material.name + "-" + smallguid;
            string newShaderDirectory = shaderFilePath.Remove(shaderFilePath.Length-".shader".Length, ".shader".Length) + ".Optimized/" + material.name + "-" + smallguid + "/";

            // Parse shader and cginc files, renaming them and moving them to a new directory
            // Also gets preprocessor macros
            List<ParsedShaderFile> shaderFiles = new List<ParsedShaderFile>();
            List<Macro> macros = new List<Macro>();
            if (!ParseShaderFilesRecursive(props, shaderFiles, newShaderDirectory, newShaderName, shaderFilePath, macros))
                return false;

            // Get collection of all properties to replace
            List<PropertyData> constantProps = new List<PropertyData>();
            foreach (MaterialProperty prop in props)
            {
                // Check for the convention 'Animated' Property to be true otherwise assume all properties are constant
                MaterialProperty animatedProp = Array.Find(props, x => x.name == prop.name + AnimatedPropertySuffix);
                if (animatedProp != null && animatedProp.floatValue == 1)
                    continue;

                PropertyData propData;
                switch(prop.type)
                {
                    case MaterialProperty.PropType.Color:
                        propData = new PropertyData();
                        propData.type = PropertyType.Vector;
                        propData.name = prop.name;
                        // Could probably check for Gamma space color property flag
                        propData.value = prop.colorValue.linear;
                        constantProps.Add(propData);
                        break;
                    case MaterialProperty.PropType.Vector:
                        propData = new PropertyData();
                        propData.type = PropertyType.Vector;
                        propData.name = prop.name;
                        propData.value = prop.vectorValue;
                        constantProps.Add(propData);
                        break;
                    case MaterialProperty.PropType.Float:
                        propData = new PropertyData();
                        propData.type = PropertyType.Float;
                        propData.name = prop.name;
                        propData.value = new Vector4(prop.floatValue, 0, 0, 0);
                        constantProps.Add(propData);
                        break;
                    case MaterialProperty.PropType.Range:
                        propData = new PropertyData();
                        propData.type = PropertyType.Float;
                        propData.name = prop.name;
                        propData.value = new Vector4(prop.floatValue, 0, 0, 0);
                        constantProps.Add(propData);
                        break;
                    case MaterialProperty.PropType.Texture:
                        if (prop.textureDimension == UnityEngine.Rendering.TextureDimension.Tex2D)
                        {
                            animatedProp = Array.Find(props, x => x.name == prop.name + "_ST" + AnimatedPropertySuffix);
                            if (!(animatedProp != null && animatedProp.floatValue == 1))
                            {
                                PropertyData ST = new PropertyData();
                                ST.type = PropertyType.Vector;
                                ST.name = prop.name + "_ST";
                                Vector2 offset = material.GetTextureOffset(prop.name);
                                Vector2 scale = material.GetTextureScale(prop.name);
                                ST.value = new Vector4(scale.x, scale.y, offset.x, offset.y);
                                constantProps.Add(ST);
                            }
                            animatedProp = Array.Find(props, x => x.name == prop.name + "_TexelSize" + AnimatedPropertySuffix);
                            if (!(animatedProp != null && animatedProp.floatValue == 1))
                            {
                                PropertyData TexelSize = new PropertyData();
                                TexelSize.type = PropertyType.Vector;
                                TexelSize.name = prop.name + "_TexelSize";
                                Texture t = prop.textureValue;
                                if (t != null)
                                    TexelSize.value = new Vector4(1.0f / t.width, 1.0f / t.height, t.width, t.height);
                                else TexelSize.value = new Vector4(1.0f, 1.0f, 1.0f, 1.0f);
                                constantProps.Add(TexelSize);
                            }

                        }
                        break;
                }
            }

            // Loop back through each new file to apply macros and replace properties
            foreach (ParsedShaderFile psf in shaderFiles)
            {
                string fileContents = psf.contents;
                string output = null;
                if (psf.filePath.EndsWith(".shader"))
                {
                    // Shader property declarations and properties as blending/stencil settings aren't a problem
                    // because they're only in .shader files outside the CG blocks, so isolate CG blocks and
                    // treat each of them like a full cginclude file
                    // Cheese it and only process any text between CGPROGRAM and ENDCG and CGINCLUDE and ENDCG anywhere
                    // Should probably stringbuilder these
                    output = "";
                    int cgIndex;
                    while ((cgIndex = fileContents.IndexOf("CGINCLUDE")) != -1)
                    {
                        output += fileContents.Substring(0, cgIndex + "CGINCLUDE".Length);
                        fileContents = fileContents.Remove(0, cgIndex + "CGINCLUDE".Length);
                        int ENDCG = fileContents.IndexOf("ENDCG");
                        string cg = fileContents.Substring(0, ENDCG);
                        fileContents = fileContents.Remove(0, ENDCG);
                        output += ReplaceShaderValues(cg, constantProps, macros);
                    }
                    while ((cgIndex = fileContents.IndexOf("CGPROGRAM")) != -1)
                    {
                        output += fileContents.Substring(0, cgIndex + "CGPROGRAM".Length);
                        fileContents = fileContents.Remove(0, cgIndex + "CGPROGRAM".Length);
                        int ENDCG = fileContents.IndexOf("ENDCG");
                        string cg = fileContents.Substring(0, ENDCG);
                        fileContents = fileContents.Remove(0, ENDCG);
                        output += ReplaceShaderValues(cg, constantProps, macros);
                    }
                    output += fileContents;
                }
                else output = ReplaceShaderValues(fileContents, constantProps, macros);

                // Write output to file
                (new FileInfo(newShaderDirectory + psf.filePath)).Directory.Create();
                try
                {
                    StreamWriter sw = new StreamWriter(newShaderDirectory + psf.filePath);
                    sw.Write(output);
                    sw.Close();
                }
                catch (IOException e)
                {
                    Debug.LogError("[Kaj Shader Optimizer] Processed shader file " + newShaderDirectory + psf.filePath + " could not be written.  " + e.ToString());
                    return false;
                }
            }
            AssetDatabase.Refresh();

            // Write original shader to override tag
            material.SetOverrideTag("OriginalShader", shader.name);
            // Write the new shader name in an override tag so ONLY EXACTLY THAT SUBFOLDER WILL GET DELETED
            material.SetOverrideTag("OptimizedShaderFolder", newShaderDirectory);

            // For some reason when shaders are swapped on a material the RenderType override tag gets completely deleted and render queue set back to -1
            // So these are saved as temp values and reassigned after switching shaders
            string renderType = material.GetTag("RenderType", false, "");
            int renderQueue = material.renderQueue;

            // Actually switch the shader
            Shader newShader = Shader.Find(newShaderName);
            if (newShader == null)
            {
                Debug.LogError("[Kaj Shader Optimizer] Generated shader " + newShaderName + " could not be found");
                return false;
            }
            material.shader = newShader;
            material.SetOverrideTag("RenderType", renderType);
            material.renderQueue = renderQueue;

            return true;
        }

        // This function not only exists to get a list of all cgincludes referenced by a main shader
        // but also to change absolute paths on #include lines and write new files
        // A little dirty because recursive cginc parsing is mixed in with main .shader file parsing
        private static bool ParseShaderFilesRecursive(MaterialProperty[] props, List<ParsedShaderFile> filesParsed, string newTopLevelDirectory, string newShaderName, string filePath, List<Macro> macros)
        {
            // Infinite recursion check
            if (filesParsed.Exists(x => x.filePath == filePath)) return true;

            ParsedShaderFile psf = null;
            psf = new ParsedShaderFile();
            psf.filePath = filePath;
            filesParsed.Add(psf);

            // Read file
            string fileContents = null;
            try
            {
                StreamReader sr = new StreamReader(filePath);
                fileContents = sr.ReadToEnd();
                sr.Close();
            }
            catch (FileNotFoundException e)
            {
                Debug.LogError("[Kaj Shader Optimizer] Shader file " + filePath + " not found.  " + e.ToString());
                return false;
            }
            catch (IOException e)
            {
                Debug.LogError("[Kaj Shader Optimizer] Error reading shader file.  " + e.ToString());
                return false;
            }

            // Parse file line by line
            bool isMainShaderFile = filePath.EndsWith(".shader");
            bool shaderHeaderFound = false;
            List<String> macrosList = new List<string>();
            string[] fileLines = Regex.Split(fileContents, "\r\n|\r|\n");
            for (int i=0; i<fileLines.Length; i++)
            {
                string lineParsed = fileLines[i].Replace(" ", "").Replace("\t", "");

                // Rename the main shader in the file
                if (isMainShaderFile && !shaderHeaderFound)
                    // Quickly find the Shader name header without complicated regex or parsing logic
                    // Can false positive on lines between /* */ comments
                    if (lineParsed.StartsWith("Shader"))
                    {
                        string originalSgaderName = lineParsed.Split('\"')[1];
                        fileLines[i] = fileLines[i].Replace(originalSgaderName, newShaderName);
                        shaderHeaderFound = true;
                    }

                // Recurse on cgincludes
                // UsePass referenced shaders currently not supported!
                // Quickly find include directives without complicated regex or parsing logic
                // Can false positive on lines between /* */ comments
                // will fail on "#  include" so people learn their lesson
                if (lineParsed.StartsWith("#include"))
                {
                    lineParsed = lineParsed.Split('\"')[1];

                    // Skip default includes
                    if (Array.Exists(DefaultUnityShaderIncludes, x => x.Equals(lineParsed, StringComparison.InvariantCultureIgnoreCase)))
                        continue;

                    // cginclude filepath is either absolute or relative
                    if (lineParsed.StartsWith("Assets/"))
                    {
                        if (!ParseShaderFilesRecursive(props, filesParsed, newTopLevelDirectory, newShaderName, lineParsed, macros))
                            return false;
                        // Only absolute filepaths need to be renampped in-file
                        fileLines[i] = fileLines[i].Replace(lineParsed, newTopLevelDirectory + lineParsed);
                    }
                    else
                    {
                        string fullpath = GetFullPath(lineParsed, Path.GetDirectoryName(filePath));
                        if (!ParseShaderFilesRecursive(props, filesParsed, newTopLevelDirectory, newShaderName, fullpath, macros))
                            return false;
                    }
                }
                else if (lineParsed == "//KSOEvaluateMacro")
                {
                    string macro = "";
                    do
                    {
                        i++;
                        if (fileLines[i].TrimEnd().EndsWith("\\"))
                            macro += fileLines[i].TrimEnd().TrimEnd('\\') + '\n'; // keep new lines in macro to make output more readable
                        else macro += fileLines[i].TrimEnd().TrimEnd('\\');
                    } 
                    while (fileLines[i].TrimEnd().EndsWith("\\"));
                    macrosList.Add(macro);
                }
                else if (lineParsed.StartsWith("//#pragmamulti_compile_LOD_FADE_CROSSFADE"))
                {
                    MaterialProperty crossfadeProp = Array.Find(props, x => x.name == LODCrossFadePropertyName);
                    if (crossfadeProp != null && crossfadeProp.floatValue == 1)
                        fileLines[i] = fileLines[i].Replace("//#pragma", "#pragma");
                }
                else if (lineParsed.StartsWith("//\"IgnoreProjector\"=\"True\""))
                {
                    MaterialProperty projProp = Array.Find(props, x => x.name == IgnoreProjectorPropertyName);
                    if (projProp != null && projProp.floatValue == 1)
                        fileLines[i] = fileLines[i].Replace("//\"IgnoreProjector", "\"IgnoreProjector");
                }
                else if (lineParsed.StartsWith("//\"ForceNoShadowCasting\"=\"True\""))
                {
                    MaterialProperty forceNoShadowsProp = Array.Find(props, x => x.name == ForceNoShadowCastingPropertyName);
                    if (forceNoShadowsProp != null && forceNoShadowsProp.floatValue == 1)
                        fileLines[i] = fileLines[i].Replace("//\"ForceNoShadowCasting", "\"ForceNoShadowCasting");
                }
                else if (lineParsed.StartsWith("//KSOInlineSamplerState("))
                {
                    // example usage: //KSOInlineSamplerState(_MainTex, _SpecularAnisotropyTangentMap)
                    // Will replace all instances of argument 0 (_MainTex) on the next line with the samplerstate
                    // corresponding to the wrap/filter mode of the texture of name argument 1 (_SpecularAnisotropyTangentMap)
                    int firstParenthesis = lineParsed.IndexOf('(');
                    int lastParenthesis = lineParsed.IndexOf(')');
                    string argsString = lineParsed.Substring(firstParenthesis+1, lastParenthesis - firstParenthesis-1);
                    string[] args = argsString.Split(',');
                    MaterialProperty texProp = Array.Find(props, x => x.name == args[1]);
                    if (texProp != null)
                    {
                        Texture t = texProp.textureValue;
                        int inlineSamplerIndex = 0;
                        if (t != null)
                        {
                            switch (t.filterMode)
                            {
                                case FilterMode.Bilinear:
                                    break;
                                case FilterMode.Point:
                                    inlineSamplerIndex += 1 * 4;
                                    break;
                                case FilterMode.Trilinear:
                                    inlineSamplerIndex += 2 * 4;
                                    break;
                            }
                            switch (t.wrapMode)
                            {
                                case TextureWrapMode.Repeat:
                                    break;
                                case TextureWrapMode.Clamp:
                                    inlineSamplerIndex += 1;
                                    break;
                                case TextureWrapMode.Mirror:
                                    inlineSamplerIndex += 2;
                                    break;
                                case TextureWrapMode.MirrorOnce:
                                    inlineSamplerIndex += 3;
                                    break;
                            }
                        }

                        // Replace the token on the following line
                        fileLines[i+1] = fileLines[i+1].Replace(args[0], InlineSamplerStateNames[inlineSamplerIndex]);
                    }
                    else Debug.LogWarning("[Kaj Shader Optimizer] KSOInlineSamplerState on texture " + args[1] + " failed, texture not found.");
                }
                else if (lineParsed.StartsWith("//KSOPropertyKeyword("))
                {
                    // replace this line with #define _PROPERTY floatValue
                }
            }
            if (isMainShaderFile && !shaderHeaderFound)
            {
                Debug.LogError("[Kaj Shader Optimizer] Could not rename " + filePath + " to new shader name " + newShaderName);
                return false;
            }

            // Prepare the macros list into pattern matchable structs
            foreach (string macroString in macrosList)
            {
                string m = macroString;
                Macro macro = new Macro();
                m = m.TrimStart();
                if (m[0] != '#') continue;
                m = m.Remove(0, "#".Length).TrimStart();
                if (!m.StartsWith("define")) continue;
                m = m.Remove(0, "define".Length).TrimStart();
                int firstParenthesis = m.IndexOf('(');
                macro.name = m.Substring(0, firstParenthesis);
                m = m.Remove(0, firstParenthesis + "(".Length);
                int lastParenthesis = m.IndexOf(')');
                string allArgs = m.Substring(0, lastParenthesis).Replace(" ", "").Replace("\t", "");
                macro.args = allArgs.Split(',');
                m = m.Remove(0, lastParenthesis + ")".Length);
                macro.contents = m;
                macros.Add(macro);
            }

            // Recombine file after parse
            fileContents = "";
            foreach (string line in fileLines)
                fileContents += line + '\n';

            // Save processed file into psf list
            psf.contents = fileContents;
            return true;
        }

        // error CS1501: No overload for method 'Path.GetFullPath' takes 2 arguments
        // Thanks Unity
        public static string GetFullPath(string relativePath, string basePath)
        {
            while (relativePath.StartsWith("./"))
                relativePath = relativePath.Remove(0, "./".Length);
            while (relativePath.StartsWith("../"))
            {
                basePath = basePath.Remove(basePath.LastIndexOf("/"), basePath.Length - basePath.LastIndexOf("/"));
                relativePath = relativePath.Remove(0, "../".Length);
            }
            return basePath + '/' + relativePath;
        }
 
        // Replace properties! The meat of the shader optimization process
        // For each constantProp, pattern match and find each instance of the property that isn't a declaration
        private static string ReplaceShaderValues(string originalText, List<PropertyData> constants, List<Macro> macros)
        {
            // Apply all macros
            foreach (Macro macro in macros)
            {
                string macroProcessed = "";
                int macroIndex;
                while ((macroIndex = originalText.IndexOf(macro.name)) != -1)
                {
                    macroProcessed += originalText.Substring(0, macroIndex);
                    // Skip macro definitions
                    if (macroProcessed.Replace(" ", "").Replace("\t", "").EndsWith("#define"))
                    {
                        macroProcessed += originalText.Substring(macroIndex, macro.name.Length);
                        originalText = originalText.Remove(0, macroIndex + macro.name.Length);
                        continue;
                    }
                    // Skip instances where macro name doesn't have '(' directly to the right, as it is a subname of something else
                    string restOftheFile = originalText.Substring(macroIndex + macro.name.Length).Trim();
                    if (!restOftheFile.StartsWith("("))
                    {
                        macroProcessed += originalText.Substring(macroIndex, macro.name.Length);
                        originalText = originalText.Remove(0, macroIndex + macro.name.Length);
                        continue;
                    }
                    // Remove macro name, find next '(' and ')' and call everything between that args
                    // Will fail on expressions, but I don't want to do the regex atm
                    originalText = originalText.Remove(0, macroIndex + macro.name.Length); // Remove macro.name
                    int firstParenthesis = originalText.IndexOf("(");
                    originalText = originalText.Remove(0, firstParenthesis + "(".Length); // Remove whitespiace and first parenthesis
                    int lastParenthesis = originalText.IndexOf(")");
                    string allArgs = originalText.Substring(0, lastParenthesis);
                    originalText = originalText.Remove(0, lastParenthesis + ")".Length); // Remove whitespace and args up to closing parenthesis
                    // Again, this will fail unless macro use is very basic
                    string[] args = allArgs.Split(',');
                    for (int i=0; i<args.Length;i++)
                        args[i] = args[i].Trim(); // Remove whitespace on args

                    string newContents = macro.contents;
                    for (int i=0; i<args.Length; i++)
                    {
                        string contentsProcessed = "";
                        int argIndex;
                        while ((argIndex = newContents.IndexOf(macro.args[i])) != -1)
                        {
                            contentsProcessed += newContents.Substring(0, argIndex);
                            // check to see if chars to the left and right of args are valid separator chars
                            char charLeft = newContents[argIndex-1];
                            char charRight = newContents[argIndex+macro.args[i].Length];
                            if (Array.Exists(ValidSeparators, x => x == charLeft) && Array.Exists(ValidSeparators, x => x == charRight))
                            {
                                contentsProcessed += args[i]; // Replace the arg!
                            } else contentsProcessed += macro.args[i]; // False positive, arg name is probably sub-name of another symbol
                            newContents = newContents.Remove(0, argIndex + macro.args[i].Length); // remove original arg name from macro contents that are being processed
                        }
                        contentsProcessed += newContents; // Append the rest of the macro
                        newContents = contentsProcessed; // Reset for next argument loop
                    }
                    
                    newContents = newContents.Replace("##", ""); // Remove token pasting separators
                    macroProcessed += newContents; // Append the processed macro
                }
                macroProcessed += originalText; // Append the rest of the file
                originalText = macroProcessed; // Reset whole text file for next macro
            }

            // Loop through text another time to replace constants
            foreach (PropertyData constant in constants)
            {
                string constantProcessed = "";
                int constantIndex;
                while ((constantIndex = originalText.IndexOf(constant.name)) != -1)
                {
                    constantProcessed += originalText.Substring(0, constantIndex);
                    // Check for valid left and right characters
                    char charLeft = originalText[constantIndex-1];
                    char charRight = originalText[constantIndex + constant.name.Length];
                    // Skip invalid matches (probably a subname in another symbol)
                    if (!(Array.Exists(ValidSeparators, x => x == charLeft) && Array.Exists(ValidSeparators, x => x == charRight)))
                    {
                        constantProcessed += originalText.Substring(constantIndex, constant.name.Length);
                        originalText = originalText.Remove(0, constantIndex + constant.name.Length);
                        continue;
                    }
                    // Skip basic declarations of unity shader properties i.e. "uniform float4 _Color;"
                    // whitespace removed string immediately to the left should be float or float4
                    // whitespace removed character immediately to the right should be ;
                    string precedingText = constantProcessed.TrimEnd();
                    string restOftheFile = originalText.Substring(constantIndex + constant.name.Length).Trim();
                    //Debug.Log(constant.name + " declaration testing");
                    if (Array.Exists(ValidPropertyDataTypes, x => precedingText.EndsWith(x)) && restOftheFile.StartsWith(";"))
                    {
                        constantProcessed += originalText.Substring(constantIndex, constant.name.Length);
                        originalText = originalText.Remove(0, constantIndex + constant.name.Length);
                        continue;
                    }

                    // Replace with constant!
                    switch (constant.type)
                    {
                        case PropertyType.Float:
                            constantProcessed += "float(" + constant.value.x + ")";
                            break;
                        case PropertyType.Vector:
                            constantProcessed += "float4("+constant.value.x+","+constant.value.y+","+constant.value.z+","+constant.value.w+")";
                            break;
                    }
                    originalText = originalText.Remove(0, constantIndex + constant.name.Length);
                }
                constantProcessed += originalText; // append the rest of the file
                originalText = constantProcessed; // Reset whole text file for next constant
            }

            // Lastly, hard replace UNITY_BRANCH or [branch] if the setting is enabled
            if (RemoveUnityBranches)
                originalText = originalText.Replace("UNITY_BRANCH", "").Replace("[branch]", "");

            return originalText;
        }

        public static bool Unlock (Material material)
        {
            // Revert to original shader
            string originalShaderName = material.GetTag("OriginalShader", false, "");
            if (originalShaderName == "")
            {
                Debug.LogError("[Kaj Shader Optimizer] Original shader not saved to material, could not unlock shader");
                return false;
            }
            Shader orignalShader = Shader.Find(originalShaderName);
            if (orignalShader == null)
            {
                Debug.LogError("[Kaj Shader Optimizer] Original shader " + originalShaderName + " could not be found");
                return false;
            }

            // For some reason when shaders are swapped on a material the RenderType override tag gets completely deleted and render queue set back to -1
            // So these are saved as temp values and reassigned after switching shaders
            string renderType = material.GetTag("RenderType", false, "");
            int renderQueue = material.renderQueue;
            material.shader = orignalShader;
            material.SetOverrideTag("RenderType", renderType);
            material.renderQueue = renderQueue;

            // Delete the variants folder and all files in it, as to not orhpan files and inflate Unity project
            string shaderDirectory = material.GetTag("OptimizedShaderFolder", false, "");
            if (shaderDirectory == "")
            {
                Debug.LogError("[Kaj Shader Optimizer] Optimized shader folder could not be found, not deleting anything");
                return false;
            }
            // Both safe ways of removing the shader make the editor GUI throw an error, so just don't refresh the
            // asset database immediately
            //AssetDatabase.DeleteAsset(shaderFilePath);
            FileUtil.DeleteFileOrDirectory(shaderDirectory);
            FileUtil.DeleteFileOrDirectory(shaderDirectory.TrimEnd('/') + ".meta");
            //AssetDatabase.Refresh();

            return true;
        }
    }
}