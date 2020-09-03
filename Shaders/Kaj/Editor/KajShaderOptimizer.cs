using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Text;

// v3

namespace Kaj
{
    // Static methods to generate new shader files with in-place constants based on a material's properties
    // and link that new shader to the material automatically
    public class ShaderOptimizer
    {
        // For some reason, 'if' statements with replaced constant (literal) conditions cause some compilation error
        // So until that is figured out, branches will be removed by default
        // Set to false if you want to keep UNITY_BRANCH and [branch]
        public static bool RemoveUnityBranches = true;

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
        // NOT IMPLEMENTED YET
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
            public string[] lines;
        }

        public static bool Lock(Material material, MaterialProperty[] props)
        {
            // File filepaths and names
            Shader shader = material.shader;
            string shaderFilePath = AssetDatabase.GetAssetPath(shader);
            string materialFilePath = AssetDatabase.GetAssetPath(material);
            string materialFolder = Path.GetDirectoryName(materialFilePath);
            string smallguid = Guid.NewGuid().ToString().Split('-')[0];
            string newShaderName = shader.name + ".Optimized/" + material.name + "-" + smallguid;
            string newShaderDirectory = materialFolder + "/OptimizedShaders/" + material.name + "-" + smallguid + "/";

            // Get collection of all properties to replace
            List<PropertyData> constantProps = new List<PropertyData>();
            foreach (MaterialProperty prop in props)
            {
                if (prop == null) continue;
                // Properties ending with convention suffix will be skipped!
                if (prop.name.EndsWith(AnimatedPropertySuffix)) continue;

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
                        if ((prop.flags & MaterialProperty.PropFlags.Gamma) == 0)
                            propData.value = prop.colorValue.linear;
                        else propData.value = prop.colorValue;
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
                        break;
                }
            }
                
            // Parse shader and cginc files, also gets preprocessor macros
            List<ParsedShaderFile> shaderFiles = new List<ParsedShaderFile>();
            List<Macro> macros = new List<Macro>();
            if (!ParseShaderFilesRecursiveNew(shaderFiles, newShaderDirectory, shaderFilePath, macros))
                return false;

            
            // Loop back through and do macros, props, and all other things line by line as to save string ops
            // Will still be a massive n2 operation from each line * each property
            foreach (ParsedShaderFile psf in shaderFiles)
            {
                // Shader file specific stuff
                if (psf.filePath.EndsWith(".shader"))
                {
                    for (int i=0; i<psf.lines.Length;i++)
                    {
                        string trimmedLine = psf.lines[i].TrimStart();
                        if (trimmedLine.StartsWith("Shader"))
                        {
                            string originalSgaderName = psf.lines[i].Split('\"')[1];
                            psf.lines[i] = psf.lines[i].Replace(originalSgaderName, newShaderName);
                        }
                        else if (trimmedLine.StartsWith("//#pragmamulti_compile_LOD_FADE_CROSSFADE"))
                        {
                            MaterialProperty crossfadeProp = Array.Find(props, x => x.name == LODCrossFadePropertyName);
                            if (crossfadeProp != null && crossfadeProp.floatValue == 1)
                                psf.lines[i] = psf.lines[i].Replace("//#pragma", "#pragma");
                        }
                        else if (trimmedLine.StartsWith("//\"IgnoreProjector\"=\"True\""))
                        {
                            MaterialProperty projProp = Array.Find(props, x => x.name == IgnoreProjectorPropertyName);
                            if (projProp != null && projProp.floatValue == 1)
                                psf.lines[i] = psf.lines[i].Replace("//\"IgnoreProjector", "\"IgnoreProjector");
                        }
                        else if (trimmedLine.StartsWith("//\"ForceNoShadowCasting\"=\"True\""))
                        {
                            MaterialProperty forceNoShadowsProp = Array.Find(props, x => x.name == ForceNoShadowCastingPropertyName);
                            if (forceNoShadowsProp != null && forceNoShadowsProp.floatValue == 1)
                                psf.lines[i] = psf.lines[i].Replace("//\"ForceNoShadowCasting", "\"ForceNoShadowCasting");
                        }
                        else if (trimmedLine.StartsWith("CGINCLUDE"))
                        {
                            for (int j=i+1; j<psf.lines.Length;j++)
                                if (psf.lines[j].TrimStart().StartsWith("ENDCG"))
                                {
                                    ReplaceShaderValuesNew(psf.lines, i+1, j, props, constantProps, macros);
                                    break;
                                }
                        }
                        else if (trimmedLine.StartsWith("CGPROGRAM"))
                        {
                            for (int j=i+1; j<psf.lines.Length;j++)
                                if (psf.lines[j].TrimStart().StartsWith("ENDCG"))
                                {
                                    ReplaceShaderValuesNew(psf.lines, i+1, j, props, constantProps, macros);
                                    break;
                                }
                        }
                    }
                }
                else // CGINC file
                    ReplaceShaderValuesNew(psf.lines, 0, psf.lines.Length, props, constantProps, macros);

                // Recombine file lines into a single string
                int totalLen = psf.lines.Length; // extra space for newline chars
                foreach (string line in psf.lines)
                    totalLen += line.Length;
                StringBuilder sb = new StringBuilder(totalLen);
                // This appendLine function is incompatible with the '\n's that are being added elsewhere
                foreach (string line in psf.lines)
                    sb.AppendLine(line);
                string output = sb.ToString();

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
            // Write the new shader folder name in an override tag so it will be deleted 
            material.SetOverrideTag("OptimizedShaderFolder", material.name + "-" + smallguid);

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

        // Preprocess each file for macros and includes
        // Save each file as string[], parse each macro with //KSOEvaluateMacro
        // Only editing done is replacing #include "X" filepaths where necessary
        private static bool ParseShaderFilesRecursiveNew(List<ParsedShaderFile> filesParsed, string newTopLevelDirectory, string filePath, List<Macro> macros)
        {
            // Infinite recursion check
            if (filesParsed.Exists(x => x.filePath == filePath)) return true;

            ParsedShaderFile psf = new ParsedShaderFile();
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
            List<String> macrosList = new List<string>();
            string[] fileLines = Regex.Split(fileContents, "\r\n|\r|\n");
            for (int i=0; i<fileLines.Length; i++)
            {
                string lineParsed = fileLines[i].TrimStart();
                // Specifically requires no whitespace between # and include, as it should be
                if (lineParsed.StartsWith("#include"))
                {
                    int firstQuotation = lineParsed.IndexOf('\"',0);
                    int lastQuotation = lineParsed.IndexOf('\"',firstQuotation+1);
                    string includeFilename = lineParsed.Substring(firstQuotation+1, lastQuotation-firstQuotation-1);

                    // Skip default includes
                    if (Array.Exists(DefaultUnityShaderIncludes, x => x.Equals(includeFilename, StringComparison.InvariantCultureIgnoreCase)))
                        continue;

                    // cginclude filepath is either absolute or relative
                    if (includeFilename.StartsWith("Assets/"))
                    {
                        if (!ParseShaderFilesRecursiveNew(filesParsed, newTopLevelDirectory, includeFilename, macros))
                            return false;
                        // Only absolute filepaths need to be renampped in-file
                        fileLines[i] = fileLines[i].Replace(includeFilename, newTopLevelDirectory + includeFilename);
                    }
                    else
                    {
                        string includeFullpath = GetFullPath(includeFilename, Path.GetDirectoryName(filePath));
                        if (!ParseShaderFilesRecursiveNew(filesParsed, newTopLevelDirectory, includeFullpath, macros))
                            return false;
                    }
                }
                // Specifically requires no whitespace between // and KSOEvaluateMacro
                else if (lineParsed == "//KSOEvaluateMacro")
                {
                    string macro = "";
                    string lineTrimmed = null;
                    do
                    {
                        i++;
                        lineTrimmed = fileLines[i].TrimEnd();
                        if (lineTrimmed.EndsWith("\\"))
                            macro += lineTrimmed.TrimEnd('\\') + Environment.NewLine; // keep new lines in macro to make output more readable
                        else macro += lineTrimmed;
                    } 
                    while (lineTrimmed.EndsWith("\\"));
                    macrosList.Add(macro);
                }
            }

            // Prepare the macros list into pattern matchable structs
            // Revise this later to not do so many string ops
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

            // Save psf lines to list
            psf.lines = fileLines;
            return true;
        }

        // error CS1501: No overload for method 'Path.GetFullPath' takes 2 arguments
        // Thanks Unity
        // Could be made more efficent with stringbuilder
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
        private static void ReplaceShaderValuesNew(string[] lines, int startLine, int endLine, MaterialProperty[] props, List<PropertyData> constants, List<Macro> macros)
        {
            // Outside loop is each line
            for (int i=startLine;i<endLine;i++)
            {
                string lineTrimmed = lines[i].TrimStart();
                // Replace inline smapler states
                if (lineTrimmed.StartsWith("//KSOInlineSamplerState"))
                {
                    string lineParsed = lineTrimmed.Replace(" ", "").Replace("\t", "");
                    // Remove all whitespace
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
                        lines[i+1] = lines[i+1].Replace(args[0], InlineSamplerStateNames[inlineSamplerIndex]);
                    }
                }
                // then replace macros
                foreach (Macro macro in macros)
                {
                    // Expects only one instance of a macro per line!
                    int macroIndex;
                    if ((macroIndex = lines[i].IndexOf(macro.name + "(")) != -1)
                    {
                        // Macro exists on this line, make sure its not the definition
                        string lineParsed = lineTrimmed.Replace(" ", "").Replace("\t", "");
                        if (lineParsed.StartsWith("#define")) continue;

                        // parse args between first '(' and first ')'
                        int firstParenthesis = macroIndex + macro.name.Length;
                        int lastParenthesis = lines[i].IndexOf(')', macroIndex + macro.name.Length+1);
                        string allArgs = lines[i].Substring(firstParenthesis+1, lastParenthesis-firstParenthesis-1);
                        string[] args = allArgs.Split(',');
                        
                        // Replace macro parts
                        string newContents = macro.contents;
                        for (int j=0; j<args.Length;j++)
                        {
                            args[j] = args[j].Trim();
                            int argIndex;
                            int lastIndex = 0;
                            while ((argIndex = newContents.IndexOf(macro.args[j], lastIndex)) != -1)
                            {
                                lastIndex = argIndex+1;
                                char charLeft = newContents[argIndex-1];
                                char charRight = newContents[argIndex+macro.args[j].Length];
                                if (Array.Exists(ValidSeparators, x => x == charLeft) && Array.Exists(ValidSeparators, x => x == charRight))
                                {
                                    // Replcae the arg!
                                    StringBuilder sbm = new StringBuilder(newContents.Length - macro.args[j].Length + args[j].Length);
                                    sbm.Append(newContents, 0, argIndex);
                                    sbm.Append(args[j]);
                                    sbm.Append(newContents, argIndex + macro.args[j].Length, newContents.Length - argIndex - macro.args[j].Length);
                                    newContents = sbm.ToString();
                                }
                            }
                        }
                        newContents = newContents.Replace("##", ""); // Remove token pasting separators
                        // Replace the line with the evaluated macro
                        StringBuilder sb = new StringBuilder(lines[i].Length + newContents.Length);
                        sb.Append(lines[i], 0, macroIndex);
                        sb.Append(newContents);
                        sb.Append(lines[i], lastParenthesis+1, lines[i].Length - lastParenthesis-1);
                        lines[i] = sb.ToString();
                    }
                }
                // then replace properties
                foreach (PropertyData constant in constants)
                {
                    int constantIndex;
                    int lastIndex = 0;
                    bool declarationFound = false;
                    while ((constantIndex = lines[i].IndexOf(constant.name, lastIndex)) != -1)
                    {
                        lastIndex = constantIndex+1;
                        char charLeft = lines[i][constantIndex-1];
                        char charRight = lines[i][constantIndex + constant.name.Length];
                        // Skip invalid matches (probably a subname of another symbol)
                        if (!(Array.Exists(ValidSeparators, x => x == charLeft) && Array.Exists(ValidSeparators, x => x == charRight)))
                            continue;
                        
                        // Skip basic declarations of unity shader properties i.e. "uniform float4 _Color;"
                        if (!declarationFound)
                        {
                            string precedingText = lines[i].Substring(0, constantIndex-1).TrimEnd(); // whitespace removed string immediately to the left should be float or float4
                            string restOftheFile = lines[i].Substring(constantIndex + constant.name.Length).TrimStart(); // whitespace removed character immediately to the right should be ;
                            if (Array.Exists(ValidPropertyDataTypes, x => precedingText.EndsWith(x)) && restOftheFile.StartsWith(";"))
                            {
                                declarationFound = true;
                                continue;
                            }
                        }

                        // Replace with constant!
                        StringBuilder sb = new StringBuilder(lines[i].Length * 2);
                        sb.Append(lines[i], 0, constantIndex);
                        switch (constant.type)
                        {
                            case PropertyType.Float:
                                sb.Append("float(" + constant.value.x + ")");
                                break;
                            case PropertyType.Vector:
                                sb.Append("float4("+constant.value.x+","+constant.value.y+","+constant.value.z+","+constant.value.w+")");
                                break;
                        }
                        sb.Append(lines[i], constantIndex+constant.name.Length, lines[i].Length-constantIndex-constant.name.Length);
                        lines[i] = sb.ToString();

                        // Check for Unity branches on previous line here?
                    }
                }
                // Then remove Unity branches
                if (RemoveUnityBranches)
                    lines[i] = lines[i].Replace("UNITY_BRANCH", "").Replace("[branch]", "");
            }
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
            string materialFilePath = AssetDatabase.GetAssetPath(material);
            string materialFolder = Path.GetDirectoryName(materialFilePath);
            string newShaderDirectory = materialFolder + "/OptimizedShaders/" + shaderDirectory;
            // Both safe ways of removing the shader make the editor GUI throw an error, so just don't refresh the
            // asset database immediately
            //AssetDatabase.DeleteAsset(shaderFilePath);
            FileUtil.DeleteFileOrDirectory(newShaderDirectory + "/");
            FileUtil.DeleteFileOrDirectory(newShaderDirectory + ".meta");
            //AssetDatabase.Refresh();

            return true;
        }
    }
}