Shader "Kaj/Omega"
{
    Properties
    {
        [GIFlags] _GIFlags ("Global Illumination", Int) = 4
        [DisabledLightModes] _LightModes ("Disabled LightModes", Int) = 0
        [DisableBatching] _DisableBatching ("Disable Batching", Int) = 0
        [PreviewType] _PreviewType ("Preview Type", Int) = 0
        [OverrideTagToggle(IgnoreProjector)] _IgnoreProjector ("IgnoreProjector", Int) = 0
        [OverrideTagToggle(ForceNoShadowCasting)] _ForceNoShadowCasting ("ForceNoShadowCasting", Int) = 0
        [OverrideTagToggle(CanUseSpriteAtlas)] _CanUseSpriteAtlas ("CanUseSpriteAtlas", Int) = 1

        // Keyword to remind users in the VRChat SDK that this material hasn't been locked.  Inelegant but it works.
        [HideInInspector] _ForgotToLockMaterial(";;YOU_FORGOT_TO_LOCK_THIS_MATERIAL;", Int) = 1
        [ShaderOptimizerLockButton] _ShaderOptimizerEnabled ("", Int) = 0
        [HelpBox(3)] _LockTooltip("ALWAYS LOCK YOUR MATERIALS BEFORE BUILDING VRCHAT AVATARS AND WORLDS", Int) = 0

        [PresetsEnum] _Mode ("Rendering Mode;Opaque,RenderQueue=-1,RenderType=,_BlendOp=0,_BlendOpAlpha=0,_SrcBlend=1,_DstBlend=0,_SrcBlendAlpha=1,_DstBlendAlpha=0,_AlphaToMask=0,_ZWrite=1,_ZTest=4;Cutout,RenderQueue=2450,RenderType=TransparentCutout,_BlendOp=0,_BlendOpAlpha=0,_SrcBlend=1,_DstBlend=0,_SrcBlendAlpha=1,_DstBlendAlpha=0,_AlphaToMask=1,_ZWrite=1,_ZTest=4;Fade,RenderQueue=3000,RenderType=Transparent,_BlendOp=0,_BlendOpAlpha=0,_SrcBlend=5,_DstBlend=10,_SrcBlendAlpha=5,_DstBlendAlpha=10,_AlphaToMask=0,_ZWrite=0,_ZTest=4;Transparent,RenderQueue=3000,RenderType=Transparent,_BlendOp=0,_BlendOpAlpha=0,_SrcBlend=1,_DstBlend=10,_SrcBlendAlpha=1,_DstBlendAlpha=10,_AlphaToMask=0,_ZWrite=0,_ZTest=4", Int) = 0

        [HideInInspector]group_Main("Main Settings", Int) = 0
        [MainColor]_Color("Color", Color) = (1,1,1,1)
        [MainTexture]_MainTex ("Albedo", 2D) = "white" { }
        [Indent]
            [Enum(Kaj.UVMapping)]_MainTexUV ("UV Set", Int) = 0
            [Enum(RGB,0, RGBA,1)]_AlbedoTransparencyEnabled("Channels to Sample", Int) = 1
        [UnIndent]
        [ToggleUI]_VertexColorsEnabled("Vertex Color Albedo", Int) = 0
        [KeywordTex(_SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A)]_CoverageMap (";;_SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A;Coverage (Transparency) Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_CoverageMapUV ("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_CoverageMapChannel("Channel to Sample", Int) = 0
        [UnIndent]
        [ToggleUI]_VertexColorsTransparencyEnabled("Vertex Color Transparency", Int) = 0
        _Cutoff("Cutoff", Range(0,1)) = 0.5
        [Indent]
            [ToggleUI]_AlphaToMask ("Alpha To Coverage", Int) = 0
            [ToggleUI]_DitheringEnabled("Dithered Transparency", Int) = 0
            [ToggleUI]_DitheredShadows("Dithered Transparent Shadows", Int) = 1
        [UnIndent]
        [Normal][KeywordTex(_NORMALMAP)]_BumpMap(";;_NORMALMAP;Normal Map", 2D) = "bump" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_BumpMapUV ("UV Set", Int) = 0
            [Enum(Tangent Space,0, Object Space,1, World Space,2)]_BumpMapSpace("Space", Int) = 0
            _BumpScale("Normals Scale", Float) = 1.0
        [UnIndent]
        [HDR]_EmissionColor("Emission Color", Color) = (1,1,1,1)
        [KeywordTex(_EMISSION)]_EmissionMap(";;_EMISSION;Emission Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_EmissionMapUV ("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3,RGB,4)]_EmissionMapChannel("Channel(s) to Sample", Int) = 4
            _EmissionTintByAlbedo("Tint by Albedo", Range(0,1)) = 0
            [MinimumFloat(0)]_RealtimeGIIntensity("Realtime GI Intensity", Float) = 1
        [HideInInspector]end_Main("", Int) = 1

        [HideInInspector]group_StandardSettings("Standard Settings", Int) = 0
        [WideEnum(Metallic, 0, Specular, 1)]_WorkflowMode("Standard Workflow", Int) = 0
        [KeywordTex(_METALLICGLOSSMAP)]_MetallicGlossMap(";;_METALLICGLOSSMAP;Metallic Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_MetallicGlossMapUV ("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_MetallicGlossMapChannel("Channel to Sample", Int) = 0
            [RangeMax]_Metallic("Metallic Max", Range(0.0, 1.0)) = 0.0
            [RangeMin]_MetallicMin("Metallic Min", Range(0.0, 1.0)) = 0.0
        [UnIndent]
        [WideEnum(Roughness, 0, Smoothness, 1)]_GlossinessMode("Glossiness Mode", Int) = 1
        [KeywordTex(_GLOSSYREFLECTIONS_OFF)]_SpecGlossMap(";;_GLOSSYREFLECTIONS_OFF;Glossiness Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_SpecGlossMapUV ("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_SpecGlossMapChannel("Channel to Sample", Int) = 0
            [RangeMax]_Glossiness("Glossiness Max", Range(0.0, 1.0)) = 0.5
            [RangeMin]_GlossinessMin("Glossiness Min", Range(0.0, 1.0)) = 0.0
        [UnIndent]
        [KeywordTex(_REQUIRE_UV2)]_OcclusionMap(";;_REQUIRE_UV2;Occlusion Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_OcclusionMapUV("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3,RGB,4)]_OcclusionMapChannel("Channel(s) to Sample", Int) = 4
            _OcclusionStrength("Indirect Diffuse Strength", Range(0.0, 1.0)) = 1.0
            _OcclusionDirectDiffuse("Direct Diffuse Strength", Range(0,1)) = 0
            _OcclusionDirectSpecular("Specular Strength", Range(0,1)) = 0
            _OcclusionIndirectSpecular("Reflections Strength", Range(0,1)) = 0
        [UnIndent]
        _SpecColor("Specular Color", Color) = (1,1,1,1)
        [KeywordTex(_SPECGLOSSMAP)]_SpecularMap(";;_SPECGLOSSMAP;Specular Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_SpecularMapUV("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3,RGB,4)]_SpecularMapChannel("Channel(s) to Sample", Int) = 4
            [RangeMax]_SpecularMax("Specular Max", Range(0.0, 1.0)) = 1.0
            [RangeMin]_SpecularMin("Specular Min", Range(0.0, 1.0)) = 0.0
        [UnIndent]
        [HideInInspector]end_StandardSettings("", Int) = 1

        [HideInInspector]group_advanced_normals("Extra Normal Maps", Int) = 0
        [KeywordTex(AUTO_KEY_VALUE)]_BentNormalMap(";;AUTO_KEY_VALUE;Bent Normal Map", 2D) = "bump" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_BentNormalMapUV ("UV Set", Int) = 0
            [Enum(RGorAG DXTnm,0, RGB,1, AG Hemi Octahedron,2)]_BentNormalMapEncoding("Normals Encoding", Int) = 0
            [Enum(Tangent Space,0, Object Space,1, World Space,2)]_BentNormalMapSpace("Normals Space", Int) = 0
        [UnIndent]
        [KeywordTex(DITHERING)]_AlternateBumpMap(";;DITHERING;Default-Texture Normal Map", 2D) = "bump" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_AlternateBumpMapUV ("UV Set", Int) = 0
            [Enum(RGorAG DXTnm,0, RGB,1, AG Hemi Octahedron,2)]_AlternateBumpMapEncoding("Normals Encoding", Int) = 0
            [Enum(Tangent Space,0, Object Space,1, World Space,2)]_AlternateBumpMapSpace("Normals Space", Int) = 0
            _AlternateBumpScale("Normals Scale", Float) = 1.0
        [UnIndent]
        [HelpBox]_NormalMapSettingsTooltip("Special normals & tangents must be created for skinned meshes with object space normal maps.  This will break tangent space normals and many effects that rely on mesh normals.", Int) = 0
        [ToggleUI]_IdentityNormalsAndTangents("Custom Normals & Tangets for Skinned Meshes", Int) = 0
        [HideInInspector]end_advanced_normals("", Int) = 0

        [HideInInspector]group_Lighting("Lighting Settings", Int) = 0
        [ToggleUI]_HDREnabled("HDR Enabled", Int) = 1
        [ToggleUI]_FlippedNormalBackfaces("Backfaces use Flipped Normals (Cull Front/Off)", Int) = 1
        [ToggleUI]_GeometricSpecularAA("Geometric Specular Anti-aliasing", Int) = 0
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
            [ToggleUI]_IndirectSpecFallback("Indirect Specular Fallback", Int) = 1
            _ReflectionsIntensity("Intensity", Range(0,1)) = 1
            [NoScaleOffset]_CubeMap ("Fallback Cubemap", Cube) = "" { }
            [WideEnum(Off,0, Fallback Only,1, Always Use CubeMap,2)]_CubeMapMode("Fallback Cubemap Mode", Int) = 0
        [UnIndent]
        [HideInInspector]end_Lighting("", Int) = 0

        [HideInInspector]group_ShaderLights("Shader Lights", Int) = 0
        [HideInInspector][ToggleUI]group_toggle_ShaderLight0("Shader Light 0", Int) = 0
            [ShaderLight(_ShaderLight0)]
            [WideEnum(Point,0, Spot,1, Directional,2)]_ShaderLight0Mode("Mode", Int) = 0
            [ToggleUI]_ShaderLight0Specular("Specular Highlights", Int) = 1
            [KajVector3]_ShaderLight0Position("Position", Vector) = (0,0,0,0)
            [KajVector3]_ShaderLight0Direction("Direction", Vector) = (1,0,0,0)
            [MinimumFloat(0)]_ShaderLight0Angle("Angle", Float) = 30
            [MinimumFloat(0)]_ShaderLight0Range("Range", Float) = 10
            _ShaderLight0Color("Color", Color) = (1,1,1,1)
            [MinimumFloat(0)]_ShaderLight0Intensity("Intensity", Float) = 1
            [Header(Animated Properties)]
            [ToggleUILeft]group_toggle_ShaderLight0Animated("  Shader Light 0", Int) = 0
            [ToggleUILeft]_ShaderLight0ModeAnimated("  Mode", Int) = 0
            [ToggleUILeft]_ShaderLight0SpecularAnimated("  Specular Highlights", Int) = 0
            [ToggleUILeft]_ShaderLight0PositionAnimated("  Position", Int) = 0
            [ToggleUILeft]_ShaderLight0DirectionAnimated("  Direction", Int) = 0
            [ToggleUILeft]_ShaderLight0AngleAnimated("  Angle", Int) = 0
            [ToggleUILeft]_ShaderLight0RangeAnimated("  Range", Int) = 0
            [ToggleUILeft]_ShaderLight0ColorAnimated("  Color", Int) = 0
            [ToggleUILeft]_ShaderLight0IntensityAnimated("  Intensity", Int) = 0
        [HideInInspector]end_ShaderLight0("", Int) = 0
        [HideInInspector][ToggleUI]group_toggle_ShaderLight1("Shader Light 1", Int) = 0
            [ShaderLight(_ShaderLight1)]
            [WideEnum(Point,0, Spot,1, Directional,2)]_ShaderLight1Mode("Mode", Int) = 0
            [ToggleUI]_ShaderLight1Specular("Specular Highlights", Int) = 1
            [KajVector3]_ShaderLight1Position("Position", Vector) = (0,0,0,0)
            [KajVector3]_ShaderLight1Direction("Direction", Vector) = (1,0,0,0)
            [MinimumFloat(0)]_ShaderLight1Angle("Angle", Float) = 30
            [MinimumFloat(0)]_ShaderLight1Range("Range", Float) = 10
            _ShaderLight1Color("Color", Color) = (1,1,1,1)
            [MinimumFloat(0)]_ShaderLight1Intensity("Intensity", Float) = 1
            [Header(Animated Properties)]
            [ToggleUILeft]group_toggle_ShaderLight1Animated("  Shader Light 1", Int) = 0
            [ToggleUILeft]_ShaderLight1ModeAnimated("  Mode", Int) = 0
            [ToggleUILeft]_ShaderLight1SpecularAnimated("  Specular Highlights", Int) = 0
            [ToggleUILeft]_ShaderLight1PositionAnimated("  Position", Int) = 0
            [ToggleUILeft]_ShaderLight1DirectionAnimated("  Direction", Int) = 0
            [ToggleUILeft]_ShaderLight1AngleAnimated("  Angle", Int) = 0
            [ToggleUILeft]_ShaderLight1RangeAnimated("  Range", Int) = 0
            [ToggleUILeft]_ShaderLight1ColorAnimated("  Color", Int) = 0
            [ToggleUILeft]_ShaderLight1IntensityAnimated("  Intensity", Int) = 0
        [HideInInspector]end_ShaderLight1("", Int) = 0
        [HideInInspector][ToggleUI]group_toggle_ShaderLight2("Shader Light 2", Int) = 0
            [ShaderLight(_ShaderLight2)]
            [WideEnum(Point,0, Spot,1, Directional,2)]_ShaderLight2Mode("Mode", Int) = 0
            [ToggleUI]_ShaderLight2Specular("Specular Highlights", Int) = 1
            [KajVector3]_ShaderLight2Position("Position", Vector) = (0,0,0,0)
            [KajVector3]_ShaderLight2Direction("Direction", Vector) = (1,0,0,0)
            [MinimumFloat(0)]_ShaderLight2Angle("Angle", Float) = 30
            [MinimumFloat(0)]_ShaderLight2Range("Range", Float) = 10
            _ShaderLight2Color("Color", Color) = (1,1,1,1)
            [MinimumFloat(0)]_ShaderLight2Intensity("Intensity", Float) = 1
            [Header(Animated Properties)]
            [ToggleUILeft]group_toggle_ShaderLight2Animated("  Shader Light 2", Int) = 0
            [ToggleUILeft]_ShaderLight2ModeAnimated("  Mode", Int) = 0
            [ToggleUILeft]_ShaderLight2SpecularAnimated("  Specular Highlights", Int) = 0
            [ToggleUILeft]_ShaderLight2PositionAnimated("  Position", Int) = 0
            [ToggleUILeft]_ShaderLight2DirectionAnimated("  Direction", Int) = 0
            [ToggleUILeft]_ShaderLight2AngleAnimated("  Angle", Int) = 0
            [ToggleUILeft]_ShaderLight2RangeAnimated("  Range", Int) = 0
            [ToggleUILeft]_ShaderLight2ColorAnimated("  Color", Int) = 0
            [ToggleUILeft]_ShaderLight2IntensityAnimated("  Intensity", Int) = 0
        [HideInInspector]end_ShaderLight2("", Int) = 0
        [HideInInspector][ToggleUI]group_toggle_ShaderLight3("Shader Light 3", Int) = 0
            [ShaderLight(_ShaderLight3)]
            [WideEnum(Point,0, Spot,1, Directional,2)]_ShaderLight3Mode("Mode", Int) = 0
            [ToggleUI]_ShaderLight3Specular("Specular Highlights", Int) = 1
            [KajVector3]_ShaderLight3Position("Position", Vector) = (0,0,0,0)
            [KajVector3]_ShaderLight3Direction("Direction", Vector) = (1,0,0,0)
            [MinimumFloat(0)]_ShaderLight3Angle("Angle", Float) = 30
            [MinimumFloat(0)]_ShaderLight3Range("Range", Float) = 10
            _ShaderLight3Color("Color", Color) = (1,1,1,1)
            [MinimumFloat(0)]_ShaderLight3Intensity("Intensity", Float) = 1
            [Header(Animated Properties)]
            [ToggleUILeft]group_toggle_ShaderLight3Animated("  Shader Light 3", Int) = 0
            [ToggleUILeft]_ShaderLight3ModeAnimated("  Mode", Int) = 0
            [ToggleUILeft]_ShaderLight3SpecularAnimated("  Specular Highlights", Int) = 0
            [ToggleUILeft]_ShaderLight3PositionAnimated("  Position", Int) = 0
            [ToggleUILeft]_ShaderLight3DirectionAnimated("  Direction", Int) = 0
            [ToggleUILeft]_ShaderLight3AngleAnimated("  Angle", Int) = 0
            [ToggleUILeft]_ShaderLight3RangeAnimated("  Range", Int) = 0
            [ToggleUILeft]_ShaderLight3ColorAnimated("  Color", Int) = 0
            [ToggleUILeft]_ShaderLight3IntensityAnimated("  Intensity", Int) = 0
        [HideInInspector]end_ShaderLight3("", Int) = 0
        [HideInInspector][ToggleUI]group_toggle_ShaderLight4("Shader Light 4", Int) = 0
            [ShaderLight(_ShaderLight4)]
            [WideEnum(Point,0, Spot,1, Directional,2)]_ShaderLight3Mode("Mode", Int) = 0
            [ToggleUI]_ShaderLight4Specular("Specular Highlights", Int) = 1
            [KajVector3]_ShaderLight4Position("Position", Vector) = (0,0,0,0)
            [KajVector3]_ShaderLight4Direction("Direction", Vector) = (1,0,0,0)
            [MinimumFloat(0)]_ShaderLight4Angle("Angle", Float) = 30
            [MinimumFloat(0)]_ShaderLight4Range("Range", Float) = 10
            _ShaderLight4Color("Color", Color) = (1,1,1,1)
            [MinimumFloat(0)]_ShaderLight4Intensity("Intensity", Float) = 1
            [Header(Animated Properties)]
            [ToggleUILeft]group_toggle_ShaderLight4Animated("  Shader Light 4", Int) = 0
            [ToggleUILeft]_ShaderLight4ModeAnimated("  Mode", Int) = 0
            [ToggleUILeft]_ShaderLight4SpecularAnimated("  Specular Highlights", Int) = 0
            [ToggleUILeft]_ShaderLight4PositionAnimated("  Position", Int) = 0
            [ToggleUILeft]_ShaderLight4DirectionAnimated("  Direction", Int) = 0
            [ToggleUILeft]_ShaderLight4AngleAnimated("  Angle", Int) = 0
            [ToggleUILeft]_ShaderLight4RangeAnimated("  Range", Int) = 0
            [ToggleUILeft]_ShaderLight4ColorAnimated("  Color", Int) = 0
            [ToggleUILeft]_ShaderLight4IntensityAnimated("  Intensity", Int) = 0
        [HideInInspector]end_ShaderLight4("", Int) = 0
        [HideInInspector][ToggleUI]group_toggle_ShaderLight5("Shader Light 5", Int) = 0
            [ShaderLight(_ShaderLight5)]
            [WideEnum(Point,0, Spot,1, Directional,2)]_ShaderLight3Mode("Mode", Int) = 0
            [ToggleUI]_ShaderLight5Specular("Specular Highlights", Int) = 1
            [KajVector3]_ShaderLight5Position("Position", Vector) = (0,0,0,0)
            [KajVector3]_ShaderLight5Direction("Direction", Vector) = (1,0,0,0)
            [MinimumFloat(0)]_ShaderLight5Angle("Angle", Float) = 30
            [MinimumFloat(0)]_ShaderLight5Range("Range", Float) = 10
            _ShaderLight5Color("Color", Color) = (1,1,1,1)
            [MinimumFloat(0)]_ShaderLight5Intensity("Intensity", Float) = 1
            [Header(Animated Properties)]
            [ToggleUILeft]group_toggle_ShaderLight5Animated("  Shader Light 5", Int) = 0
            [ToggleUILeft]_ShaderLight5ModeAnimated("  Mode", Int) = 0
            [ToggleUILeft]_ShaderLight5SpecularAnimated("  Specular Highlights", Int) = 0
            [ToggleUILeft]_ShaderLight5PositionAnimated("  Position", Int) = 0
            [ToggleUILeft]_ShaderLight5DirectionAnimated("  Direction", Int) = 0
            [ToggleUILeft]_ShaderLight5AngleAnimated("  Angle", Int) = 0
            [ToggleUILeft]_ShaderLight5RangeAnimated("  Range", Int) = 0
            [ToggleUILeft]_ShaderLight5ColorAnimated("  Color", Int) = 0
            [ToggleUILeft]_ShaderLight5IntensityAnimated("  Intensity", Int) = 0
        [HideInInspector]end_ShaderLight5("", Int) = 0
        [HideInInspector][ToggleUI]group_toggle_ShaderLight6("Shader Light 6", Int) = 0
            [ShaderLight(_ShaderLight6)]
            [WideEnum(Point,0, Spot,1, Directional,2)]_ShaderLight3Mode("Mode", Int) = 0
            [ToggleUI]_ShaderLight6Specular("Specular Highlights", Int) = 1
            [KajVector3]_ShaderLight6Position("Position", Vector) = (0,0,0,0)
            [KajVector3]_ShaderLight6Direction("Direction", Vector) = (1,0,0,0)
            [MinimumFloat(0)]_ShaderLight6Angle("Angle", Float) = 30
            [MinimumFloat(0)]_ShaderLight6Range("Range", Float) = 10
            _ShaderLight6Color("Color", Color) = (1,1,1,1)
            [MinimumFloat(0)]_ShaderLight6Intensity("Intensity", Float) = 1
            [Header(Animated Properties)]
            [ToggleUILeft]group_toggle_ShaderLight6Animated("  Shader Light 6", Int) = 0
            [ToggleUILeft]_ShaderLight6ModeAnimated("  Mode", Int) = 0
            [ToggleUILeft]_ShaderLight6SpecularAnimated("  Specular Highlights", Int) = 0
            [ToggleUILeft]_ShaderLight6PositionAnimated("  Position", Int) = 0
            [ToggleUILeft]_ShaderLight6DirectionAnimated("  Direction", Int) = 0
            [ToggleUILeft]_ShaderLight6AngleAnimated("  Angle", Int) = 0
            [ToggleUILeft]_ShaderLight6RangeAnimated("  Range", Int) = 0
            [ToggleUILeft]_ShaderLight6ColorAnimated("  Color", Int) = 0
            [ToggleUILeft]_ShaderLight6IntensityAnimated("  Intensity", Int) = 0
        [HideInInspector]end_ShaderLight6("", Int) = 0
        [HideInInspector][ToggleUI]group_toggle_ShaderLight7("Shader Light 7", Int) = 0
            [ShaderLight(_ShaderLight7)]
            [WideEnum(Point,0, Spot,1, Directional,2)]_ShaderLight3Mode("Mode", Int) = 0
            [ToggleUI]_ShaderLight7Specular("Specular Highlights", Int) = 1
            [KajVector3]_ShaderLight7Position("Position", Vector) = (0,0,0,0)
            [KajVector3]_ShaderLight7Direction("Direction", Vector) = (1,0,0,0)
            [MinimumFloat(0)]_ShaderLight7Angle("Angle", Float) = 30
            [MinimumFloat(0)]_ShaderLight7Range("Range", Float) = 10
            _ShaderLight7Color("Color", Color) = (1,1,1,1)
            [MinimumFloat(0)]_ShaderLight7Intensity("Intensity", Float) = 1
            [Header(Animated Properties)]
            [ToggleUILeft]group_toggle_ShaderLight7Animated("  Shader Light 7", Int) = 0
            [ToggleUILeft]_ShaderLight7ModeAnimated("  Mode", Int) = 0
            [ToggleUILeft]_ShaderLight7SpecularAnimated("  Specular Highlights", Int) = 0
            [ToggleUILeft]_ShaderLight7PositionAnimated("  Position", Int) = 0
            [ToggleUILeft]_ShaderLight7DirectionAnimated("  Direction", Int) = 0
            [ToggleUILeft]_ShaderLight7AngleAnimated("  Angle", Int) = 0
            [ToggleUILeft]_ShaderLight7RangeAnimated("  Range", Int) = 0
            [ToggleUILeft]_ShaderLight7ColorAnimated("  Color", Int) = 0
            [ToggleUILeft]_ShaderLight7IntensityAnimated("  Intensity", Int) = 0
        [HideInInspector]end_ShaderLight7("", Int) = 0
        [HideInInspector]end_ShaderLights("", Int) = 0

        [HideInInspector][Toggle(_COLORADDSUBDIFF_ON)]group_toggle_Diffuse(";;_COLORADDSUBDIFF_ON;Diffuse Shading", Int) = 1
        [WideEnum(Lambert,0, PBR,1, Skin,2, Flat Lit,3,Oren Nayer,4)]_DiffuseMode("Mode", Int) = 1
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

        [HideInInspector][Toggle(_COLOROVERLAY_ON)]group_toggle_Specular(";;_COLOROVERLAY_ON;Specular Highlights", Int) = 1
        [WideEnum(Phong,0, PBR,1, Skin,3)]_SpecularMode("Mode", Int) = 1
        _DirectionalLightSpecularIntensity("Directional Lights", Range(0,1)) = 1
        _PointLightSpecularIntensity("Point Lights", Range(0,1)) = 1
        _SpotLightSpecularIntensity("Spot Lights", Range(0,1)) = 1
        [HideInInspector]group_PhongSpecular("Phong", Int) = 0
        [ToggleUI]_Blinn("Blinn-Phong Shape", Int) = 1
        [MinimumFloat(1)]_PhongSpecularPower("Power", Float) = 5.0
        _PhongSpecularIntensity("Intensity", Range(0,1)) = 1
        [ToggleUI]_PhongSpecularUseRoughness("Use PBR Roughness for Power", Int) = 0
        [HideInInspector]end_PhongSpecular("", Int) = 0
        [HideInInspector]end_Specular("", Int) = 0

        [HideInInspector][Toggle(_MAPPING_6_FRAMES_LAYOUT)]group_toggle_Reflections(";;_MAPPING_6_FRAMES_LAYOUT;Reflections", Int) = 1
        [WideEnum(PBR,1, Skin,2)]_ReflectionsMode("Mode", Int) = 1
        [HideInInspector]group_PBRReflections("PBR", Int) = 0
        _StandardFresnelIntensity("Fresnel Intensity", Range(0,1)) = 1.0
        [HideInInspector]end_PBRReflections("", Int) = 0
        [HideInInspector]end_Reflections("", Int) = 0

        [HideInInspector][ToggleUI]group_toggle_Anisotropy("Anisotropy", Int) = 0
        _ReflectionsAnisotropy("Reflections Anisotropy", Range(0,1)) = 0
        [WideEnum(Anisotropy Scale,0, Second Glossiness Map,1)]_AnisotropyMode("Specular Mode", Int) = 0
        [Space(10)]
        [KeywordTex(ANTI_FLICKER)]_AnisotropyMap(";;ANTI_FLICKER;Anisotropy Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_AnisotropyMapUV("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_AnisotropyMapChannel("Channel to Sample", Int) = 0
            [RangeMax]_AnisotropyMax("Anisotropy Max", Range(0.0, 1.0)) = 0.5
            [RangeMin]_AnisotropyMin("Anisotropy Min", Range(0.0, 1.0)) = 0.0
        [UnIndent]
        [WideEnum(Roughness, 0, Smoothness, 1)]_GlossinessMode2("Glossiness Mode", Int) = 1
        [KeywordTex(GRAIN)]_SpecGlossMap2(";;GRAIN;Second Glossiness Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_SpecGlossMap2UV ("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_SpecGlossMap2Channel("Channel to Sample", Int) = 0
            [RangeMax]_Glossiness2("Glossiness Max", Range(0.0, 1.0)) = 0.5
            [RangeMin]_Glossiness2Min("Glossiness Min", Range(0.0, 1.0)) = 0.0
        [UnIndent]
        [KeywordTex(BLOOM)]_AnisotropyAngleMap(";;BLOOM;Angle Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_AnisotropyAngleMapUV("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_AnisotropyAngleMapChannel("Channel to Sample", Int) = 0
            [RangeMax]_AnisotropyAngleMax("Angle Max", Range(0.0, 1.0)) = 0.5
            [RangeMin]_AnisotropyAngleMin("Angle Min", Range(0.0, 1.0)) = 0.0
        [UnIndent]
        [HideInInspector]end_Anisotropy("", Int) = 0

        [HideInInspector][Toggle(_DETAIL_MULX2)]group_toggle_Clearcoat(";;_DETAIL_MULX2;Clearcoat", Int) = 0
        [KeywordTex(_COLORCOLOR_ON)]_ClearcoatMask(";;_COLORCOLOR_ON;Clearcoat Mask", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_ClearcoatMaskUV("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_ClearcoatMaskChannel("Channel to Sample", Int) = 0
        [UnIndent]
        [RangeMax]_ClearcoatMaskMax("Mask Max", Range(0,1)) = 1
        [RangeMin]_ClearcoatMaskMin("Mask Min", Range(0,1)) = 0
        [ToggleUI]_ClearcoatRefract("Refract", Int) = 1
        _ClearcoatFresnelInfluence("Fresnel Influence", Range(0,1)) = 1
        _ClearcoatRoughnessInfluence("Roughness Influence", Range(0,1)) = 1
        [HideInInspector]end_Clearcoat("", Int) = 0
        
        [HideInInspector][Toggle(EFFECT_BUMP)]group_toggle_Parallax(";;EFFECT_BUMP;Parallax", Int) = 0
        [KeywordTex(_PARALLAXMAP)]_ParallaxMap (";;_PARALLAXMAP;Parallax (Height) Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_ParallaxMapUV("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_ParallaxMapChannel("Channel to Sample", Int) = 0
        [UnIndent]
        _Parallax ("Parallax Scale", Range (0, 0.08)) = 0.02
        _ParallaxBias ("Parallax Bias", Float) = 0.42
        [ToggleUI]_ParallaxUV0 ("Affects UV0", Int) = 1
        [ToggleUI]_ParallaxUV1 ("Affects UV1", Int) = 1
        [ToggleUI]_ParallaxUV2 ("Affects UV2", Int) = 1
        [ToggleUI]_ParallaxUV3 ("Affects UV3", Int) = 1
        [HideInInspector]end_Parallax("", Int) = 0

        [HideInInspector][Toggle(_SPECULARHIGHLIGHTS_OFF)]group_toggle_SSSTransmission(";;_SPECULARHIGHLIGHTS_OFF;Subsurface Transmission", Int) = 0
        [ToggleUI]_SSSTransmissionShadowCastingLightsOnly("Shadow Casting Lights Only", Int) = 1
        [ToggleUI]_SSSTransmissionIgnoreShadowAttenuation("Ignore Shadows", Int) = 0
        _SubsurfaceColor("Subsurface Color", Color) = (1,0.4,0.25)
        [KeywordTex(_FADING_ON)]_TranslucencyMap(";;_FADING_ON;Translucency (Thickness) Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_TranslucencyMapUV("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_TranslucencyMapChannel("Channel to Sample", Int) = 0
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

        [HideInInspector]group_Details("Detail Settings", Int) = 0
        [KeywordTex(GEOM_TYPE_BRANCH_DETAIL)]_DetailMask(";;GEOM_TYPE_BRANCH_DETAIL;Detail Mask (RGBA)", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_DetailMaskUV("UV Set", Int) = 0
        [UnIndent]
        _DetailColorR("Detail Color (Red)", Color) = (1,1,1,1)
        _DetailColorG("Detail Color (Green)", Color) = (1,1,1,1)
        _DetailColorB("Detail Color (Blue)", Color) = (1,1,1,1)
        _DetailColorA("Detail Color (Alpha)", Color) = (1,1,1,1)
        [Space(10)]
        [KeywordTex(_ALPHABLEND_ON)]_DetailAlbedoMap(";;_ALPHABLEND_ON;Detail Albedo (Red)", 2D) = "grey" {}
        [KeywordTex(_ALPHAMODULATE_ON)]_DetailAlbedoMapGreen(";;_ALPHAMODULATE_ON;Detail Albedo (Green)", 2D) = "grey" {}
        [KeywordTex(_ALPHAPREMULTIPLY_ON)]_DetailAlbedoMapBlue(";;_ALPHAPREMULTIPLY_ON;Detail Albedo (Blue)", 2D) = "grey" {}
        [KeywordTex(_ALPHATEST_ON)]_DetailAlbedoMapAlpha(";;_ALPHATEST_ON;Detail Albedo (Alpha)", 2D) = "grey" {}
        [Space(10)]
        [Normal][KeywordTex(GEOM_TYPE_BRANCH)]_DetailNormalMap(";;GEOM_TYPE_BRANCH;Detail Normal Map (Red)", 2D) = "bump" {}
        [Indent]
            _DetailNormalMapScale("Detail Normals (Red) Scale", Float) = 1.0
        [UnIndent]
        [Normal][KeywordTex(GEOM_TYPE_FROND)]_DetailNormalMapGreen(";;GEOM_TYPE_FROND;Detail Normal Map (Green)", 2D) = "bump" {}
        [Indent]
            _DetailNormalMapScaleGreen("Detail Normals (Green) Scale", Float) = 1.0
        [UnIndent]
        [Normal][KeywordTex(GEOM_TYPE_LEAF)]_DetailNormalMapBlue(";;GEOM_TYPE_LEAF;Detail Normal Map (Blue)", 2D) = "bump" {}
        [Indent]
            _DetailNormalMapScaleBlue("Detail Normals (Blue) Scale", Float) = 1.0
        [UnIndent]
        [Normal][KeywordTex(GEOM_TYPE_MESH)]_DetailNormalMapAlpha(";;GEOM_TYPE_MESH;Detail Normal Map (Alpha)", 2D) = "bump" {}
        [Indent]
            _DetailNormalMapScaleAlpha("Detail Normals (Alpha) Scale", Float) = 1.0
        [UnIndent]
        [Space(10)]
        [Enum(Kaj.UVMapping)]_UVSec ("Detail Textures UV Set", Int) = 0
        [Enum(Tangent Space,0, Object Space,1, World Space,2)]_DetailNormalsSpace("Detail Normals Space", Int) = 0
        [WideEnum(Multiply x2,0,Multiply,1,Add,2,Lerp,3)]_DetailAlbedoCombineMode("Albedo Combine Mode", Int) = 0
        [HideInInspector]end_Details("", Int) = 0

        [HideInInspector][ToggleUI]group_toggle_Geometry("Geometry Effects", Int) = 0
        [ToggleUI]group_toggle_GeometryForwardBase("Affects Base Pass", Int) = 1
        [ToggleUI]group_toggle_GeometryForwardAdd("Affects Additive Passes (Point and Spot lights)", Int) = 1
        [ToggleUI]group_toggle_GeometryShadowCaster("Affects ShadowCaster Pass", Int) = 1
        [ToggleUI]group_toggle_GeometryMeta("Affects GI Pass", Int) = 1
        [Space(10)]
        _GeometryFlattenNormals("Flatten Normals", Range(0,1)) = 0
        [ToggleUI]_GeometryDisplacedTangents("Correct Displaced Vertex Tangets/Bitangents", Int) = 0
        [Header(Debug)]
        [ToggleUI]_DebugWireframe("Visualize Wireframe", Int) = 0
        [HideInInspector]end_Geometry("", Int) = 0

        [HideInInspector][ToggleUI]group_toggle_Tessellation("Tessellation", Int) = 0
        [ToggleUI]group_toggle_TessellationForwardBase("Affects Base Pass", Int) = 1
        [ToggleUI]group_toggle_TessellationForwardAdd("Affects Additive Passes (Point and Spot lights)", Int) = 1
        [ToggleUI]group_toggle_TessellationShadowCaster("Affects ShadowCaster Pass", Int) = 1
        [ToggleUI]group_toggle_TessellationMeta("Affects GI Pass", Int) = 0
        [Header(Settings)]
        [WideKeywordEnum(Integer, FractionalEven, FractionalOdd)]_Partitioning(";;_SUNDISK_NONE;_SUNDISK_SIMPLE;Partitioning Mode", Int) = 2
        [WideKeywordEnum(Triangle Clockwise, Triangle Counterclockwise)]_OutputTopology(";;_SUNDISK_HIGH_QUALITY;Output Topology", Int) = 0
        [WideKeywordEnum(Triangle, Quad)]_Domain(";;_TERRAIN_NORMAL_MAP;Patch Domain", Int) = 0
        [RangeMax]_TessellationFactorMax("Tessellation Max", Range(1, 64)) = 3
        [RangeMin]_TessellationFactorMin("Tessellation Min", Range(1, 64)) = 1
        [Space(10)]
        [KeywordTex(BILLBOARD_FACE_CAMERA_POS)]_TessellationMask(";;BILLBOARD_FACE_CAMERA_POS;Tessellation Mask", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_TessellationMaskUV("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_TessellationMaskChannel("Channel to Sample", Int) = 0
            [RangeMax]_TessellationMaskMax("Mask Max", Range(0,1)) = 1
            [RangeMin]_TessellationMaskMin("Mask Min", Range(0,1)) = 0
        [UnIndent]
        [Header(Adaptive Culling)]
        [ToggleUI]_MinEdgeLengthEnabled("Edge Length Scaling", Int) = 0
        [Indent]
            [MinimumFloat(0)]_MaxEdgeLength("Max Tess Factor Length", Float) = 0.1
            [MinimumFloat(0)]_MinEdgeLength("Min Tess Factor Length", Float) = 0.01
            [Enum(Object,0, World,1)]_MinEdgeLengthSpace("Object or World Space", Int) = 1
        [UnIndent]
        [ToggleUI]_CameraDistanceScaling("Camera Distance Scaling", Int) = 1
        [Indent]
            [MinimumFloat(0)]_TessMinCameraDist("Min Tess Factor Distance", Float) = 3
            [MinimumFloat(0)]_TessMaxCameraDist("Max Tess Factor Distance", Float) = 0.5
        [UnIndent]
        [ToggleUI]_TessFrustumCulling("Frustum Culling", Int) = 0
        [Indent]
            [MinimumFloat(0)]_TessFrustumCullingRadius("Bias", Float) = 0
        [UnIndent]
        [ToggleUI]_TessCullUnusedFaces("Cull Unseen Faces", Int) = 1
        [Indent]
            _TessUnusedFacesBias("Bias", Range(0,1)) = 0
        [UnIndent]
        [ToggleUI]_RimTessOnly("Rim-Only Tessellation", Int) = 0
        [Indent]
            _RimTessBias("Bias", Range(0,1)) = 0
            _RimTessIntensity("Rim-Only Intensity", Range(0,1)) = 1
        [UnIndent]
        [HideInInspector][ToggleUI]group_toggle_PhongTessellation("Phong Tessellation", Int) = 0
        [KeywordTex(EFFECT_HUE_VARIATION)]_PhongTessMask(";;EFFECT_HUE_VARIATION;Phong Tessellation Mask", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_PhongTessMaskUV("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_PhongTessMaskChannel("Channel to Sample", Int) = 0
            [RangeMax]_PhongTessMaskMax("Mask Max", Range(0,1)) = 0.5
            [RangeMin]_PhongTessMaskMin("Mask Min", Range(0,1)) = 0
        [UnIndent]
        [HideInInspector]end_PhongTessellation("", Int) = 0
        [HideInInspector]end_Tessellation("", Int) = 0

        [HideInInspector][ToggleUI]group_toggle_Displacement("Displacement", Int) = 0
        [KeywordTex(ETC1_EXTERNAL_ALPHA)]_DisplacementMap(";;ETC1_EXTERNAL_ALPHA;Displacement Map", 2D) = "white" {}
        [Indent]
            [Enum(Kaj.UVMapping)]_DisplacementMapUV("UV Set", Int) = 0
            [Enum(Red,0,Green,1,Blue,2,Alpha,3)]_DisplacementMapChannel("Channel to Sample", Int) = 0
            [RangeMax]_DisplacementMapMax("Mask Max", Range(0,1)) = 1
            [RangeMin]_DisplacementMapMin("Mask Min", Range(0,1)) = 0
        [UnIndent]
        _DisplacementIntensity("Displacement Intensity", Float) = 0.001
        _DisplacementBias("Displacement Bias", Float) = 0
        [HideInInspector]end_Displacement("", Int) = 0

        [HideInInspector]group_Blending("Blending Options", Int) = 0
        [WideEnum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Int) = 2
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
        [ToggleUI]_LODCrossfade("LOD Crossfade", Int) = 0
        [HelpBox]_InlineSamplerStatesTooltip("Inline sampler states make all textures' unique filter/wrap settings work at the cost of only 1x anisotropic filtering on all textures.  Albedo wrap/filter/aniso is used on all textures if this is off.", Int) = 0
        [ToggleUI]_InlineSamplerStates("Use Inline Sampler States", Int) = 1
        [HelpBox]_AnimatedPropsTooltip("Any material properties that need to be changed at runtime should be selected here so the Optimizer does not bake them into the optimized shader.", Int) = 0
        [Header(Animated Properties)]
        [ToggleUILeft]_AlbedoTransparencyEnabledAnimated("  _AlbedoTransparencyEnabled", Int) = 0
        [ToggleUILeft]_AlphaToCoverageAnimated("  _AlphaToCoverage", Int) = 0
        [ToggleUILeft]_AlternateBentNormalMap_STAnimated("  _AlternateBentNormalMap_ST", Int) = 0
        [ToggleUILeft]_AlternateBentNormalMap_TexelSizeAnimated("  _AlternateBentNormalMap_TexelSize", Int) = 0
        [ToggleUILeft]_AlternateBentNormalMapUVAnimated("  _AlternateBentNormalMapUV", Int) = 0
        [ToggleUILeft]_AlternateBumpMap_STAnimated("  _AlternateBumpMap_ST", Int) = 0
        [ToggleUILeft]_AlternateBumpMap_TexelSizeAnimated("  _AlternateBumpMap_TexelSize", Int) = 0
        [ToggleUILeft]_AlternateBumpMapEncodingAnimated("  _AlternateBumpMapEncoding", Int) = 0
        [ToggleUILeft]_AlternateBumpMapSpaceAnimated("  _AlternateBumpMapSpace", Int) = 0
        [ToggleUILeft]_AlternateBumpMapUVAnimated("  _AlternateBumpMapUV", Int) = 0
        [ToggleUILeft]_AlternateBumpScaleAnimated("  _AlternateBumpScale", Int) = 0
        [ToggleUILeft]_AnisotropyAngleMap_STAnimated("  _AnisotropyAngleMap_ST", Int) = 0
        [ToggleUILeft]_AnisotropyAngleMap_TexelSizeAnimated("  _AnisotropyAngleMap_TexelSize", Int) = 0
        [ToggleUILeft]_AnisotropyAngleMapChannelAnimated("  _AnisotropyAngleMapChannel", Int) = 0
        [ToggleUILeft]_AnisotropyAngleMapUVAnimated("  _AnisotropyAngleMapUV", Int) = 0
        [ToggleUILeft]_AnisotropyAngleMaxAnimated("  _AnisotropyAngleMax", Int) = 0
        [ToggleUILeft]_AnisotropyAngleMinAnimated("  _AnisotropyAngleMin", Int) = 0
        [ToggleUILeft]_AnisotropyMap_STAnimated("  _AnisotropyMap_ST", Int) = 0
        [ToggleUILeft]_AnisotropyMap_TexelSizeAnimated("  _AnisotropyMap_TexelSize", Int) = 0
        [ToggleUILeft]_AnisotropyMapChannelAnimated("  _AnisotropyMapChannel", Int) = 0
        [ToggleUILeft]_AnisotropyMapUVAnimated("  _AnisotropyMapUV", Int) = 0
        [ToggleUILeft]_AnisotropyMaxAnimated("  _AnisotropyMax", Int) = 0
        [ToggleUILeft]_AnisotropyMinAnimated("  _AnisotropyMin", Int) = 0
        [ToggleUILeft]_AnisotropyModeAnimated("  _AnisotropyMode", Int) = 0
        [ToggleUILeft]_AOColorBleedAnimated("  _AOColorBleed", Int) = 0
        [ToggleUILeft]_BentNormalMap_STAnimated("  _BentNormalMap_ST", Int) = 0
        [ToggleUILeft]_BentNormalMap_TexelSizeAnimated("  _BentNormalMap_TexelSize", Int) = 0
        [ToggleUILeft]_BentNormalMapEncodingAnimated("  _BentNormalMapEncoding", Int) = 0
        [ToggleUILeft]_BentNormalMapSpaceAnimated("  _BentNormalMapSpace", Int) = 0
        [ToggleUILeft]_BentNormalMapUVAnimated("  _BentNormalMapUV", Int) = 0
        [ToggleUILeft]_BlinnAnimated("  _Blinn", Int) = 0
        [ToggleUILeft]_BlurStrengthAnimated("  _BlurStrength", Int) = 0
        [ToggleUILeft]_BumpBlurBiasAnimated("  _BumpBlurBias", Int) = 0
        [ToggleUILeft]_BumpMap_STAnimated("  _BumpMap_ST", Int) = 0
        [ToggleUILeft]_BumpMap_TexelSizeAnimated("  _BumpMap Texture", Int) = 0
        [ToggleUILeft]_BumpMapSpaceAnimated("  _BumpMapSpace", Int) = 0
        [ToggleUILeft]_BumpMapUVAnimated("  _BumpMapUV", Int) = 0
        [ToggleUILeft]_BumpScaleAnimated("  _BumpScale", Int) = 0
        [ToggleUILeft]_CameraDistanceScalingAnimated("  _CameraDistanceScaling", Int) = 0
        [ToggleUILeft]_ClearcoatFresnelInfluenceAnimated("  _ClearcoatFresnelInfluence", Int) = 0
        [ToggleUILeft]_ClearcoatMask_STAnimated("  _ClearcoatMask_ST", Int) = 0
        [ToggleUILeft]_ClearcoatMask_TexelSizeAnimated("  _ClearcoatMask Texture", Int) = 0
        [ToggleUILeft]_ClearcoatMaskChannelAnimated("  _ClearcoatMaskChannel", Int) = 0
        [ToggleUILeft]_ClearcoatMaskMaxAnimated("  _ClearcoatMaskMax", Int) = 0
        [ToggleUILeft]_ClearcoatMaskMinAnimated("  _ClearcoatMaskMin", Int) = 0
        [ToggleUILeft]_ClearcoatRefractAnimated("  _ClearcoatRefract", Int) = 0
        [ToggleUILeft]_ClearcoatRoughnessInfluenceAnimated("  _ClearcoatRoughnessInfluence", Int) = 0
        [ToggleUILeft]_ColorAnimated("  _Color", Int) = 0
        [ToggleUILeft]_CoverageMap_STAnimated("  _CoverageMap_ST", Int) = 0
        [ToggleUILeft]_CoverageMap_TexelSizeAnimated("  _CoverageMap Texture", Int) = 0
        [ToggleUILeft]_CoverageMapChannelAnimated("  _CoverageMapChannel", Int) = 0
        [ToggleUILeft]_CoverageMapUVAnimated("  _CoverageMapUV", Int) = 0
        [ToggleUILeft]_CubeMapAnimated("  _CubeMap", Int) = 0
        [ToggleUILeft]_CubeMapModeAnimated("  _CubeMapMode", Int) = 0
        [ToggleUILeft]_CurvatureBiasAnimated("  _CurvatureBias", Int) = 0
        [ToggleUILeft]_CurvatureInfluenceAnimated("  _CurvatureInfluence", Int) = 0
        [ToggleUILeft]_CurvatureScaleAnimated("  _CurvatureScale", Int) = 0
        [ToggleUILeft]_CutoffAnimated("  _Cutoff", Int) = 0
        [ToggleUILeft]_DebugOcclusionAnimated("  _DebugOcclusion", Int) = 0
        [ToggleUILeft]_DebugWireframeAnimated("  _DebugWireframe", Int) = 0
        [ToggleUILeft]_DebugWorldNormalsAnimated("  _DebugWorldNormals", Int) = 0
        [ToggleUILeft]_DetailAlbedoCombineModeAnimated("  _DetailAlbedoCombineMode", Int) = 0
        [ToggleUILeft]_DetailAlbedoMap_STAnimated("  _DetailAlbedoMap_ST", Int) = 0
        [ToggleUILeft]_DetailAlbedoMap_TexelSizeAnimated("  _DetailAlbedoMap Texture", Int) = 0
        [ToggleUILeft]_DetailAlbedoMapAlpha_STAnimated("  _DetailAlbedoMapAlpha_ST", Int) = 0
        [ToggleUILeft]_DetailAlbedoMapAlpha_TexelSizeAnimated("  _DetailAlbedoMapAlpha Texture", Int) = 0
        [ToggleUILeft]_DetailAlbedoMapBlue_STAnimated("  _DetailAlbedoMapBlue_ST", Int) = 0
        [ToggleUILeft]_DetailAlbedoMapBlue_TexelSizeAnimated("  _DetailAlbedoMapBlue Texture", Int) = 0
        [ToggleUILeft]_DetailAlbedoMapGreen_STAnimated("  _DetailAlbedoMapGreen_ST", Int) = 0
        [ToggleUILeft]_DetailAlbedoMapGreen_TexelSizeAnimated("  _DetailAlbedoMapGreen Texture", Int) = 0
        [ToggleUILeft]_DetailColorAAnimated("  _DetailColorA", Int) = 0
        [ToggleUILeft]_DetailColorBAnimated("  _DetailColorB", Int) = 0
        [ToggleUILeft]_DetailColorGAnimated("  _DetailColorG", Int) = 0
        [ToggleUILeft]_DetailColorRAnimated("  _DetailColorR", Int) = 0
        [ToggleUILeft]_DetailMask_STAnimated("  _DetailMask_ST", Int) = 0
        [ToggleUILeft]_DetailMask_TexelSizeAnimated("  _DetailMask Texture", Int) = 0
        [ToggleUILeft]_DetailMaskUVAnimated("  _DetailMaskUV", Int) = 0
        [ToggleUILeft]_DetailNormalMap_STAnimated("  _DetailNormalMap_ST", Int) = 0
        [ToggleUILeft]_DetailNormalMap_TexelSizeAnimated("  _DetailNormalMap Texture", Int) = 0
        [ToggleUILeft]_DetailNormalMapAlpha_STAnimated("  _DetailNormalMapAlpha_ST", Int) = 0
        [ToggleUILeft]_DetailNormalMapAlpha_TexelSizeAnimated("  _DetailNormalMapAlpha Texture", Int) = 0
        [ToggleUILeft]_DetailNormalMapBlue_STAnimated("  _DetailNormalMapBlue_ST", Int) = 0
        [ToggleUILeft]_DetailNormalMapBlue_TexelSizeAnimated("  _DetailNormalMapBlue Texture", Int) = 0
        [ToggleUILeft]_DetailNormalMapGreen_STAnimated("  _DetailNormalMapGreen_ST", Int) = 0
        [ToggleUILeft]_DetailNormalMapGreen_TexelSizeAnimated("  _DetailNormalMapGreen Texture", Int) = 0
        [ToggleUILeft]_DetailNormalMapScaleAlphaAnimated("  _DetailNormalMapScaleAlpha", Int) = 0
        [ToggleUILeft]_DetailNormalMapScaleAnimated("  _DetailNormalMapScale", Int) = 0
        [ToggleUILeft]_DetailNormalMapScaleBlueAnimated("  _DetailNormalMapScaleBlue", Int) = 0
        [ToggleUILeft]_DetailNormalMapScaleGreenAnimated("  _DetailNormalMapScaleGreen", Int) = 0
        [ToggleUILeft]_DetailNormalsSpaceAnimated("  _DetailNormalsSpace", Int) = 0
        [ToggleUILeft]_DiffuseModeAnimated("  _DiffuseMode", Int) = 0
        [ToggleUILeft]_DiffuseWrapAnimated("  _DiffuseWrap", Int) = 0
        [ToggleUILeft]_DiffuseWrapConserveEnergyAnimated("  _DiffuseWrapConserveEnergy", Int) = 0
        [ToggleUILeft]_DirectionalLightIntensityAnimated("  _DirectionalLightIntensity", Int) = 0
        [ToggleUILeft]_DirectionalLightSpecularIntensityAnimated("  _DirectionalLightSpecularIntensity", Int) = 0
        [ToggleUILeft]_DirectLightIntensityAnimated("  _DirectLightIntensity", Int) = 0
        [ToggleUILeft]_DisplacementBiasAnimated("  _DisplacementBias", Int) = 0
        [ToggleUILeft]_DisplacementIntensityAnimated("  _DisplacementIntensity", Int) = 0
        [ToggleUILeft]_DisplacementMap_STAnimated("  _DisplacementMap_ST", Int) = 0
        [ToggleUILeft]_DisplacementMap_TexelSizeAnimated("  _DisplacementMap Texture", Int) = 0
        [ToggleUILeft]_DisplacementMapChannelAnimated("  _DisplacementMapChannel", Int) = 0
        [ToggleUILeft]_DisplacementMapMaxAnimated("  _DisplacementMapMax", Int) = 0
        [ToggleUILeft]_DisplacementMapMinAnimated("  _DisplacementMapMin", Int) = 0
        [ToggleUILeft]_DisplacementMapUVAnimated("  _DisplacementMapUV", Int) = 0
        [ToggleUILeft]_DitheredShadowsAnimated("  _DitheredShadows", Int) = 0
        [ToggleUILeft]_DitheringEnabledAnimated("  _DitheringEnabled", Int) = 0
        [ToggleUILeft]_EmissionColorAnimated("  _EmissionColor", Int) = 0
        [ToggleUILeft]_EmissionMap_STAnimated("  _EmissionMap_ST", Int) = 0
        [ToggleUILeft]_EmissionMap_TexelSizeAnimated("  _EmissionMap Texture", Int) = 0
        [ToggleUILeft]_EmissionMapChannelAnimated("  _EmissionMapChannel", Int) = 0
        [ToggleUILeft]_EmissionMapUVAnimated("  _EmissionMapUV", Int) = 0
        [ToggleUILeft]_EmissionTintByAlbedoAnimated("  _EmissionTintByAlbedo", Int) = 0
        [ToggleUILeft]_FakeLightColorAnimated("  _FakeLightColor", Int) = 0
        [ToggleUILeft]_FakeLightDirectionAnimated("  _FakeLightDirection", Int) = 0
        [ToggleUILeft]_FakeLightIntensityAnimated("  _FakeLightIntensity", Int) = 0
        [ToggleUILeft]_FakeLightToggleAnimated("  _FakeLightToggle", Int) = 0
        [ToggleUILeft]_FlippedNormalBackfacesAnimated("  _FlippedNormalBackfaces", Int) = 0
        [ToggleUILeft]_GeometricSpecularAAAnimated("  _GeometricSpecularAA", Int) = 0
        [ToggleUILeft]_GeometryDisplacedTangentsAnimated("  _GeometryDisplacedTangents", Int) = 0
        [ToggleUILeft]_GeometryFlattenNormalsAnimated("  _GeometryFlattenNormals",  Int) = 0
        [ToggleUILeft]_Glossiness2Animated("  _Glossiness2", Int) = 0
        [ToggleUILeft]_Glossiness2MinAnimated("  _Glossiness2Min", Int) = 0
        [ToggleUILeft]_GlossinessAnimated("  _Glossiness", Int) = 0
        [ToggleUILeft]_GlossinessMinAnimated("  _GlossinessMin", Int) = 0
        [ToggleUILeft]_GlossinessMode2Animated("  _GlossinessMode2", Int) = 0
        [ToggleUILeft]_GlossinessModeAnimated("  _GlossinessMode", Int) = 0
        [ToggleUILeft]_GlossyReflectionsAnimated("  _GlossyReflections", Int) = 0
        [ToggleUILeft]_HDREnabledAnimated("  _HDREnabled", Int) = 0
        [ToggleUILeft]_IndirectLightIntensityAnimated("  _IndirectLightIntensity", Int) = 0
        [ToggleUILeft]_IndirectSpecFallbackAnimated("  _IndirectSpecFallback", Int) = 0
        [ToggleUILeft]_LightmapIntensityAnimated("  _LightmapIntensity", Int) = 0
        [ToggleUILeft]_LightProbeIntensityAnimated("  _LightProbeIntensity", Int) = 0
        [ToggleUILeft]_MainTex_STAnimated("  _MainTex_ST", Int) = 0
        [ToggleUILeft]_MainTex_TexelSizeAnimated("  _MainTex Texture", Int) = 0
        [ToggleUILeft]_MainTexUVAnimated("  _MainTexUV", Int) = 0
        [ToggleUILeft]_MetallicAnimated("  _Metallic", Int) = 0
        [ToggleUILeft]_MetallicGlossMap_STAnimated("  _MetallicGlossMap_ST", Int) = 0
        [ToggleUILeft]_MetallicGlossMap_TexelSizeAnimated("  _MetallicGlossMap Texture", Int) = 0
        [ToggleUILeft]_MetallicGlossMapChannelAnimated("  _MetallicGlossMapChannel", Int) = 0
        [ToggleUILeft]_MetallicGlossMapUVAnimated("  _MetallicGlossMapUV", Int) = 0
        [ToggleUILeft]_MetallicMinAnimated("  _MetallicMin", Int) = 0
        [ToggleUILeft]_MinEdgeLengthAnimated("  _MinEdgeLength", Int) = 0
        [ToggleUILeft]_MinEdgeLengthEnabledAnimated("  _MinEdgeLengthEnabled", Int) = 0
        [ToggleUILeft]_MinEdgeLengthSpaceAnimated("  _MinEdgeLengthSpace", Int) = 0
        [ToggleUILeft]_OcclusionDirectDiffuseAnimated("  _OcclusionDirectDiffuse", Int) = 0
        [ToggleUILeft]_OcclusionDirectSpecularAnimated("  _OcclusionDirectSpecular", Int) = 0
        [ToggleUILeft]_OcclusionIndirectSpecularAnimated("  _OcclusionIndirectSpecular", Int) = 0
        [ToggleUILeft]_OcclusionMap_STAnimated("  _OcclusionMap_ST", Int) = 0
        [ToggleUILeft]_OcclusionMap_TexelSizeAnimated("  _OcclusionMap Texture", Int) = 0
        [ToggleUILeft]_OcclusionMapChannelAnimated("  _OcclusionMapChannel", Int) = 0
        [ToggleUILeft]_OcclusionMapUVAnimated("  _OcclusionMapUV", Int) = 0
        [ToggleUILeft]_OcclusionStrengthAnimated("  _OcclusionStrength", Int) = 0
        [ToggleUILeft]_ParallaxAnimated("  _Parallax", Int) = 0
        [ToggleUILeft]_ParallaxBiasAnimated("  _ParallaxBias", Int) = 0
        [ToggleUILeft]_ParallaxMap_STAnimated("  _ParallaxMap_ST", Int) = 0
        [ToggleUILeft]_ParallaxMap_TexelSizeAnimated("  _ParallaxMap Texture", Int) = 0
        [ToggleUILeft]_ParallaxMapChannelAnimated("  _ParallaxMapChannel", Int) = 0
        [ToggleUILeft]_ParallaxMapUVAnimated("  _ParallaxMapUV", Int) = 0
        [ToggleUILeft]_ParallaxUV0Animated("  _ParallaxUV0", Int) = 0
        [ToggleUILeft]_ParallaxUV1Animated("  _ParallaxUV1", Int) = 0
        [ToggleUILeft]_ParallaxUV2Animated("  _ParallaxUV2", Int) = 0
        [ToggleUILeft]_ParallaxUV3Animated("  _ParallaxUV3", Int) = 0
        [ToggleUILeft]_PhongSpecularIntensityAnimated("  _PhongSpecularIntensity", Int) = 0
        [ToggleUILeft]_PhongSpecularPowerAnimated("  _PhongSpecularPower", Int) = 0
        [ToggleUILeft]_PhongSpecularUseRoughnessAnimated("  _PhongSpecularUseRoughness", Int) = 0
        [ToggleUILeft]_PhongTessMask_STAnimated("  _PhongTessMask_ST", Int) = 0
        [ToggleUILeft]_PhongTessMask_TexelSizeAnimated("  _PhongTessMask Texture", Int) = 0
        [ToggleUILeft]_PhongTessMaskChannelAnimated("  _PhongTessMaskChannel", Int) = 0
        [ToggleUILeft]_PhongTessMaskMaxAnimated("  _PhongTessMaskMax", Int) = 0
        [ToggleUILeft]_PhongTessMaskMinAnimated("  _PhongTessMaskMin", Int) = 0
        [ToggleUILeft]_PhongTessMaskUVAnimated("  _PhongTessMaskUV", Int) = 0
        [ToggleUILeft]_PointLightIntensityAnimated("  _PointLightIntensity", Int) = 0
        [ToggleUILeft]_PointLightSpecularIntensityAnimated("  _PointLightSpecularIntensity", Int) = 0
        [ToggleUILeft]_PreIntSkinTex_STAnimated("  _PreIntSkinTex_ST", Int) = 0
        [ToggleUILeft]_PreIntSkinTex_TexelSizeAnimated("  _PreIntSkinTex Texture", Int) = 0
        [ToggleUILeft]_RealtimeGIIntensityAnimated("  _RealtimeGIIntensity", Int) = 0
        [ToggleUILeft]_RealtimeLightmapIntensityAnimated("  _RealtimeLightmapIntensity", Int) = 0
        [ToggleUILeft]_ReceiveFogAnimated("  _ReceiveFog", Int) = 0
        [ToggleUILeft]_ReceiveShadowsAnimated("  _ReceiveShadows", Int) = 0
        [ToggleUILeft]_ReflectionsAnisotropyAnimated("  _ReflectionsAnisotropy", Int) = 0
        [ToggleUILeft]_ReflectionsIntensityAnimated("  _ReflectionsIntensity", Int) = 0
        [ToggleUILeft]_ReflectionsModeAnimated("  _ReflectionsMode", Int) = 0
        [ToggleUILeft]_RimTessBiasAnimated("  _RimTessBias", Int) = 0
        [ToggleUILeft]_RimTessIntensityAnimated("  _RimTessIntensity", Int) = 0
        [ToggleUILeft]_RimTessOnlyAnimated("  _RimTessOnly", Int) = 0
        [ToggleUILeft]_ShadowsSharpAnimated("  _ShadowsSharp", Int) = 0
        [ToggleUILeft]_ShadowsSmoothAnimated("  _ShadowsSmooth", Int) = 0
        [ToggleUILeft]_SpecColorAnimated("  _SpecColor", Int) = 0
        [ToggleUILeft]_SpecGlossMap2_STAnimated("  _SpecGlossMap2_ST", Int) = 0
        [ToggleUILeft]_SpecGlossMap2_TexelSizeAnimated("  _SpecGlossMap2_TexelSize", Int) = 0
        [ToggleUILeft]_SpecGlossMap2ChannelAnimated("  _SpecGlossMap2Channel", Int) = 0
        [ToggleUILeft]_SpecGlossMap2UVAnimated("  _SpecGlossMap2UV", Int) = 0
        [ToggleUILeft]_SpecGlossMap_STAnimated("  _SpecGlossMap_ST", Int) = 0
        [ToggleUILeft]_SpecGlossMap_TexelSizeAnimated("  _SpecGlossMap Texture", Int) = 0
        [ToggleUILeft]_SpecGlossMapChannelAnimated("  _SpecGlossMapChannel", Int) = 0
        [ToggleUILeft]_SpecGlossMapUVAnimated("  _SpecGlossMapUV", Int) = 0
        [ToggleUILeft]_SpecularMap_STAnimated("  _SpecularMap_ST", Int) = 0
        [ToggleUILeft]_SpecularMap_TexelSizeAnimated("  _SpecularMap Texture", Int) = 0
        [ToggleUILeft]_SpecularMapChannelAnimated("  _SpecularMapChannel", Int) = 0
        [ToggleUILeft]_SpecularMapUVAnimated("  _SpecularMapUV", Int) = 0
        [ToggleUILeft]_SpecularMaxAnimated("  _SpecularMax", Int) = 0
        [ToggleUILeft]_SpecularMinAnimated("  _SpecularMin", Int) = 0
        [ToggleUILeft]_SpecularModeAnimated("  _SpecularMode", Int) = 0
        [ToggleUILeft]_SpotLightIntensityAnimated("  _SpotLightIntensity", Int) = 0
        [ToggleUILeft]_SpotLightSpecularIntensityAnimated("  _SpotLightSpecularIntensity", Int) = 0
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
        [ToggleUILeft]_TessCullUnusedFacesAnimated("  _TessCullUnusedFaces", Int) = 0
        [ToggleUILeft]_TessellationFactorMaxAnimated("  _TessellationFactorMax", Int) = 0
        [ToggleUILeft]_TessellationFactorMinAnimated("  _TessellationFactorMin", Int) = 0
        [ToggleUILeft]_TessellationMask_STAnimated("  _TessellationMask_ST", Int) = 0
        [ToggleUILeft]_TessellationMask_TexelSizeAnimated("  _TessellationMask Texture", Int) = 0
        [ToggleUILeft]_TessellationMaskChannelAnimated("  _TessellationMaskChannel", Int) = 0
        [ToggleUILeft]_TessellationMaskMaxAnimated("  _TessellationMaskMax", Int) = 0
        [ToggleUILeft]_TessellationMaskMinAnimated("  _TessellationMaskMin", Int) = 0
        [ToggleUILeft]_TessellationMaskUVAnimated("  _TessellationMaskUV", Int) = 0
        [ToggleUILeft]_TessFrustumCullingAnimated("  _TessFrustumCulling", Int) = 0
        [ToggleUILeft]_TessFrustumCullingRadiusAnimated("  _TessFrustumCullingRadius", Int) = 0
        [ToggleUILeft]_TessMaxCameraDistAnimated("  _TessMaxCameraDist", Int) = 0
        [ToggleUILeft]_TessMinCameraDistAnimated("  _TessMinCameraDist", Int) = 0
        [ToggleUILeft]_TessUnusedFacesBiasAnimated("  _TessUnusedFacesBias", Int) = 0
        [ToggleUILeft]_TranslucencyMap_STAnimated("  _TranslucencyMap_ST", Int) = 0
        [ToggleUILeft]_TranslucencyMap_TexelSizeAnimated("  _TranslucencyMap Texture", Int) = 0
        [ToggleUILeft]_TranslucencyMapChannelAnimated("  _TranslucencyMapChannel", Int) = 0
        [ToggleUILeft]_TranslucencyMapUVAnimated("  _TranslucencyMapUV", Int) = 0
        [ToggleUILeft]_TriplanarUseVertexColorsAnimated("  _TriplanarUseVertexColors", Int) = 0
        [ToggleUILeft]_UVSecAnimated("  _UVSec", Int) = 0
        [ToggleUILeft]_VertDisplacementTessFactorAnimated("  _VertDisplacementTessFactor", Int) = 0
        [ToggleUILeft]_VertexColorsEnabledAnimated("  _VertexColorsEnabled", Int) = 0
        [ToggleUILeft]_VertexColorsTransparencyEnabledAnimated("  _VertexColorsTransparencyEnabled", Int) = 0
        [ToggleUILeft]_VertexLightIntensityAnimated("  _VertexLightIntensity", Int) = 0
        [ToggleUILeft]_WorkflowModeAnimated("  _WorkflowMode", Int) = 0
        [ToggleUILeft]group_toggle_AnisotropyAnimated("  group_toggle_Anisotropy", Int) = 0
        [ToggleUILeft]group_toggle_ClearcoatAnimated("  group_toggle_Clearcoat", Int) = 0
        [ToggleUILeft]group_toggle_DiffuseAnimated("  group_toggle_Diffuse", Int) = 0
        [ToggleUILeft]group_toggle_DisplacementAnimated("  group_toggle_Displacement", Int) = 0
        [ToggleUILeft]group_toggle_ParallaxAnimated("  group_toggle_Parallax", Int) = 0
        [ToggleUILeft]group_toggle_PhongTessellationAnimated("  group_toggle_PhongTessellation", Int) = 0
        [ToggleUILeft]group_toggle_ReflectionsAnimated("  group_toggle_Reflections", Int) = 0
        [ToggleUILeft]group_toggle_SpecularAnimated("  group_toggle_Specular", Int) = 0
        [ToggleUILeft]group_toggle_SSSTransmissionAnimated("  group_toggle_SSSTransmission", Int) = 0
        [HideInInspector]end_OptimizerSettings("", Int) = 0

        [HideInInspector]group_Debug("Other", Int) = 0
        [Header(Triplanar Settings)]
        [HelpBox]_TriplanarTooltip("Object and World Triplanar sampling is scaled using each texture's Tiling X parameter.  Offset X/Y offsets the X/Y axes and Tiling Y offsets the Z axis.", Int) = 0
        [ToggleUI]_TriplanarUseVertexColors("Vertex Colors are Object Space Position - WIP", Int) = 0
        [Header(Debug)]
        [ToggleUI]_DebugWorldNormals("Visualize World Normal", Int) = 0
        [ToggleUI]_DebugOcclusion("Visualize Occlusion", Int) = 0
        [HideInInspector]end_Debug("", Int) = 0

        [KajLabel]_Version("Shader Version: 44", Int) = 44
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

            // These compile directives serve only to make variant generation by the editor faster,
            // as currently with Omega the more textures you have the slower variant generation is.
            // These and the associated keywords get removed when the shader is locked in.
            // Some are driven by textures being used, some by group toggles.
            // The hitching still exists in the 2018 editor, but its effectively amortized.
            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature _NORMALMAP
            #pragma shader_feature _EMISSION
            #pragma shader_feature _METALLICGLOSSMAP
            #pragma shader_feature _GLOSSYREFLECTIONS_OFF
            #pragma shader_feature _REQUIRE_UV2
            #pragma shader_feature _SPECGLOSSMAP
            #pragma shader_feature _COLORCOLOR_ON
            #pragma shader_feature _PARALLAXMAP
            #pragma shader_feature _FADING_ON
            #pragma shader_feature GEOM_TYPE_BRANCH_DETAIL
            #pragma shader_feature _ALPHABLEND_ON
            #pragma shader_feature _ALPHAMODULATE_ON
            #pragma shader_feature _ALPHAPREMULTIPLY_ON
            #pragma shader_feature _ALPHATEST_ON
            #pragma shader_feature GEOM_TYPE_BRANCH
            #pragma shader_feature GEOM_TYPE_FROND
            #pragma shader_feature GEOM_TYPE_LEAF
            #pragma shader_feature GEOM_TYPE_MESH
            #pragma shader_feature EFFECT_BUMP
            #pragma shader_feature _COLORADDSUBDIFF_ON
            #pragma shader_feature _COLOROVERLAY_ON
            #pragma shader_feature _DETAIL_MULX2
            #pragma shader_feature _MAPPING_6_FRAMES_LAYOUT
            #pragma shader_feature _SPECULARHIGHLIGHTS_OFF
            #pragma shader_feature BILLBOARD_FACE_CAMERA_POS
            #pragma shader_feature EFFECT_HUE_VARIATION
            #pragma shader_feature ETC1_EXTERNAL_ALPHA
            #pragma shader_feature ANTI_FLICKER
            #pragma shader_feature GRAIN
            #pragma shader_feature BLOOM
            #pragma shader_feature AUTO_KEY_VALUE
            #pragma shader_feature DITHERING
            // These keywords are used to switch tessellation and geometry program attributes
            #pragma shader_feature _ _SUNDISK_NONE _SUNDISK_SIMPLE
            #pragma shader_feature _SUNDISK_HIGH_QUALITY
            #pragma shader_feature _TERRAIN_NORMAL_MAP

            #pragma vertex vert_omega
            #pragma hull hull_omega
            #pragma domain domain_omega
            #pragma geometry geom_omega
            #pragma fragment frag_omega
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

            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature _NORMALMAP
            #pragma shader_feature _EMISSION
            #pragma shader_feature _METALLICGLOSSMAP
            #pragma shader_feature _GLOSSYREFLECTIONS_OFF
            #pragma shader_feature _REQUIRE_UV2
            #pragma shader_feature _SPECGLOSSMAP
            #pragma shader_feature _COLORCOLOR_ON
            #pragma shader_feature _PARALLAXMAP
            #pragma shader_feature _FADING_ON
            #pragma shader_feature GEOM_TYPE_BRANCH_DETAIL
            #pragma shader_feature _ALPHABLEND_ON
            #pragma shader_feature _ALPHAMODULATE_ON
            #pragma shader_feature _ALPHAPREMULTIPLY_ON
            #pragma shader_feature _ALPHATEST_ON
            #pragma shader_feature GEOM_TYPE_BRANCH
            #pragma shader_feature GEOM_TYPE_FROND
            #pragma shader_feature GEOM_TYPE_LEAF
            #pragma shader_feature GEOM_TYPE_MESH
            #pragma shader_feature EFFECT_BUMP
            #pragma shader_feature _COLORADDSUBDIFF_ON
            #pragma shader_feature _COLOROVERLAY_ON
            #pragma shader_feature _DETAIL_MULX2
            #pragma shader_feature _MAPPING_6_FRAMES_LAYOUT
            #pragma shader_feature _SPECULARHIGHLIGHTS_OFF
            #pragma shader_feature BILLBOARD_FACE_CAMERA_POS
            #pragma shader_feature EFFECT_HUE_VARIATION
            #pragma shader_feature ETC1_EXTERNAL_ALPHA
            #pragma shader_feature ANTI_FLICKER
            #pragma shader_feature GRAIN
            #pragma shader_feature BLOOM
            #pragma shader_feature AUTO_KEY_VALUE
            #pragma shader_feature DITHERING
            #pragma shader_feature _ _SUNDISK_NONE _SUNDISK_SIMPLE
            #pragma shader_feature _SUNDISK_HIGH_QUALITY
            #pragma shader_feature _TERRAIN_NORMAL_MAP

            #pragma vertex vert_omega
            #pragma hull hull_omega
            #pragma domain domain_omega
            #pragma geometry geom_omega
            #pragma fragment frag_omega
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

            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature GEOM_TYPE_BRANCH_DETAIL
            #pragma shader_feature _ALPHABLEND_ON
            #pragma shader_feature _ALPHAMODULATE_ON
            #pragma shader_feature _ALPHAPREMULTIPLY_ON
            #pragma shader_feature _ALPHATEST_ON
            #pragma shader_feature BILLBOARD_FACE_CAMERA_POS
            #pragma shader_feature EFFECT_HUE_VARIATION
            #pragma shader_feature ETC1_EXTERNAL_ALPHA
            #pragma shader_feature _ _SUNDISK_NONE _SUNDISK_SIMPLE
            #pragma shader_feature _SUNDISK_HIGH_QUALITY
            #pragma shader_feature _TERRAIN_NORMAL_MAP

            #pragma vertex vert_omega
            #pragma hull hull_omega
            #pragma domain domain_omega
            #pragma geometry geom_omega
            #pragma fragment frag_omega
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

            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature _EMISSION
            #pragma shader_feature GEOM_TYPE_BRANCH_DETAIL
            #pragma shader_feature _ALPHABLEND_ON
            #pragma shader_feature _ALPHAMODULATE_ON
            #pragma shader_feature _ALPHAPREMULTIPLY_ON
            #pragma shader_feature _ALPHATEST_ON
            #pragma shader_feature BILLBOARD_FACE_CAMERA_POS
            #pragma shader_feature EFFECT_HUE_VARIATION
            #pragma shader_feature ETC1_EXTERNAL_ALPHA
            #pragma shader_feature _ _SUNDISK_NONE _SUNDISK_SIMPLE
            #pragma shader_feature _SUNDISK_HIGH_QUALITY
            #pragma shader_feature _TERRAIN_NORMAL_MAP

            #pragma vertex vert_omega
            #pragma hull hull_omega
            #pragma domain domain_omega
            #pragma geometry geom_omega
            #pragma fragment frag_omega
            #include "KajCore.cginc"
            ENDCG
        }
    }
}