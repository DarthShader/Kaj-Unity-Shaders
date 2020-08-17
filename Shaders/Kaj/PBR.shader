Shader "Kaj/PBR"
{
    Properties
    {
        [HideInInspector] _Mode ("__mode", Int) = 0
        [HideInInspector] _LightModes ("__lightmodes", Int) = 0
        [HideInInspector] _DisableBatching ("__disableBatching", Int) = 0
        [HideInInspector] _IgnoreProjector ("__ignoreProjector", Int) = 0
        [HideInInspector] _ForceNoShadowCasting ("__forceNoShadowCasting", Int) = 0
        [HideInInspector] _CanUseSpriteAtlas ("__canUseSpriteAtlas", Int) = 1
        [HideInInspector] _PreviewType ("__previewType", Int) = 0

        [Header(Standard Settings)]
        [HideInInspector]group_Main("Main Settings", Int) = 0
        [MainColor]_Color("Color", Color) = (1,1,1,1)
        [MainTexture]_MainTex ("Albedo", 2D) = "white" { }
        [Indent]
            //[KajVector2]_MainTexPan("Panning", Vector) = (0,0,0,0)
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_MainTexUV ("UV Set", Int) = 0
        [UnIndent]
        [ToggleUI]_VertexColorsEnabled("Vertex Color Albedo and Transparency", Int) = 1
        [TexToggleActive]_CoverageMap ("Coverage (Alpha) Map", 2D) = "white" {}
        [HideInInspector]_CoverageMapActive ("", Int) = 0
        [Indent]
            _Cutoff("Cutoff", Range(0,1)) = 0.5
            [ToggleUI]_ForceOpaque("Force Opaque", Int) = 0
            [ToggleUI]_AlphaToCoverage("Alpha to Coverage", Int) = 0
            [ToggleUI]_DitheringEnabled("Dithered Transparency", Int) = 0
            [ToggleUI]_DitheredShadows("Dithered Transparent Shadows", Int) = 1
        [UnIndent]
        [Normal]_BumpMap("Normal Map", 2D) = "bump" {}
        [Indent]
            _BumpScale("Normals Scale", Float) = 1.0
        [UnIndent]
        [HDR]_EmissionColor("Emission Color", Color) = (1,1,1,1)
        _EmissionMap("Emission Map", 2D) = "white" {}
        [HideInInspector]end_Main("", Int) = 1

        [HideInInspector]group_StandardSettings("Standard Settings", Int) = 0
        [WideEnum(Metallic, 0, Specular, 1)]_WorkflowMode("Standard Workflow", Int) = 0
        [RangeMax]_Metallic("Metallic Max", Range(0.0, 1.0)) = 0.0
        [RangeMin]_MetallicMin("Metallic Min", Range(0.0, 1.0)) = 0.0
        [WideEnum(Glossiness Map,0, Combined Map,1, Metallic Alpha,2, Specular Alpha,3, Albedo Alpha,4)]_GlossinessSource("Glossiness Source", Int) = 0
        [WideEnum(Roughness, 0, Smoothness, 1)]_GlossinessMode("Glossiness Mode", Int) = 0
        [RangeMax]_Glossiness("Glossiness Max", Range(0.0, 1.0)) = 0.5
        [RangeMin]_GlossinessMin("Glossiness Min", Range(0.0, 1.0)) = 0.0
        _OcclusionStrength("Occlusion Strength", Range(0.0, 1.0)) = 1.0
        _SpecColor("Specular Color", Color) = (1,1,1,1)
        [RangeMax]_SpecularMax("Specular Max", Range(0.0, 1.0)) = 1.0
        [RangeMin]_SpecularMin("Specular Min", Range(0.0, 1.0)) = 0.0
        [ToggleUI]_ReceiveShadows("Receive Shadows", Int) = 1
        [HideInInspector]group_StandardTextures("Textures", Int) = 0
        [TexToggleActive]_MetallicGlossMap("Metallic Map", 2D) = "white" {}
        [HideInInspector]_MetallicGlossMapActive ("", Int) = 0
        [TexToggleActive]_SpecGlossMap("Glossiness Map", 2D) = "white" {}
        [HideInInspector]_SpecGlossMapActive ("", Int) = 0
        [TexToggleActive]_OcclusionMap("Occlusion Map", 2D) = "white" {}
        [HideInInspector]_OcclusionMapActive ("", Int) = 0
        [Indent]
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_OcclusionMapUV("UV Set", Int) = 0
        [UnIndent]
        [TexToggleActive]_SpecularMap("Specular Map (RGB)", 2D) = "white" {}
        [HideInInspector]_SpecularMapActive ("", Int) = 0
        [HideInInspector]end_StandardTextures("", Int) = 1
        [HideInInspector]group_CombinedMap("Combined Texture", Int) = 0
        [TexToggleActive]_CombinedMap("Combined Map (RGBA)", 2D) = "white" {}
        [HideInInspector]_CombinedMapActive ("", Int) = 0
        [Indent]
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_MetallicGlossMapCombinedMapChannel("Metallic Channel", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_SpecGlossMapCombinedMapChannel("Glossiness Channel", Int) = 1
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_OcclusionMapCombinedMapChannel("Occlusion Channel", Int) = 2
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_SpecularMapCombinedMapChannel("Specular Channel", Int) = 3
        [HideInInspector]end_CombinedMap("", Int) = 0
        [HideInInspector]end_StandardSettings("", Int) = 1

        [HideInInspector][ToggleUI]group_toggle_Diffuse("Shading", Int) = 1
        //[WideEnum(Lambert,0, PBR,1, Skin,2, ToonRamp,3)]_DiffuseMode("Mode", Int) = 1
        [WideEnum(Lambert,0, PBR,1, Skin,2, Flat Lit,3)]_DiffuseMode("Mode", Int) = 1
        [HideInInspector]group_SkinDiffuse("Skin", Int) = 0
        [NoScaleOffset]_PreIntSkinTex("Scattering Lookup Texture", 2D) = "white" {} // hard lniked to BRDF lookup tex
        _BumpBlurBias("Normals Blur Bias", Float) = 3.0
        _BlurStrength("Blur Strength", Range(0,1)) = 1
        _CurvatureInfluence("Curvature Influence", Range (0,1)) = 0.5
        _CurvatureScale("Curvature Scale", Float) = 0.02
        _CurvatureBias("Curvature Bias", Range(0,1)) = 0
        [HideInInspector]end_SkinDiffuse("", Int) = 0
        //[HideInInspector]group_ToonRampDiffuse("Toon", Int) = 0
        //[HideInInspector]end_ToonRampDiffuse("", Int) = 0
        [HideInInspector]end_Diffuse("", Int) = 0

        [HideInInspector][ToggleUI]group_toggle_Specular("Specular", Int) = 1
        //[WideEnum(Phong,0, PBR,1, Anisotropic,2, Skin,3, Toon,4)]_SpecularMode("Mode", Int) = 1
        [WideEnum(Phong,0, PBR,1, Skin,3)]_SpecularMode("Mode", Int) = 1
        [HideInInspector]group_PhongSpecular("Phong", Int) = 0
        _PhongSpecularPower("Power", Range(1,1000)) = 5
        _PhongSpecularIntensity("Intensity", Range(0,1)) = 1
        [HideInInspector]end_PhongSpecular("", Int) = 0
        //[HideInInspector]group_AnisotropicSpecular("Anisotropic", Int) = 0
        //[HideInInspector]end_AnisotropicSpecular("", Int) = 0
        //[HideInInspector]group_ToonSpecular("Toon", Int) = 0
        //[HideInInspector]end_ToonSpecular("", Int) = 0
        [HideInInspector]end_Specular("", Int) = 0

        [HideInInspector][ToggleUI]group_toggle_Reflections("Reflections", Int) = 1
        //[WideEnum(Basic,0, PBR,1, Skin,2, Toon,3)]_ReflectionsMode("Mode", Int) = 1
        [WideEnum(PBR,1, Skin,2)]_ReflectionsMode("Mode", Int) = 1
        [HideInInspector]group_PBRReflections("PBR", Int) = 0
        [ToggleUI]_GlossyReflections("Glossy Reflections", Int) = 1
        _StandardFresnelIntensity("Fresnel Intensity", Range(0,1)) = 1.0
        [HideInInspector]end_PBRReflections("", Int) = 0
        //[HideInInspector]group_ToonReflections("Toon", Int) = 0
        //[HideInInspector]end_ToonReflections("", Int) = 0
        [HideInInspector]end_Reflections("", Int) = 0

        [HideInInspector]group_Details("Detail Settings", Int) = 0
        [TexToggleActive]_DetailMask("Detail Mask (RGB)", 2D) = "white" {}
        [HideInInspector]_DetailMaskActive("", Int) = 0
        _DetailColorR("Detail Color (Red)", Color) = (1,1,1,1)
        _DetailColorG("Detail Color (Green)", Color) = (1,1,1,1)
        _DetailColorB("Detail Color (Blue)", Color) = (1,1,1,1)
        [TexToggleActive]_DetailAlbedoMap("Detail Albedo (Red)", 2D) = "grey" {}
        [HideInInspector]_DetailAlbedoMapActive("", Int) = 0
        [TexToggleActive]_DetailAlbedoMapGreen("Detail Albedo (Green)", 2D) = "grey" {}
        [HideInInspector]_DetailAlbedoMapGreenActive("", Int) = 0
        [TexToggleActive]_DetailAlbedoMapBlue("Detail Albedo (Blue)", 2D) = "grey" {}
        [HideInInspector]_DetailAlbedoMapBlueActive("", Int) = 0
        [Normal][TexToggleActive]_DetailNormalMap("Detail Normal Map (Red)", 2D) = "bump" {}
        [HideInInspector]_DetailNormalMapActive("", Int) = 0
        [Indent]
            _DetailNormalMapScale("Detail Normals (Red) Scale", Float) = 1.0
        [UnIndent]
        [Normal][TexToggleActive]_DetailNormalMapGreen("Detail Normal Map (Green)", 2D) = "bump" {}
        [HideInInspector]_DetailNormalMapGreenActive("", Int) = 0
        [Indent]
            _DetailNormalMapScaleGreen("Detail Normals (Green) Scale", Float) = 1.0
        [UnIndent]
        [Normal][TexToggleActive]_DetailNormalMapBlue("Detail Normal Map (Blue)", 2D) = "bump" {}
        [HideInInspector]_DetailNormalMapBlueActive("", Int) = 0
        [Indent]
            _DetailNormalMapScaleBlue("Detail Normals (Blue) Scale", Float) = 1.0
        [UnIndent]
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_UVSec ("Detail Textures UV Set", Int) = 0
        [WideEnum(Multiply x2,0,Multiply,1,Add,2,Lerp,3)]_DetailAlbedoCombineMode("Albedo Combine Mode", Int) = 0
        [HideInInspector]end_Details("", Int) = 0

        [HideInInspector][ToggleUI]group_toggle_Parallax("Parallax", Int) = 0
        [TexToggleActive]_ParallaxMap ("Parallax Map", 2D) = "white" {}
        [HideInInspector]_ParallaxMapActive ("", Int) = 0
        _Parallax ("Parallax Scale", Range (0, 0.08)) = 0.02
        _ParallaxBias ("Parallax Bias", Float) = 0.42
        [HideInInspector]end_Parallax("", Int) = 0

        //[HideInInspector]group_SubsurfaceScattering("Subsurface Scattering", Int) = 0
        //_DiffuseWrap("Diffuse Wrap", Range(0.5,1)) = 0.5
        //_DiffuseWrapIntensity("Diffuse Wrap Intensity", Range(0,1)) = 0
        [HideInInspector][ToggleUI]group_toggle_SSSTransmission("Subsurface Transmission", Int) = 0
        [ToggleUI]_SSSTransmissionShadowCastingLightsOnly("Shadow Casting Lights Only", Int) = 1
        [ToggleUI]_SSSTransmissionIgnoreShadowAttenuation("Ignore Shadows", Int) = 0
        _SubsurfaceColor("Subsurface Color", Color) = (1,0.4,0.25)
        _TranslucencyMap("Translucency Map", 2D) = "white" {}
        [RangeMax]_SSSTranslucencyMax("Translucency Max", Range(0,1)) = 0
        [RangeMin]_SSSTranslucencyMin("Translucency Min", Range(0,1)) = 0
        _SSSTransmissionPower("Power", Range(1,8)) = 2
        _SSSTransmissionDistortion("Normals Distortion", Range(0,1)) = 0.1
        _SSSTransmissionScale("Scale", Range(1,8)) = 4
        [HideInInspector]end_SSSTransmission("", Int) = 0
        //[HideInInspector]end_SubsurfaceScattering("", Int) = 0

        [HideInInspector]group_Blending("Blending Options", Int) = 0
        [WideEnum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Int) = 2
        [WideEnum(Off,0,On,1)] _AlphaToMask ("Alpha to Mask", Int) = 0
        [WideEnum(Off,0,On,1)] _ZWrite ("ZWrite", Int) = 1
        [WideEnum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 4
        _OffsetFactor("Offset Factor", Float) = 0
        _OffsetUnits("Offset Units", Float) = 0
        [WideEnum(Kaj.BlendOp)]_BlendOp ("RGB Blend Op", Int) = 0
        [WideEnum(Kaj.BlendOp)]_BlendOpAlpha ("Alpha Blend Op", Int) = 0
        [WideEnum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("RGB Source Blend", Int) = 1
        [WideEnum(UnityEngine.Rendering.BlendMode)] _DstBlend ("RGB Destination Blend", Int) = 0
        [WideEnum(UnityEngine.Rendering.BlendMode)] _SrcBlendAlpha ("Alpha Source Blend", Int) = 1
        [WideEnum(UnityEngine.Rendering.BlendMode)] _DstBlendAlpha ("Alpha Destination Blend", Int) = 0
        [WideEnum(Kaj.ColorMask)] _ColorMask("Color Mask", Int) = 15
        [HideInInspector]end_Blending("", Int) = 0

        [HideInInspector]group_Stencil("Stencil Options", Int) = 0
        [IntRange] _Stencil ("Reference Value", Range(0, 255)) = 0
        [IntRange] _StencilWriteMask ("ReadMask", Range(0, 255)) = 255
        [IntRange] _StencilReadMask ("WriteMask", Range(0, 255)) = 255
        [WideEnum(UnityEngine.Rendering.StencilOp)] _StencilPass ("Pass Op", Int) = 0
        [WideEnum(UnityEngine.Rendering.StencilOp)] _StencilFail ("Fail Op", Int) = 0
        [WideEnum(UnityEngine.Rendering.StencilOp)] _StencilZFail ("ZFail Op", Int) = 0
        [WideEnum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Compare Function", Int) = 8
        [HideInInspector]end_Stencil("", Int) = 0

        [HideInInspector]group_Debug("Debug", Int) = 0
        [HideInInspector]end_Debug("", Int) = 0

        [KajLabel]_Version("Shader Version: 13", Int) = 13
    }

    CustomEditor "Kaj.ShaderEditor"    
    SubShader
    {
        Tags { "RenderType"="Opaque" 
               "Queue"="Geometry+0" 
               //"IgnoreProjector"="True"      // Uncomment to enable, editor toggle doesn't work
               //"ForceNoShadowCasting"="True" // Broken too, hard coded to work, uncomment to save draw calls
             }
        LOD 300
        Cull [_Cull]
        ZTest [_ZTest]
        ColorMask [_ColorMask]
        Offset [_OffsetFactor], [_OffsetUnits]
        AlphaToMask [_AlphaToMask]

        Stencil
        {
            Ref [_Stencil]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
            Comp [_StencilComp]
            Pass [_StencilPass]
            Fail [_StencilFail]
            ZFail [_StencilZFail]
        }

        Pass
        {
            Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
            ZWrite [_ZWrite]
            BlendOp [_BlendOp], [_BlendOpAlpha]
            Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]

            CGPROGRAM
            #pragma target 5.0
            #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
            #pragma multi_compile_fwdbase
			#pragma multi_compile_fog
            #pragma multi_compile_instancing
            //#pragma instancing_options
			#pragma multi_compile _ LIGHTMAP_ON VERTEXLIGHT_ON
            #pragma multi_compile _ LOD_FADE_CROSSFADE

            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma vertex vert_full
            #pragma fragment frag_full_pbr
            #include "KajCore.cginc"
            ENDCG
        }

        Pass
        {
            Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
            Zwrite Off
            BlendOp [_BlendOp], [_BlendOpAlpha]
			Blend [_SrcBlend] One, [_SrcBlend] One
            Fog { Color (0,0,0,0) }

            CGPROGRAM
			#pragma target 5.0
            #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            //#pragma instancing_options
            #pragma multi_compile _ LOD_FADE_CROSSFADE

            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma vertex vert_full
            #pragma fragment frag_full_pbr
            #include "KajCore.cginc"
			ENDCG
        }

        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode"="ShadowCaster" }
            AlphaToMask Off

            CGPROGRAM
            #pragma target 5.0
            #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing
            //#pragma instancing_options
            #pragma multi_compile _ LOD_FADE_CROSSFADE

            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma vertex vert_shadow_full
            #pragma fragment frag_shadow_full
            #include "KajCore.cginc"
            ENDCG
        }

        Pass
        {
            Name "META"
            Tags { "LightMode"="Meta" }
            Cull Off

            CGPROGRAM
            #pragma target 5.0
            #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
            #pragma shader_feature EDITOR_VISUALIZATION

            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma vertex vert_meta_full
            #pragma fragment frag_meta_full
            #include "KajCore.cginc"
            ENDCG
        }
    }
    Fallback "Standard"
}