// KajCore.cginc
// Giant colllection of reusable shader code meant to coexist without conflict in a single file
// New vert/frags can be written for different/specialized techniques so shader property remapping 
// can be quickly done by extending an existing vert/frag
#ifndef KAJ_CORE
#define KAJ_CORE

#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "Autolight.cginc"
#include "UnityMetaPass.cginc"


// SHADER PROPERTIES
// Unity
sampler2D _CameraDepthTexture;                          // Camera depth texture
sampler3D _DitherMaskLOD;                               // Built-in dither tex
//sampler2D _DitherMaskLOD2D;                           // Built-in dither tex, defined in UNITY_APPLY_DITHER_CROSSFADE
// Standard
uniform half4 _Color;                                   // Standard shader color param, used by Enlighten during lightmapping too
UNITY_DECLARE_TEX2D(_MainTex);                // Standard main texture
    uniform float4 _MainTex_ST;
    uniform float4 _MainTex_TexelSize;
uniform half _Cutoff;                                   // Standard cutoff
uniform float _Glossiness;                              // Standard smoothness
uniform float _GlossMapScale;                           // Standard smoothness scale when using a texture
uniform half _Metallic;                                 // Standard metallic
UNITY_DECLARE_TEX2D_NOSAMPLER(_MetallicGlossMap);       // Standard metallic map
    uniform float4 _MetallicGlossMap_ST;
    uniform float4 _MetallicGlossMap_TexelSize;
uniform float _SpecularHighlights;                      // Standard specular highlights toggle
uniform float _GlossyReflections;                       // Standard reflections toggle
uniform half _BumpScale;                                // Standard normal map scale
UNITY_DECLARE_TEX2D_NOSAMPLER(_BumpMap);                // Standard normal map
    uniform float4 _BumpMap_ST;
    uniform float4 _BumpMap_TexelSize;
uniform half _Parallax;                                 // Standard height map scale
UNITY_DECLARE_TEX2D_NOSAMPLER(_ParallaxMap);            // Standard height map
    uniform float4 _ParallaxMap_ST;
    uniform float4 _ParallaxMap_TexelSize;
uniform half _OcclusionStrength;                        // Standard AO strength
UNITY_DECLARE_TEX2D_NOSAMPLER(_OcclusionMap);           // Standard AO map
    uniform float4 _OcclusionMap_ST;
    uniform float4 _OcclusionMap_TexelSize;
uniform float4 _EmissionColor;                          // Standard emission color (HDR)
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissionMap);            // Standard emission map
    uniform float4 _EmissionMap_ST;
    uniform float4 _EmissionMap_TexelSize;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailMask);             // Standard detail mask
    uniform float4 _DetailMask_ST;
    uniform float4 _DetailMask_TexelSize;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailAlbedoMap);        // Standard mid-gray detail map
    uniform float4 _DetailAlbedoMap_ST;
    uniform float4 _DetailAlbedoMap_TexelSize;
uniform half _DetailNormalMapScale;                     // Standard detail normal map scale
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailNormalMap);        // Standard detail normal map
    uniform float4 _DetailNormalMap_ST;
    uniform float4 _DetailNormalMap_TexelSize;
uniform half _UVSec;                                    // Standard UV selection for secondary textures
uniform float _Mode;                                    // Standard rendering mode (opaque, cutout, fade, transparent)
uniform float _SrcBlend;                                // Standard blending source mode
uniform float _DstBlend;                                // Standard blending destination mode
uniform float _ZWrite;                                  // Blending option
// Standard Specular            
UNITY_DECLARE_TEX2D_NOSAMPLER(_SpecGlossMap);           // Standard Specular specular map, also roughness map in Autodesk Interactive
    uniform float4 _SpecGlossMap_ST;
    uniform float4 _SpecGlossMap_TexelSize;
// Nature
uniform float4 _WaveAndDistance;                        // Terrain grass waving
uniform float4 _WavingTint;                             // Terrain grass fade color
uniform float _HueVariationKwToggle;                    // SpeedTree color variation keyword toggle
uniform float4 _HueVariationColor;                      // SpeedTree color variation
uniform float _NormalMapKwToggle;                       // SpeedTree normal map keyword toggle
UNITY_DECLARE_TEX2D(_ExtraTex);                         // SpeedTree Smoothness (R), Metallic (G), AO (B)
uniform float _SubsurfaceKwToggle;                      // SpeedTree SSS keyword toggle
UNITY_DECLARE_TEX2D(_SubsurfaceTex);                    // SpeedTree SSS map
uniform float4 _SubsurfaceColor;                        // SpeedTree SSS color
uniform float _SubsurfaceIndirect;                      // SpeedTree SSS indirect multiplier
uniform float _Shininess;                               // Terrain traditional specular power
UNITY_DECLARE_TEX2D(_Control);                          // Terrain control texture
UNITY_DECLARE_TEX2D(_Splat0);                           // Terrain textures
UNITY_DECLARE_TEX2D(_Splat1);                           // Terrain textures
UNITY_DECLARE_TEX2D(_Splat2);                           // Terrain textures
UNITY_DECLARE_TEX2D(_Splat3);                           // Terrain textures
uniform float _Metallic0;                               // Terrain metallic scale
uniform float _Metallic1;                               // Terrain metallic scale
uniform float _Metallic2;                               // Terrain metallic scale
uniform float _Metallic3;                               // Terrain metallic scale
uniform float _Smoothness0;                             // Terrain specular scale
uniform float _Smoothness1;                             // Terrain specular scale
uniform float _Smoothness2;                             // Terrain specular scale
uniform float _Smoothness3;                             // Terrain specular scale
// UI
uniform float _ColorMask;                               // Blending option
uniform float _Stencil;                                 // Stencil options
uniform float _StencilWriteMask;                        // Stencil options
uniform float _StencilReadMask;                         // Stencil options
uniform float _StencilComp;                             // Stencil options
// Hidden/Internal-Colored
uniform float _ZTest;                                   // Blending option
// Particles
uniform float _Cull;                                    // Standard surface culling option
uniform float4 _TintColor;                              // Particle system specific color
uniform float _InvFade;                                 // Particle system soft particles factor
uniform float _DistortionStrength;                      // Standard Surface distortion strength
uniform float _DistortionBlend;                         // Standard Surface distortion blend
uniform float _SoftParticlesNearFadeDistance;           //Standard Surface soft particles near fade
uniform float _SoftParticlesFarFadeDistance;            // Standard Surface soft particles far fade
uniform float _CameraNearFadeDistance;                  // Standard Surface Camera near fade
uniform float _CameraFarFadeDistance;                   // Standard Surface Camera far fade
uniform float _BlendOp;                                 // Standard Surface blendop parameter
// Skybox
uniform float4 _Tint;                                   // Cubemap color
uniform float _Exposure;                                // Cubemap gamma exposure
uniform float _Rotation;                                // Cubemap rotation
UNITY_DECLARE_TEX3D(_Tex);                              // Cubemap main texture
UNITY_DECLARE_TEX2D(_FrontTex);                         // 6 Sided texture
UNITY_DECLARE_TEX2D(_BackTex);                          // 6 Sided texture
UNITY_DECLARE_TEX2D(_LeftTex);                          // 6 Sided texture
UNITY_DECLARE_TEX2D(_RightTex);                         // 6 Sided texture
UNITY_DECLARE_TEX2D(_UpTex);                            // 6 Sided texture
UNITY_DECLARE_TEX2D(_DownTex);                          // 6 Sided texture
uniform float _SunDisk;                                 // Procedural sun type
uniform float _SunSize;                                 // Procedural sun radius
uniform float _SunSizeConvergence;                      // Procedural sun size convergence
uniform float _AtmosphereThickness;                     // Procedural atmosphere thickness
uniform float4 _SkyTint;                                // Procedural sky color
uniform float4 _GroundColor;                            // Procedural ground color
uniform float _Mapping;                                 // Panoramic skybox mode
uniform float _ImageType;                               // Panoramic image type
uniform float _Layout;                                  // Panoramic skybox layout
// UCTS

// Cubed

// Noe

// Xiexe

// Poiyomi
uniform float _ParallaxBias;                            // Catlike coding bias
uniform float _DitheringEnabled;                        // Dithered transparency toggle
UNITY_DECLARE_TEXCUBE(_CubeMap);                        // Fallback reflection probe
    uniform float4 _CubeMap_HDR;
// Rero

// Mochie

// Arktoon

// VRChat
UNITY_DECLARE_TEX2D(_ReflectionTex0);                   // Mirror shader textures
UNITY_DECLARE_TEX2D(_ReflectionTex1);                   // Mirror shader textures
// Kaj
UNITY_DECLARE_TEX2D(_BampMap);                          // 4-channel bumpmap not DXTn compressed because alpha channel is used
UNITY_DECLARE_TEX2D(_ArcSSS);                           // Arc System Works SSS texture
UNITY_DECLARE_TEX2D(_ArcILM);                           // Arc System Works ILM texture
uniform float _SpecularMax;                             // PBR Scaling utilities
uniform float _SpecularMin;                             // PBR Scaling utilities
uniform float _GlossinessMin;                           // PBR Scaling utilities
uniform float _MetallicMin;                             // PBR Scaling utilities
uniform float _OcclusionMin;                            // PBR Scaling utilities
uniform float _PhongSpecularEnabled;                    // Custom phong toggle
uniform float _PhongSpecularPower;                      // Custom phong power
uniform float4 _PhongSpecularColor;                     // Custom phong color
uniform float _PhongSpecularIntensity;                  // Custom phong specular range
uniform float _AlphaToCoverage;                         // A2C toggle
uniform float _StandardFresnelIntensity;                // Standard BRDF fresnel control
UNITY_DECLARE_TEX2D(_SkyrimSkinTex);                    // Skyrim SSS map
uniform float _SkyrimLightingEffectOne;                 // Skyrim generic shader property - varies with shaders
uniform float _SkyrimLightingEffectTwo;                 // Skyrim generic shader property - varies with shaders
UNITY_DECLARE_TEX2D_NOSAMPLER(_CombinedMap);            // Reusable mask texture for roughness, AO, blah blah blah
    uniform float4 _CombinedMap_ST;
    uniform float4 _CombinedMap_TexelSize;
    uniform float _CombinedMapSamplerState;
uniform float _MetallicGlossMapCombinedMapChannel;      // _CombinedMap RGBA selection for Metallic
uniform float _SpecGlossMapCombinedMapChannel;          // _CombinedMap RGBA selection for Roughness/Smoothness
uniform float _OcclusionMapCombinedMapChannel;          // _CombinedMap RGBA selection for Occlusion
uniform float _SpecularMapCombinedMapChannel;           // _CombinedMap RGBA selection for Specular scale
uniform float _GlossinessMode;                          // Roughnes s/Smoothness toggle
UNITY_DECLARE_TEX2D_NOSAMPLER(_CoverageMap);            // Dedicated alpha channel texture
    uniform float4 _CoverageMap_ST;
    uniform float4 _CoverageMap_TexelSize;
    uniform float _CoverageMapUV;
    uniform float _CoverageMapSamplerState;
uniform float _OcclusionMapUV;                          // UV channel selector for occlusion map
uniform float _StencilPass;                             // Stencil options
uniform float _StencilFail;                             // Stencil options
uniform float _StencilZFail;                            // Stencil options
uniform float _DisableBatching;                         // Toggle for material subshader tag
uniform float _IgnoreProjector;                         // Toggle for material subshader tag
uniform float _ForceNoShadowCasting;                    // Toggle for material subshader tag
uniform float _CanUseSpriteAtlas;                       // Toggle for material subshader tag
uniform float _PreviewType;                             // Toggle for material subshader tag
uniform float _DitheredShadows;                         // Dithered shadows in shadowcaster toggle
uniform float _DetailAlbedoCombineMode;                 // Detail albedo combine mode
UNITY_DECLARE_TEX2D_NOSAMPLER(_SpecularMap);            // Dedicated RGB(A) map for old specular workflow + metallic workflow tint
    uniform float4 _SpecularMap_ST;
    uniform float4 _SpecularMap_TexelSize;
    uniform float _SpecularMapSamplerState;
uniform float _WorkflowMode;                            // Metallic or Specular Toggle
uniform float4 _DetailColorR;                           // Detail mask coloring
uniform float4 _DetailColorG;                           // Detail mask coloring
uniform float4 _DetailColorB;                           // Detail mask coloring
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailAlbedoMapGreen);   // 2nd detail map
    uniform float4 _DetailAlbedoMapGreen_ST;
    uniform float4 _DetailAlbedoMapGreen_TexelSize;
    uniform float _DetailAlbedoMapGreenSamplerState;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailAlbedoMapBlue);    // 3rd detail map
    uniform float4 _DetailAlbedoMapBlue_ST;
    uniform float4 _DetailAlbedoMapBlue_TexelSize;
    uniform float _DetailAlbedoMapBlueSamplerState;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailNormalMapGreen);   // 2nd detail normal map
    uniform float4 _DetailNormalMapGreen_ST;
    uniform float4 _DetailNormalMapGreen_TexelSize;
    uniform float _DetailNormalMapScaleGreen;
    uniform float _DetailNormalMapGreenSamplerState;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailNormalMapBlue);    // 3rd detail normal map
    uniform float4 _DetailNormalMapBlue_ST;
    uniform float4 _DetailNormalMapBlue_TexelSize;
    uniform float _DetailNormalMapScaleBlue;
    uniform float _DetailNormalMapBlueSamplerState;
uniform float _MainTexUV;                               // Main texture UV selector
uniform float _Version;                                 // Kaj Shader version
uniform float _BlendOpAlpha;                            // Blend op parameter for alpha
uniform float _SrcBlendAlpha;                           // Blend ops for alpha
uniform float _DstBlendAlpha;                           // Blend ops for alpha
uniform float group_toggle_Parallax;                    // new Parallax toggle
uniform float _GlossinessSource;                        // PBR shader specific glossiness source toggle
uniform float _AlphaToMask;                             // Dedicated paramater toggle
uniform float _DiffuseWrap;                             // Lambert shading diffuse wrap factor
uniform float _DiffuseWrapIntensity;                    // Lambert shading diffuse wrap toggle
uniform float _DiffuseWrapConserveEnergy;               // Lambert shading diffuse wrap toggle
uniform float group_toggle_PreIntegratedSkin;
UNITY_DECLARE_TEX2D_NOSAMPLER(_PreIntSkinTex);          // BRDF diffuse term lookup texture
uniform float _BumpBlurBias;                            // Pre-Integrated Skin parameters
uniform float _BlurStrength;                            // Pre-Integrated Skin parameters
uniform float _CurvatureInfluence;                      // Pre-Integrated Skin parameters
uniform float _CurvatureScale;                          // Pre-Integrated Skin parameters
uniform float _CurvatureBias;                           // Pre-Integrated Skin parameters
uniform float group_toggle_SSSTransmission;
UNITY_DECLARE_TEX2D_NOSAMPLER(_TranslucencyMap);        // Subsurface Transmission relative thickness map
    uniform float4 _TranslucencyMap_ST;
    uniform float4 _TranslucencyMap_TexelSize;
    uniform float _TranslucencyMapUV;
    uniform float _TranslucencyMapSamplerState;
uniform float _SSSTranslucencyMax;
uniform float _SSSTranslucencyMin;
uniform float _SSSTransmissionPower;
uniform float _SSSTransmissionDistortion;
uniform float _SSSTransmissionScale;
uniform float group_toggle_Diffuse;
uniform float group_toggle_Specular;
uniform float group_toggle_Reflections;
uniform float _DiffuseMode;
uniform float _SpecularMode;
uniform float _ReflectionsMode;
uniform float _VertexColorsEnabled;
uniform float _ReceiveShadows;
uniform float _SSSTransmissionShadowCastingLightsOnly;
uniform float _SSSTransmissionIgnoreShadowAttenuation;
uniform float _HDREnabled;
uniform float _SSSStylizedIndirect;
uniform float _BumpMapUV;
uniform float _EmissionMapUV;
uniform float _MetallicGlossMapUV;
uniform float _SpecGlossMapUV;
uniform float _SpecularMapUV;
uniform float _CombinedMapUV;
uniform float _DetailMaskUV;
uniform float _ParallaxMapUV;
uniform float _ParallaxUV0;
uniform float _ParallaxUV1;
uniform float _ParallaxUV2;
uniform float _ParallaxUV3;
uniform float _TriplanarUseVertexColors;
uniform float _DebugWorldNormals;
uniform float4 _AOColorBleed;
uniform float _DebugOcclusion;
uniform float _EmissionTintByAlbedo;
uniform float _SpecularAnisotropy;
uniform float _SpecularAnisotropyAngle;
UNITY_DECLARE_TEX2D_NOSAMPLER(_SpecularAnisotropyTangentMap);
    uniform float4 _SpecularAnisotropyTangentMap_ST;
    uniform float4 _SpecularAnisotropyTangentMap_TexelSize;
    uniform float _SpecularAnisotropyTangentMapUV;
    uniform float _SpecularAnisotropyTangentMapSamplerState;
uniform float _ReflectionsAnisotropy;
uniform float _ReflectionsAnisotropyAngle;
uniform float _MainTexSamplerState;
uniform float _BumpMapSamplerState;
uniform float _EmissionMapSamplerState;
uniform float _MetallicGlossMapSamplerState;
uniform float _SpecGlossMapSamplerState;
uniform float _OcclusionMapSamplerState;
uniform float _DetailMaskSamplerState;
uniform float _DetailAlbedoMapSamplerState;
uniform float _DetailNormalMapSamplerState;
uniform float _ParallaxMapSamplerState;
uniform float _SSSStylizedIndrectScaleByTranslucency;
uniform float _ShadowsSmooth;
uniform float _ShadowsSharp;
uniform float _FakeLightToggle;
uniform float4 _FakeLightDirection;
uniform float4 _FakeLightColor;
uniform float _FakeLightIntensity;
uniform float _ReceiveFog;
uniform float _PhongSpecularUseRoughness;
uniform float _CubeMapMode;
uniform float _OcclusionDirectSpecular;
uniform float _OcclusionDirectDiffuse;
uniform float _AlbedoTransparencyEnabled;
uniform float _DirectLightIntensity;
uniform float _DirectionalLightIntensity;
uniform float _PointLightIntensity;
uniform float _SpotLightIntensity;
uniform float _IndirectLightIntensity;
uniform float _VertexLightIntensity;
uniform float _LightProbeIntensity;
uniform float _LightmapIntensity;
uniform float _RealtimeLightmapIntensity;
uniform float _ReflectionsIntensity;
uniform float _LightModes;

// Reusable macros and functions

// Stereo correct world camera position
#ifdef USING_STEREO_MATRICES
#define _WorldSpaceStereoCameraCenterPos lerp(unity_StereoWorldSpaceCameraPos[0], unity_StereoWorldSpaceCameraPos[1], 0.5)
#else
#define _WorldSpaceStereoCameraCenterPos _WorldSpaceCameraPos
#endif

// UNITY_LIGHT_ATTENUATION macros without the shadow multiplied in
#ifdef POINT
#define LIGHT_ATTENUATION_NO_SHADOW_MUL(destName, input, worldPos) \
        unityShadowCoord3 lightCoord = mul(unity_WorldToLight, unityShadowCoord4(worldPos, 1)).xyz; \
        fixed shadow = UNITY_SHADOW_ATTENUATION(input, worldPos); \
        fixed destName = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).r;
#endif
#ifdef SPOT
#define LIGHT_ATTENUATION_NO_SHADOW_MUL(destName, input, worldPos) \
        DECLARE_LIGHT_COORD(input, worldPos); \
        fixed shadow = UNITY_SHADOW_ATTENUATION(input, worldPos); \
        fixed destName = (lightCoord.z > 0) * UnitySpotCookie(lightCoord) * UnitySpotAttenuate(lightCoord.xyz);
#endif
#ifdef DIRECTIONAL
#define LIGHT_ATTENUATION_NO_SHADOW_MUL(destName, input, worldPos) \
        fixed shadow = UNITY_SHADOW_ATTENUATION(input, worldPos); \
        fixed destName = 1;
#endif
#ifdef POINT_COOKIE
#define LIGHT_ATTENUATION_NO_SHADOW_MUL(destName, input, worldPos) \
        DECLARE_LIGHT_COORD(input, worldPos); \
        fixed shadow = UNITY_SHADOW_ATTENUATION(input, worldPos); \
        fixed destName = tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).r * texCUBE(_LightTexture0, lightCoord).w;
#endif
#ifdef DIRECTIONAL_COOKIE
#define LIGHT_ATTENUATION_NO_SHADOW_MUL(destName, input, worldPos) \
        DECLARE_LIGHT_COORD(input, worldPos); \
        fixed shadow = UNITY_SHADOW_ATTENUATION(input, worldPos); \
        fixed destName = tex2D(_LightTexture0, lightCoord).w;
#endif

// Unity texture declarations and sampler macros because HLSLSupport.cginc doesn't have tex2Dbias or tex2Dlod
#define UNITY_SAMPLE_TEX2D_BIAS(tex,coord,bias) tex.SampleBias (sampler##tex,coord,bias)
#define UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex,samplertex,coord,bias) tex.SampleBias (sampler##samplertex,coord,bias)
#define UNITY_SAMPLE_TEX2D_LOD(tex,coord,lod) tex.SampleLevel (sampler##tex,coord,lod)
#define UNITY_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord,lod) tex.SampleLevel (sampler##samplertex,coord,lod)

// Inline sampler states, meant to be used in conjunction with KSOSamplerState  
SamplerState sampler_linear_repeat;
SamplerState sampler_linear_clamp;
SamplerState sampler_linear_mirror;
SamplerState sampler_linear_mirroronce;
SamplerState sampler_point_repeat;
SamplerState sampler_point_clamp;
SamplerState sampler_point_mirror;
SamplerState sampler_point_mirroronce;
SamplerState sampler_trilinear_repeat;
SamplerState sampler_trilinear_clamp;
SamplerState sampler_trilinear_mirror;
SamplerState sampler_trilinear_mirroronce;

// Easy triplanar sampling
#define SAMPLE_TEX2D_TRIPLANAR_SAMPLER(tex,samplertex,coordX,coordY,coordZ,scale,blend) \
    UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, ((coordX) * (scale))) * (blend).x \
    + UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, ((coordY) * (scale))) * (blend).y \
    + UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, ((coordZ) * (scale))) * (blend).z

#define SAMPLE_TEX2D_TRIPLANAR_SAMPLER_BIAS(tex,samplertex,coordX,coordY,coordZ,scale,blend,bias) \
    UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex, samplertex, ((coordX) * (scale)), bias) * (blend).x \
    + UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex, samplertex, ((coordY) * (scale)), bias) * (blend).y \
    + UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex, samplertex, ((coordZ) * (scale)), bias) * (blend).z


// PBR shader specific branching and sampling, expects convention texture variables and specific triplanar variable names
// Checks the convention UV set for the texture.  Either UVs 0-3 are used and transformed using Tiling/Offset or 
// shader triplanar/planar/screenspace variables are used with custom Tiling/Offset setup
//KSOEvaluateMacro
#define PBR_SAMPLE_TEX2DS(var,tex,samplertex) \
    UNITY_BRANCH \
    if (tex##UV == 0) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, (i.uv.xy * tex##_ST.xy + tex##_ST.zw)); \
    else if (tex##UV == 1) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, (i.uv1.xy * tex##_ST.xy + tex##_ST.zw)); \
    else if (tex##UV == 2) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, (i.uv2and3.xy * tex##_ST.xy + tex##_ST.zw)); \
    else if (tex##UV == 3) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, (i.uv2and3.zw * tex##_ST.xy + tex##_ST.zw)); \
    else if (tex##UV == 4) \
        var = SAMPLE_TEX2D_TRIPLANAR_SAMPLER(tex, samplertex, (tpWorldX + tex##_ST.wy), (tpWorldY + tex##_ST.yz), (tpWorldZ + tex##_ST.zw), tex##_ST.x, tpWorldBlendFactor); \
    else if (tex##UV == 5) \
        var = SAMPLE_TEX2D_TRIPLANAR_SAMPLER(tex, samplertex, (tpObjX + tex##_ST.wy), (tpObjY + tex##_ST.yz), (tpObjZ + tex##_ST.zw), tex##_ST.x, tpObjBlendFactor); \
    else if (tex##UV == 6) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, (i.posWorld.xy * tex##_ST.xy + tex##_ST.zw)); \
    else if (tex##UV == 7) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, (i.posWorld.yz * tex##_ST.xy + tex##_ST.zw)); \
    else if (tex##UV == 8) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, (i.posWorld.zx * tex##_ST.xy + tex##_ST.zw)); \
    else if (tex##UV == 9) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, (i.posObject.xy * tex##_ST.xy + tex##_ST.zw)); \
    else if (tex##UV == 10) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, (i.posObject.yz * tex##_ST.xy + tex##_ST.zw)); \
    else if (tex##UV == 11) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, (i.posObject.zx * tex##_ST.xy + tex##_ST.zw)); \
    else if (tex##UV == 12) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, (stereoCorrectScreenUV01(i.grabPos) * tex##_ST.xy + tex##_ST.zw)); \
    else \
        var = UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, (panoUV * tex##_ST.xy + tex##_ST.zw));

// KSOEvaluateMacro
#define PBR_SAMPLE_TEX2DS_BIAS(var,tex,samplertex,bias) \
    UNITY_BRANCH \
    if (tex##UV == 0) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex, samplertex, (i.uv.xy * tex##_ST.xy + tex##_ST.zw), bias); \
    else if (tex##UV == 1) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex, samplertex, (i.uv1.xy * tex##_ST.xy + tex##_ST.zw), bias); \
    else if (tex##UV == 2) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex, samplertex, (i.uv2and3.xy * tex##_ST.xy + tex##_ST.zw), bias); \
    else if (tex##UV == 3) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex, samplertex, (i.uv2and3.zw * tex##_ST.xy + tex##_ST.zw), bias); \
    else if (tex##UV == 4) \
        var = SAMPLE_TEX2D_TRIPLANAR_SAMPLER_BIAS(tex, samplertex, (tpWorldX + tex##_ST.wy), (tpWorldY + tex##_ST.yz), (tpWorldZ + tex##_ST.zw), tex##_ST.x, tpWorldBlendFactor, bias); \
    else if (tex##UV == 5) \
        var = SAMPLE_TEX2D_TRIPLANAR_SAMPLER_BIAS(tex, samplertex, (tpObjX + tex##_ST.wy), (tpObjY + tex##_ST.yz), (tpObjZ + tex##_ST.zw), tex##_ST.x, tpObjBlendFactor, bias); \
    else if (tex##UV == 6) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex, samplertex, (i.posWorld.xy * tex##_ST.xy + tex##_ST.zw), bias); \
    else if (tex##UV == 7) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex, samplertex, (i.posWorld.yz * tex##_ST.xy + tex##_ST.zw), bias); \
    else if (tex##UV == 8) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex, samplertex, (i.posWorld.zx * tex##_ST.xy + tex##_ST.zw), bias); \
    else if (tex##UV == 9) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex, samplertex, (i.posObject.xy * tex##_ST.xy + tex##_ST.zw), bias); \
    else if (tex##UV == 10) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex, samplertex, (i.posObject.yz * tex##_ST.xy + tex##_ST.zw), bias); \
    else if (tex##UV == 11) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex, samplertex, (i.posObject.zx * tex##_ST.xy + tex##_ST.zw), bias); \
    else if (tex##UV == 12)\
        var = UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex, samplertex, (stereoCorrectScreenUV01(i.grabPos) * tex##_ST.xy + tex##_ST.zw), bias); \
    else \
        var = UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex, samplertex, (panoUV * tex##_ST.xy + tex##_ST.zw), bias);


// VRChat mirror utility
bool IsInMirror()
{
	return unity_CameraProjection[2][0] != 0.f || unity_CameraProjection[2][1] != 0.f;
}

// Alpha to coverage helper fucntion, courtesy of bgolus
float CalcMipLevel(float2 texture_coord)
{
	float2 dx = ddx(texture_coord);
	float2 dy = ddy(texture_coord);
	float delta_max_sqr = max(dot(dx, dx), dot(dy, dy));
	
	return max(0.0, 0.5 * log2(delta_max_sqr));
}

// fallback baked lighting direction, from Poi?
// WIP
float3 GetBakedLightDir(float3 wPos, float atten)
{
    float3 _light_direction_var =_WorldSpaceLightPos0.xyz;
    _light_direction_var *= atten * dot(float3(0.2125, 0.7154, 0.0721), _LightColor0);
    float3 probeDir = unity_SHAr.xyz + unity_SHAg.xyz + unity_SHAb.xyz;
    _light_direction_var =  _light_direction_var + probeDir;
    return normalize( _light_direction_var);
}

// Normalized light direction for both base pass, additive pass, AND directional lightmap
// WIP
half3 getLightDirection(float3 worldPosition, float2 lightmapUV)
{
    #ifdef UNITY_PASS_FORWARDBASE
        //if (any(_WorldSpaceLightPos0.xyz))
        return _WorldSpaceLightPos0.xyz;
    #else
        return normalize(_WorldSpaceLightPos0.xyz - worldPosition);
    #endif
    if (any(_WorldSpaceLightPos0.xyz))
        return _WorldSpaceLightPos0.xyz;

    //#ifdef LIGHTMAP_ON
        //#ifdef DIRLIGHTMAP_COMBINED

}

// Light color with fallback that estimates
// WIP
half3 getLightColor()
{
    //if (any(_LightColor0.rgb))
    return _LightColor0.rgb;
    //else return half3(1, 0, 1); // pink if black light
    #ifdef UNITY_PASS_FORWARDBASE
        #ifdef LIGHTMAP_ON
            #ifdef DIRLIGHTMAP_COMBINED
            #endif
        #endif
    #endif
}

// More user friendly speccube-roughness sampling function from UnityImageBasedLighting.cginc
half3 Unity_GlossyEnvironmentModular (UNITY_ARGS_TEXCUBE(tex), half4 hdr, half perceptualRoughness, half3 reflUVW)
{
    // approximation of more complex real roughness
    perceptualRoughness = perceptualRoughness*(1.7 - 0.7*perceptualRoughness);
    return DecodeHDR(UNITY_SAMPLE_TEXCUBE_LOD(tex, reflUVW, perceptualRoughness * UNITY_SPECCUBE_LOD_STEPS), hdr);
}

// Unity GI function that actually uses Unity's speccubes instead of roundabout struct data packing
half3 UnityGI_IndirectSpecularModular(half3 viewReflectDir, float3 posWorld, half perceptualRoughness)
{
    half3 indirect_specular = 0;

    #ifdef UNITY_PASS_FORWARDBASE
        #ifdef UNITY_SPECCUBE_BOX_PROJECTION
            half3 originalReflUVW = viewReflectDir;
            viewReflectDir = BoxProjectedCubemapDirection (originalReflUVW, posWorld, unity_SpecCube0_ProbePosition, unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);
        #endif

        half3 env0 = Unity_GlossyEnvironmentModular (UNITY_PASS_TEXCUBE(unity_SpecCube0), unity_SpecCube0_HDR, perceptualRoughness, viewReflectDir);
        #ifdef UNITY_SPECCUBE_BLENDING
            const float kBlendFactor = 0.99999;
            float blendLerp = unity_SpecCube0_BoxMin.w;
            UNITY_BRANCH
            if (blendLerp < kBlendFactor)
            {
                #ifdef UNITY_SPECCUBE_BOX_PROJECTION
                    viewReflectDir = BoxProjectedCubemapDirection (originalReflUVW, posWorld, unity_SpecCube1_ProbePosition, unity_SpecCube1_BoxMin, unity_SpecCube1_BoxMax);
                #endif

                half3 env1 = Unity_GlossyEnvironmentModular (UNITY_PASS_TEXCUBE_SAMPLER(unity_SpecCube1,unity_SpecCube0), unity_SpecCube1_HDR, perceptualRoughness, viewReflectDir);
                indirect_specular = lerp(env1, env0, blendLerp);
            }
            else indirect_specular = env0;
        #else
            indirect_specular = env0;
        #endif

    #endif
    return indirect_specular;
}

// Vertex lights diffuse-only helper
// Forwardbase 4 unimportant lights (Vertex-lit 8 unimportant lights support later)
half3 VertexLightsDiffuse(half3 normalDir, float3 posWorld)
{
    half3 vertexDiffuse = 0;
    #ifdef UNITY_PASS_FORWARDBASE
        #ifdef VERTEXLIGHT_ON
            // if _LightModes & 4 != 0, Fwdadd pass is disabled, do all 8?
            for (int i=0; i<4; i++)
            {
                float3 lightPos = float3(unity_4LightPosX0[i],  unity_4LightPosY0[i], unity_4LightPosZ0[i]);
                float3 vertexToLightSource = lightPos - posWorld;
                float squaredDistance = max(0.000001, dot(vertexToLightSource, vertexToLightSource));
                vertexToLightSource *= rsqrt(squaredDistance);
                float atten = 1.0 / (1.0 + squaredDistance * unity_4LightAtten0[i]);
                float diff = max(0, dot(normalDir, vertexToLightSource));
                vertexDiffuse += unity_LightColor[i].rgb * (diff * atten);
            }
        #endif
    #endif
    return vertexDiffuse;
}

// Light probes sampler helper function
half3 ShadeSHPerPixelModular(half3 normal, float3 worldPos)
{
    half3 ambient_contrib = 0.0;
    #if UNITY_LIGHT_PROBE_PROXY_VOLUME
        if (unity_ProbeVolumeParams.x == 1.0)
            ambient_contrib = SHEvalLinearL0L1_SampleProbeVolume(half4(normal, 1.0), worldPos);
        else
            ambient_contrib = SHEvalLinearL0L1(half4(normal, 1.0));
    #else
        ambient_contrib = SHEvalLinearL0L1(half4(normal, 1.0));
    #endif
    ambient_contrib += SHEvalLinearL2(half4(normal, 1.0));
    return max(half3(0, 0, 0), ambient_contrib);;
}

// Old static shader
float static_effect( float2 screenPos )
{
    return frac(sin(dot(screenPos,float2(_Time.y,65.115)))*2773.8856);
}

// Camera depth helper
float camera_depth(float4 screenPos)
{
    return Linear01Depth(tex2Dproj(_CameraDepthTexture, screenPos));
}

// nan lol
float nan()
{
    return 1.0 / 0.0;
}

// neginf lol
float neginf()
{
    return log2(0.0);
}

// Old red/white sunglasses effect
float3 memeShades_effect(float speed, float2 uv, float3 color1, float3 color2)
{
    float timeModOne = fmod(_Time.y, speed);
    float distToCenter = 2.0 * distance(uv, float2(0.5,0.5));
    float4 steppedColor = 0;
    float temp = fmod(pow(distToCenter, 3) - timeModOne + speed, speed);
    if (temp > speed * 0.5)
        return color1;
    else return color2;
}

// Runescape/PSX style world space vertex snapping
float3 roundVertex(float3 vert, half factor) // good default is 120
{
    return round(vert * factor) / factor;
}

// Affine texture transformation
half4 sampleAffine(sampler2D tex, float4 objPosition, float2 coord, float4 st)
{
    float3 texcoord = float3((coord.xy* st.xy + st.zw) * objPosition.w, objPosition.w);
    return tex2D(tex, texcoord.xy / texcoord.z);
}

half3 switchDetailAlbedo(fixed4 tex, half3 albedo, float combineMode, fixed mask)
{
    UNITY_BRANCH
    if (combineMode == 0)
        return albedo * LerpWhiteTo (tex.rgb * unity_ColorSpaceDouble.rgb, mask);
    else if (combineMode == 1)
        return albedo * LerpWhiteTo (tex.rgb, mask);
    else if (combineMode == 1)
        return albedo + tex.rgb * mask;
    else return lerp(albedo, tex.rgb, mask);
}

// Light intensity(?) function from poiyomi
half3 GetSHLength()
{
    half3 x, x1;
    x.r = length(unity_SHAr);
    x.g = length(unity_SHAg);
    x.b = length(unity_SHAb);
    x1.r = length(unity_SHBr);
    x1.g = length(unity_SHBg);
    x1.b = length(unity_SHBb);
    return x + x1;
}

// https://en.wikipedia.org/wiki/Ordered_dithering
// Shifted up by 1 each to make sure clipping at zero opacity works
inline half Dither8x8Bayer( int x, int y )
{
    const half dither[ 64 ] = {
    1, 49, 13, 61,  4, 52, 16, 64,
    33, 17, 45, 29, 36, 20, 48, 32,
    9, 57,  5, 53, 12, 60,  8, 56,
    41, 25, 37, 21, 44, 28, 40, 24,
    3, 51, 15, 63,  2, 50, 14, 62,
    35, 19, 47, 31, 34, 18, 46, 30,
    11, 59,  7, 55, 10, 58,  6, 54,
    43, 27, 39, 23, 42, 26, 38, 22};
    int r = y * 8 + x;
    return dither[r] / 64;
}
half ditherBayer(half2 position)
{
    return Dither8x8Bayer(fmod(position.x, 8), fmod(position.y, 8));
}

half2 stereoCorrectScreenUV(half4 screenPos)
{
    half2 uv = screenPos / (screenPos.w + 0.0000000001); //0.0x1 Stops division by 0 warning in console.
    #if UNITY_SINGLE_PASS_STEREO
        uv.xy *= half2(_ScreenParams.x * 2, _ScreenParams.y);	
    #else
        uv.xy *= _ScreenParams.xy;
    #endif
    
    return uv;
}

half2 stereoCorrectScreenUV01(half4 screenPos)
{
    half2 uv = screenPos / (screenPos.w + 0.0000000001); //0.0x1 Stops division by 0 warning in console.
    #if UNITY_SINGLE_PASS_STEREO
        uv.x += 0.6 * unity_StereoEyeIndex; // Works on oculus lol
    #endif
    return uv;
}

float2 PanosphereProjection(float3 worldPos, float3 cameraPos)
{
    float3 normalizedCoords = normalize(cameraPos - worldPos) * -1;
    float latitude = acos(normalizedCoords.y);
    float longitude = atan2(normalizedCoords.z, normalizedCoords.x);
    float2 sphereCoords = 1.0 - float2(longitude, latitude) * UNITY_INV_PI;
    return sphereCoords + float2(0, 1 - unity_StereoEyeIndex);
}

// https://openproblems.realtimerendering.com/s2017/02-PhysicallyBasedMaterialWhereAreWe.pdf
// HDRP also uses this implementation
float GGXTerm_Aniso(float TdotH, float BdotH, float roughnessT, float roughnessB, float NdotH)
{
    float denom = TdotH * TdotH / (roughnessT * roughnessT) + BdotH * BdotH / (roughnessB * roughnessB) + NdotH * NdotH;
    return (1.0 / ( roughnessT*roughnessB * denom*denom));
}
float SmithJointGGXAniso(float TdotV, float BdotV, float NdotV, float TdotL, float BdotL, float NdotL, float roughnessT, float roughnessB)
{
    roughnessT *= roughnessT;
    roughnessB *= roughnessB;
    float lambdaV = NdotL * sqrt(roughnessT * TdotV * TdotV + roughnessB * BdotV * BdotV + NdotV * NdotV);
    float lambdaL = NdotV * sqrt(roughnessT * TdotL * TdotL + roughnessB * BdotL * BdotL + NdotL * NdotL);
    return 0.5 / max(1e-5f, (lambdaV + lambdaL) );
}
// IBL vector hack for reflections [Revie11] [McAuley15]
// The grain direction (e.g. hair or brush direction) is assumed to be orthogonal to the normal.
// The returned normal is NOT normalized.
float3 ComputeGrainNormal(float3 grainDir, float3 viewDir)
{
    float3 B = cross(-viewDir, grainDir);
    return cross(B, grainDir);
}
// Fake anisotropic by distorting the normal.
// The grain direction (e.g. hair or brush direction) is assumed to be orthogonal to the provided normal.
// Anisotropic ratio (0->no isotropic; 1->full anisotropy in tangent direction)
float3 GetAnisotropicModifiedNormal(float3 grainDir, float3 normal, float3 viewDir, float anisotropy)
{
    float3 grainNormal = ComputeGrainNormal(grainDir, viewDir);
    return normalize(lerp(normal, grainNormal, anisotropy));
}

// Rotate an aniso bent normal using tangent/bitangent, a 0-1 angle range, and a 0-1 intensity
half3 AngledAnisotropicModifiedNormal(half3 normalWorld, half3 tangentWorld, half3 bitangentWorld, half3 viewDir, half angle, half anisotropy)
{
    // An accurate rotation angle isn't necessary here, as this is a small hack
    // so lerp instead of sin/cos/matrix mul
    half3 rotatedBitangent = 0;
    float reflectionsAngle = angle * 2 - 1;
    if (reflectionsAngle >= 0)
        rotatedBitangent = lerp(bitangentWorld, -tangentWorld, reflectionsAngle);
    else rotatedBitangent = lerp(bitangentWorld, tangentWorld, -reflectionsAngle);
    float3 anisoIblNormalWS = GetAnisotropicModifiedNormal(rotatedBitangent, normalWorld, viewDir, anisotropy);
    return reflect(-viewDir, anisoIblNormalWS);
}


// Reusable vert/frag/geoms

UNITY_INSTANCING_BUFFER_START(Props)
    //UNITY_DEFINE_INSTANCED_PROP
UNITY_INSTANCING_BUFFER_END(Props)

struct appdata_full_pbr
{
    float4 vertex : POSITION;
    half3 normal : NORMAL;
    half4 tangent : TANGENT;
    float4 texcoord : TEXCOORD0;
    float4 texcoord1 : TEXCOORD1;
    float4 texcoord2 : TEXCOORD2;
    float4 texcoord3 : TEXCOORD3;
    fixed4 color : COLOR;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};
// Full v2f, if you need fewer interpolators make a new vert/v2f
struct v2f_full
{
	float4 pos : SV_POSITION;
	float4 uv : TEXCOORD0;
    float4 uv1 : TEXCOORD1;
    float4 uv2and3 : TEXCOORD2;
	float4 color : TEXCOORD3;
    float4 posWorld : TEXCOORD4;    
    float4 posObject : TEXCOORD5;
    float3 normalObject : TEXCOORD6;
	float3 normalWorld : TEXCOORD7;
	float3 tangentWorld : TEXCOORD8;
	float3 bitangentWorld : TEXCOORD9;
    float4 grabPos: TEXCOORD10;
    float4 screenPos: TEXCOORD11;
    float3 tangentViewDir : TEXCOORD12;
	UNITY_FOG_COORDS(13)
#ifndef UNITY_PASS_SHADOWCASTER
	SHADOW_COORDS(14)
#endif
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};
v2f_full vert_full (appdata_full_pbr v)
{
	v2f_full o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_OUTPUT(v2f_full, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    UNITY_TRANSFER_INSTANCE_ID(v, o);

    UNITY_BRANCH
    if (group_toggle_Parallax) // batched mehses don't have normalized tangent/normal
    {
        v.tangent.xyz = normalize(v.tangent.xyz);
	    v.normal = normalize(v.normal);
    }

    // http://www.humus.name/Articles/Persson_LowlevelShaderOptimization.pdf
    // Packing interpolators is useless on dx11 hardware because each interpolator is resolved by a single instruction.
    // Packing values to save interpolators would actually use more instructions.
	o.pos = UnityObjectToClipPos(v.vertex);
    o.posWorld = mul(unity_ObjectToWorld, v.vertex);
    o.posObject = v.vertex;
	o.normalWorld = normalize(UnityObjectToWorldNormal(v.normal));
    o.normalObject = v.normal;
	o.tangentWorld = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
	o.bitangentWorld = normalize(cross(o.normalWorld, o.tangentWorld) * v.tangent.w);
	o.uv = v.texcoord;
    o.uv1 = v.texcoord1;
    o.uv2and3.xy = v.texcoord2;
    o.uv2and3.zw = v.texcoord3;
	o.color = v.color;
    o.screenPos = ComputeScreenPos(o.pos);
    o.grabPos = ComputeGrabScreenPos(o.pos);
    COMPUTE_EYEDEPTH(o.screenPos.z);
    float3x3 objectToTangent = float3x3(v.tangent.xyz, cross(v.normal, v.tangent.xyz) * v.tangent.w, v.normal);
	o.tangentViewDir = mul(objectToTangent, ObjSpaceViewDir(v.vertex));
#ifndef UNITY_PASS_SHADOWCASTER
	TRANSFER_SHADOW(o);
#endif
	UNITY_TRANSFER_FOG(o,o.pos);
	return o;
}


fixed4 frag_unlitSimple (v2f_full i) : SV_Target
{
	return UNITY_SAMPLE_TEX2D_SAMPLER(_MainTex, _linear_repeat, TRANSFORM_TEX(i.uv, _MainTex)) * _Color * i.color;
}


half4 frag_full_pbr (v2f_full i) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(i);
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
    UNITY_APPLY_DITHER_CROSSFADE(i.pos.xy);

    // Triplanar UVs
    // Object Space
    float3 tpObjBlendFactor = normalize(abs(i.normalObject));
    tpObjBlendFactor /= dot(tpObjBlendFactor, (float3)1);
    float2 tpObjX = 0;
    float2 tpObjY = 0;
    float2 tpObjZ = 0;
    if (_TriplanarUseVertexColors)
    {
        tpObjX = i.color.yz;
        tpObjY = i.color.zx;
        tpObjZ = i.color.xy;
    }
    else
    {
        tpObjX = i.posObject.yz;
        tpObjY = i.posObject.zx;
        tpObjZ = i.posObject.xy;
    }

    // World Space
    float3 tpWorldBlendFactor = normalize(abs(i.normalWorld));
    tpWorldBlendFactor /= dot(tpWorldBlendFactor, (float3)1);
    float2 tpWorldX = i.posWorld.yz;
    float2 tpWorldY = i.posWorld.zx;
    float2 tpWorldZ = i.posWorld.xy;

    // Panosphere UVs
    float2 panoUV = PanosphereProjection(i.posWorld, _WorldSpaceCameraPos.xyz);

    // Parallax
    fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
    UNITY_BRANCH
    if (group_toggle_Parallax)
    {
        fixed4 _ParallaxMap_var = 1;
        if (_ParallaxMap_TexelSize.x != 1)
            // KSOInlineSamplerState   ( _MainTex,  _ParallaxMap )
            PBR_SAMPLE_TEX2DS(_ParallaxMap_var, _ParallaxMap, _MainTex);
        i.tangentViewDir = normalize(i.tangentViewDir);
        i.tangentViewDir.xy /= (i.tangentViewDir.z + _ParallaxBias);
        half2 parallaxOffset = i.tangentViewDir.xy * _Parallax * (_ParallaxMap_var.g - 0.5f);;
        if (_ParallaxUV0)
		    i.uv.xy += parallaxOffset;
        if (_ParallaxUV1)
		    i.uv1.xy += parallaxOffset;
        if (_ParallaxUV2)
		    i.uv2and3.xy += parallaxOffset;
        if (_ParallaxUV3)
		    i.uv2and3.zw += parallaxOffset;

        // Triplanar parallax goes here
    }

    // Base opacity
    fixed4 _MainTex_var = 1;
    if (_MainTex_TexelSize.x != 1)
        // Default behaviour is to have all textures sampled by Albedo until you lock in with inline samplers
        // However, albedo will ALWAYS be sampled by its own sampler
        PBR_SAMPLE_TEX2DS(_MainTex_var, _MainTex, _MainTex);
    half3 albedo = _MainTex_var.rgb * _Color.rgb;
    if (_VertexColorsEnabled)
        albedo *= i.color.rgb;
    half opacity = 1;
    if (_AlbedoTransparencyEnabled)
        opacity = _MainTex_var.a; // detail abledos don't affect transparency
    UNITY_BRANCH
    if (_CoverageMap_TexelSize.x != 1)  // Texel size is used to determine if a texture is being used
    {
        fixed4 _CoverageMap_var = 0;
        //KSOInlineSamplerState(_MainTex, _CoverageMap)
        PBR_SAMPLE_TEX2DS(_CoverageMap_var, _CoverageMap, _MainTex);
        opacity = _CoverageMap_var.r;
    }
    opacity *= _Color.a;
    if (_VertexColorsEnabled)
        opacity *= i.color.a;

    // A2C
    UNITY_BRANCH
    if (_Mode == 1) // _ALPHATEST_ON
    {
        UNITY_BRANCH
        if (_AlphaToCoverage && _AlphaToMask)
        {
            // todo: scale by coverage map instead if it exists
            opacity *= 1 + max(0, CalcMipLevel(i.uv.xy * _MainTex_TexelSize.zw)) * 0.25;
            opacity = (opacity - _Cutoff) / max(fwidth(opacity), 0.0001) + 0.5;
        }
    }

    UNITY_BRANCH
    if (_Mode >= 1 && _Mode <= 3) // _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
    {
        // Dithering
        UNITY_BRANCH
        if (_DitheringEnabled)
        {
            half dither = ditherBayer(stereoCorrectScreenUV(i.grabPos));
            dither -= 0.01; // hack because opacity with vertex color imprecision makes dithering visible at full white
            UNITY_BRANCH
            if (_AlphaToMask)
                opacity = opacity - (dither * (1 - opacity) * 0.15);
            else 
                clip(opacity - dither);
        }

        // Cutoff clipping
        UNITY_BRANCH
        if (!_AlphaToCoverage)
            clip(opacity - _Cutoff);
    }


    // PBR texture samples (if textures are active - is this more efficient?)
    fixed4 _CombinedMap_var = 1;
    UNITY_BRANCH
    if (_CombinedMap_TexelSize.x != 1)
        //KSOInlineSamplerState(_MainTex, _CombinedMap)
        PBR_SAMPLE_TEX2DS(_CombinedMap_var, _CombinedMap, _MainTex);
    fixed4 _MetallicGlossMap_var = 1;
    UNITY_BRANCH
    if (_MetallicGlossMap_TexelSize.x != 1)
        //KSOInlineSamplerState(_MainTex, _MetallicGlossMap)
        PBR_SAMPLE_TEX2DS(_MetallicGlossMap_var, _MetallicGlossMap, _MainTex);
    fixed4 _SpecGlossMap_var = 1;
    UNITY_BRANCH
    if (_SpecGlossMap_TexelSize.x != 1)
        //KSOInlineSamplerState(_MainTex, _SpecGlossMap)
        PBR_SAMPLE_TEX2DS(_SpecGlossMap_var, _SpecGlossMap, _MainTex);
    fixed4 _OcclusionMap_var = 1;
    UNITY_BRANCH
    if (_OcclusionMap_TexelSize.x != 1)
        //KSOInlineSamplerState(_MainTex, _OcclusionMap)
        PBR_SAMPLE_TEX2DS(_OcclusionMap_var, _OcclusionMap, _MainTex);
    fixed4 _SpecularMap_var = 1;
    UNITY_BRANCH
    if (_SpecularMap_TexelSize.x != 1)
        //KSOInlineSamplerState(_MainTex, _SpecularMap)
        PBR_SAMPLE_TEX2DS(_SpecularMap_var, _SpecularMap, _MainTex);
    
    // Map textures to PBR variables
    fixed metallic = 1;
    if (_MetallicGlossMap_TexelSize.x != 1)
        metallic = _MetallicGlossMap_var.r;
    else metallic = _CombinedMap_var[_MetallicGlossMapCombinedMapChannel];

    fixed3 occlusion = 1;
    if (_OcclusionMap_TexelSize.x != 1)
        occlusion = _OcclusionMap_var.rgb;
    else occlusion = _CombinedMap_var[_OcclusionMapCombinedMapChannel].rrr;

    fixed perceptualRoughness = 0;
    if (_GlossinessSource == 0)
        perceptualRoughness = _SpecGlossMap_var.r;
    else if (_GlossinessSource == 1)
        perceptualRoughness = _CombinedMap_var[_SpecGlossMapCombinedMapChannel];
    else if (_GlossinessSource == 2)
        perceptualRoughness = _MetallicGlossMap_var.a;
    else if (_GlossinessSource == 3)
        perceptualRoughness = _SpecularMap_var.a;
    else perceptualRoughness = _MainTex_var.a;

    fixed3 specularScale;
    if (_SpecularMap_TexelSize.x != 1)
        specularScale = _SpecularMap_var.rgb;
    else specularScale = _CombinedMap_var[_SpecularMapCombinedMapChannel].rrr;

    // Filter PBR variables
    metallic = _MetallicMin + metallic * (_Metallic - _MetallicMin);
    if (_GlossinessMode == 1)
        perceptualRoughness = 1.0 - perceptualRoughness;
    perceptualRoughness = _GlossinessMin + perceptualRoughness * (_Glossiness - _GlossinessMin);
    occlusion = lerp(1, occlusion, _OcclusionStrength);
    if (_DiffuseMode == 2) // Color bleed only available on Skin diffuse, may change later. Occlusion tint is also a thing
        occlusion = pow(occlusion, 1 - _AOColorBleed);
    specularScale = _SpecularMin + specularScale * (_SpecularMax - _SpecularMin);
    specularScale *= _SpecColor;

    // Details
    half3 _DetailMask_var = 1;
    UNITY_BRANCH
    if (_DetailMask_TexelSize.x != 1)
    {
        //KSOInlineSamplerState(_MainTex, _DetailMask)
        PBR_SAMPLE_TEX2DS(_DetailMask_var, _DetailMask, _MainTex);
        // Detail colors only applied if a mask is applied
        albedo.rgb = lerp(albedo.rgb, albedo.rgb * _DetailColorR.rgb, _DetailMask_var.r);
        albedo.rgb = lerp(albedo.rgb, albedo.rgb * _DetailColorG.rgb, _DetailMask_var.g);
        albedo.rgb = lerp(albedo.rgb, albedo.rgb * _DetailColorB.rgb, _DetailMask_var.b);
    }

    float2 detailUV;
    if (_UVSec == 0)
        detailUV = i.uv;
    else if (_UVSec == 1)
        detailUV = i.uv1;
    else if (_UVSec == 2)
        detailUV = i.uv2and3.xy;
    else if (_UVSec == 3)
        detailUV = i.uv2and3.zw;

    UNITY_BRANCH
    if (_DetailAlbedoMap_TexelSize.x != 1)
    {
        fixed _DetailAlbedoMapUV = _UVSec; // Temporary defines so the macro works, could change macro to switch UVselection just for these details
        fixed4 _DetailAlbedoMap_var = 0;
        //KSOInlineSamplerState(_MainTex, _DetailAlbedoMap)
        PBR_SAMPLE_TEX2DS(_DetailAlbedoMap_var, _DetailAlbedoMap, _MainTex);
        albedo = switchDetailAlbedo(_DetailAlbedoMap_var, albedo, _DetailAlbedoCombineMode, _DetailMask_var.r);
    }
    UNITY_BRANCH
    if (_DetailAlbedoMapGreen_TexelSize.x != 1)
    {
        fixed _DetailAlbedoMapGreenUV = _UVSec;
        fixed4 _DetailAlbedoMapGreen_var = 0;
        //KSOInlineSamplerState(_MainTex, _DetailAlbedoMapGreen)
        PBR_SAMPLE_TEX2DS(_DetailAlbedoMapGreen_var, _DetailAlbedoMapGreen, _MainTex);
        albedo = switchDetailAlbedo(_DetailAlbedoMapGreen_var, albedo, _DetailAlbedoCombineMode, _DetailMask_var.g);
    }
    UNITY_BRANCH
    if (_DetailAlbedoMapBlue_TexelSize.x != 1)
    {
        fixed _DetailAlbedoMapBlueUV = _UVSec;
        fixed4 _DetailAlbedoMapBlue_var = 0;
        //KSOInlineSamplerState(_MainTex, _DetailAlbedoMapBlue)
        PBR_SAMPLE_TEX2DS(_DetailAlbedoMapBlue_var, _DetailAlbedoMapBlue, _MainTex);
        albedo = switchDetailAlbedo(_DetailAlbedoMapBlue_var, albedo, _DetailAlbedoCombineMode, _DetailMask_var.b);
    }

    // Normals
    half3 blendedNormal = half3(0,0,1);
    if (_BumpMap_TexelSize.x != 1)
    {
        half4 _BumpMap_var = 0;
        //KSOInlineSamplerState(_MainTex, _BumpMap)
        PBR_SAMPLE_TEX2DS(_BumpMap_var, _BumpMap, _MainTex);
        blendedNormal = UnpackScaleNormal(_BumpMap_var, _BumpScale);
    }
    UNITY_BRANCH
    if (_DetailNormalMap_TexelSize.x != 1)
    {
        fixed _DetailNormalMapUV = _UVSec;
        fixed4 _DetailNormalMap_var = 0;
        //KSOInlineSamplerState(_MainTex, _DetailNormalMap)
        PBR_SAMPLE_TEX2DS(_DetailNormalMap_var, _DetailNormalMap, _MainTex);
        _DetailNormalMap_var.xyz = UnpackScaleNormal(_DetailNormalMap_var, _DetailNormalMapScale);
        blendedNormal = lerp(blendedNormal, BlendNormals(blendedNormal, _DetailNormalMap_var.xyz), _DetailMask_var.r);
    }
    UNITY_BRANCH
    if (_DetailNormalMapGreen_TexelSize.x != 1)
    {
        fixed _DetailNormalMapGreenUV = _UVSec;
        fixed4 _DetailNormalMapGreen_var = 0;
        //KSOInlineSamplerState(_MainTex, _DetailNormalMapGreen)
        PBR_SAMPLE_TEX2DS(_DetailNormalMapGreen_var, _DetailNormalMapGreen, _MainTex);
        _DetailNormalMapGreen_var.xyz = UnpackScaleNormal(_DetailNormalMapGreen_var, _DetailNormalMapScaleGreen);
        blendedNormal = lerp(blendedNormal, BlendNormals(blendedNormal, _DetailNormalMapGreen_var.xyz), _DetailMask_var.g);
    }
    UNITY_BRANCH
    if (_DetailNormalMapBlue_TexelSize.x != 1)
    {
        fixed _DetailNormalMapBlueUV = _UVSec;
        fixed4 _DetailNormalMapBlue_var = 0;
        //KSOInlineSamplerState(_MainTex, _DetailNormalMapBlue)
        PBR_SAMPLE_TEX2DS(_DetailNormalMapBlue_var, _DetailNormalMapBlue, _MainTex);
        _DetailNormalMapBlue_var.xyz = UnpackScaleNormal(_DetailNormalMapBlue_var, _DetailNormalMapScaleBlue);
        blendedNormal = lerp(blendedNormal, BlendNormals(blendedNormal, _DetailNormalMapBlue_var.xyz), _DetailMask_var.b);
    }
    float3x3 tangentToWorld = float3x3(i.tangentWorld, i.bitangentWorld, i.normalWorld);
    fixed3 normalDir = normalize(mul(blendedNormal, tangentToWorld));

    // Early translucency sample because indirect diffuse can be modulated by it
    fixed translucency = 0;
    UNITY_BRANCH
    if (group_toggle_SSSTransmission)
    {
        fixed4 _TranslucencyMap_var = 0;
        //KSOInlineSamplerState(_MainTex, _TranslucencyMap)
        PBR_SAMPLE_TEX2DS(_TranslucencyMap_var, _TranslucencyMap, _MainTex);
        translucency = _SSSTranslucencyMin + _TranslucencyMap_var.r * (_SSSTranslucencyMax - _SSSTranslucencyMin);
    }

    // Common vars
    float2 lightmapUV = i.uv1 * unity_LightmapST.xy + unity_LightmapST.zw;
    float2 dynamicLightmapUV = i.uv2and3.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
    fixed3 lightDir = getLightDirection(i.posWorld.xyz, lightmapUV); 
    #ifdef UNITY_PASS_FORWARDBASE
        if (_FakeLightToggle)
            lightDir = _FakeLightDirection.xyz;
    #endif
    //float3 lightColor = getLightColor();
    fixed3 viewReflectDir = reflect(-viewDir, normalDir);
    float3 halfDir = Unity_SafeNormalize (lightDir + viewDir); // BRDF friendly normalize
    fixed3 lightReflectDir = reflect(lightDir, normalDir);
    float NdotL = saturate(dot(normalDir, lightDir));
    half NdotV = abs(dot(normalDir, viewDir)); // abs to get backside rimlight?
    float NdotH = saturate(dot(normalDir, halfDir));
    half LdotV = saturate(dot(lightDir, viewDir));
    half LdotH = saturate(dot(lightDir, halfDir));
    float TdotH = dot(i.tangentWorld, halfDir);
    float BdotH = dot(i.bitangentWorld, halfDir);
    float TdotV = dot(i.tangentWorld, viewDir);
    float BdotV = dot(i.bitangentWorld, viewDir);
    float TdotL = dot(i.tangentWorld, lightDir);
    float BdotL = dot(i.bitangentWorld, lightDir);
    fixed RVdotL = max(0, dot(viewReflectDir, lightDir));
    half smoothness = 1.0f - perceptualRoughness;
    float roughness = max(PerceptualRoughnessToRoughness(perceptualRoughness), 0.002);
    half3 specColor;
    half oneMinusReflectivity;
    if (_WorkflowMode == 0) // Metallic workflow
    {
        specColor = lerp (unity_ColorSpaceDielectricSpec.rgb, albedo, metallic) * specularScale;
        oneMinusReflectivity = unity_ColorSpaceDielectricSpec.a - metallic * unity_ColorSpaceDielectricSpec.a;
    }
    else // Specular workflow
    {
        specColor = specularScale;
        oneMinusReflectivity = 1 - SpecularStrength(specColor);
    }


    // GI
    // Shadows
    LIGHT_ATTENUATION_NO_SHADOW_MUL(attenuation, i, i.posWorld.xyz);
    fixed attenuation_noshadows = attenuation;
    shadow = lerp(1, shadow, _ReceiveShadows);
    shadow = lerp(shadow, smoothstep(0,1,shadow), _ShadowsSmooth);
    shadow = lerp(shadow, round(shadow), _ShadowsSharp);
    attenuation *= shadow;

    // Base pass lightmapping and indirect, adapted from UnityGI_Base
    half3 indirect_diffuse = 0;
    half3 lightColor = _LightColor0.rgb;
    #ifdef UNITY_PASS_FORWARDBASE
        #if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
            half bakedAtten = UnitySampleBakedOcclusion(lightmapUV, i.posWorld.xyz);
            float zDist = dot(_WorldSpaceCameraPos - posWorld, UNITY_MATRIX_V[2].xyz);
            float fadeDist = UnityComputeShadowFadeDistance(posWorld, zDist);
            attenuation = UnityMixRealtimeAndBakedShadows(attenuation, bakedAtten, UnityComputeShadowFade(fadeDist));
        #endif
        #if UNITY_SHOULD_SAMPLE_SH
            half3 indirect_diffuse_normal = normalDir;
            if (_DiffuseMode == 3) // Flat lit light, vertex lights are sampled with regular normal
                indirect_diffuse_normal = 0;
            indirect_diffuse = VertexLightsDiffuse(normalDir, i.posWorld.xyz) * _VertexLightIntensity;
            indirect_diffuse += ShadeSHPerPixelModular(indirect_diffuse_normal, i.posWorld.xyz) * _LightProbeIntensity;
            // Stylized indirect diffuse transmission
            if (group_toggle_SSSTransmission && _SSSStylizedIndirect > 0)
            {
                half3 stylized_transmission_normal = UnityObjectToWorldNormal(i.posObject.xyz); // probably needs to be normalized
                half3 stylized_indirect_diffuse_transmission = VertexLightsDiffuse(stylized_transmission_normal, i.posWorld.xyz) * _VertexLightIntensity;
                stylized_indirect_diffuse_transmission += ShadeSHPerPixelModular(stylized_transmission_normal, i.posWorld.xyz) * _LightProbeIntensity;
                indirect_diffuse = lerp(indirect_diffuse, stylized_indirect_diffuse_transmission, 
                                    _SSSStylizedIndirect * (_SSSStylizedIndrectScaleByTranslucency ? translucency : 1));
            }
            #ifdef UNITY_COLORSPACE_GAMMA
                indirect_diffuse = LinearToGammaSpace(indirect_diffuse);
            #endif
        #endif
        #ifdef LIGHTMAP_ON
            half3 bakedColor = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, lightmapUV));
            #ifdef DIRLIGHTMAP_COMBINED
                fixed4 bakedDirTex = UNITY_SAMPLE_TEX2D_SAMPLER (unity_LightmapInd, unity_Lightmap, lightmapUV);
                indirect_diffuse += DecodeDirectionalLightmap (bakedColor, bakedDirTex, normalDir) * _LightmapIntensity;

                #if defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN)
                    lightColor = 0;
                    indirect_diffuse = SubtractMainLightWithRealtimeAttenuationFromLightmap (indirect_diffuse, attenuation, bakedColorTex, normalDir);
                #endif

            #else // not directional lightmap
                indirect_diffuse += bakedColor * _LightmapIntensity;

                #if defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN)
                    lightColor = 0;
                    indirect_diffuse = SubtractMainLightWithRealtimeAttenuationFromLightmap(indirect_diffuse, attenuation, bakedColorTex, normalDir);
                #endif

            #endif
        #endif
        #ifdef DYNAMICLIGHTMAP_ON
            // Dynamic lightmaps
            half3 realtimeColor = DecodeRealtimeLightmap (UNITY_SAMPLE_TEX2D(unity_DynamicLightmap, dynamicLightmapUV));

            #ifdef DIRLIGHTMAP_COMBINED
                indirect_diffuse += DecodeDirectionalLightmap (
                    realtimeColor, 
                    UNITY_SAMPLE_TEX2D_SAMPLER(unity_DynamicDirectionality, unity_DynamicLightmap, dynamicLightmapUV), 
                    normalDir) * _RealtimeLightmapIntensity;
            #else
                indirect_diffuse += realtimeColor * _RealtimeLightmapIntensity;
            #endif
        #endif
    #endif
    indirect_diffuse *= occlusion * _IndirectLightIntensity;

    // Fake directional light
    #ifdef UNITY_PASS_FORWARDBASE
        if (_FakeLightToggle)
        {
            lightColor = _FakeLightColor.rgb;
            lightColor *= _FakeLightIntensity;
        }
    #endif

    // Direct light intensity scaling
    #ifdef DIRECTIONAL
        lightColor *= _DirectionalLightIntensity;
    #endif
    #ifdef POINT
        lightColor *= _PointLightIntensity;
    #endif
    #ifdef SPOT
        lightColor *= _SpotLightIntensity;
    #endif
    lightColor *= _DirectLightIntensity;
    half3 lightColorNoAttenuation = lightColor;
    half3 lightColorAttenuationNoShadows = lightColor * attenuation_noshadows;
    lightColor *= attenuation;
    half3 direct_diffuse_occlusion = lerp(1, occlusion, _OcclusionDirectDiffuse);

    // Indirect specular (reflections) GI
    half3 indirect_specular = 0;
    #ifdef UNITY_PASS_FORWARDBASE
        UNITY_BRANCH
        if (_GlossyReflections)
        {
            half3 reflectionsSampleViewReflectDir = viewReflectDir;
            UNITY_BRANCH
            if (_ReflectionsMode == 3) // Anisotropic reflections indirect specular
                reflectionsSampleViewReflectDir = AngledAnisotropicModifiedNormal(normalDir, i.tangentWorld, i.bitangentWorld, viewDir, _ReflectionsAnisotropyAngle, _ReflectionsAnisotropy);

            UNITY_BRANCH
            if (_CubeMapMode == 0) // cubemap off
                indirect_specular = UnityGI_IndirectSpecularModular(reflectionsSampleViewReflectDir, i.posWorld.xyz, perceptualRoughness);
            else if (_CubeMapMode == 1) // fallback only
            {
                float testW=0; float testH=0;
                unity_SpecCube0.GetDimensions(testW,testH); // Thanks AciiL
                if (testW<16)
                    indirect_specular = Unity_GlossyEnvironmentModular(UNITY_PASS_TEXCUBE(_CubeMap), _CubeMap_HDR, perceptualRoughness, reflectionsSampleViewReflectDir);
                else indirect_specular = UnityGI_IndirectSpecularModular(reflectionsSampleViewReflectDir, i.posWorld.xyz, perceptualRoughness);
            }
            else indirect_specular = Unity_GlossyEnvironmentModular(UNITY_PASS_TEXCUBE(_CubeMap), _CubeMap_HDR, perceptualRoughness, reflectionsSampleViewReflectDir);
        }
        else indirect_specular = unity_IndirectSpecColor.rgb;
        indirect_specular *= occlusion * _ReflectionsIntensity;
    #endif


    // Pre-Integrated skin variables
    fixed3 blurredWorldNormal = 0;
    fixed Curvature = 0;
    UNITY_BRANCH
    if (_DiffuseMode == 2)
    {
        // Blur main normal map via tex2Dbias
        fixed4 blurredWorldNormal_var = 0;
        //KSOInlineSamplerState(_MainTex, _BumpMap)
        PBR_SAMPLE_TEX2DS_BIAS(blurredWorldNormal_var, _BumpMap, _MainTex, _BumpBlurBias);
        blurredWorldNormal = UnpackScaleNormal(blurredWorldNormal_var, _BumpScale);
        // Lerp blurred normal against combined normal by blur strength
        blurredWorldNormal = lerp(blendedNormal, blurredWorldNormal, _BlurStrength);
        blurredWorldNormal = normalize(mul(blurredWorldNormal, tangentToWorld));

        // use fwidth to get surface curvature via world normal and world position
        UNITY_BRANCH
        if (_CurvatureInfluence > 0)
        {
            float deltaWorldNormal = length( fwidth( blurredWorldNormal ) );
			float deltaWorldPosition = length( max(1e-5f, fwidth ( i.posWorld.xyz ) ) );
            deltaWorldPosition = (deltaWorldPosition == 0.0) ? 1e-5f : deltaWorldPosition;
            Curvature = (deltaWorldNormal / deltaWorldPosition) * _CurvatureScale;
            Curvature *= _CurvatureInfluence;
        }
        Curvature = saturate(Curvature + _CurvatureBias);
    }
    // Set skin specular value (0.028)
    // Skin specular isn't so much a separate mode as it is a preset for Specular workflow and a spec color
    // Technically does affect diffuse too
    if (_SpecularMode == 3)
    {
        specColor = unity_ColorSpaceDielectricSpec.rgb * 0.7;
        oneMinusReflectivity = 1 - SpecularStrength(specColor);
    }

    // Final BRDF setup
    half3 diffColor = albedo * oneMinusReflectivity;
    // Premultiplied transparency
    UNITY_BRANCH
    if (_Mode == 3) // _ALPHAPREMULTIPLY_ON
    {
        diffColor *= opacity;
        opacity = 1-oneMinusReflectivity + opacity*oneMinusReflectivity;
    }

    //BRDF (apdapted from Unity Standard BRDF1)
    half4 color = 0;
    color.a = opacity;

    // Diffuse
    UNITY_BRANCH
    if (group_toggle_Diffuse)
    {
        UNITY_BRANCH
        if (_DiffuseMode == 0) // Lambert
        {
            // simplify math
            UNITY_BRANCH
            if (_DiffuseWrap > 0)
            {
                half wrappedDiffuse = 0;
                if (_DiffuseWrapConserveEnergy)
                    wrappedDiffuse = saturate((dot(lightDir, normalDir) + _DiffuseWrap) / ((1 + _DiffuseWrap) * (1 + _DiffuseWrap)));
                else
                    wrappedDiffuse = saturate((dot(lightDir, normalDir) + _DiffuseWrap) / ((1 + _DiffuseWrap)));
                color.rgb += diffColor * (indirect_diffuse + lightColorAttenuationNoShadows * wrappedDiffuse * direct_diffuse_occlusion); // ignore received shadows completely?
            }
            else color.rgb += diffColor * (indirect_diffuse + lightColor * NdotL);
        }
        else if (_DiffuseMode == 1) // PBR
        {
            half3 diffuseTerm = DisneyDiffuse(NdotV, NdotL, LdotH, perceptualRoughness) * NdotL;
            color.rgb += diffColor * (indirect_diffuse + lightColor * diffuseTerm * direct_diffuse_occlusion);
        }
        else if (_DiffuseMode == 2) // Skin
        {
            float NdotLBlurredUnclamped = dot(blurredWorldNormal, lightDir);
            NdotLBlurredUnclamped = NdotLBlurredUnclamped * 0.5 + 0.5;
            // Pre integrated skin lookup tex serves as the BRDF diffuse term
            //KSOInlineSamplerState(_trilinear_clamp, _PreIntSkinTex)
            half3 brdf = UNITY_SAMPLE_TEX2D_SAMPLER_LOD(_PreIntSkinTex, _trilinear_clamp, half2(NdotLBlurredUnclamped, Curvature), 0);
            color.rgb += diffColor * (indirect_diffuse + lightColor * brdf * direct_diffuse_occlusion);
        }
        else if (_DiffuseMode == 3) // Flat Lit
        {
            color.rgb += diffColor * min(half3(1,1,1), indirect_diffuse + lightColor * direct_diffuse_occlusion); // wonky solution so light dosn't go HDR
        }
    }
    else color.rgb = albedo; // Unlit

    // Direct Specular
    UNITY_BRANCH
    if (group_toggle_Specular)
    {
        UNITY_BRANCH
        if (_SpecularMode == 0) // Phong
        {
            half power = _PhongSpecularPower;
            if (_PhongSpecularUseRoughness)
                power = PerceptualRoughnessToSpecPower(roughness);
            half specularTerm = pow(RVdotL, power);
            specularTerm = lerp(specularTerm, specularTerm * occlusion, _OcclusionDirectSpecular);
            color.rgb += specularTerm * _PhongSpecularIntensity * lightColor * specularScale;
        }
        else if (_SpecularMode == 1 || _SpecularMode == 2 || _SpecularMode == 3) // PBR, Anisotropic, and Skin
        {
            float V = 0;
            float D = 0;

            UNITY_BRANCH
            if (_SpecularMode == 2)
            {
                // Two roughness params from a single anisotropy parameter
                // Would be better to have full independent roughness control in the future
                float roughnessT = roughness;
                float roughnessB = lerp(0.002, roughness, 1-_SpecularAnisotropy);
                
                // Use tangent map if it exists
                UNITY_BRANCH
                if (_SpecularAnisotropyTangentMap_TexelSize.x != 1)
                {
                    fixed4 _SpecularAnisotropyTangentMap_var = 1;
                    ////KSOInlineSamplerState(_MainTex, _SpecularAnisotropyTangentMap)
                    PBR_SAMPLE_TEX2DS(_SpecularAnisotropyTangentMap_var, _SpecularAnisotropyTangentMap, _MainTex);
                    _SpecularAnisotropyTangentMap_var.xyz = UnpackNormal(_SpecularAnisotropyTangentMap_var);
                    // blend with unmultiplied tangent space normal (from normal map?)
                    // perturb tangent then recalculate bitangent?
                    // rotate tanget and bitangent
                    // tangentDirectionMap = mul(tangentToWorld, float3(normalLocalAniso.rg, 0.0)).xyz; ?
                }

                // Rotate tangent/bitangent via the tangentToWorld matrix
                half theta = radians((_SpecularAnisotropyAngle * 2 - 1) * 90);
                half3 rotatedTangent = half3(cos(theta), sin(theta), 0);
                rotatedTangent = normalize(mul(rotatedTangent, tangentToWorld));
                half3 rotatedBitangent = normalize(cross(i.normalWorld, rotatedTangent));
                // Overwriting these dot products because they're not used anywhere else atm
                TdotH = dot(rotatedTangent, halfDir);
                BdotH = dot(rotatedBitangent, halfDir);
                TdotV = dot(rotatedTangent, viewDir);
                BdotV = dot(rotatedBitangent, viewDir);
                TdotL = dot(rotatedTangent, lightDir);
                BdotL = dot(rotatedBitangent, lightDir);
                V = SmithJointGGXAniso(TdotV, BdotV, NdotV, TdotL, BdotL, NdotL, roughnessT, roughnessB);
                D = GGXTerm_Aniso(TdotH, BdotH, roughnessT, roughnessB, NdotH);
            }
            else
            {
                V = SmithJointGGXVisibilityTerm (NdotL, NdotV, roughness);
                D = GGXTerm (NdotH, roughness);
            }

            half3 specularTerm = V*D * UNITY_PI; // Torrance-Sparrow model, Fresnel is applied later
            #ifdef UNITY_COLORSPACE_GAMMA
                specularTerm = sqrt(max(1e-4h, specularTerm));
            #endif
            specularTerm = max(0, specularTerm * NdotL);
            specularTerm = lerp(specularTerm, specularTerm * occlusion, _OcclusionDirectSpecular);
            color.rgb += specularTerm * lightColor * FresnelTerm (specColor, LdotH);
        }
    }

    // Reflections (Indirect Specular)
#ifdef UNITY_PASS_FORWARDBASE
    UNITY_BRANCH
    if (group_toggle_Reflections)
    {
        UNITY_BRANCH
        if (_ReflectionsMode == 1 || _ReflectionsMode == 3) // PBR
        {
            half surfaceReduction;
            #ifdef UNITY_COLORSPACE_GAMMA
                surfaceReduction = 1.0-0.28*roughness*perceptualRoughness;      // 1-0.28*x^3 as approximation for (1/(x^4+1))^(1/2.2) on the domain [0;1]
            #else
                surfaceReduction = 1.0 / (roughness*roughness + 1.0);           // fade \in [0.5;1]
            #endif
            half grazingTerm = saturate(smoothness + (1-oneMinusReflectivity));
            color.rgb += surfaceReduction * indirect_specular * FresnelLerp (specColor, grazingTerm, NdotV) * _StandardFresnelIntensity;
        }
        else if (_ReflectionsMode == 2) // Skin aka Lazarov environmental
        {
            const half4 c0 = { -1, -0.0275, -0.572, 0.022 };
            const half4 c1 = { 1, 0.0425, 1.04, -0.04 };
            half4 r = perceptualRoughness * c0 + c1;
            half a004 = min( r.x * r.x, exp2( -9.28 * NdotV ) ) * r.x + r.y;
            half2 AB = half2( -1.04, 1.04 ) * a004 + r.zw;
            half3 F_L = specColor * AB.x + AB.y;
            color.rgb += indirect_specular * F_L;
        }
    }
#endif

    // Subsurface Transmission
    // Needs energy conservation
    UNITY_BRANCH
    if (group_toggle_SSSTransmission)
    {
        half3 transmissionLightColor = _SSSTransmissionIgnoreShadowAttenuation ? lightColorAttenuationNoShadows : lightColor;
        half3 transLightDir = lightDir + blurredWorldNormal * _SSSTransmissionDistortion;
        half transDot = dot( -transLightDir, viewDir );
        transDot = exp2(saturate(transDot) * _SSSTransmissionPower - _SSSTransmissionPower)
                * translucency * _SSSTransmissionScale;
        UNITY_BRANCH
        if (_SSSTransmissionShadowCastingLightsOnly)
        {
            #if defined(SHADOWS_DEPTH) || defined(SHADOWS_SCREEN) || defined(SHADOWS_CUBE)
                color.rgb += transDot * _SubsurfaceColor * transmissionLightColor;
            #endif
        }
        else color.rgb += transDot * _SubsurfaceColor * transmissionLightColor;
    }

    if (!_HDREnabled)
        color.rgb = saturate(color.rgb);

    // Emission
    #ifdef UNITY_PASS_FORWARDBASE
        fixed4 _EmissionMap_var = 1;
        if (_EmissionMap_TexelSize.x != 1)
            //KSOInlineSamplerState(_MainTex, _EmissionMap)
            PBR_SAMPLE_TEX2DS(_EmissionMap_var, _EmissionMap, _MainTex);
        color.rgb += _EmissionColor.rgb * lerp(_EmissionMap_var.rgb, albedo.rgb * _EmissionMap_var.rgb, _EmissionTintByAlbedo);
    #endif

    if (_ReceiveFog > 0)
    {
        half4 foggedColor = color;
        UNITY_APPLY_FOG(i.fogCoord, foggedColor);
        color = lerp(color, foggedColor, _ReceiveFog);
    }

    // Debug
    if (_DebugWorldNormals)
        color.rgb = normalDir;
    if (_DebugOcclusion)
        color.rgb = occlusion;

	return color;
}

// Full shadowcaster with cutout support
struct v2f_shadow_full
{
    V2F_SHADOW_CASTER;
    float4 uv : TEXCOORD0;
    float4 uv1 : TEXCOORD1;
    float4 uv2and3 : TEXCOORD2;
    float4 color : TEXCOORD3;
    float4 posWorld : TEXCOORD4;
    float4 posObject : TEXCOORD5;
    float3 normalObject : TEXCOORD6;
	float3 normalWorld : TEXCOORD7;
    float4 grabPos: TEXCOORD8;
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};
v2f_shadow_full vert_shadow_full (appdata_full v)
{
    v2f_shadow_full o;
    o.uv = v.texcoord;
    o.uv1 = v.texcoord1;
    o.uv2and3.xy = v.texcoord2;
    o.uv2and3.zw = v.texcoord3;
    o.color = v.color;
    o.posWorld = mul(unity_ObjectToWorld, v.vertex);
    o.posObject = v.vertex;
	o.normalWorld = normalize(UnityObjectToWorldNormal(v.normal));
    o.normalObject = v.normal;
    TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
    o.grabPos = ComputeGrabScreenPos(o.pos);
    return o;
}
// Separate vpos struct for frag input instead of V2F_SHADOW_CASTER because you can't have both SV_Position and VPOS
struct v2f_shadow_full_vpos
{
    V2F_SHADOW_CASTER_NOPOS
    UNITY_VPOS_TYPE vpos : VPOS;
    float4 uv : TEXCOORD0;
    float4 uv1 : TEXCOORD1;
    float4 uv2and3 : TEXCOORD2;
    float4 color : TEXCOORD3;
    float4 posWorld : TEXCOORD4;
    float4 posObject : TEXCOORD5;
    float3 normalObject : TEXCOORD6;
	float3 normalWorld : TEXCOORD7;
    float4 grabPos: TEXCOORD8;
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};
fixed4 frag_shadow_full (v2f_shadow_full_vpos i) : SV_Target
{
    // This subshader override tag doesn't work, so hard coding it here.
    // Use the shader optimizer to make the override tag work & skip shadowcasting calls entirely
    UNITY_BRANCH
    if (_ForceNoShadowCasting) discard;

    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_APPLY_DITHER_CROSSFADE(i.vpos.xy);

    UNITY_BRANCH
    if (_Mode >= 1 && _Mode <= 3) // _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
    {
        // Triplanar UVs
        // Object Space
        float3 tpObjBlendFactor = normalize(abs(i.normalObject));
        tpObjBlendFactor /= dot(tpObjBlendFactor, (float3)1);
        float2 tpObjX = 0;
        float2 tpObjY = 0;
        float2 tpObjZ = 0;
        if (_TriplanarUseVertexColors)
        {
            tpObjX = i.color.yz;
            tpObjY = i.color.zx;
            tpObjZ = i.color.xy;
        }
        else
        {
            tpObjX = i.posObject.yz;
            tpObjY = i.posObject.zx;
            tpObjZ = i.posObject.xy;
        }

        // World Space
        float3 tpWorldBlendFactor = normalize(abs(i.normalWorld));
        tpWorldBlendFactor /= dot(tpWorldBlendFactor, (float3)1);
        float2 tpWorldX = i.posWorld.yz;
        float2 tpWorldY = i.posWorld.zx;
        float2 tpWorldZ = i.posWorld.xy;

        // Panosphere UVs
        float2 panoUV = PanosphereProjection(i.posWorld, _WorldSpaceCameraPos.xyz);

        // Base Opacity
        fixed opacity = 1;
        UNITY_BRANCH
        if (_CoverageMap_TexelSize.x != 1)
        {
            fixed4 _CoverageMap_var = 0;
            //KSOInlineSamplerState(_MainTex, _CoverageMap)
            PBR_SAMPLE_TEX2DS(_CoverageMap_var, _CoverageMap, _MainTex);
            opacity = _CoverageMap_var.r;
        }
        else if (_AlbedoTransparencyEnabled && _MainTex_TexelSize.x != 1)
        {
            fixed4 _MainTex_var = 1;
            PBR_SAMPLE_TEX2DS(_MainTex_var, _MainTex, _MainTex);
            opacity = _MainTex_var.a;
        }
        
        opacity *= _Color.a;
        if (_VertexColorsEnabled)
            opacity *= i.color.a;

        // Dithered shadows
        UNITY_BRANCH
        if (_DitheredShadows && _Mode >= 2 && _Mode <= 3)
            clip(tex3D(_DitherMaskLOD, float3(i.vpos.xy * 0.25, opacity * 0.9375)).a - 0.01);

        // Cutoff clipping
        clip(opacity - _Cutoff);
    }

    SHADOW_CASTER_FRAGMENT(i)
}

// Full meta pass
struct v2f_meta_full
{
    float4 pos : SV_POSITION;
	float4 uv : TEXCOORD0;
    float4 uv1 : TEXCOORD1;
    float4 uv2and3 : TEXCOORD2;
    float4 color : TEXCOORD3;
    float4 posWorld : TEXCOORD4;
    float4 posObject : TEXCOORD5;
    float3 normalObject : TEXCOORD6;
	float3 normalWorld : TEXCOORD7;
    float4 grabPos: TEXCOORD8;
#ifdef EDITOR_VISUALIZATION
    float2 vizUV        : TEXCOORD9;
    float4 lightCoord   : TEXCOORD10;
#endif
};
v2f_meta_full vert_meta_full(appdata_full v)
{
    v2f_meta_full o;
    o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);
    o.uv = v.texcoord;
    o.uv1 = v.texcoord1;
    o.uv2and3.xy = v.texcoord2;
    o.uv2and3.zw = v.texcoord3;
    o.color = v.color;
    o.posWorld = mul(unity_ObjectToWorld, v.vertex);
    o.posObject = v.vertex;
	o.normalWorld = normalize(UnityObjectToWorldNormal(v.normal));
    o.normalObject = v.normal;
    o.grabPos = ComputeGrabScreenPos(o.pos);
#ifdef EDITOR_VISUALIZATION
    o.vizUV = 0;
    o.lightCoord = 0;
    if (unity_VisualizationMode == EDITORVIZ_TEXTURE)
        o.vizUV = UnityMetaVizUV(unity_EditorViz_UVIndex, v.texcoord.xy, v.texcoord1.xy, v.texcoord2.xy, unity_EditorViz_Texture_ST);
    else if (unity_VisualizationMode == EDITORVIZ_SHOWLIGHTMASK)
    {
        o.vizUV = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
        o.lightCoord = mul(unity_EditorViz_WorldToLight, mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)));
    }
#endif
    return o;
}
float4 frag_meta_full (v2f_meta_full i) : SV_Target
{
    // Triplanar UVs
    // Object Space
    float3 tpObjBlendFactor = normalize(abs(i.normalObject));
    tpObjBlendFactor /= dot(tpObjBlendFactor, (float3)1);
    float2 tpObjX = 0;
    float2 tpObjY = 0;
    float2 tpObjZ = 0;
    if (_TriplanarUseVertexColors)
    {
        tpObjX = i.color.yz;
        tpObjY = i.color.zx;
        tpObjZ = i.color.xy;
    }
    else
    {
        tpObjX = i.posObject.yz;
        tpObjY = i.posObject.zx;
        tpObjZ = i.posObject.xy;
    }

    // World Space
    float3 tpWorldBlendFactor = normalize(abs(i.normalWorld));
    tpWorldBlendFactor /= dot(tpWorldBlendFactor, (float3)1);
    float2 tpWorldX = i.posWorld.yz;
    float2 tpWorldY = i.posWorld.zx;
    float2 tpWorldZ = i.posWorld.xy;

    // Panosphere UVs
    float2 panoUV = PanosphereProjection(i.posWorld, _WorldSpaceCameraPos.xyz);

    fixed4 _MainTex_var = 1;
    if (_MainTex_TexelSize.x != 1)
        PBR_SAMPLE_TEX2DS(_MainTex_var, _MainTex, _MainTex);


    UNITY_BRANCH
    if (_Mode == 1) // _ALPHATEST_ON
    {
        fixed opacity = 1;
        if (_AlbedoTransparencyEnabled)
            opacity = _MainTex_var.a;
        UNITY_BRANCH
        if (_CoverageMap_TexelSize.x != 1)
        {
            fixed4 _CoverageMap_var = 0;
            //KSOInlineSamplerState(_MainTex, _CoverageMap)
            PBR_SAMPLE_TEX2DS(_CoverageMap_var, _CoverageMap, _MainTex);
            opacity = _CoverageMap_var.r;
        }
        opacity *= _Color.a;
        if (_VertexColorsEnabled)
            opacity *= i.color.a;
        clip(opacity - _Cutoff);
    }

    fixed4 _EmissionMap_var = 1;
    if (_EmissionMap_TexelSize.x != 1)
        //KSOInlineSamplerState(_MainTex, _EmissionMap)
        PBR_SAMPLE_TEX2DS(_EmissionMap_var, _EmissionMap, _MainTex);

    UnityMetaInput o;
    UNITY_INITIALIZE_OUTPUT(UnityMetaInput, o);
    o.Albedo = _MainTex_var.rgb * _Color.rgb;
    if (_VertexColorsEnabled)
        o.Albedo *= i.color.rgb;
#ifdef EDITOR_VISUALIZATION
    o.VizUV = i.vizUV;
    o.LightCoord = i.lightCoord;
#endif
    o.Emission = _EmissionColor.rgb * lerp(_EmissionMap_var.rgb, o.Albedo.rgb * _EmissionMap_var.rgb, _EmissionTintByAlbedo);
    return UnityMetaFragment(o);
}


#endif