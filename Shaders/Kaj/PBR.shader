Shader "Kaj/PBR"
{
    Properties
    {
        [HideInInspector] _Mode ("__mode", Int) = 0
        [HideInInspector] _DisableBatching ("__disableBatching", Int) = 0
        [HideInInspector] _IgnoreProjector ("__ignoreProjector", Int) = 0
        [HideInInspector] _ForceNoShadowCasting ("__forceNoShadowCasting", Int) = 0
        [HideInInspector] _CanUseSpriteAtlas ("__canUseSpriteAtlas", Int) = 1
        [HideInInspector] _PreviewType ("__previewType", Int) = 0

        [Header(Standard Settings)]
        [MainColor]_Color("Color", Color) = (1,1,1,1)
        [MainTexture]_MainTex ("Albedo", 2D) = "white" { }
        [Indent]
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_MainTexUV ("UV Set", Int) = 0
        [UnIndent]
        [TexToggleActive]_CoverageMap ("Coverage (Alpha) Map", 2D) = "white" {}
        [HideInInspector]_CoverageMapActive ("", Int) = 0
        [Indent]
            _Cutoff("Cutoff", Range(0,1)) = 0.5
            [ToggleUI]_ForceOpaque("Force Opaque", Int) = 0
            [ToggleUI]_AlphaToCoverage("Alpha to Coverage", Int) = 0
            [ToggleUI]_DitheredShadows("Dithered Transparent Shadows", Int) = 1
        [UnIndent]
        [Normal]_BumpMap("Normal Map", 2D) = "bump" {}
        [Indent]
            _BumpScale("Normals Scale", Float) = 1.0
        [UnIndent]
        [HDR]_EmissionColor("Emission Color", Color) = (1,1,1,1)
        _EmissionMap("Emission Map", 2D) = "white" {}

        [Header(PBR Shading)]
        [Enum(Metallic, 0, Specular, 1)]_WorkflowMode("Standard Workflow Mode", Int) = 0
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
        [Indent]
            _SpecColor("Specular Color", Color) = (1,1,1,1)
        [UnIndent]
        [TexToggleActive]_CombinedMap("Combined Map (RGBA)", 2D) = "white" {}
        [HideInInspector]_CombinedMapActive ("", Int) = 0
        [Indent]
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_MetallicGlossMapCombinedMapChannel("Metallic Channel", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3,Albedo Alpha,4,Metallic Alpha,5,Specular Alpha,6)]_SpecGlossMapCombinedMapChannel("Glossiness Channel or Source", Int) = 1
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_OcclusionMapCombinedMapChannel("Occlusion Channel", Int) = 2
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_SpecularMapCombinedMapChannel("Specular Channel", Int) = 3
        [UnIndent]
        _Metallic("Metallic Max", Range(0.0, 1.0)) = 0.0
        _MetallicMin("Metallic Min", Range(0.0, 1.0)) = 0.0
        [Enum(Roughness, 0, Smoothness, 1)]_GlossinessMode("Glossiness Mode", Int) = 0
        _Glossiness("Glossiness Max", Range(0.0, 1.0)) = 0.5
        _GlossinessMin("Glossiness Min", Range(0.0, 1.0)) = 0.0
        _OcclusionStrength("Occlusion Strength", Range(0.0, 1.0)) = 1.0
        _SpecularMax("Specular Max", Range(0.0, 1.0)) = 1.0
        _SpecularMin("Specular Min", Range(0.0, 1.0)) = 0.0
        [ToggleUI]_SpecularHighlights("Specular Highlights", Int) = 1
        [ToggleUI]_GlossyReflections("Glossy Reflections", Int) = 1
        _StandardFresnelIntensity("Fresnel Intensity", Range(0,1)) = 1.0
        
        [Header(Detail Settings)]
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
        [Enum(Mul x2,0,Multiply,1,Add,2,Lerp,3)]_DetailAlbedoCombineMode("Detail Albedo Combine Mode", Int) = 0

        [Header(Parallax Settings)]
        [TexToggleActive]_ParallaxMap ("Parallax Map", 2D) = "black" {}
        [HideInInspector]_ParallaxMapActive ("", Int) = 0
        _Parallax ("Parallax Scale", Range (0, 0.08)) = 0.02
        _ParallaxBias ("Parallax Bias", Float) = 0.42

        [Header(Blending Options)]
        [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Int) = 2
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 4
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Source Blend", Int) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Destination Blend", Int) = 0
        [Enum(Off,0,On,1)] _ZWrite ("ZWrite", Int) = 1
        [Enum(Kaj.ColorMask)] _ColorMask("Color Mask", Int) = 15
        _OffsetFactor("Offset Factor", Float) = 0
        _OffsetUnits("Offset Units", Float) = 0

        [Header(Stencil Options)]
        [IntRange] _Stencil ("Stencil Reference Value", Range(0, 255)) = 0
        [IntRange] _StencilWriteMask ("Stencil ReadMask Value", Range(0, 255)) = 255
        [IntRange] _StencilReadMask ("Stencil WriteMask Value", Range(0, 255)) = 255
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilPass ("Stencil Pass Op", Int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilFail ("Stencil Fail Op", Int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilZFail ("Stencil ZFail Op", Int) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Compare Function", Int) = 8

        [KajLabel]_Version("Shader Version: 2", Int) = 2
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
        AlphaToMask [_AlphaToCoverage]

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
            Blend [_SrcBlend] [_DstBlend]

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
			Blend [_SrcBlend] One
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