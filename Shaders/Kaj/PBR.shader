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

        [HideInInspector] _ShaderOptimizerEnabled ("__shaderOptimizerEnabled", Int) = 0

        [HideInInspector]group_Main("Main Settings", Int) = 0
        [MainColor]_Color("Color", Color) = (1,1,1,1)
        [MainTexture]_MainTex ("Albedo", 2D) = "white" { }
        [Indent]
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3,World Triplanar,4,Object Triplanar,5)]_MainTexUV ("UV Set", Int) = 0
        [UnIndent]
        [ToggleUI]_VertexColorsEnabled("Vertex Color Albedo and Transparency", Int) = 1
        _CoverageMap ("Coverage (Alpha) Map", 2D) = "white" {}
        [Indent]
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3,World Triplanar,4,Object Triplanar,5)]_CoverageMapUV ("UV Set", Int) = 0
        [UnIndent]
        _Cutoff("Cutoff", Range(0,1)) = 0.5
        [Indent]
            [ToggleUI]_ForceOpaque("Force Opaque", Int) = 0
            [ToggleUI]_AlphaToCoverage("Sharpen Alpha to Coverage", Int) = 0
            [ToggleUI]_DitheringEnabled("Dithered Transparency", Int) = 0
            [ToggleUI]_DitheredShadows("Dithered Transparent Shadows", Int) = 1
        [UnIndent]
        [Normal]_BumpMap("Normal Map", 2D) = "bump" {}
        [Indent]
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3,World Triplanar,4,Object Triplanar,5)]_BumpMapUV ("UV Set", Int) = 0
            _BumpScale("Normals Scale", Float) = 1.0
        [UnIndent]
        [HDR]_EmissionColor("Emission Color", Color) = (1,1,1,1)
        _EmissionMap("Emission Map", 2D) = "white" {}
        [Indent]
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3,World Triplanar,4,Object Triplanar,5)]_EmissionMapUV ("UV Set", Int) = 0
            _EmissionTintByAlbedo("Tint by Albedo", Range(0,1)) = 0
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
        [HideInInspector]group_StandardTextures("Textures", Int) = 0
        _MetallicGlossMap("Metallic Map", 2D) = "white" {}
        [Indent]
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3,World Triplanar,4,Object Triplanar,5)]_MetallicGlossMapUV ("UV Set", Int) = 0
        [UnIndent]
        _SpecGlossMap("Glossiness Map", 2D) = "white" {}
        [Indent]
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3,World Triplanar,4,Object Triplanar,5)]_SpecGlossMapUV ("UV Set", Int) = 0
        [UnIndent]
        _OcclusionMap("Occlusion Map", 2D) = "white" {}
        [Indent]
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3,World Triplanar,4,Object Triplanar,5)]_OcclusionMapUV("UV Set", Int) = 0
        [UnIndent]
        _SpecularMap("Specular Map (RGB)", 2D) = "white" {}
        [Indent]
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3,World Triplanar,4,Object Triplanar,5)]_SpecularMapUV("UV Set", Int) = 0
        [HideInInspector]end_StandardTextures("", Int) = 1
        [HideInInspector]group_CombinedMap("Combined Texture", Int) = 0
        _CombinedMap("Combined Map (RGBA)", 2D) = "white" {}
        [Indent]
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3,World Triplanar,4,Object Triplanar,5)]_CombinedMapUV("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_MetallicGlossMapCombinedMapChannel("Metallic Channel", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_SpecGlossMapCombinedMapChannel("Glossiness Channel", Int) = 1
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_OcclusionMapCombinedMapChannel("Occlusion Channel", Int) = 2
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_SpecularMapCombinedMapChannel("Specular Channel", Int) = 3
        [HideInInspector]end_CombinedMap("", Int) = 0
        [HideInInspector]end_StandardSettings("", Int) = 1

        [HideInInspector]group_Lighting("Lighting Settings", Int) = 0
        [ToggleUI]_HDREnabled("HDR Enabled", Int) = 1
        _ReceiveShadows("Receive Shadows", Range(0,1)) = 1
        [Indent]
            _ShadowsSmooth("Shadows Smooth", Range(0,1)) = 0
            _ShadowsSharp("Shardows Sharp", Range(0,1)) = 0
        [UnIndent]
        [ToggleUI]_FakeLightToggle("Use Fake Directional Light", Int) = 0
        [Indent]
            [KajVector3(Normalize)]_FakeLightDirection("Direction", Vector) = (0,1,0)
            _FakeLightColor("Color", Color) = (1,1,1,1)
            [MinimumFloat(0)]_FakeLightIntensity("Intensity", Float) = 1.0
        [UnIndent]
        [ToggleUI]_ReceiveFog("Receive Fog", Int) = 1
        [ToggleUI]_GlossyReflections("Glossy Reflections", Int) = 1
        [NoScaleOffset]_CubeMap ("Fallback Cubemap", Cube) = "" { }
        [WideEnum(Off,0, Fallback Only,1, Always Use CubeMap,2)]_CubeMapMode("Fallback Cubemap Mode", Int) = 0
        [HideInInspector]end_Lighting("", Int) = 0

        [HideInInspector][ToggleUI]group_toggle_Diffuse("Diffuse Shading", Int) = 1
        [WideEnum(Lambert,0, PBR,1, Skin,2, Flat Lit,3)]_DiffuseMode("Mode", Int) = 1
        _OcclusionDirectDiffuse("Occlusion Strength", Range(0,1)) = 0
        [HideInInspector]group_Lambert("Lambert", Int) = 0
        [ToggleUI]_DiffuseWrapIntensity("Diffuse Wrap", Int) = 0
        _DiffuseWrap("Wrap Factor", Range(0,1)) = 0.5
        [ToggleUI]_DiffuseWrapConserveEnergy("Conserve Energy", Int) = 0
        [HideInInspector]end_Lambert("", Int) = 0
        [HideInInspector]group_SkinDiffuse("Skin", Int) = 0
        [NoScaleOffset]_PreIntSkinTex("Scattering Lookup Texture", 2D) = "white" {} // hard lniked to BRDF lookup tex
        _BumpBlurBias("Normals Blur Bias", Float) = 3.0
        _BlurStrength("Blur Strength", Range(0,1)) = 1
        _CurvatureInfluence("Curvature Influence", Range (0,1)) = 0.5
        [MinimumFloat(0)]_CurvatureScale("Curvature Scale", Float) = 0.02
        _CurvatureBias("Curvature Bias", Range(0,1)) = 0
        _AOColorBleed("AO Color Bleed", Color) = (0.4,0.15,0.13,1)
        [HideInInspector]end_SkinDiffuse("", Int) = 0
        [HideInInspector]end_Diffuse("", Int) = 0

        [HideInInspector][ToggleUI]group_toggle_Specular("Specular Highlights", Int) = 1
        [WideEnum(Phong,0, PBR,1, PBR Anisotropic,2, Skin,3)]_SpecularMode("Mode", Int) = 1
        _OcclusionDirectSpecular("Occlusion Strength", Range(0,1)) = 0
        [HideInInspector]group_PhongSpecular("Phong", Int) = 0
        [MinimumFloat(1)]_PhongSpecularPower("Power", Float) = 5.0
        _PhongSpecularIntensity("Intensity", Range(0,1)) = 1
        [ToggleUI]_PhongSpecularUseRoughness("Use PBR Roughness for Power", Int) = 0
        [HideInInspector]end_PhongSpecular("", Int) = 0
        [HideInInspector]group_PBRAnisotropicSpecular("PBR Anisotropic", Int) = 0
        _SpecularAnisotropy("Anisotropy", Range(0,1)) = 0
        _SpecularAnisotropyAngle("Angle", Range(0,1)) = 0.5
        [HideInInspector]end_PBRAnisotropicSpecular("", Int) = 0
        [HideInInspector]end_Specular("", Int) = 0

        [HideInInspector][ToggleUI]group_toggle_Reflections("Reflections", Int) = 1
        [WideEnum(PBR,1, Skin,2, PBR Anisotropic,3)]_ReflectionsMode("Mode", Int) = 1
        [HideInInspector]group_PBRReflections("PBR", Int) = 0
        _StandardFresnelIntensity("Fresnel Intensity", Range(0,1)) = 1.0
        [HideInInspector]end_PBRReflections("", Int) = 0
        [HideInInspector]group_PBRAnisotropicReflections("PBR Anisotropic", Int) = 0
        _ReflectionsAnisotropy("Anisotropy", Range(0,1)) = 0
        _ReflectionsAnisotropyAngle("Angle", Range(0,1)) = 0.5
        [HideInInspector]end_PBRAnisotropicReflections("", Int) = 0
        [HideInInspector]end_Reflections("", Int) = 0

        [HideInInspector]group_Details("Detail Settings", Int) = 0
        _DetailMask("Detail Mask (RGB)", 2D) = "white" {}
        [Indent]
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3,World Triplanar,4,Object Triplanar,5)]_DetailMaskUV("UV Set", Int) = 0
        [UnIndent]
        _DetailColorR("Detail Color (Red)", Color) = (1,1,1,1)
        _DetailColorG("Detail Color (Green)", Color) = (1,1,1,1)
        _DetailColorB("Detail Color (Blue)", Color) = (1,1,1,1)
        [Space(10)]
        _DetailAlbedoMap("Detail Albedo (Red)", 2D) = "grey" {}
        _DetailAlbedoMapGreen("Detail Albedo (Green)", 2D) = "grey" {}
        _DetailAlbedoMapBlue("Detail Albedo (Blue)", 2D) = "grey" {}
        [Space(10)]
        [Normal]_DetailNormalMap("Detail Normal Map (Red)", 2D) = "bump" {}
        [Indent]
            _DetailNormalMapScale("Detail Normals (Red) Scale", Float) = 1.0
        [UnIndent]
        [Normal]_DetailNormalMapGreen("Detail Normal Map (Green)", 2D) = "bump" {}
        [Indent]
            _DetailNormalMapScaleGreen("Detail Normals (Green) Scale", Float) = 1.0
        [UnIndent]
        [Normal]_DetailNormalMapBlue("Detail Normal Map (Blue)", 2D) = "bump" {}
        [Indent]
            _DetailNormalMapScaleBlue("Detail Normals (Blue) Scale", Float) = 1.0
        [UnIndent]
        [Space(10)]
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3,World Triplanar,4,Object Triplanar,5)]_UVSec ("Detail Textures UV Set", Int) = 0
        [WideEnum(Multiply x2,0,Multiply,1,Add,2,Lerp,3)]_DetailAlbedoCombineMode("Albedo Combine Mode", Int) = 0
        [HideInInspector]end_Details("", Int) = 0

        [HideInInspector][ToggleUI]group_toggle_Parallax("Parallax", Int) = 0
        _ParallaxMap ("Parallax (Height) Map", 2D) = "white" {}
        [Indent]
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3,World Triplanar,4,Object Triplanar,5)]_ParallaxMapUV("UV Set", Int) = 0
        [UnIndent]
        _Parallax ("Parallax Scale", Range (0, 0.08)) = 0.02
        _ParallaxBias ("Parallax Bias", Float) = 0.42
        [ToggleUI]_ParallaxUV0 ("Affects UV0", Int) = 1
        [ToggleUI]_ParallaxUV1 ("Affects UV1", Int) = 1
        [ToggleUI]_ParallaxUV2 ("Affects UV2", Int) = 1
        [ToggleUI]_ParallaxUV3 ("Affects UV3", Int) = 1
        [HideInInspector]end_Parallax("", Int) = 0

        [HideInInspector][ToggleUI]group_toggle_SSSTransmission("Subsurface Transmission", Int) = 0
        [ToggleUI]_SSSTransmissionShadowCastingLightsOnly("Shadow Casting Lights Only", Int) = 1
        [ToggleUI]_SSSTransmissionIgnoreShadowAttenuation("Ignore Shadows", Int) = 0
        _SubsurfaceColor("Subsurface Color", Color) = (1,0.4,0.25)
        _TranslucencyMap("Translucency (Thickness) Map", 2D) = "white" {}
        [Indent]
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3,World Triplanar,4,Object Triplanar,5)]_TranslucencyMapUV("UV Set", Int) = 0
        [UnIndent]
        [RangeMax]_SSSTranslucencyMax("Translucency Max", Range(0,1)) = 0
        [RangeMin]_SSSTranslucencyMin("Translucency Min", Range(0,1)) = 0
        _SSSTransmissionPower("Power", Range(1,8)) = 2
        _SSSTransmissionDistortion("Normals Distortion", Range(0,1)) = 0.1
        _SSSTransmissionScale("Scale", Range(1,8)) = 4
        _SSSStylizedIndirect("Stylized Indirect Diffuse", Range(0,1)) = 0
        [Indent]
            [ToggleUI]_SSSStylizedIndrectScaleByTranslucency("Scale by Translucency", Int) = 0
        [HideInInspector]end_SSSTransmission("", Int) = 0

        [HideInInspector]group_Triplanar("Triplanar Mapping", Int) = 0
        [HelpBox]_TriplanarTooltip("Object and World Triplanar sampled textures are scaled using each texture's Tiling X parameter.  Offset X/Y offset the X/Y axes and Tiling Y offsets the Z axis.", Int) = 0
        [ToggleUI]_TriplanarUseVertexColors("Vertex Colors are Object Space Position", Int) = 0
        [HideInInspector]end_Triplanar("", Int) = 0

        [HideInInspector]group_Blending("Blending Options", Int) = 0
        [WideEnum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Int) = 2
        [WideEnum(Off,0,On,1)] _AlphaToMask ("Alpha To Coverage", Int) = 0
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
        [ToggleUI]_DebugWorldNormals("Show World Normal Direction", Int) = 0
        [ToggleUI]_DebugOcclusion("Show Occlusion", Int) = 0
        [HideInInspector]end_Debug("", Int) = 0

        [KajLabel]_Version("Shader Version: 20", Int) = 20
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
            #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON _ALPHAMODULATE_ON
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
            #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON _ALPHAMODULATE_ON
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
            #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON _ALPHAMODULATE_ON
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
            #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON _ALPHAMODULATE_ON
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