using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System.Reflection;
using UnityEditor;
using System;

// Material property drawers and a shader GUI because the base material inspector only needs slight improvement
// Meant to serve as a functionally-complete foundation for the base shader GUI with no shader-specific logic

namespace Kaj
{
    // Full colormask enum because UnityEngine.Rendering.ColorWriteMask doesn't have every option
    public enum ColorMask
    {
        None,
        Alpha,
        Blue,
        BA,
        Green,
        GA,
        GB,
        GBA,
        Red,
        RA,
        RB,
        RBA,
        RG,
        RGA,
        RGB,
        RGBA
    }

    // DX11 only blend operations
    public enum BlendOp
    {
        Add,
        Subtract,
        ReverseSubtract,
        Min,
        Max,
        LogicalClear,
        LogicalSet,
        LogicalCopy,
        LogicalCopyInverted,
        LogicalNoop,
        LogicalInvert,
        LogicalAnd,
        LogicalNand,
        LogicalOr,
        LogicalNor,
        LogicalXor,
        LogicalEquivalence,
        LogicalAndReverse,
        LogicalAndInverted,
        LogicalOrReverse,
        LogicalOrInverted
    }

    // Lightmodes so passes can be disabled
    public enum LightMode
    {
        Always,
        ForwardBase,
        ForwardAdd,
        Deferred,
        ShadowCaster,
        MotionVectors,
        PrepassBase,
        PrepassFinal,
        Vertex,
        VertexLMRGBM,
        VertexLM
    }

    // Simple indent and unindent decorators
    // 2px padding is still added around each decorator, might change to -2 height later
    public class IndentDecorator : MaterialPropertyDrawer
    {
        public override void OnGUI (Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            EditorGUI.indentLevel += 1;
        }

        public override float GetPropertyHeight (MaterialProperty prop, string label, MaterialEditor editor)
        {
            return 0f;
        }
    }
    public class UnIndentDecorator : MaterialPropertyDrawer
    {
        public override void OnGUI (Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            EditorGUI.indentLevel -= 1;
        }

        public override float GetPropertyHeight (MaterialProperty prop, string label, MaterialEditor editor)
        {
            return 0f;
        }
    }

    // Vector2 with a prefix to not cause conflicts with other (i.e. Thry's) drawers
    public class KajVector2Drawer : MaterialPropertyDrawer
    {
        public override void OnGUI (Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            EditorGUIUtility.labelWidth = 0;
            Vector2 v = new Vector2(prop.vectorValue.x, prop.vectorValue.y);
            EditorGUI.showMixedValue = prop.hasMixedValue;
            EditorGUI.BeginChangeCheck();
            v = EditorGUI.Vector2Field(position, label, v);
            if (EditorGUI.EndChangeCheck())
                prop.vectorValue = new Vector4(v.x, v.y, prop.vectorValue.z, prop.vectorValue.w);
            EditorGUI.showMixedValue = false;
            editor.SetDefaultGUIWidths();
        }
    }

    // Vector3 with a prefix to not cause conflicts with other (i.e. Thry's) drawers
    public class KajVector3Drawer : MaterialPropertyDrawer
    {
        private readonly bool normalize = false;

        public KajVector3Drawer() { }
        public KajVector3Drawer(string f1) : this(new[] {f1}) {}
        public KajVector3Drawer(string[] flags)
        {
            foreach (string flag in flags)
            {
                if (flag == "Normalize") normalize = true;
            }
        }

        public override void OnGUI (Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            EditorGUIUtility.labelWidth = 0;
            Vector3 v = new Vector3(prop.vectorValue.x, prop.vectorValue.y, prop.vectorValue.z);
            EditorGUI.showMixedValue = prop.hasMixedValue;
            EditorGUI.BeginChangeCheck();
            v = EditorGUI.Vector3Field(position, label, v);
            if (EditorGUI.EndChangeCheck())
            {
                if (normalize) v.Normalize();
                prop.vectorValue = new Vector4(v.x, v.y, v.z, prop.vectorValue.w);
            }
            EditorGUI.showMixedValue = false;
            editor.SetDefaultGUIWidths();
        }
    }

    // Basic single-line decorator-like label, uses property display name.  Kaj prefix to avoid name clashes
    public class KajLabelDrawer : MaterialPropertyDrawer
    {
        public override void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor)
        {
            position.y += 8; // This spacing could be an argument
            position = EditorGUI.IndentedRect(position);
            GUI.Label(position, label, EditorStyles.label);
        }
        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
            return EditorGUIUtility.singleLineHeight;
        }
    }

    // Enum with normal editor width, rather than MaterialEditor Default GUI widths
    // Would be nice if Decorators could access Drawers too so this wouldn't be necessary for something to trivial
    // Adapted from Unity interal MaterialEnumDrawer https://github.com/Unity-Technologies/UnityCsReference/
    public class WideEnumDrawer : MaterialPropertyDrawer
    {
        private readonly GUIContent[] names;
        private readonly float[] values;

        // internal Unity AssemblyHelper can't be accessed
        private Type[] TypesFromAssembly(Assembly a)
        {
            if (a == null)
                return new Type[0];
            try
            {
                return a.GetTypes();
            }
            catch (ReflectionTypeLoadException)
            {
                return new Type[0];
            }
        }
        public WideEnumDrawer(string enumName)
        {
            var types = AppDomain.CurrentDomain.GetAssemblies().SelectMany(
                x => TypesFromAssembly(x)).ToArray();
            try
            {
                var enumType = types.FirstOrDefault(
                    x => x.IsEnum && (x.Name == enumName || x.FullName == enumName)
                );
                var enumNames = Enum.GetNames(enumType);
                names = new GUIContent[enumNames.Length];
                for (int i=0; i<enumNames.Length; ++i)
                    names[i] = new GUIContent(enumNames[i]);

                var enumVals = Enum.GetValues(enumType);
                values = new float[enumVals.Length];
                for (int i=0; i<enumVals.Length; ++i)
                    values[i] = (int)enumVals.GetValue(i);
            }
            catch (Exception)
            {
                Debug.LogWarningFormat("Failed to create  WideEnum, enum {0} not found", enumName);
                throw;
            }

        }
        
        public WideEnumDrawer(string n1, float v1) : this(new[] {n1}, new[] {v1}) {}
        public WideEnumDrawer(string n1, float v1, string n2, float v2) : this(new[] { n1, n2 }, new[] { v1, v2 }) {}
        public WideEnumDrawer(string n1, float v1, string n2, float v2, string n3, float v3) : this(new[] { n1, n2, n3 }, new[] { v1, v2, v3 }) {}
        public WideEnumDrawer(string n1, float v1, string n2, float v2, string n3, float v3, string n4, float v4) : this(new[] { n1, n2, n3, n4 }, new[] { v1, v2, v3, v4 }) {}
        public WideEnumDrawer(string n1, float v1, string n2, float v2, string n3, float v3, string n4, float v4, string n5, float v5) : this(new[] { n1, n2, n3, n4, n5 }, new[] { v1, v2, v3, v4, v5 }) {}
        public WideEnumDrawer(string n1, float v1, string n2, float v2, string n3, float v3, string n4, float v4, string n5, float v5, string n6, float v6) : this(new[] { n1, n2, n3, n4, n5, n6 }, new[] { v1, v2, v3, v4, v5, v6 }) {}
        public WideEnumDrawer(string n1, float v1, string n2, float v2, string n3, float v3, string n4, float v4, string n5, float v5, string n6, float v6, string n7, float v7) : this(new[] { n1, n2, n3, n4, n5, n6, n7 }, new[] { v1, v2, v3, v4, v5, v6, v7 }) {}
        public WideEnumDrawer(string[] enumNames, float[] vals)
        {
            names = new GUIContent[enumNames.Length];
            for (int i=0; i<enumNames.Length; ++i)
                names[i] = new GUIContent(enumNames[i]);

            values = new float[vals.Length];
            for (int i=0; i<vals.Length; ++i)
                values[i] = vals[i];
        }

        public override void OnGUI(Rect position, MaterialProperty prop, GUIContent label, MaterialEditor editor)
        {
            EditorGUI.showMixedValue = prop.hasMixedValue;
            EditorGUI.BeginChangeCheck();
            var value = prop.floatValue;
            int selectedIndex = -1;
            for (int i=0; i<values.Length; i++)
                if (values[i] == value)
                {
                    selectedIndex = i;
                    break;
                }
 
            float labelWidth = EditorGUIUtility.labelWidth;
            EditorGUIUtility.labelWidth = 0f;
            var selIndex = EditorGUI.Popup(position, label, selectedIndex, names);
            EditorGUI.showMixedValue = false;
            if (EditorGUI.EndChangeCheck())
                prop.floatValue = values[selIndex];
             EditorGUIUtility.labelWidth = labelWidth;
        }

        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
            return base.GetPropertyHeight(prop, label, editor);
        }
    }

    // Range drawer that looks for a property with the same name minus a 'Max' suffix if it exists or a matching
    // 'Min' property.  Then forces that value to be equal to this drawer's newly assigned value
    public class RangeMaxDrawer : MaterialPropertyDrawer
    {
        public override void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor)
        {
            EditorGUI.showMixedValue = prop.hasMixedValue;
            EditorGUI.BeginChangeCheck();
            editor.RangeProperty(prop, label);
            if (EditorGUI.EndChangeCheck())
            {
                MaterialProperty[] props = MaterialEditor.GetMaterialProperties(editor.targets);
                MaterialProperty min = null;

                // Looping through this myself because MaterialEditor.GetMaterialProperty returns a broken prop
                if (prop.name.EndsWith("Max"))
                {
                    string baseName = prop.name.Remove(prop.name.Length - 3, 3);
                    foreach (MaterialProperty mp in props)
                        if (mp.name == baseName || mp.name == baseName + "Min")
                        {
                            min = mp;
                            break;
                        }
                }
                else
                {
                    foreach (MaterialProperty mp in props)
                        if (mp.name == prop.name + "Min")
                        {
                            min = mp;
                            break;
                        }
                }
                
                if (min != null)
                    if (min.floatValue > prop.floatValue)
                        min.floatValue = prop.floatValue;
            }
            EditorGUI.showMixedValue = false;
        }

        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
           return -2f; // Remove the extra drawer padding
        }
    }

    // Range drawer that looks for a property with the same name minus a 'Min' suffix if it exists or a matching
    // 'Max' property.  Then forces that value to equal to this drawer's newly assigned value
    public class RangeMinDrawer : MaterialPropertyDrawer
    {
        public override void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor)
        {
            EditorGUI.showMixedValue = prop.hasMixedValue;
            EditorGUI.BeginChangeCheck();
            editor.RangeProperty(prop, label);
            if (EditorGUI.EndChangeCheck())
            {
                MaterialProperty[] props = MaterialEditor.GetMaterialProperties(editor.targets);
                MaterialProperty max = null;

                // Looping through this myself because MaterialEditor.GetMaterialProperty returns a broken prop
                if (prop.name.EndsWith("Min"))
                {
                    string baseName = prop.name.Remove(prop.name.Length - 3, 3);
                    foreach (MaterialProperty mp in props)
                        if (mp.name == baseName || mp.name == baseName + "Max")
                        {
                            max = mp;
                            break;
                        }
                }
                else
                {
                    foreach (MaterialProperty mp in props)
                        if (mp.name == prop.name + "Max")
                        {
                            max = mp;
                            break;
                        }
                }
                
                if (max != null)
                    if (max.floatValue < prop.floatValue)
                        max.floatValue = prop.floatValue;
            }
            EditorGUI.showMixedValue = false;
        }

        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
            return -2f; // Remove the extra drawer padding
        }
    }

    // Simple auto-laid out information box, uses materialproperty display name as text
    public class HelpBoxDrawer : MaterialPropertyDrawer
    {
        public override void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor)
        {
            EditorGUILayout.HelpBox(label, MessageType.Info);
        }
        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
           return -4f; // Remove the extra drawer padding + helpbox extra padding
        }
    }

    // Regular float field but with a definable minimum for nonzero stuff and power exponents
    public class MinimumFloatDrawer : MaterialPropertyDrawer
    {
        private readonly float min;

        public MinimumFloatDrawer(float min)
        {
            this.min = min;
        }
        public override void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor)
        {
            EditorGUI.showMixedValue = prop.hasMixedValue;
            EditorGUI.BeginChangeCheck();
            float f = editor.FloatProperty(prop, label);
            if (EditorGUI.EndChangeCheck())
            {
                if (f < min)
                   prop.floatValue = min;
            }
            EditorGUI.showMixedValue = false;
        }
        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
           return 0;
        }
    }

    // ToggleUI drawer with left side checkbox
    public class ToggleUILeftDrawer : MaterialPropertyDrawer
    {
        public override void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor)
        {
            EditorGUI.BeginChangeCheck();
            bool value = (prop.floatValue == 1);
            EditorGUI.showMixedValue = prop.hasMixedValue;
            value = EditorGUILayout.ToggleLeft("  " + label, value);
            EditorGUI.showMixedValue = false;
            if (EditorGUI.EndChangeCheck())
                prop.floatValue = value ? 1.0f : 0.0f;
        }
        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
            return 0;
        }
    }

    // Minimalistic shader editor extension to edit the few things the base inspector can't access
    // AND what doesn't quite fit the use case of MaterialPropertyDrawers, even if it could be done by them
    // Supports grouped foldouts and foldouts with toggles as labels, and helpbox based information
    public class ShaderEditor : ShaderGUI
    {
        const string groupPrefix = "group_";
        const string togglePrefix = "toggle_"; // foldout combined with a checkbox i.e. group_toggle_Parallax
        const string endPrefix = "end_";
        GUIStyle foldoutStyle;

        public enum DisableBatchingFlags
        {
            False,
            True,
            LODFading
        }

        public enum PreviewType
        {
            Sphere, // Actually called 'Mesh' internally, but regular users recognize the sphere/don't use other meshes
            Plane,
            Skybox
        }

        MaterialProperty blendMode = null;
        MaterialProperty lightModes = null;
        MaterialProperty disableBatching = null;
        MaterialProperty ignoreProjector = null; // Doesn't work, thanks Unity
        MaterialProperty forceNoShadowCasting = null; // Doesn't work, thanks Unity
        MaterialProperty canUseSpriteAtlas = null;
        MaterialProperty previewType = null;

        // Shader Optimizer
        MaterialProperty shaderOptimizer = null;

        bool m_FirstTimeApply = true;
        string[] modeNames;

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
        {
            // Move to constructor?
            foldoutStyle = new GUIStyle("ShurikenModuleTitle");
            foldoutStyle.font = new GUIStyle(EditorStyles.label).font;
            foldoutStyle.border = new RectOffset(15, 7, 4, 4);
            foldoutStyle.fixedHeight = 22;
            foldoutStyle.contentOffset = new Vector2(20f, -2f);


            blendMode = FindProperty("_Mode", props, false);
            if (blendMode == null) Debug.LogWarning("[Kaj Shader Editor] Shader Property _Mode not found");
            // Cache the names of each mode preset
            if (blendMode != null)
            {
                int modeCount = Int32.Parse(blendMode.displayName);
                modeNames = new string[modeCount];
                for (int i=0; i<modeCount;i++)
                    modeNames[i] = Array.Find(props, x => x.name == "_Mode" + i).displayName.Split(';')[0];
            }

            lightModes = FindProperty("_LightModes", props, false);
            if (lightModes == null) Debug.LogWarning("[Kaj Shader Editor] Shader Property _LightModes not found");
            disableBatching = FindProperty("_DisableBatching", props, false);
            if (disableBatching == null) Debug.LogWarning("[Kaj Shader Editor] Shader Property _DisableBatching not found");
            ignoreProjector = FindProperty("_IgnoreProjector", props, false);
            if (ignoreProjector == null) Debug.LogWarning("[Kaj Shader Editor] Shader Property _IgnoreProjector not found");
            forceNoShadowCasting = FindProperty("_ForceNoShadowCasting", props, false);
            if (forceNoShadowCasting == null) Debug.LogWarning("[Kaj Shader Editor] Shader Property _ForceNoShadowCasting not found");
            canUseSpriteAtlas = FindProperty("_CanUseSpriteAtlas", props, false);
            if (canUseSpriteAtlas == null) Debug.LogWarning("[Kaj Shader Editor] Shader Property _CanUseSpriteAtlas not found");
            previewType = FindProperty("_PreviewType", props, false);
            if (previewType == null) Debug.LogWarning("[Kaj Shader Editor] Shader Property _PreviewType not found");
            Material material = materialEditor.target as Material;

            shaderOptimizer = FindProperty("_ShaderOptimizerEnabled", props, false);
            if (shaderOptimizer == null) Debug.LogWarning("[Kaj Shader Editor] Shader Property _ShaderOptimizerEnabled not found");

            if (m_FirstTimeApply)
            {
                // Materials could have their existing tags/override tags assigned to the convention named
                // properties for them, but those tags might not be consistent across multiple materials, and also might not exist.
                // Conversely, properties also shouldn't be auto-applied to override tags if they have mixed values.
                // But properties (and hard coded defaults for them) could be inconsistent with override tags, 
                // so this part applys them where it makes sense to.
                if (lightModes != null && !lightModes.hasMixedValue)
                    SetMaterialsLightMode(materialEditor, (int)lightModes.floatValue);
                if (disableBatching != null && !disableBatching.hasMixedValue)
                    SetDisableBatchingFlags(materialEditor, (DisableBatchingFlags)disableBatching.floatValue);
                if (ignoreProjector != null && !ignoreProjector.hasMixedValue)
                    if (ignoreProjector.floatValue == 1)
                        SetMaterialsTag(materialEditor.targets, "IgnoreProjector", "True");
                    else SetMaterialsTag(materialEditor.targets, "IgnoreProjector", "False");
                if (forceNoShadowCasting != null && !forceNoShadowCasting.hasMixedValue)
                    if (forceNoShadowCasting.floatValue == 1)
                        SetMaterialsTag(materialEditor.targets, "ForceNoShadowCasting", "True");
                    else SetMaterialsTag(materialEditor.targets, "ForceNoShadowCasting", "False");
                if (canUseSpriteAtlas != null && !canUseSpriteAtlas.hasMixedValue)
                    if (canUseSpriteAtlas.floatValue == 1)
                        SetMaterialsTag(materialEditor.targets, "CanUseSpriteAtlas", "True");
                    else SetMaterialsTag(materialEditor.targets, "CanUseSpriteAtlas", "False");
                if (previewType != null && !previewType.hasMixedValue)
                    SetPreviewTypeFlags(materialEditor, (PreviewType)previewType.floatValue);

                m_FirstTimeApply = false;
            }

            // Blend Mode
            if (blendMode != null)
            {
                EditorGUI.showMixedValue = blendMode.hasMixedValue;
                var mode = blendMode.floatValue;
                EditorGUI.BeginChangeCheck();
                mode = EditorGUILayout.Popup("Rendering Mode", (int)mode, modeNames);
                if (EditorGUI.EndChangeCheck())
                {
                    // Idk if these Undo registrations are even still necessary since changing a material property registers one,
                    // but the Standard shader GUI does this so I will too
                    materialEditor.RegisterPropertyChangeUndo("Rendering Mode");
                    blendMode.floatValue = mode;
                    // Apply Rendering Mode preset
                    // Rendering modes provide a simple way to preset blending options/render queue
                    string[] renderModeSettings = Array.Find(props, x => x.name == "_Mode" + (int)mode).displayName.Split(';');
                    for (int i=1; i<renderModeSettings.Length; i++)
                    {
                        // [0] is name and [1] is value
                        string[] renderModeSetting = renderModeSettings[i].Split('=');
                        if (renderModeSetting[0] == "RenderQueue")
                            foreach (Material m in materialEditor.targets)
                                m.renderQueue = Int32.Parse(renderModeSetting[1]);
                        else if (renderModeSetting[0] == "RenderType")
                            foreach (Material m in materialEditor.targets)
                                m.SetOverrideTag("RenderType", renderModeSetting[1]);
                        else Array.Find(props, x => x.name == renderModeSetting[0]).floatValue = Single.Parse(renderModeSetting[1]);
                    }
                    EditorUtility.SetDirty(material);
                }
            }

            // GI flags
            EditorGUI.showMixedValue = false;
            var firstGIflag = (MaterialGlobalIlluminationFlags)material.globalIlluminationFlags;
            foreach (Material m in materialEditor.targets)
            {
                if ((MaterialGlobalIlluminationFlags)m.globalIlluminationFlags != firstGIflag)
                {
                    EditorGUI.showMixedValue = true;
                    break;
                }
            }
            var giFlags = (MaterialGlobalIlluminationFlags)material.globalIlluminationFlags;
            EditorGUI.BeginChangeCheck();
            giFlags = (MaterialGlobalIlluminationFlags)EditorGUILayout.Popup("Global Illumination", (int)giFlags, Enum.GetNames(typeof(MaterialGlobalIlluminationFlags)));
            if (EditorGUI.EndChangeCheck())
            {
                materialEditor.RegisterPropertyChangeUndo("Global Illumination");
                foreach (Material m in materialEditor.targets)
                    m.globalIlluminationFlags = giFlags;
                EditorUtility.SetDirty(material);
            }

            // LightModes
            if (lightModes != null)
            {
                EditorGUI.showMixedValue = lightModes.hasMixedValue;
                EditorGUI.BeginChangeCheck();
                int lightModesMask = EditorGUILayout.MaskField("Disabled Lightmodes", (int)lightModes.floatValue, Enum.GetNames(typeof(LightMode)));
                if (EditorGUI.EndChangeCheck())
                {
                    materialEditor.RegisterPropertyChangeUndo("LightModes");
                    lightModes.floatValue = lightModesMask;
                    SetMaterialsLightMode(materialEditor, lightModesMask);
                    EditorUtility.SetDirty(material);
                }
            }

            // DisableBatching
            if (disableBatching != null)
            {
                EditorGUI.showMixedValue = disableBatching.hasMixedValue;
                var batchingFlag = (DisableBatchingFlags)disableBatching.floatValue;
                EditorGUI.BeginChangeCheck();
                batchingFlag = (DisableBatchingFlags)EditorGUILayout.Popup("Disable Batching", (int)batchingFlag, Enum.GetNames(typeof(DisableBatchingFlags)));
                if (EditorGUI.EndChangeCheck())
                {
                    materialEditor.RegisterPropertyChangeUndo("Disable Batching");
                    disableBatching.floatValue = (float)batchingFlag;
                    SetDisableBatchingFlags(materialEditor, batchingFlag);
                    EditorUtility.SetDirty(material);
                }
            }

            // PreviewType
            if (previewType != null)
            {
                EditorGUI.showMixedValue = previewType.hasMixedValue;
                var previewTypeFlag = (PreviewType)previewType.floatValue;
                EditorGUI.BeginChangeCheck();
                previewTypeFlag = (PreviewType)EditorGUILayout.Popup("Preview Type", (int)previewTypeFlag, Enum.GetNames(typeof(PreviewType)));
                if (EditorGUI.EndChangeCheck())
                {
                    materialEditor.RegisterPropertyChangeUndo("Preview Type");
                    previewType.floatValue = (float)previewTypeFlag;
                    SetPreviewTypeFlags(materialEditor, previewTypeFlag);
                    EditorUtility.SetDirty(material);
                }
            }
            
            // IgnoreProjector
            if (ignoreProjector != null)
            {
                EditorGUI.showMixedValue = ignoreProjector.hasMixedValue;
                var projectorFlag = ignoreProjector.floatValue;
                EditorGUI.BeginChangeCheck();
                projectorFlag = EditorGUILayout.Toggle("Ignore Projector", projectorFlag == 1) ? 1 : 0;
                if (EditorGUI.EndChangeCheck())
                {
                    materialEditor.RegisterPropertyChangeUndo("Ignore Projector");
                    ignoreProjector.floatValue = projectorFlag;
                    if (ignoreProjector.floatValue == 1)
                        SetMaterialsTag(materialEditor.targets, "IgnoreProjector", "True");
                    else SetMaterialsTag(materialEditor.targets, "IgnoreProjector", "False");
                    EditorUtility.SetDirty(material);
                }
            }

            // ForceNoShadowCasting
            if (forceNoShadowCasting != null)
            {
                EditorGUI.showMixedValue = forceNoShadowCasting.hasMixedValue;
                var forceNoShadowCastingFlag = forceNoShadowCasting.floatValue;
                EditorGUI.BeginChangeCheck();
                forceNoShadowCastingFlag = EditorGUILayout.Toggle("ForceNoShadowCasting", forceNoShadowCastingFlag == 1) ? 1 : 0;
                if (EditorGUI.EndChangeCheck())
                {
                    materialEditor.RegisterPropertyChangeUndo("ForceNoShadowCasting");
                    forceNoShadowCasting.floatValue = forceNoShadowCastingFlag;
                    if (forceNoShadowCasting.floatValue == 1)
                        SetMaterialsTag(materialEditor.targets, "ForceNoShadowCasting", "True");
                    else SetMaterialsTag(materialEditor.targets, "ForceNoShadowCasting", "False");
                    EditorUtility.SetDirty(material);
                }
            }

            // CanUseSpriteAtlas
            if (canUseSpriteAtlas != null)
            {
                EditorGUI.showMixedValue = canUseSpriteAtlas.hasMixedValue;
                var canUseSpriteAtlasFlag = canUseSpriteAtlas.floatValue;
                EditorGUI.BeginChangeCheck();
                canUseSpriteAtlasFlag = EditorGUILayout.Toggle("CanUseSpriteAtlas", canUseSpriteAtlasFlag == 1) ? 1 : 0;
                if (EditorGUI.EndChangeCheck())
                {
                    materialEditor.RegisterPropertyChangeUndo("CanUseSpriteAtlas");
                    canUseSpriteAtlas.floatValue = canUseSpriteAtlasFlag;
                    if (canUseSpriteAtlas.floatValue == 1)
                        SetMaterialsTag(materialEditor.targets, "CanUseSpriteAtlas", "True");
                    else SetMaterialsTag(materialEditor.targets, "CanUseSpriteAtlas", "False");
                    EditorUtility.SetDirty(material);
                }
                EditorGUI.showMixedValue = false;
            }

            // Kaj Shader Optimizer
            if (shaderOptimizer != null)
            {
                // Theoretically this shouldn't ever happen since locked in materials have different shaders.
                // But in a case where the material property says its locked in but the material really isn't, this
                // will display and allow users to fix the property/lock in
                if (shaderOptimizer.hasMixedValue)
                {
                    EditorGUI.BeginChangeCheck();
                    GUILayout.Button("Lock in Optimized Shaders (Beta) (" + materialEditor.targets.Length + " materials)");
                    if (EditorGUI.EndChangeCheck())
                        foreach (Material m in materialEditor.targets)
                        {
                            m.SetFloat("_ShaderOptimizerEnabled", 1);
                            if (!ShaderOptimizer.Lock(m, props)) // Error locking shader, revert property
                                m.SetFloat("_ShaderOptimizerEnabled", 0);
                        }
                }
                else
                {
                    EditorGUI.BeginChangeCheck();
                    if (shaderOptimizer.floatValue == 0)
                        GUILayout.Button("Lock In Optimized Shader (Beta)");
                    else GUILayout.Button("Unlock Shader");
                    if (EditorGUI.EndChangeCheck())
                    {
                        shaderOptimizer.floatValue = shaderOptimizer.floatValue == 1 ? 0 : 1;
                        if (shaderOptimizer.floatValue == 1)
                        {
                            foreach (Material m in materialEditor.targets)
                                if (!ShaderOptimizer.Lock(m, props))
                                    m.SetFloat("_ShaderOptimizerEnabled", 0);
                        }
                        else
                        {
                            foreach (Material m in materialEditor.targets)
                                if (!ShaderOptimizer.Unlock(m))
                                    m.SetFloat("_ShaderOptimizerEnabled", 1);
                        }
                    }
                }
            }

            // Actual shader properties
            materialEditor.SetDefaultGUIWidths();
            DrawPropertiesGUIRecursive(materialEditor, props);            
            // Render queue, GPU instancing, and double sided GI checkboxes
            base.OnGUI(materialEditor, new MaterialProperty[0]);
        }

        // Recursive to easily deal with foldouts
        // the group header property can store a toggle value, and the end property stores whether or not the foldout is expanded
        protected void DrawPropertiesGUIRecursive(MaterialEditor materialEditor, MaterialProperty[] props)
        {
            for (var i = 0; i < props.Length; i++)
            {
                // Check for groups and toggle groups
                bool toggle = false;
                if (props[i].name.StartsWith(groupPrefix) && // props[i] is group property
                   ((props[i].flags & MaterialProperty.PropFlags.HideInInspector) != 0))
                {
                    if (props[i].name.StartsWith(groupPrefix + togglePrefix))
                        toggle = true;
                    
                    // Find matching end tag
                    string groupName;
                    if (toggle)
                        groupName = props[i].name.Substring(groupPrefix.Length +togglePrefix.Length);
                    else
                        groupName = props[i].name.Substring(groupPrefix.Length);
                    string endName = endPrefix + groupName;
                    int j = i+1;
                    bool foundEnd = false;
                    for (; j<props.Length; j++)
                        if (props[j].name == endName && // props[j] is group end property
                            ((props[j].flags & MaterialProperty.PropFlags.HideInInspector) != 0))
                            {
                                foundEnd = true;
                                break;
                            }
                    if (!foundEnd)
                    {
                        Debug.LogWarning("[Kaj Shader Editor] Group end for " + groupName + " not found! Skipping.");
                        continue;
                    }

                    // Draw particle system styled header with indentation applied
                    float indentPixels = EditorGUI.indentLevel * 13f;
                    var rect = GUILayoutUtility.GetRect(0, 22f, foldoutStyle);
                    rect.width -= indentPixels;
                    rect.x += indentPixels;
                    if (shaderOptimizer != null && (shaderOptimizer.floatValue == 1 || shaderOptimizer.hasMixedValue))
                        EditorGUI.BeginDisabledGroup(true);
                    if (toggle)
                        GUI.Box(rect, "", foldoutStyle);
                    else
                        GUI.Box(rect, props[i].displayName, foldoutStyle);
                    if (shaderOptimizer != null && (shaderOptimizer.floatValue == 1 || shaderOptimizer.hasMixedValue))
                        EditorGUI.EndDisabledGroup();

                    // Draw foldout arrow
                    var toggleRect = new Rect(rect.x + 4f, rect.y + 2f, 13f, 13f);
                    bool expanded = props[j].floatValue == 1;
                    var e = Event.current;
                    if (e.type == EventType.Repaint)
                        EditorStyles.foldout.Draw(toggleRect, false, false, expanded, false);

                    // Toggle property
                    // Technically drawers besides Toggles work, but are VERY wonky and not resized properly
                    if (toggle)
                    {
                        // Toggle alignment from Thry's
                        Rect togglePropertyRect = new Rect(rect);
                        // Add 18 to skip foldout arrow, shift by indents because the original box rect is being used
                        togglePropertyRect.x += 18 - ((EditorGUI.indentLevel) * 13);
                        togglePropertyRect.y += 1;
                        float labelWidth = EditorGUIUtility.labelWidth;
                        EditorGUIUtility.labelWidth = 0;
                        if (shaderOptimizer != null && (shaderOptimizer.floatValue == 1 || shaderOptimizer.hasMixedValue))
                            EditorGUI.BeginDisabledGroup(true);
                        materialEditor.ShaderProperty(togglePropertyRect, props[i], props[i].displayName);
                        if (shaderOptimizer != null && (shaderOptimizer.floatValue == 1 || shaderOptimizer.hasMixedValue))
                            EditorGUI.EndDisabledGroup();
                        EditorGUIUtility.labelWidth = labelWidth;
                    }

                    // Activate foldout
                    // Set the value individually in each material rather than through props[j]'s floatValue because that is recorded
                    // in the animation clip editor.  Also doesn't make an undo set for it.
                    if (e.type == EventType.MouseDown && rect.Contains(e.mousePosition))
                    {
                        if (props[j].floatValue == 1)
                            foreach (Material mat in materialEditor.targets)
                                mat.SetFloat(props[j].name, 0);
                        else 
                            foreach (Material mat in materialEditor.targets)
                                mat.SetFloat(props[j].name, 1);
                        e.Use();
                    }

                    // Recurse on props in this group
                    if (expanded)
                    {
                        MaterialProperty[] subProps = new MaterialProperty[j-i-1];
                        for (int k=i+1; k<j; k++)
                            subProps[k-(i+1)] = props[k];

                        int originalIndentLevel = EditorGUI.indentLevel;
                        EditorGUI.indentLevel += 1;
                        EditorGUILayout.Space();
                        DrawPropertiesGUIRecursive(materialEditor, subProps);
                        EditorGUILayout.Space();
                        // Hard reset to original indent level because [UnIndent] decorators may need the hidden group end property, which isn't drawn
                        EditorGUI.indentLevel = originalIndentLevel;
                    }

                    // Continue past subgroup props
                    i += j-i; 
                }

                // Derived from MaterialEditor.PropertiesDefaultGUI https://github.com/Unity-Technologies/UnityCsReference/
                if ((props[i].flags & MaterialProperty.PropFlags.HideInInspector) != 0)
                    continue;
                float h = materialEditor.GetPropertyHeight(props[i], props[i].displayName);
                Rect r = EditorGUILayout.GetControlRect(true, h, EditorStyles.layerMaskField);
                if (shaderOptimizer != null && (shaderOptimizer.floatValue == 1 || shaderOptimizer.hasMixedValue))
                    EditorGUI.BeginDisabledGroup(true);
                materialEditor.ShaderProperty(r, props[i], props[i].displayName); // something is throwing a warning here
                if (shaderOptimizer != null && (shaderOptimizer.floatValue == 1 || shaderOptimizer.hasMixedValue))
                    EditorGUI.EndDisabledGroup();
            }

        }

        private void SetDisableBatchingFlags(MaterialEditor materialEditor, DisableBatchingFlags flag)
        {
            switch (flag)
            {
                case DisableBatchingFlags.False:
                    SetMaterialsTag(materialEditor.targets, "DisableBatching", "False");
                    break;
                case DisableBatchingFlags.True:
                    SetMaterialsTag(materialEditor.targets, "DisableBatching", "True");
                    break;
                case DisableBatchingFlags.LODFading:
                    SetMaterialsTag(materialEditor.targets, "DisableBatching", "LODFading");
                    break;
            }
        }

        private void SetPreviewTypeFlags(MaterialEditor materialEditor, PreviewType previewTypeFlag)
        {
            switch (previewTypeFlag)
            {
                case PreviewType.Sphere:
                    SetMaterialsTag(materialEditor.targets, "PreviewType", "");
                    break;
                case PreviewType.Plane:
                    SetMaterialsTag(materialEditor.targets, "PreviewType", "Plane");
                    break;
                case PreviewType.Skybox:
                    SetMaterialsTag(materialEditor.targets, "PreviewType", "Skybox");
                    break;
            }
        }

        private void SetMaterialsTag(UnityEngine.Object[] mats, string key, string value)
        {
            foreach (Material m in mats)
                m.SetOverrideTag(key, value);
        }

        private void SetMaterialsLightModeEnabled(UnityEngine.Object[] mats, string pass, bool enabled)
        {
            foreach (Material m in mats)
                m.SetShaderPassEnabled(pass, enabled);
        }

        private void SetMaterialsLightMode(MaterialEditor materialEditor, int lightModesMask)
        {
            if (lightModesMask == -1)
                foreach (string name in Enum.GetNames(typeof(LightMode)))
                    SetMaterialsLightModeEnabled(materialEditor.targets, name, false);
            else if (lightModesMask == 0)
                foreach (string name in Enum.GetNames(typeof(LightMode)))
                    SetMaterialsLightModeEnabled(materialEditor.targets, name, true);
            else
            {
                if (lightModesMask % 1 == 0)
                    SetMaterialsLightModeEnabled(materialEditor.targets, "Always", false);
                else SetMaterialsLightModeEnabled(materialEditor.targets, "Always", true);
                if (lightModesMask % 2 == 0)
                    SetMaterialsLightModeEnabled(materialEditor.targets, "ForwardBase", false);
                else SetMaterialsLightModeEnabled(materialEditor.targets, "ForwardBase", true);
                if (lightModesMask % 4 == 0)
                    SetMaterialsLightModeEnabled(materialEditor.targets, "ForwardAdd", false);
                else SetMaterialsLightModeEnabled(materialEditor.targets, "ForwardAdd", true);
                if (lightModesMask % 8 == 0)
                    SetMaterialsLightModeEnabled(materialEditor.targets, "Deferred", false);
                else SetMaterialsLightModeEnabled(materialEditor.targets, "Deferred", true);
                if (lightModesMask % 16 == 0)
                    SetMaterialsLightModeEnabled(materialEditor.targets, "ShadowCaster", false);
                else SetMaterialsLightModeEnabled(materialEditor.targets, "ShadowCaster", true);
                if (lightModesMask % 32 == 0)
                    SetMaterialsLightModeEnabled(materialEditor.targets, "MotionVectors", false);
                else SetMaterialsLightModeEnabled(materialEditor.targets, "MotionVectors", true);
                if (lightModesMask % 64 == 0)
                    SetMaterialsLightModeEnabled(materialEditor.targets, "PrepassBase", false);
                else SetMaterialsLightModeEnabled(materialEditor.targets, "PrepassBase", true);
                if (lightModesMask % 128 == 0)
                    SetMaterialsLightModeEnabled(materialEditor.targets, "PrepassFinal", false);
                else SetMaterialsLightModeEnabled(materialEditor.targets, "PrepassFinal", true);
                if (lightModesMask % 256 == 0)
                    SetMaterialsLightModeEnabled(materialEditor.targets, "Vertex", false);
                else SetMaterialsLightModeEnabled(materialEditor.targets, "Vertex", true);
                if (lightModesMask % 512 == 0)
                    SetMaterialsLightModeEnabled(materialEditor.targets, "VertexLMRGBM", false);
                else SetMaterialsLightModeEnabled(materialEditor.targets, "VertexLMRGBM", true);
                if (lightModesMask % 1024 == 0)
                    SetMaterialsLightModeEnabled(materialEditor.targets, "VertexLM", false);
                else SetMaterialsLightModeEnabled(materialEditor.targets, "VertexLM", true);
            }
        }

    }
}