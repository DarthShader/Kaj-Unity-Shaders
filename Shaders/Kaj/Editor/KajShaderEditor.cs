using System.Collections;
using System.Collections.Generic;
using UnityEngine;
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

    // Simple indent and unindent decorators
    public class IndentDecorator : MaterialPropertyDrawer
    {
        public override void OnGUI (Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            EditorGUI.indentLevel += 2;
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
            EditorGUI.indentLevel -= 2;
        }

        public override float GetPropertyHeight (MaterialProperty prop, string label, MaterialEditor editor)
        {
            return 0f;
        }
    }

    // Sets a material property with the same name as the texture + suffix 'Active' to true
    // when a texture is assigned, otherwise sets it to false.  Use [HideInInspector] on the 'Active' Properties
    // Requires the custom inspector to assign all of these when you switch shaders! 
    public class TexToggleActiveDrawer : MaterialPropertyDrawer
    {
        public override void OnGUI (Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            Texture t = editor.TextureProperty(position, prop, label, prop.flags != MaterialProperty.PropFlags.NoScaleOffset);
            EditorGUI.showMixedValue = false;
            if (EditorGUI.EndChangeCheck())
            {
                prop.textureValue = t;
                MaterialProperty activeProp = MaterialEditor.GetMaterialProperty(editor.targets, prop.name + "Active");
                if (activeProp != null)
                    activeProp.floatValue = (t != null) ? 1 : 0;
            }
        }

        public override float GetPropertyHeight (MaterialProperty prop, string label, MaterialEditor editor)
        {
            return base.GetPropertyHeight (prop, label, editor) + 54; // afaik default texture is 54 pixels more than the default height
        }
    }

    // Vector2 with a prefix to not cause conflicts with other (i.e. Thry's) drawers
    public class KajVector2Drawer : MaterialPropertyDrawer
    {
        public override void OnGUI (Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            EditorGUIUtility.fieldWidth = EditorGUIUtility.fieldWidth * 2;
            EditorGUIUtility.labelWidth = EditorGUIUtility.labelWidth * 0.5f;
            Vector2 v = new Vector2(prop.vectorValue.x, prop.vectorValue.y);
            EditorGUI.BeginChangeCheck();
            v = EditorGUI.Vector2Field(position, label, v);
            if (EditorGUI.EndChangeCheck())
                prop.vectorValue = new Vector4(v.x, v.y, prop.vectorValue.z, prop.vectorValue.w);
            editor.SetDefaultGUIWidths();
        }
    }

    // Vector3 with a prefix to not cause conflicts with other (i.e. Thry's) drawers
    public class KajVector3Drawer : MaterialPropertyDrawer
    {
        public override void OnGUI (Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            EditorGUIUtility.fieldWidth = EditorGUIUtility.fieldWidth * 2;
            EditorGUIUtility.labelWidth = EditorGUIUtility.labelWidth * 0.5f;
            Vector3 v = new Vector3(prop.vectorValue.x, prop.vectorValue.y, prop.vectorValue.z);
            EditorGUI.BeginChangeCheck();
            v = EditorGUI.Vector3Field(position, label, v);
            if (EditorGUI.EndChangeCheck())
                prop.vectorValue = new Vector4(v.x, v.y, v.z, prop.vectorValue.w);
            editor.SetDefaultGUIWidths();
        }
    }

    // Basic single-line decorator-like label, uses property display name.  Kaj prefix to avoid name clashes
    public class KajLabelDrawer : MaterialPropertyDrawer
    {
        public override void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor)
        {
            position.y += 8; // Make this spacing an argument
            position = EditorGUI.IndentedRect(position);
            GUI.Label(position, label, EditorStyles.label);
        }
        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
            return EditorGUIUtility.singleLineHeight;
        }
    }

    // Minimalistic shader editor extension to edit the few things the base inspector can't access
    // AND what doesn't quite fit the use case of MaterialPropertyDrawers, even if it could be done by them
    public class ShaderEditor : ShaderGUI
    {
        const string groupPrefix = "group_start_";
        const string togglePrefix = "toggle_";
        const string endPrefix = "end_";
        GUIStyle foldoutStyle;

        public enum BlendMode
        {
            Opaque,
            Cutout,
            Fade,   // Old school alpha-blending mode, fresnel does not affect amount of transparency
            Transparent, // Physically plausible transparency mode, implemented as alpha pre-multiply
            Skybox, // Background queue
            Overlay, // Flare, halo
            Additive,
            Subtractive,
            Modulate
        }

        public enum DisableBatchingFlags
        {
            False,
            True,
            LODFading
        }

        public enum PreviewType
        {
            Sphere,
            Plane,
            Skybox
        }

        MaterialProperty blendMode = null;
        MaterialProperty disableBatching = null;
        MaterialProperty ignoreProjector = null; // Doesn't work, thanks Unity
        MaterialProperty forceNoShadowCasting = null; // Doesn't work, thanks Unity
        MaterialProperty canUseSpriteAtlas = null;
        MaterialProperty previewType = null;

        bool m_FirstTimeApply = true;

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
        {
            foldoutStyle = new GUIStyle("ShurikenModuleTitle");
            foldoutStyle.font = new GUIStyle(EditorStyles.label).font;
            foldoutStyle.border = new RectOffset(15, 7, 4, 4);
            foldoutStyle.fixedHeight = 22;
            foldoutStyle.contentOffset = new Vector2(20f, -2f);

            blendMode = FindProperty("_Mode", props);
            disableBatching = FindProperty("_DisableBatching", props);
            ignoreProjector = FindProperty("_IgnoreProjector", props);
            forceNoShadowCasting = FindProperty("_ForceNoShadowCasting", props);
            canUseSpriteAtlas = FindProperty("_CanUseSpriteAtlas", props);
            previewType = FindProperty("_PreviewType", props);
            Material material = materialEditor.target as Material;

            if (m_FirstTimeApply)
            {
                // TexToggleActiveDrawer support!
                // Loop through all material properties, look for an existing
                // var with the same name as each texture prop with suffix "Active" 
                // that is flagged as HideInInspector and apply true or false to it
                foreach (MaterialProperty mp in props)
                {
                    if (mp.type == MaterialProperty.PropType.Texture)
                    {
                        MaterialProperty activeProp = MaterialEditor.GetMaterialProperty(materialEditor.targets, mp.name + "Active");
                        if (activeProp != null)
                            if (activeProp.flags == MaterialProperty.PropFlags.HideInInspector)
                                activeProp.floatValue = (mp.textureValue != null) ? 1 : 0;
                    }
                }
                m_FirstTimeApply = false;
            }

            // Blend Mode
            EditorGUI.showMixedValue = blendMode.hasMixedValue;
            var mode = (BlendMode)blendMode.floatValue;
            EditorGUI.BeginChangeCheck();
            mode = (BlendMode)EditorGUILayout.Popup("Rendering Mode", (int)mode, Enum.GetNames(typeof(BlendMode)));
            if (EditorGUI.EndChangeCheck())
            {
                materialEditor.RegisterPropertyChangeUndo("Rendering Mode");
                blendMode.floatValue = (float)mode;
                SetupMaterialsWithBlendMode(materialEditor.targets, (BlendMode)material.GetFloat("_Mode"));
                if (mode == BlendMode.Skybox)
                {
                    previewType.floatValue = (float)PreviewType.Skybox;
                    SetMaterialsTag(materialEditor.targets, "PreviewType", "Skybox");
                }
                EditorUtility.SetDirty(material);
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

            // DisableBatching
            EditorGUI.showMixedValue = disableBatching.hasMixedValue;
            var batchingFlag = (DisableBatchingFlags)disableBatching.floatValue;
            EditorGUI.BeginChangeCheck();
            batchingFlag = (DisableBatchingFlags)EditorGUILayout.Popup("Disable Batching", (int)batchingFlag, Enum.GetNames(typeof(DisableBatchingFlags)));
            if (EditorGUI.EndChangeCheck())
            {
                materialEditor.RegisterPropertyChangeUndo("Disable Batching");
                disableBatching.floatValue = (float)batchingFlag;
                switch (batchingFlag)
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
                EditorUtility.SetDirty(material);
            }

            // PreviewType
            EditorGUI.showMixedValue = previewType.hasMixedValue;
            var previewTypeFlag = (PreviewType)previewType.floatValue;
            EditorGUI.BeginChangeCheck();
            previewTypeFlag = (PreviewType)EditorGUILayout.Popup("Preview Type", (int)previewTypeFlag, Enum.GetNames(typeof(PreviewType)));
            if (EditorGUI.EndChangeCheck())
            {
                materialEditor.RegisterPropertyChangeUndo("Preview Type");
                previewType.floatValue = (float)previewTypeFlag;
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
                EditorUtility.SetDirty(material);
            }
            
            // IgnoreProjector
            EditorGUI.showMixedValue = ignoreProjector.hasMixedValue;
            var projectorFlag = ignoreProjector.floatValue;
            EditorGUI.BeginChangeCheck();
            projectorFlag = EditorGUILayout.Toggle("Ignore Projector", projectorFlag == 1) ? 1 : 0;
            if (EditorGUI.EndChangeCheck())
            {
                materialEditor.RegisterPropertyChangeUndo("Ignore Projector");
                ignoreProjector.floatValue = projectorFlag;
                if (material.GetFloat("_IgnoreProjector") == 1)
                    SetMaterialsTag(materialEditor.targets, "IgnoreProjector", "True");
                else SetMaterialsTag(materialEditor.targets, "IgnoreProjector", "False");
                EditorUtility.SetDirty(material);
            }

            // ForceNoShadowCasting
            EditorGUI.showMixedValue = forceNoShadowCasting.hasMixedValue;
            var forceNoShadowCastingFlag = forceNoShadowCasting.floatValue;
            EditorGUI.BeginChangeCheck();
            forceNoShadowCastingFlag = EditorGUILayout.Toggle("ForceNoShadowCasting", forceNoShadowCastingFlag == 1) ? 1 : 0;
            if (EditorGUI.EndChangeCheck())
            {
                materialEditor.RegisterPropertyChangeUndo("ForceNoShadowCasting");
                forceNoShadowCasting.floatValue = forceNoShadowCastingFlag;
                if (material.GetFloat("_ForceNoShadowCasting") == 1)
                    SetMaterialsTag(materialEditor.targets, "ForceNoShadowCasting", "True");
                else SetMaterialsTag(materialEditor.targets, "ForceNoShadowCasting", "False");
                EditorUtility.SetDirty(material);
            }

            // CanUseSpriteAtlas
            EditorGUI.showMixedValue = canUseSpriteAtlas.hasMixedValue;
            var canUseSpriteAtlasFlag = canUseSpriteAtlas.floatValue;
            EditorGUI.BeginChangeCheck();
            canUseSpriteAtlasFlag = EditorGUILayout.Toggle("CanUseSpriteAtlas", canUseSpriteAtlasFlag == 1) ? 1 : 0;
            if (EditorGUI.EndChangeCheck())
            {
                materialEditor.RegisterPropertyChangeUndo("CanUseSpriteAtlas");
                canUseSpriteAtlas.floatValue = canUseSpriteAtlasFlag;
                if (material.GetFloat("_CanUseSpriteAtlas") == 1)
                    SetMaterialsTag(materialEditor.targets, "CanUseSpriteAtlas", "True");
                else SetMaterialsTag(materialEditor.targets, "CanUseSpriteAtlas", "False");
                EditorUtility.SetDirty(material);
            }
            EditorGUI.showMixedValue = false;

            // Actual shader properties
            materialEditor.SetDefaultGUIWidths();
            DrawPropertiesGUIRecursive(materialEditor, props);            
            // Render queue, GPU instancing, and double sided GI checkboxes
            base.OnGUI(materialEditor, new MaterialProperty[0]);
        }

        // Recursive to easily deal with foldouts
        protected void DrawPropertiesGUIRecursive(MaterialEditor materialEditor, MaterialProperty[] props)
        {
            for (var i = 0; i < props.Length; i++)
            {
                // Check for groups and toggle groups
                if (props[i].name.StartsWith(groupPrefix) && 
                   ((props[i].flags & MaterialProperty.PropFlags.HideInInspector) != 0))
                {
                    // Find matching end tag
                    string groupName = props[i].name.Substring(groupPrefix.Length);
                    string endName = endPrefix + groupName;
                    int j = i+1;
                    bool foundEnd = false;
                    for (; j<props.Length; j++)
                        if (props[j].name == endName && 
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

                    // Make array of shader props in between group start and end
                    MaterialProperty[] subProps = new MaterialProperty[j-i-1];
                    for (int k=i+1; k<j; k++)
                        subProps[k-(i+1)] = props[k];

                    bool expanded = props[j].floatValue == 1;
                    
                    // draw foldout with arrow + label + checkbox if a toggle (togglePrefix)
                    var rect = GUILayoutUtility.GetRect(16f + 20f, 22f, foldoutStyle);
                    GUI.Box(rect, props[i].displayName, foldoutStyle);
                    var e = Event.current;
                    var toggleRect = new Rect(rect.x + 4f, rect.y + 2f, 13f, 13f);
                    if (e.type == EventType.Repaint)
                    {
                        EditorStyles.foldout.Draw(toggleRect, false, false, expanded, false);
                    }
                    if (e.type == EventType.MouseDown && rect.Contains(e.mousePosition))
                    {
                        if (props[j].floatValue == 1)
                            props[j].floatValue = 0;
                        else props[j].floatValue = 1;
                        e.Use();
                    }
                    // Copy from XSToon
                    //s_dropDownHeaderLabel = new GUIStyle(EditorStyles.boldLabel);
                    //s_dropDownHeaderLabel.alignment = TextAnchor.MiddleCenter;
                    if (expanded)
                    {
                        EditorGUI.indentLevel += 1;
                        EditorGUILayout.Space();
                        DrawPropertiesGUIRecursive(materialEditor, subProps);
                        EditorGUILayout.Space();
                        EditorGUI.indentLevel -= 1;
                    }
                    i += j-i; // Continue past subgroup props
                }

                // Derived from MaterialEditor.PropertiesDefaultGUI https://github.com/Unity-Technologies/UnityCsReference/
                if ((props[i].flags & MaterialProperty.PropFlags.HideInInspector) != 0)
                    continue;
                float h = materialEditor.GetPropertyHeight(props[i], props[i].displayName);
                Rect r = EditorGUILayout.GetControlRect(true, h, EditorStyles.layerMaskField);
                materialEditor.ShaderProperty(r, props[i], props[i].displayName);
            }

        }

        private void SetMaterialsTag(UnityEngine.Object[] mats, string key, string value)
        {
            foreach (Material m in mats)
                m.SetOverrideTag(key, value);
        }

        // Rendering modes provide a means to preset blending options AND to enable certain keywords
        private void SetupMaterialsWithBlendMode(UnityEngine.Object[] mats, BlendMode blendMode)
        {
            foreach (Material material in mats)
            {
                switch (blendMode)
                {
                    case BlendMode.Opaque:
                        material.SetOverrideTag("RenderType", "");
                        material.SetInt("_BlendOp", (int)UnityEngine.Rendering.BlendOp.Add);
                        material.SetInt("_BlendOpAlpha", (int)UnityEngine.Rendering.BlendOp.Add);
                        material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                        material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                        material.SetInt("_SrcBlendAlpha", (int)UnityEngine.Rendering.BlendMode.One);
                        material.SetInt("_DstBlendAlpha", (int)UnityEngine.Rendering.BlendMode.Zero);
                        material.SetInt("_ZWrite", 1);
                        material.SetInt("_ZTest", (int)UnityEngine.Rendering.CompareFunction.LessEqual);
                        material.DisableKeyword("_ALPHATEST_ON");
                        material.DisableKeyword("_ALPHABLEND_ON");
                        material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                        material.DisableKeyword("_ALPHAMODULATE_ON");
                        material.renderQueue = -1;
                        break;
                    case BlendMode.Cutout:
                        material.SetOverrideTag("RenderType", "TransparentCutout");
                        material.SetInt("_BlendOp", (int)UnityEngine.Rendering.BlendOp.Add);
                        material.SetInt("_BlendOpAlpha", (int)UnityEngine.Rendering.BlendOp.Add);
                        material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                        material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                        material.SetInt("_SrcBlendAlpha", (int)UnityEngine.Rendering.BlendMode.One);
                        material.SetInt("_DstBlendAlpha", (int)UnityEngine.Rendering.BlendMode.Zero);
                        material.SetInt("_ZWrite", 1);
                        material.SetInt("_ZTest", (int)UnityEngine.Rendering.CompareFunction.LessEqual);
                        material.EnableKeyword("_ALPHATEST_ON");
                        material.DisableKeyword("_ALPHABLEND_ON");
                        material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                        material.DisableKeyword("_ALPHAMODULATE_ON");
                        material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.AlphaTest;
                        break;
                    case BlendMode.Fade:
                        material.SetOverrideTag("RenderType", "Transparent");
                        material.SetInt("_BlendOp", (int)UnityEngine.Rendering.BlendOp.Add);
                        material.SetInt("_BlendOpAlpha", (int)UnityEngine.Rendering.BlendOp.Add);
                        material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
                        material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                        material.SetInt("_SrcBlendAlpha", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
                        material.SetInt("_DstBlendAlpha", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                        material.SetInt("_ZWrite", 0);
                        material.SetInt("_ZTest", (int)UnityEngine.Rendering.CompareFunction.LessEqual);
                        material.DisableKeyword("_ALPHATEST_ON");
                        material.EnableKeyword("_ALPHABLEND_ON");
                        material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                        material.DisableKeyword("_ALPHAMODULATE_ON");
                        material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;
                        break;
                    case BlendMode.Transparent:
                        material.SetOverrideTag("RenderType", "Transparent");
                        material.SetInt("_BlendOp", (int)UnityEngine.Rendering.BlendOp.Add);
                        material.SetInt("_BlendOpAlpha", (int)UnityEngine.Rendering.BlendOp.Add);
                        material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                        material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                        material.SetInt("_SrcBlendAlpha", (int)UnityEngine.Rendering.BlendMode.One);
                        material.SetInt("_DstBlendAlpha", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                        material.SetInt("_ZWrite", 0);
                        material.SetInt("_ZTest", (int)UnityEngine.Rendering.CompareFunction.LessEqual);
                        material.DisableKeyword("_ALPHATEST_ON");
                        material.DisableKeyword("_ALPHABLEND_ON");
                        material.EnableKeyword("_ALPHAPREMULTIPLY_ON");
                        material.DisableKeyword("_ALPHAMODULATE_ON");
                        material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;
                        break;
                    case BlendMode.Skybox:
                        material.SetOverrideTag("RenderType", "Background");
                        material.SetInt("_BlendOp", (int)UnityEngine.Rendering.BlendOp.Add);
                        material.SetInt("_BlendOpAlpha", (int)UnityEngine.Rendering.BlendOp.Add);
                        material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                        material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                        material.SetInt("_SrcBlendAlpha", (int)UnityEngine.Rendering.BlendMode.One);
                        material.SetInt("_DstBlendAlpha", (int)UnityEngine.Rendering.BlendMode.Zero);
                        material.SetInt("_ZWrite", 0);
                        material.SetInt("_ZTest", (int)UnityEngine.Rendering.CompareFunction.LessEqual);
                        material.DisableKeyword("_ALPHATEST_ON");
                        material.DisableKeyword("_ALPHABLEND_ON");
                        material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                        material.DisableKeyword("_ALPHAMODULATE_ON");
                        material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Background;
                        break;
                    case BlendMode.Overlay:
                        material.SetOverrideTag("RenderType", "Overlay");
                        material.SetInt("_ZWrite", 0);
                        material.SetInt("_ZTest", (int)UnityEngine.Rendering.CompareFunction.Always);
                        material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Overlay;
                        break;
                    case BlendMode.Additive:
                        material.SetOverrideTag("RenderType", "Transparent");
                        material.SetInt("_BlendOp", (int)UnityEngine.Rendering.BlendOp.Add);
                        material.SetInt("_BlendOpAlpha", (int)UnityEngine.Rendering.BlendOp.Add);
                        material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
                        material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.One);
                        material.SetInt("_SrcBlendAlpha", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
                        material.SetInt("_DstBlendAlpha", (int)UnityEngine.Rendering.BlendMode.One);
                        material.SetInt("_ZWrite", 0);
                        material.SetInt("_ZTest", (int)UnityEngine.Rendering.CompareFunction.LessEqual);
                        material.DisableKeyword("_ALPHATEST_ON");
                        material.EnableKeyword("_ALPHABLEND_ON");
                        material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                        material.DisableKeyword("_ALPHAMODULATE_ON");
                        material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;
                        break;
                    case BlendMode.Subtractive:
                        material.SetOverrideTag("RenderType", "Transparent");
                        material.SetInt("_BlendOp", (int)UnityEngine.Rendering.BlendOp.ReverseSubtract);
                        material.SetInt("_BlendOpAlpha", (int)UnityEngine.Rendering.BlendOp.ReverseSubtract);
                        material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
                        material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.One);
                        material.SetInt("_SrcBlendAlpha", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
                        material.SetInt("_DstBlendAlpha", (int)UnityEngine.Rendering.BlendMode.One);
                        material.SetInt("_ZWrite", 0);
                        material.SetInt("_ZTest", (int)UnityEngine.Rendering.CompareFunction.LessEqual);
                        material.DisableKeyword("_ALPHATEST_ON");
                        material.EnableKeyword("_ALPHABLEND_ON");
                        material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                        material.DisableKeyword("_ALPHAMODULATE_ON");
                        material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;
                        break;
                    case BlendMode.Modulate:
                        material.SetOverrideTag("RenderType", "Transparent");
                        material.SetInt("_BlendOp", (int)UnityEngine.Rendering.BlendOp.Add);
                        material.SetInt("_BlendOpAlpha", (int)UnityEngine.Rendering.BlendOp.Add);
                        material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.DstColor);
                        material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                        material.SetInt("_SrcBlendAlpha", (int)UnityEngine.Rendering.BlendMode.DstColor);
                        material.SetInt("_DstBlendAlpha", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                        material.SetInt("_ZWrite", 0);
                        material.SetInt("_ZTest", (int)UnityEngine.Rendering.CompareFunction.LessEqual);
                        material.DisableKeyword("_ALPHATEST_ON");
                        material.DisableKeyword("_ALPHABLEND_ON");
                        material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                        material.EnableKeyword("_ALPHAMODULATE_ON");
                        material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;
                        break;
                }
            }
            
        }
    }

}