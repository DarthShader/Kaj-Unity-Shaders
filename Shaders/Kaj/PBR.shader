Shader "Kaj/PBR"
{
    Properties
    {
        [HideInInspector] _LightModes ("__lightmodes", Int) = 0
        [HideInInspector] _DisableBatching ("__disableBatching", Int) = 0
        [HideInInspector] _IgnoreProjector ("__ignoreProjector", Int) = 0
        [HideInInspector] _ForceNoShadowCasting ("__forceNoShadowCasting", Int) = 0
        [HideInInspector] _CanUseSpriteAtlas ("__canUseSpriteAtlas", Int) = 1
        [HideInInspector] _PreviewType ("__previewType", Int) = 0
        [HideInInspector] _DitheredLODCrossfade("__ditheredLODCrossfade", Int) = 0

        [HideInInspector] _ShaderOptimizerEnabled ("__shaderOptimizerEnabled", Int) = 0

        [HideInInspector] _Mode ("__mode", Int) = 0
        [HideInInspector] _Mode0 ("Opaque;RenderQueue=-1;RenderType=;_BlendOp=0;_BlendOpAlpha=0;_SrcBlend=1;_DstBlend=0;_SrcBlendAlpha=1;_DstBlendAlpha=0;_AlphaToMask=0;_ZWrite=1;_ZTest=4", Int) = 0
        [HideInInspector] _Mode1 ("Cutout;RenderQueue=2450;RenderType=TransparentCutout;_BlendOp=0;_BlendOpAlpha=0;_SrcBlend=1;_DstBlend=0;_SrcBlendAlpha=1;_DstBlendAlpha=0;_AlphaToMask=1;_ZWrite=1;_ZTest=4", Int) = 0
        [HideInInspector] _Mode2 ("Fade;RenderQueue=3000;RenderType=Transparent;_BlendOp=0;_BlendOpAlpha=0;_SrcBlend=5;_DstBlend=10;_SrcBlendAlpha=5;_DstBlendAlpha=10;_AlphaToMask=0;_ZWrite=0;_ZTest=4", Int) = 0
        [HideInInspector] _Mode3 ("Transparent;RenderQueue=3000;RenderType=Transparent;_BlendOp=0;_BlendOpAlpha=0;_SrcBlend=1;_DstBlend=10;_SrcBlendAlpha=1;_DstBlendAlpha=10;_AlphaToMask=0;_ZWrite=0;_ZTest=4", Int) = 0

        [HideInInspector]group_Main("Main Settings", Int) = 0
        [MainColor]_Color("Color", Color) = (1,1,1,1)
        [MainTexture]_MainTex ("Albedo", 2D) = "white" { }
        [Indent]
            [Enum(Kaj.UVMapping)]_MainTexUV ("UV Set", Int) = 0
        [UnIndent]
        [ToggleUI]_AlbedoTransparencyEnabled("Albedo Alpha is Transparency", Int) = 1
        [ToggleUI]_VertexColorsEnabled("Vertex Color Albedo and Transparency", Int) = 1
        _CoverageMap ("Coverage (Transparency) Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_CoverageMapUV ("UV Set", Int) = 0
        [UnIndent]
        _Cutoff("Cutoff", Range(0,1)) = 0.5
        [Indent]
            [ToggleUI]_AlphaToCoverage("Sharpen Cutout (Requires A2C)", Int) = 0
            [ToggleUI]_DitheringEnabled("Dithered Transparency", Int) = 0
            [ToggleUI]_DitheredShadows("Dithered Transparent Shadows", Int) = 1
        [UnIndent]
        [Normal]_BumpMap("Normal Map", 2D) = "bump" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_BumpMapUV ("UV Set", Int) = 0
            _BumpScale("Normals Scale", Float) = 1.0
        [UnIndent]
        [HDR]_EmissionColor("Emission Color", Color) = (1,1,1,1)
        _EmissionMap("Emission Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_EmissionMapUV ("UV Set", Int) = 0
            _EmissionTintByAlbedo("Tint by Albedo", Range(0,1)) = 0
        [HideInInspector]end_Main("", Int) = 1

        [HideInInspector]group_StandardSettings("Standard Settings", Int) = 0
        [WideEnum(Metallic, 0, Specular, 1)]_WorkflowMode("Standard Workflow", Int) = 0
        [RangeMax]_Metallic("Metallic Max", Range(0.0, 1.0)) = 0.0
        [RangeMin]_MetallicMin("Metallic Min", Range(0.0, 1.0)) = 0.0
        [WideEnum(Glossiness Map,0, Combined Map,1, Metallic Alpha,2, Specular Alpha,3, Albedo Alpha,4)]_GlossinessSource("Glossiness Source", Int) = 0
        [WideEnum(Roughness, 0, Smoothness, 1)]_GlossinessMode("Glossiness Mode", Int) = 1
        [RangeMax]_Glossiness("Glossiness Max", Range(0.0, 1.0)) = 0.5
        [RangeMin]_GlossinessMin("Glossiness Min", Range(0.0, 1.0)) = 0.0
        _OcclusionStrength("Occlusion Strength", Range(0.0, 1.0)) = 1.0
        _SpecColor("Specular Color", Color) = (1,1,1,1)
        [RangeMax]_SpecularMax("Specular Max", Range(0.0, 1.0)) = 1.0
        [RangeMin]_SpecularMin("Specular Min", Range(0.0, 1.0)) = 0.0
        [HideInInspector]group_StandardTextures("Textures", Int) = 0
        _MetallicGlossMap("Metallic Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_MetallicGlossMapUV ("UV Set", Int) = 0
        [UnIndent]
        _SpecGlossMap("Glossiness Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_SpecGlossMapUV ("UV Set", Int) = 0
        [UnIndent]
        _OcclusionMap("Occlusion Map (RGB)", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_OcclusionMapUV("UV Set", Int) = 0
        [UnIndent]
        _SpecularMap("Specular Map (RGB)", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_SpecularMapUV("UV Set", Int) = 0
        [HideInInspector]end_StandardTextures("", Int) = 1
        [HideInInspector]group_CombinedMap("Combined Texture", Int) = 0
        [HelpBox]_CombinedMapTooltip("Regular Metallic, Occlusion, and Specular textures will override the Combined texture's values if they exist.", Int) = 0
        _CombinedMap("Combined Map (RGBA)", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_CombinedMapUV("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_MetallicGlossMapCombinedMapChannel("Metallic Channel", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_SpecGlossMapCombinedMapChannel("Glossiness Channel", Int) = 1
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_OcclusionMapCombinedMapChannel("Occlusion Channel", Int) = 2
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_SpecularMapCombinedMapChannel("Specular Channel", Int) = 3
        [HideInInspector]end_CombinedMap("", Int) = 0
        [HideInInspector]end_StandardSettings("", Int) = 1

        [HideInInspector]group_Lighting("Lighting Settings", Int) = 0
        [ToggleUI]_HDREnabled("HDR Enabled", Int) = 1
        // Lights go here
        _DirectLightIntensity("Direct Light Intensity", Range(0,1)) = 1
        [Indent]
            _DirectionalLightIntensity("Directional Lights", Range(0,1)) = 1
            _PointLightIntensity("Point Lights", Range(0,1)) = 1
            _SpotLightIntensity("Spot Lights", Range(0,1)) = 1
        [UnIndent]
        _IndirectLightIntensity("Indirect Light Intensity", Range(0,1)) = 1
        [Indent]
            _VertexLightIntensity("Vertex Lights", Range(0,1)) = 1
            _LightProbeIntensity("Light Probes", Range(0,1)) = 1
            _LightmapIntensity("Lightmap", Range(0,1)) = 1
            _RealtimeLightmapIntensity("Realtime Lightmap", Range(0,1)) = 1
        [UnIndent]
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
        _ReceiveFog("Fog Intensity", Range(0,1)) = 1
        [ToggleUI]_GlossyReflections("Cubemap Reflections", Int) = 1
        [Indent]
            _ReflectionsIntensity("Intensity", Range(0,1)) = 1
        [UnIndent]
        [NoScaleOffset]_CubeMap ("Fallback Cubemap", Cube) = "" { }
        [WideEnum(Off,0, Fallback Only,1, Always Use CubeMap,2)]_CubeMapMode("Fallback Cubemap Mode", Int) = 0
        [HideInInspector]end_Lighting("", Int) = 0

        [HideInInspector][ToggleUI]group_toggle_Diffuse("Diffuse Shading", Int) = 1
        [WideEnum(Lambert,0, PBR,1, Skin,2, Flat Lit,3)]_DiffuseMode("Mode", Int) = 1
        _OcclusionDirectDiffuse("Occlusion Strength", Range(0,1)) = 0
        [HideInInspector]group_Lambert("Lambert", Int) = 0
        _DiffuseWrap("Wrap Factor", Range(0,1)) = 0
        [ToggleUI]_DiffuseWrapConserveEnergy("Wrap Conserves Energy", Int) = 0
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
            [Enum(Kaj.UVMapping)]_DetailMaskUV("UV Set", Int) = 0
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
        [Enum(Kaj.UVMapping)]_UVSec ("Detail Textures UV Set", Int) = 0
        [WideEnum(Multiply x2,0,Multiply,1,Add,2,Lerp,3)]_DetailAlbedoCombineMode("Albedo Combine Mode", Int) = 0
        [HideInInspector]end_Details("", Int) = 0

        [HideInInspector][ToggleUI]group_toggle_Parallax("Parallax", Int) = 0
        _ParallaxMap ("Parallax (Height) Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_ParallaxMapUV("UV Set", Int) = 0
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
            [Enum(Kaj.UVMapping)]_TranslucencyMapUV("UV Set", Int) = 0
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

        [HideInInspector]group_Triplanar("Triplanar/Planar Mapping", Int) = 0
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

        [HideInInspector]group_OptimizerSettings("Optimizer Settings", Int) = 0
        [HelpBox]_InlineSamplerStatesTooltip("Inline sampler states can be used so all textures' unique filter/wrap settings work at the cost of 1x anisotropic filtering on all textures.", Int) = 0
        [ToggleUI]_InlineSamplerStates("Use Inline Sampler States", Int) = 1
        [HelpBox]_AnimatedPropsTooltip("Any material properties that need to be changed at runtime should be selected here so the Optimizer does not bake them into the optimized shader.", Int) = 0
        [Header(Animated Properties)]
        [ToggleUILeft]_AlbedoTransparencyEnabledAnimated("  _AlbedoTransparencyEnabled", Int) = 0
        [ToggleUILeft]_AlphaToCoverageAnimated("  _AlphaToCoverage", Int) = 0
        [ToggleUILeft]_AOColorBleedAnimated("  _AOColorBleed", Int) = 0
        [ToggleUILeft]_BlurStrengthAnimated("  _BlurStrength", Int) = 0
        [ToggleUILeft]_BumpBlurBiasAnimated("  _BumpBlurBias", Int) = 0
        [ToggleUILeft]_BumpMap_STAnimated("  _BumpMap_ST", Int) = 0
        [ToggleUILeft]_BumpMap_TexelSizeAnimated("  _BumpMap_TexelSize", Int) = 0
        [ToggleUILeft]_BumpMapUVAnimated("  _BumpMapUV", Int) = 0
        [ToggleUILeft]_BumpScaleAnimated("  _BumpScale", Int) = 0
        [ToggleUILeft]_ColorAnimated("  _Color", Int) = 0
        [ToggleUILeft]_CombinedMap_STAnimated("  _CombinedMap_ST", Int) = 0
        [ToggleUILeft]_CombinedMap_TexelSizeAnimated("  _CombinedMap_TexelSize", Int) = 0
        [ToggleUILeft]_CombinedMapUVAnimated("  _CombinedMapUV", Int) = 0
        [ToggleUILeft]_CoverageMap_STAnimated("  _CoverageMap_ST", Int) = 0
        [ToggleUILeft]_CoverageMap_TexelSizeAnimated("  _CoverageMap_TexelSize", Int) = 0
        [ToggleUILeft]_CoverageMapUVAnimated("  _CoverageMapUV", Int) = 0
        [ToggleUILeft]_CubeMapAnimated("  _CubeMap", Int) = 0
        [ToggleUILeft]_CubeMapModeAnimated("  _CubeMapMode", Int) = 0
        [ToggleUILeft]_CurvatureBiasAnimated("  _CurvatureBias", Int) = 0
        [ToggleUILeft]_CurvatureInfluenceAnimated("  _CurvatureInfluence", Int) = 0
        [ToggleUILeft]_CurvatureScaleAnimated("  _CurvatureScale", Int) = 0
        [ToggleUILeft]_CutoffAnimated("  _Cutoff", Int) = 0
        [ToggleUILeft]_DebugOcclusionAnimated("  _DebugOcclusion", Int) = 0
        [ToggleUILeft]_DebugWorldNormalsAnimated("  _DebugWorldNormals", Int) = 0
        [ToggleUILeft]_DetailAlbedoCombineModeAnimated("  _DetailAlbedoCombineMode", Int) = 0
        [ToggleUILeft]_DetailAlbedoMap_STAnimated("  _DetailAlbedoMap_ST", Int) = 0
        [ToggleUILeft]_DetailAlbedoMap_TexelSizeAnimated("  _DetailAlbedoMap_TexelSize", Int) = 0
        [ToggleUILeft]_DetailAlbedoMapBlue_STAnimated("  _DetailAlbedoMapBlue_ST", Int) = 0
        [ToggleUILeft]_DetailAlbedoMapBlue_TexelSizeAnimated("  _DetailAlbedoMapBlue_TexelSize", Int) = 0
        [ToggleUILeft]_DetailAlbedoMapGreen_STAnimated("  _DetailAlbedoMapGreen_ST", Int) = 0
        [ToggleUILeft]_DetailAlbedoMapGreen_TexelSizeAnimated("  _DetailAlbedoMapGreen_TexelSize", Int) = 0
        [ToggleUILeft]_DetailColorBAnimated("  _DetailColorB", Int) = 0
        [ToggleUILeft]_DetailColorGAnimated("  _DetailColorG", Int) = 0
        [ToggleUILeft]_DetailColorRAnimated("  _DetailColorR", Int) = 0
        [ToggleUILeft]_DetailMask_STAnimated("  _DetailMask_ST", Int) = 0
        [ToggleUILeft]_DetailMask_TexelSizeAnimated("  _DetailMask_TexelSize", Int) = 0
        [ToggleUILeft]_DetailMaskUVAnimated("  _DetailMaskUV", Int) = 0
        [ToggleUILeft]_DetailNormalMap_STAnimated("  _DetailNormalMap_ST", Int) = 0
        [ToggleUILeft]_DetailNormalMap_TexelSizeAnimated("  _DetailNormalMap_TexelSize", Int) = 0
        [ToggleUILeft]_DetailNormalMapBlue_STAnimated("  _DetailNormalMapBlue_ST", Int) = 0
        [ToggleUILeft]_DetailNormalMapBlue_TexelSizeAnimated("  _DetailNormalMapBlue_TexelSize", Int) = 0
        [ToggleUILeft]_DetailNormalMapGreen_STAnimated("  _DetailNormalMapGreen_ST", Int) = 0
        [ToggleUILeft]_DetailNormalMapGreen_TexelSizeAnimated("  _DetailNormalMapGreen_TexelSize", Int) = 0
        [ToggleUILeft]_DetailNormalMapScaleAnimated("  _DetailNormalMapScale", Int) = 0
        [ToggleUILeft]_DetailNormalMapScaleBlueAnimated("  _DetailNormalMapScaleBlue", Int) = 0
        [ToggleUILeft]_DetailNormalMapScaleGreenAnimated("  _DetailNormalMapScaleGreen", Int) = 0
        [ToggleUILeft]_DiffuseModeAnimated("  _DiffuseMode", Int) = 0
        [ToggleUILeft]_DiffuseWrapAnimated("  _DiffuseWrap", Int) = 0
        [ToggleUILeft]_DiffuseWrapConserveEnergyAnimated("  _DiffuseWrapConserveEnergy", Int) = 0
        [ToggleUILeft]_DirectionalLightIntensityAnimated("  _DirectionalLightIntensityAnimated", Int) = 0
        [ToggleUILeft]_DirectLightIntensityAnimated("  _DirectLightIntensityAnimated", Int) = 0
        [ToggleUILeft]_DitheredShadowsAnimated("  _DitheredShadows", Int) = 0
        [ToggleUILeft]_DitheringEnabledAnimated("  _DitheringEnabled", Int) = 0
        [ToggleUILeft]_EmissionColorAnimated("  _EmissionColor", Int) = 0
        [ToggleUILeft]_EmissionMap_STAnimated("  _EmissionMap_ST", Int) = 0
        [ToggleUILeft]_EmissionMap_TexelSizeAnimated("  _EmissionMap_TexelSize", Int) = 0
        [ToggleUILeft]_EmissionMapUVAnimated("  _EmissionMapUV", Int) = 0
        [ToggleUILeft]_EmissionTintByAlbedoAnimated("  _EmissionTintByAlbedo", Int) = 0
        [ToggleUILeft]_FakeLightColorAnimated("  _FakeLightColor", Int) = 0
        [ToggleUILeft]_FakeLightDirectionAnimated("  _FakeLightDirection", Int) = 0
        [ToggleUILeft]_FakeLightIntensityAnimated("  _FakeLightIntensity", Int) = 0
        [ToggleUILeft]_FakeLightToggleAnimated("  _FakeLightToggle", Int) = 0
        [ToggleUILeft]_GlossinessAnimated("  _Glossiness", Int) = 0
        [ToggleUILeft]_GlossinessMinAnimated("  _GlossinessMin", Int) = 0
        [ToggleUILeft]_GlossinessModeAnimated("  _GlossinessMode", Int) = 0
        [ToggleUILeft]_GlossinessSourceAnimated("  _GlossinessSource", Int) = 0
        [ToggleUILeft]_GlossyReflectionsAnimated("  _GlossyReflections", Int) = 0
        [ToggleUILeft]_HDREnabledAnimated("  _HDREnabled", Int) = 0
        [ToggleUILeft]_IndirectLightIntensityAnimated("  _IndirectLightIntensityAnimated", Int) = 0
        [ToggleUILeft]_LightmapIntensityAnimated("  _LightmapIntensityAnimated", Int) = 0
        [ToggleUILeft]_LightProbeIntensityAnimated("  _LightProbeIntensityAnimated", Int) = 0
        [ToggleUILeft]_MainTex_STAnimated("  _MainTex_ST", Int) = 0
        [ToggleUILeft]_MainTex_TexelSizeAnimated("  _MainTex_TexelSize", Int) = 0
        [ToggleUILeft]_MainTexUVAnimated("  _MainTexUV", Int) = 0
        [ToggleUILeft]_MetallicAnimated("  _Metallic", Int) = 0
        [ToggleUILeft]_MetallicGlossMap_STAnimated("  _MetallicGlossMap_ST", Int) = 0
        [ToggleUILeft]_MetallicGlossMap_TexelSizeAnimated("  _MetallicGlossMap_TexelSize", Int) = 0
        [ToggleUILeft]_MetallicGlossMapCombinedMapChannelAnimated("  _MetallicGlossMapCombinedMapChannel", Int) = 0
        [ToggleUILeft]_MetallicGlossMapUVAnimated("  _MetallicGlossMapUV", Int) = 0
        [ToggleUILeft]_MetallicMinAnimated("  _MetallicMin", Int) = 0
        [ToggleUILeft]_OcclusionDirectDiffuseAnimated("  _OcclusionDirectDiffuse", Int) = 0
        [ToggleUILeft]_OcclusionDirectSpecularAnimated("  _OcclusionDirectSpecular", Int) = 0
        [ToggleUILeft]_OcclusionMap_STAnimated("  _OcclusionMap_ST", Int) = 0
        [ToggleUILeft]_OcclusionMap_TexelSizeAnimated("  _OcclusionMap_TexelSize", Int) = 0
        [ToggleUILeft]_OcclusionMapCombinedMapChannelAnimated("  _OcclusionMapCombinedMapChannel", Int) = 0
        [ToggleUILeft]_OcclusionMapUVAnimated("  _OcclusionMapUV", Int) = 0
        [ToggleUILeft]_OcclusionStrengthAnimated("  _OcclusionStrength", Int) = 0
        [ToggleUILeft]_ParallaxAnimated("  _Parallax", Int) = 0
        [ToggleUILeft]_ParallaxBiasAnimated("  _ParallaxBias", Int) = 0
        [ToggleUILeft]_ParallaxMap_STAnimated("  _ParallaxMap_ST", Int) = 0
        [ToggleUILeft]_ParallaxMap_TexelSizeAnimated("  _ParallaxMap_TexelSize", Int) = 0
        [ToggleUILeft]_ParallaxMapUVAnimated("  _ParallaxMapUV", Int) = 0
        [ToggleUILeft]_ParallaxUV0Animated("  _ParallaxUV0", Int) = 0
        [ToggleUILeft]_ParallaxUV1Animated("  _ParallaxUV1", Int) = 0
        [ToggleUILeft]_ParallaxUV2Animated("  _ParallaxUV2", Int) = 0
        [ToggleUILeft]_ParallaxUV3Animated("  _ParallaxUV3", Int) = 0
        [ToggleUILeft]_PhongSpecularIntensityAnimated("  _PhongSpecularIntensity", Int) = 0
        [ToggleUILeft]_PhongSpecularPowerAnimated("  _PhongSpecularPower", Int) = 0
        [ToggleUILeft]_PhongSpecularUseRoughnessAnimated("  _PhongSpecularUseRoughness", Int) = 0
        [ToggleUILeft]_PointLightIntensityAnimated("  _PointLightIntensityAnimated", Int) = 0
        [ToggleUILeft]_PreIntSkinTex_STAnimated("  _PreIntSkinTex_ST", Int) = 0
        [ToggleUILeft]_PreIntSkinTex_TexelSizeAnimated("  _PreIntSkinTex_TexelSize", Int) = 0
        [ToggleUILeft]_RealtimeLightmapIntensityAnimated("  _RealtimeLightmapIntensityAnimated", Int) = 0
        [ToggleUILeft]_ReceiveFogAnimated("  _ReceiveFog", Int) = 0
        [ToggleUILeft]_ReceiveShadowsAnimated("  _ReceiveShadows", Int) = 0
        [ToggleUILeft]_ReflectionsAnisotropyAngleAnimated("  _ReflectionsAnisotropyAngle", Int) = 0
        [ToggleUILeft]_ReflectionsAnisotropyAnimated("  _ReflectionsAnisotropy", Int) = 0
        [ToggleUILeft]_ReflectionsIntensityAnimated("  _ReflectionsIntensityAnimated", Int) = 0
        [ToggleUILeft]_ReflectionsModeAnimated("  _ReflectionsMode", Int) = 0
        [ToggleUILeft]_ShadowsSharpAnimated("  _ShadowsSharp", Int) = 0
        [ToggleUILeft]_ShadowsSmoothAnimated("  _ShadowsSmooth", Int) = 0
        [ToggleUILeft]_SpecColorAnimated("  _SpecColor", Int) = 0
        [ToggleUILeft]_SpecGlossMap_STAnimated("  _SpecGlossMap_ST", Int) = 0
        [ToggleUILeft]_SpecGlossMap_TexelSizeAnimated("  _SpecGlossMap_TexelSize", Int) = 0
        [ToggleUILeft]_SpecGlossMapCombinedMapChannelAnimated("  _SpecGlossMapCombinedMapChannel", Int) = 0
        [ToggleUILeft]_SpecGlossMapUVAnimated("  _SpecGlossMapUV", Int) = 0
        [ToggleUILeft]_SpecularAnisotropyAngleAnimated("  _SpecularAnisotropyAngle", Int) = 0
        [ToggleUILeft]_SpecularAnisotropyAnimated("  _SpecularAnisotropy", Int) = 0
        [ToggleUILeft]_SpecularMap_STAnimated("  _SpecularMap_ST", Int) = 0
        [ToggleUILeft]_SpecularMap_TexelSizeAnimated("  _SpecularMap_TexelSize", Int) = 0
        [ToggleUILeft]_SpecularMapCombinedMapChannelAnimated("  _SpecularMapCombinedMapChannel", Int) = 0
        [ToggleUILeft]_SpecularMapUVAnimated("  _SpecularMapUV", Int) = 0
        [ToggleUILeft]_SpecularMaxAnimated("  _SpecularMax", Int) = 0
        [ToggleUILeft]_SpecularMinAnimated("  _SpecularMin", Int) = 0
        [ToggleUILeft]_SpecularModeAnimated("  _SpecularMode", Int) = 0
        [ToggleUILeft]_SpotLightIntensityAnimated("  _SpotLightIntensityAnimated", Int) = 0
        [ToggleUILeft]_SSSStylizedIndirectAnimated("  _SSSStylizedIndirect", Int) = 0
        [ToggleUILeft]_SSSStylizedIndrectScaleByTranslucencyAnimated("  _SSSStylizedIndrectScaleByTranslucency", Int) = 0
        [ToggleUILeft]_SSSTranslucencyMaxAnimated("  _SSSTranslucencyMax", Int) = 0
        [ToggleUILeft]_SSSTranslucencyMinAnimated("  _SSSTranslucencyMin", Int) = 0
        [ToggleUILeft]_SSSTransmissionDistortionAnimated("  _SSSTransmissionDistortion", Int) = 0
        [ToggleUILeft]_SSSTransmissionIgnoreShadowAttenuationAnimated("  _SSSTransmissionIgnoreShadowAttenuation", Int) = 0
        [ToggleUILeft]_SSSTransmissionPowerAnimated("  _SSSTransmissionPower", Int) = 0
        [ToggleUILeft]_SSSTransmissionScaleAnimated("  _SSSTransmissionScale", Int) = 0
        [ToggleUILeft]_SSSTransmissionShadowCastingLightsOnlyAnimated("  _SSSTransmissionShadowCastingLightsOnly", Int) = 0
        [ToggleUILeft]_StandardFresnelIntensityAnimated("  _StandardFresnelIntensity", Int) = 0
        [ToggleUILeft]_SubsurfaceColorAnimated("  _SubsurfaceColor", Int) = 0
        [ToggleUILeft]_TranslucencyMap_STAnimated("  _TranslucencyMap_ST", Int) = 0
        [ToggleUILeft]_TranslucencyMap_TexelSizeAnimated("  _TranslucencyMap_TexelSize", Int) = 0
        [ToggleUILeft]_TranslucencyMapUVAnimated("  _TranslucencyMapUV", Int) = 0
        [ToggleUILeft]_TriplanarUseVertexColorsAnimated("  _TriplanarUseVertexColors", Int) = 0
        [ToggleUILeft]_UVSecAnimated("  _UVSec", Int) = 0
        [ToggleUILeft]_VertexColorsEnabledAnimated("  _VertexColorsEnabled", Int) = 0
        [ToggleUILeft]_VertexLightIntensityAnimated("  _VertexLightIntensityAnimated", Int) = 0
        [ToggleUILeft]_WorkflowModeAnimated("  _WorkflowMode", Int) = 0
        [HideInInspector]end_OptimizerSettings("", Int) = 0

        [HideInInspector]group_Debug("Debug", Int) = 0
        [ToggleUI]_DebugWorldNormals("World Normal Direction", Int) = 0
        [ToggleUI]_DebugOcclusion("Occlusion", Int) = 0
        [HideInInspector]end_Debug("", Int) = 0

        [KajLabel]_Version("Shader Version: 30", Int) = 30
    }

    CustomEditor "Kaj.ShaderEditor"
    SubShader
    {
        Tags { "RenderType"="Opaque" 
               "Queue"="Geometry+0" 
               //"IgnoreProjector"="True"      // Override tags/editor toggle doesn't work on these
               //"ForceNoShadowCasting"="True" // Use the optimizer to lock in, which will uncomment if they're used
             }

        // These blending and stencil options could technically be per-pass settings, but to simplify the material editor
        // for end users everything is put into one group of settings with a few differences in each pass
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
            #pragma multi_compile_fwdbase
			#pragma multi_compile_fog
            #pragma multi_compile_instancing
            //#pragma instancing_options
			#pragma multi_compile _ LIGHTMAP_ON VERTEXLIGHT_ON
            //#pragma multi_compile _ LOD_FADE_CROSSFADE // Uncommented dynamically by the optimizer

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
			#pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            //#pragma instancing_options
            //#pragma multi_compile _ LOD_FADE_CROSSFADE

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
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing
            //#pragma instancing_options
            //#pragma multi_compile _ LOD_FADE_CROSSFADE

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
            #pragma shader_feature EDITOR_VISUALIZATION

            #pragma vertex vert_meta_full
            #pragma fragment frag_meta_full
            #include "KajCore.cginc"
            ENDCG
        }
    }
}