// KajCore.cginc
// Giant colllection of reusable shader code meant to coexist without conflict in a single file
// Meant to power all possible Unity shader functionality
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
uniform float _StandardFresnelIntensity;                // Standard BRDF fresnel control
UNITY_DECLARE_TEX2D(_SkyrimSkinTex);                    // Skyrim SSS map
uniform float _SkyrimLightingEffectOne;                 // Skyrim generic shader property - varies with shaders
uniform float _SkyrimLightingEffectTwo;                 // Skyrim generic shader property - varies with shaders
uniform float _GlossinessMode;                          // Roughnes s/Smoothness toggle
UNITY_DECLARE_TEX2D_NOSAMPLER(_CoverageMap);            // Dedicated alpha channel texture
    uniform float4 _CoverageMap_ST;
    uniform float4 _CoverageMap_TexelSize;
    uniform float _CoverageMapUV;
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
uniform float _WorkflowMode;                            // Metallic or Specular Toggle
uniform float4 _DetailColorR;                           // Detail mask coloring
uniform float4 _DetailColorG;                           // Detail mask coloring
uniform float4 _DetailColorB;                           // Detail mask coloring
uniform float4 _DetailColorA;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailAlbedoMapGreen);   // 2nd detail map
    uniform float4 _DetailAlbedoMapGreen_ST;
    uniform float4 _DetailAlbedoMapGreen_TexelSize;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailAlbedoMapBlue);    // 3rd detail map
    uniform float4 _DetailAlbedoMapBlue_ST;
    uniform float4 _DetailAlbedoMapBlue_TexelSize;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailAlbedoMapAlpha);
    uniform float4 _DetailAlbedoMapAlpha_ST;
    uniform float4 _DetailAlbedoMapAlpha_TexelSize;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailNormalMapGreen);   // 2nd detail normal map
    uniform float4 _DetailNormalMapGreen_ST;
    uniform float4 _DetailNormalMapGreen_TexelSize;
    uniform float _DetailNormalMapScaleGreen;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailNormalMapBlue);    // 3rd detail normal map
    uniform float4 _DetailNormalMapBlue_ST;
    uniform float4 _DetailNormalMapBlue_TexelSize;
    uniform float _DetailNormalMapScaleBlue;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailNormalMapAlpha);
    uniform float4 _DetailNormalMapAlpha_ST;
    uniform float4 _DetailNormalMapAlpha_TexelSize;
    uniform float _DetailNormalMapScaleAlpha;
uniform float _MainTexUV;                               // Main texture UV selector
uniform float _Version;                                 // Kaj Shader version
uniform float _BlendOpAlpha;                            // Blend op parameter for alpha
uniform float _SrcBlendAlpha;                           // Blend ops for alpha
uniform float _DstBlendAlpha;                           // Blend ops for alpha
uniform float group_toggle_Parallax;                    // new Parallax toggle
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
uniform float _ReflectionsAnisotropy;
uniform float _ReflectionsAnisotropyAngle;
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
uniform float group_toggle_Clearcoat;
UNITY_DECLARE_TEX2D_NOSAMPLER(_ClearcoatMask);
    uniform float4 _ClearcoatMask_ST;
    uniform float4 _ClearcoatMask_TexelSize;
    uniform float _ClearcoatMaskUV;
uniform float _ClearcoatMaskMax;
uniform float _ClearcoatMaskMin;
uniform float _ClearcoatRefract;
uniform float _ClearcoatFresnelInfluence;
uniform float _ClearcoatRoughnessInfluence;
uniform float _RealtimeGIIntensity;
uniform float _CoverageMapChannel;
uniform float _EmissionMapChannel;
uniform float _MetallicGlossMapChannel;
uniform float _SpecGlossMapChannel;
uniform float _OcclusionMapChannel;
uniform float _SpecularMapChannel;
uniform float _ClearcoatMaskChannel;
uniform float _ParallaxMapChannel;
uniform float _TranslucencyMapChannel;
uniform float _TesselationEdgeFactor;
uniform float _TesselationInsideFactor;
uniform float _DebugWireframe;
uniform float _FlippedNormalBackfaces;
uniform float group_toggle_Geometry;
uniform float group_toggle_GeometryForwardBase;
uniform float group_toggle_GeometryForwardAdd;
uniform float group_toggle_GeometryShadowCaster;
uniform float group_toggle_GeometryMeta;
uniform float group_toggle_Tesselation;
uniform float group_toggle_TesselationForwardBase;
uniform float group_toggle_TesselationForwardAdd;
uniform float group_toggle_TesselationShadowCaster;
uniform float group_toggle_TesselationMeta;

// Easier to read preprocessor variables corresponding to the safe-to-use shader_feature keywords
#ifdef _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
    #ifndef PROP_COVERAGEMAP
        #define PROP_COVERAGEMAP
    #endif
#endif
#ifdef _NORMALMAP
    #ifndef PROP_BUMPMAP
        #define PROP_BUMPMAP
    #endif
#endif
#ifdef _EMISSION
    #ifndef PROP_EMISSIONMAP
        #define PROP_EMISSIONMAP
    #endif
#endif
#ifdef _METALLICGLOSSMAP
    #ifndef PROP_METALLICGLOSSMAP
        #define PROP_METALLICGLOSSMAP
    #endif
#endif
#ifdef _GLOSSYREFLECTIONS_OFF
    #ifndef PROP_SPECGLOSSMAP
        #define PROP_SPECGLOSSMAP
    #endif
#endif
#ifdef _REQUIRE_UV2
    #ifndef PROP_OCCLUSIONMAP
        #define PROP_OCCLUSIONMAP
    #endif
#endif
#ifdef _SPECGLOSSMAP
    #ifndef PROP_SPECULARMAP
        #define PROP_SPECULARMAP
    #endif
#endif
#ifdef _COLORCOLOR_ON
    #ifndef PROP_CLEARCOATMASK
        #define PROP_CLEARCOATMASK
    #endif
#endif
#ifdef _PARALLAXMAP
    #ifndef PROP_PARALLAXMAP
        #define PROP_PARALLAXMAP
    #endif
#endif
#ifdef _FADING_ON
    #ifndef PROP_TRANSLUCENCYMAP
        #define PROP_TRANSLUCENCYMAP
    #endif
#endif
#ifdef GEOM_TYPE_BRANCH_DETAIL
    #ifndef PROP_DETAILMASK
        #define PROP_DETAILMASK
    #endif
#endif
#ifdef _ALPHABLEND_ON
    #ifndef PROP_DETAILALBEDOMAP
        #define PROP_DETAILALBEDOMAP
    #endif
#endif
#ifdef _ALPHAMODULATE_ON
    #ifndef PROP_DETAILALBEDOMAPGREEN
        #define PROP_DETAILALBEDOMAPGREEN
    #endif
#endif
#ifdef _ALPHAPREMULTIPLY_ON
    #ifndef PROP_DETAILALBEDOMAPBLUE
        #define PROP_DETAILALBEDOMAPBLUE
    #endif
#endif
#ifdef _ALPHATEST_ON
    #ifndef PROP_DETAILALBEDOMAPALPHA
        #define PROP_DETAILALBEDOMAPALPHA
    #endif
#endif
#ifdef GEOM_TYPE_BRANCH
    #ifndef PROP_DETAILNORMALMAP
        #define PROP_DETAILNORMALMAP
    #endif
#endif
#ifdef GEOM_TYPE_FROND
    #ifndef PROP_DETAILNORMALMAPGREEN
        #define PROP_DETAILNORMALMAPGREEN
    #endif
#endif
#ifdef GEOM_TYPE_LEAF
    #ifndef PROP_DETAILNORMALMAPBLUE
        #define PROP_DETAILNORMALMAPBLUE
    #endif
#endif
#ifdef GEOM_TYPE_MESH
    #ifndef PROP_DETAILNORMALMAPALPHA
        #define PROP_DETAILNORMALMAPALPHA
    #endif
#endif
#ifdef EFFECT_BUMP
    #ifndef PROPGROUP_TOGGLE_PARALLAX
        #define PROPGROUP_TOGGLE_PARALLAX
    #endif
#endif
#ifdef _COLORADDSUBDIFF_ON
    #ifndef PROPGROUP_TOGGLE_DIFFUSE
        #define PROPGROUP_TOGGLE_DIFFUSE
    #endif
#endif
#ifdef _COLOROVERLAY_ON
    #ifndef PROPGROUP_TOGGLE_SPECULAR
        #define PROPGROUP_TOGGLE_SPECULAR
    #endif
#endif
#ifdef _DETAIL_MULX2
    #ifndef PROPGROUP_TOGGLE_CLEARCOAT
        #define PROPGROUP_TOGGLE_CLEARCOAT
    #endif
#endif
#ifdef _MAPPING_6_FRAMES_LAYOUT
    #ifndef PROPGROUP_TOGGLE_REFLECTIONS
        #define PROPGROUP_TOGGLE_REFLECTIONS
    #endif
#endif
#ifdef _SPECULARHIGHLIGHTS_OFF
    #ifndef PROPGROUP_TOGGLE_SSSTRANSMISSION
        #define PROPGROUP_TOGGLE_SSSTRANSMISSION
    #endif
#endif


// Omega Shader culling preprocessor variable definitions + tesselation/geometry disabling variable definitions
// A ton of convolued logic just to cull some appdata and interpolator values.  Probably not worth much
// in the end, but the principle of fine grained subtractive optimization is cool
#ifdef OPTIMIZER_ENABLED

    #if PROPGROUP_TOGGLE_TESSELATION
        #if defined(UNITY_PASS_FORWARDBASE) && PROPGROUP_TOGGLE_TESSELATIONFORWARDBASE == 0
            #define TESSELATION_DISABLED
        #elif defined(UNITY_PASS_FORWARDADD) && PROPGROUP_TOGGLE_TESSELATIONFORWARDADD == 0
            #define TESSELATION_DISABLED
        #elif defined(UNITY_PASS_SHADOWCASTER) && PROPGROUP_TOGGLE_TESSELATIONSHADOWCASTER == 0
            #define TESSELATION_DISABLED
        #elif defined(UNITY_PASS_META) && PROPGROUP_TOGGLE_TESSELATIONMETA == 0
            #define TESSELATION_DISABLED
        #endif
    #else
        #define TESSELATION_DISABLED
    #endif
    #if PROPGROUP_TOGGLE_GEOMETRY
        #if defined(UNITY_PASS_FORWARDBASE) && PROPGROUP_TOGGLE_GEOMETRYFORWARDBASE == 0
            #define GEOMETRY_DISABLED
        #elif defined(UNITY_PASS_FORWARDADD) && PROPGROUP_TOGGLE_GEOMETRYFORWARDADD == 0
            #define GEOMETRY_DISABLED
        #elif defined(UNITY_PASS_SHADOWCASTER) && PROPGROUP_TOGGLE_GEOMETRYSHADOWCASTER == 0
            #define GEOMETRY_DISABLED
        #elif defined(UNITY_PASS_META) && PROPGROUP_TOGGLE_GEOMETRYMETA == 0
            #define GEOMETRY_DISABLED
        #endif
    #else
        #define GEOMETRY_DISABLED
    #endif

    // The rest of the interpolator exclusion defines have a similar structure
    // (if property is disabled and won't be re-enabled) foreach property needing a specific interpolator
    // Could be visually simplified but macro arguments cannot evaluate to other macro preprocessor variables
    #if PROP_VERTEXCOLORSENABLED == 0 && PROP_VERTEXCOLORSENABLEDANIMATED == 0 \
        && PROP_TRIPLANARUSEVERTEXCOLORS == 0  && PROP_TRIPLANARUSEVERTEXCOLORSANIMATED == 0 \
        && (defined(GEOMETRY_DISABLED) || (PROP_DEBUGWIREFRAME == 0 && PROP_DEBUGWIREFRAMEANIMATED == 0))
        #define EXCLUDE_VERTEX_COLORS
    #endif

    #if !defined(PROP_MAINTEX) && PROP_MAINTEX_TEXELSIZEANIMATED == 0
        #define MAINTEX_UNUSED 1
    #endif
    #if !defined(PROP_CLEARCOATMASK) && PROP_CLEARCOATMASK_TEXELSIZEANIMATED == 0
        #define CLEARCOATMASK_UNUSED 1
    #endif
    #if !defined(PROP_PARALLAXMAP) && PROP_PARALLAXMAP_TEXELSIZEANIMATED == 0
        #define PARALLAXMAP_UNUSED 1
    #endif
    #if !defined(PROP_COVERAGEMAP) && PROP_COVERAGEMAP_TEXELSIZEANIMATED == 0
        #define COVERAGEMAP_UNUSED 1
    #endif
    #if !defined(PROP_DETAILMASK) && PROP_DETAILMASK_TEXELSIZEANIMATED == 0
        #define DETAILMASK_UNUSED 1
    #endif
    #if !defined(PROP_DETAILALBEDOMAP) && PROP_DETAILALBEDOMAP_TEXELSIZEANIMATED == 0
        #define DETAILALBEDOMAP_UNUSED 1
    #endif
    #if !defined(PROP_DETAILALBEDOMAPGREEN) && PROP_DETAILALBEDOMAPGREEN_TEXELSIZEANIMATED == 0
        #define DETAILALBEDOMAPGREEN_UNUSED 1
    #endif
    #if !defined(PROP_DETAILALBEDOMAPBLUE) && PROP_DETAILALBEDOMAPBLUE_TEXELSIZEANIMATED == 0
        #define DETAILALBEDOMAPBLUE_UNUSED 1
    #endif
    #if !defined(PROP_DETAILALBEDOMAPALPHA) && PROP_DETAILALBEDOMAPALPHA_TEXELSIZEANIMATED == 0
        #define DETAILALBEDOMAPALPHA_UNUSED 1
    #endif
    #if !defined(PROP_DETAILNORMALMAP) && PROP_DETAILNORMALMAP_TEXELSIZEANIMATED == 0
        #define DETAILNORMALMAP_UNUSED 1
    #endif
    #if !defined(PROP_DETAILNORMALMAPGREEN) && PROP_DETAILNORMALMAPGREEN_TEXELSIZEANIMATED == 0
        #define DETAILNORMALMAPGREEN_UNUSED 1
    #endif
    #if !defined(PROP_DETAILNORMALMAPBLUE) && PROP_DETAILNORMALMAPBLUE_TEXELSIZEANIMATED == 0
        #define DETAILNORMALMAPBLUE_UNUSED 1
    #endif
    #if !defined(PROP_DETAILNORMALMAPALPHA) && PROP_DETAILNORMALMAPALPHA_TEXELSIZEANIMATED == 0
        #define DETAILNORMALMAPALPHA_UNUSED 1
    #endif
    #if !defined(PROP_EMISSIONMAP) && PROP_EMISSIONMAP_TEXELSIZEANIMATED == 0
        #define EMISSIONMAP_UNUSED 1
    #endif
    #if !defined(PROP_METALLICGLOSSMAP) && PROP_METALLICGLOSSMAP_TEXELSIZEANIMATED == 0
        #define METALLICGLOSSMAP_UNUSED 1
    #endif
    #if !defined(PROP_SPECGLOSSMAP) && PROP_SPECGLOSSMAP_TEXELSIZEANIMATED == 0
        #define SPECGLOSSMAP_UNUSED 1
    #endif
    #if !defined(PROP_OCCLUSIONMAP) && PROP_OCCLUSIONMAP_TEXELSIZEANIMATED == 0
        #define OCCLUSIONMAP_UNUSED 1
    #endif
    #if !defined(PROP_SPECULARMAP) && PROP_SPECULARMAP_TEXELSIZEANIMATED == 0
        #define SPECULARMAP_UNUSED 1
    #endif
    #if !defined(PROP_BUMPMAP) && PROP_BUMPMAP_TEXELSIZEANIMATED == 0
        #define BUMPMAP_UNUSED 1
    #endif
    #if !defined(PROP_TRANSLUCENCYMAP) && PROP_TRANSLUCENCYMAP_TEXELSIZEANIMATED == 0
        #define TRANSLUCENCYMAP_UNUSED 1
    #endif

    #ifndef UNITY_PASS_META // Meta pass needs UV1 and UV2 for lightmaps

        // ((UV not X and wont change to X) || (texture doesn't exist and wont exist)) for each texture
        // This could also be done for every UV sampling mode exclusion, but its expected that if you're not using a texture its
        // going to be on the default UV setting (UV0)
        #if ((PROP_MAINTEXUV != 0 && PROP_MAINTEXUVANIMATED == 0) || MAINTEX_UNUSED) \
            && ((PROP_CLEARCOATMASKUV != 0 && PROP_CLEARCOATMASKUVANIMATED == 0) || CLEARCOATMASK_UNUSED) \
            && ((PROP_PARALLAXMAPUV != 0 && PROP_PARALLAXMAPUVANIMATED == 0) || PARALLAXMAP_UNUSED) \
            && ((PROP_COVERAGEMAPUV != 0 && PROP_COVERAGEMAPUVANIMATED == 0) || COVERAGEMAP_UNUSED) \
            && ((PROP_DETAILMASKUV != 0 && PROP_DETAILMASKUVANIMATED == 0) || DETAILMASK_UNUSED) \
            && ((PROP_UVSEC != 0 && PROP_UVSECANIMATED == 0) || \
                (DETAILALBEDOMAP_UNUSED \
                && DETAILALBEDOMAPGREEN_UNUSED \
                && DETAILALBEDOMAPBLUE_UNUSED \
                && DETAILALBEDOMAPALPHA_UNUSED \
                && DETAILNORMALMAP_UNUSED \
                && DETAILNORMALMAPGREEN_UNUSED \
                && DETAILNORMALMAPBLUE_UNUSED \
                && DETAILNORMALMAPALPHA_UNUSED)) \
            && ((PROP_EMISSIONMAPUV != 0 && PROP_EMISSIONMAPUVANIMATED == 0) || EMISSIONMAP_UNUSED) \
            && ((PROP_METALLICGLOSSMAPUV != 0 && PROP_METALLICGLOSSMAPUVANIMATED == 0) || METALLICGLOSSMAP_UNUSED) \
            && ((PROP_SPECGLOSSMAPUV != 0 && PROP_SPECGLOSSMAPUVANIMATED == 0) || SPECGLOSSMAP_UNUSED) \
            && ((PROP_OCCLUSIONMAPUV != 0 && PROP_OCCLUSIONMAPUVANIMATED == 0) || OCCLUSIONMAP_UNUSED) \
            && ((PROP_SPECULARMAPUV != 0 && PROP_SPECULARMAPUVANIMATED == 0) || SPECULARMAP_UNUSED) \
            && ((PROP_BUMPMAPUV != 0 && PROP_BUMPMAPUVANIMATED == 0) || BUMPMAP_UNUSED) \
            && ((PROP_TRANSLUCENCYMAPUV != 0 && PROP_TRANSLUCENCYMAPUVANIMATED == 0) || TRANSLUCENCYMAP_UNUSED) \
            && (PROP_MODE != 1 || (PROP_ALPHATOMASK == 0 && PROP_ALPHATOMASKANIMATED == 0))
            #define EXCLUDE_UV0
        #endif
        #if PROP_MAINTEXUV != 1 && PROP_MAINTEXUVANIMATED == 0 \
            && PROP_CLEARCOATMASKUV != 1 && PROP_CLEARCOATMASKUVANIMATED == 0 \
            && PROP_PARALLAXMAPUV != 1 && PROP_PARALLAXMAPUVANIMATED == 0 \
            && PROP_COVERAGEMAPUV != 1 && PROP_COVERAGEMAPUVANIMATED == 0 \
            && PROP_DETAILMASKUV != 1 && PROP_DETAILMASKUVANIMATED == 0 \
            && PROP_UVSEC != 1 && PROP_UVSECANIMATED == 0 \
            && PROP_EMISSIONMAPUV != 1 && PROP_EMISSIONMAPUVANIMATED == 0 \
            && PROP_METALLICGLOSSMAPUV != 1 && PROP_METALLICGLOSSMAPUVANIMATED == 0 \
            && PROP_SPECGLOSSMAPUV != 1 && PROP_SPECGLOSSMAPUVANIMATED == 0 \
            && PROP_OCCLUSIONMAPUV != 1 && PROP_OCCLUSIONMAPUVANIMATED == 0 \
            && PROP_SPECULARMAPUV != 1 && PROP_SPECULARMAPUVANIMATED == 0 \
            && PROP_BUMPMAPUV != 1 && PROP_BUMPMAPUVANIMATED == 0 \
            && PROP_TRANSLUCENCYMAPUV != 1 && PROP_TRANSLUCENCYMAPUVANIMATED == 0 \
            && !defined(LIGHTMAP_ON)
            #define EXCLUDE_UV1
        #endif
        #if PROP_MAINTEXUV != 2 && PROP_MAINTEXUVANIMATED == 0 \
            && PROP_CLEARCOATMASKUV != 2 && PROP_CLEARCOATMASKUVANIMATED == 0 \
            && PROP_PARALLAXMAPUV != 2 && PROP_PARALLAXMAPUVANIMATED == 0 \
            && PROP_COVERAGEMAPUV != 2 && PROP_COVERAGEMAPUVANIMATED == 0 \
            && PROP_DETAILMASKUV != 2 && PROP_DETAILMASKUVANIMATED == 0 \
            && PROP_UVSEC != 2 && PROP_UVSECANIMATED == 0 \
            && PROP_EMISSIONMAPUV != 2 && PROP_EMISSIONMAPUVANIMATED == 0 \
            && PROP_METALLICGLOSSMAPUV != 2 && PROP_METALLICGLOSSMAPUVANIMATED == 0 \
            && PROP_SPECGLOSSMAPUV != 2 && PROP_SPECGLOSSMAPUVANIMATED == 0 \
            && PROP_OCCLUSIONMAPUV != 2 && PROP_OCCLUSIONMAPUVANIMATED == 0 \
            && PROP_SPECULARMAPUV != 2 && PROP_SPECULARMAPUVANIMATED == 0 \
            && PROP_BUMPMAPUV != 2 && PROP_BUMPMAPUVANIMATED == 0 \
            && PROP_TRANSLUCENCYMAPUV != 2 && PROP_TRANSLUCENCYMAPUVANIMATED == 0 \
            && !defined(DYNAMICLIGHTMAP_ON)
            #define EXCLUDE_UV2
        #endif
        #if PROP_MAINTEXUV != 3 && PROP_MAINTEXUVANIMATED == 0 \
            && PROP_CLEARCOATMASKUV != 3 && PROP_CLEARCOATMASKUVANIMATED == 0 \
            && PROP_PARALLAXMAPUV != 3 && PROP_PARALLAXMAPUVANIMATED == 0 \
            && PROP_COVERAGEMAPUV != 3 && PROP_COVERAGEMAPUVANIMATED == 0 \
            && PROP_DETAILMASKUV != 3 && PROP_DETAILMASKUVANIMATED == 0 \
            && PROP_UVSEC != 3 && PROP_UVSECANIMATED == 0 \
            && PROP_EMISSIONMAPUV != 3 && PROP_EMISSIONMAPUVANIMATED == 0 \
            && PROP_METALLICGLOSSMAPUV != 3 && PROP_METALLICGLOSSMAPUVANIMATED == 0 \
            && PROP_SPECGLOSSMAPUV != 3 && PROP_SPECGLOSSMAPUVANIMATED == 0 \
            && PROP_OCCLUSIONMAPUV != 3 && PROP_OCCLUSIONMAPUVANIMATED == 0 \
            && PROP_SPECULARMAPUV != 3 && PROP_SPECULARMAPUVANIMATED == 0 \
            && PROP_BUMPMAPUV != 3 && PROP_BUMPMAPUVANIMATED == 0 \
            && PROP_TRANSLUCENCYMAPUV != 3 && PROP_TRANSLUCENCYMAPUVANIMATED == 0
            #define EXCLUDE_UV3
        #endif
    #endif

    #if defined(EXCLUDE_UV0) && defined(EXCLUDE_UV1)
        #define EXCLUDE_UV0AND1
    #endif
    #if defined(EXCLUDE_UV2) && defined(EXCLUDE_UV3)
        #define EXCLUDE_UV2AND3
    #endif

    // (If ANY texture's UV channel mode isnt 12 (screenspace)
    // && (Mode is Opaque || Dithering isn't and won't be enabled))
    // OR if its the shadowcaster or meta pass then grabpos can be excluded.
    #if defined(UNITY_PASS_SHADOWCASTER) || defined(UNITY_PASS_META)
        #define EXCLUDE_GRABPOS
    #elif PROP_MAINTEXUV != 12 && PROP_MAINTEXUVANIMATED == 0 \
        && PROP_CLEARCOATMASKUV != 12 && PROP_CLEARCOATMASKUVANIMATED == 0 \
        && PROP_PARALLAXMAPUV != 12 && PROP_PARALLAXMAPUVANIMATED == 0 \
        && PROP_COVERAGEMAPUV != 12 && PROP_COVERAGEMAPUVANIMATED == 0 \
        && PROP_DETAILMASKUV != 12 && PROP_DETAILMASKUVANIMATED == 0 \
        && PROP_UVSEC != 12 && PROP_UVSECANIMATED == 0 \
        && PROP_EMISSIONMAPUV != 12 && PROP_EMISSIONMAPUVANIMATED == 0 \
        && PROP_METALLICGLOSSMAPUV != 12 && PROP_METALLICGLOSSMAPUVANIMATED == 0 \
        && PROP_SPECGLOSSMAPUV != 12 && PROP_SPECGLOSSMAPUVANIMATED == 0 \
        && PROP_OCCLUSIONMAPUV != 12 && PROP_OCCLUSIONMAPUVANIMATED == 0 \
        && PROP_SPECULARMAPUV != 12 && PROP_SPECULARMAPUVANIMATED == 0 \
        && PROP_BUMPMAPUV != 12 && PROP_BUMPMAPUVANIMATED == 0 \
        && PROP_TRANSLUCENCYMAPUV != 12 && PROP_TRANSLUCENCYMAPUVANIMATED == 0 \
        && (PROP_MODE == 0 || (PROP_DITHERINGENABLED == 0 && PROP_DITHERINGENABLEDANIMATED == 0))
        #define EXCLUDE_GRABPOS
    #endif

    #if PROP_MAINTEXUV != 5 && PROP_MAINTEXUVANIMATED == 0 \
        && PROP_CLEARCOATMASKUV != 5 && PROP_CLEARCOATMASKUVANIMATED == 0 \
        && PROP_PARALLAXMAPUV != 5 && PROP_PARALLAXMAPUVANIMATED == 0 \
        && PROP_COVERAGEMAPUV != 5 && PROP_COVERAGEMAPUVANIMATED == 0 \
        && PROP_DETAILMASKUV != 5 && PROP_DETAILMASKUVANIMATED == 0 \
        && PROP_UVSEC != 5 && PROP_UVSECANIMATED == 0 \
        && PROP_EMISSIONMAPUV != 5 && PROP_EMISSIONMAPUVANIMATED == 0 \
        && PROP_METALLICGLOSSMAPUV != 5 && PROP_METALLICGLOSSMAPUVANIMATED == 0 \
        && PROP_SPECGLOSSMAPUV != 5 && PROP_SPECGLOSSMAPUVANIMATED == 0 \
        && PROP_OCCLUSIONMAPUV != 5 && PROP_OCCLUSIONMAPUVANIMATED == 0 \
        && PROP_SPECULARMAPUV != 5 && PROP_SPECULARMAPUVANIMATED == 0 \
        && PROP_BUMPMAPUV != 5 && PROP_BUMPMAPUVANIMATED == 0 \
        && PROP_TRANSLUCENCYMAPUV != 5 && PROP_TRANSLUCENCYMAPUVANIMATED == 0
        #define EXCLUDE_NORMALOBJECT
    #endif

    #if (PROP_MAINTEXUV < 9 || PROP_MAINTEXUV > 11) && PROP_MAINTEXUVANIMATED == 0 \
        && (PROP_CLEARCOATMASKUV < 9 || PROP_CLEARCOATMASKUV > 11) && PROP_CLEARCOATMASKUVANIMATED == 0 \
        && (PROP_PARALLAXMAPUV < 9 || PROP_PARALLAXMAPUV > 11) && PROP_PARALLAXMAPUVANIMATED == 0 \
        && (PROP_COVERAGEMAPUV < 9 || PROP_COVERAGEMAPUV > 11) && PROP_COVERAGEMAPUVANIMATED == 0 \
        && (PROP_DETAILMASKUV < 9 || PROP_DETAILMASKUV > 11) && PROP_DETAILMASKUVANIMATED == 0 \
        && (PROP_UVSEC < 9 || PROP_UVSEC > 11) && PROP_UVSECANIMATED == 0 \
        && (PROP_EMISSIONMAPUV < 9 || PROP_EMISSIONMAPUV > 11) && PROP_EMISSIONMAPUVANIMATED == 0 \
        && (PROP_METALLICGLOSSMAPUV < 9 || PROP_METALLICGLOSSMAPUV > 11) && PROP_METALLICGLOSSMAPUVANIMATED == 0 \
        && (PROP_SPECGLOSSMAPUV < 9 || PROP_SPECGLOSSMAPUV > 11) && PROP_SPECGLOSSMAPUVANIMATED == 0 \
        && (PROP_OCCLUSIONMAPUV < 9 || PROP_OCCLUSIONMAPUV > 11) && PROP_OCCLUSIONMAPUVANIMATED == 0 \
        && (PROP_SPECULARMAPUV < 9 || PROP_SPECULARMAPUV > 11) && PROP_SPECULARMAPUVANIMATED == 0 \
        && (PROP_BUMPMAPUV < 9 || PROP_BUMPMAPUV > 11) && PROP_BUMPMAPUVANIMATED == 0 \
        && (PROP_TRANSLUCENCYMAPUV < 9 || PROP_TRANSLUCENCYMAPUV > 11) && PROP_TRANSLUCENCYMAPUVANIMATED == 0 \
        && ((PROPGROUP_TOGGLE_SSSTRANSMISSION == 0 && PROPGROUP_TOGGLE_SSSTRANSMISSIONANIMATED == 0) \
            || (PROP_SSSSTYLIZEDINDIRECT == 0 && PROP_SSSSTYLIZEDINDIRECTANIMATED == 0))
        #define EXCLUDE_POSOBJECT
    #endif

    #if PROPGROUP_TOGGLE_PARALLAX == 0 && PROPGROUP_TOGGLE_PARALLAXANIMATED == 0
        #define EXCLUDE_TANGENT_VIEWDIR
    #endif

    #if defined(EXCLUDE_TANGENT_VIEWDIR) \
        && !defined(PROP_BUMPMAP) && PROP_BUMPMAP_TEXELSIZEANIMATED == 0 \
        && !defined(PROP_DETAILNORMALMAP) && PROP_DETAILNORMALMAP_TEXELSIZEANIMATED == 0 \
        && !defined(PROP_DETAILNORMALMAPGREEN) && PROP_DETAILNORMALMAPGREEN_TEXELSIZEANIMATED == 0 \
        && !defined(PROP_DETAILNORMALMAPBLUE) && PROP_DETAILNORMALMAPBLUE_TEXELSIZEANIMATED == 0 \
        && !defined(PROP_DETAILNORMALMAPALPHA) && PROP_DETAILNORMALMAPALPHA_TEXELSIZEANIMATED == 0 \
        && PROP_SPECULARMODE != 2 && PROP_SPECULARMODEANIMATED == 0 \
        && PROP_REFLECTIONSMODE != 3 && PROP_REFLECTIONSMODEANIMATED == 0
        #define EXCLUDE_TANGENT_BITANGENT
    #endif

    #if PROP_RECEIVEFOG == 0 && PROP_RECEIVEFOGANIMATED == 0
        #define EXCLUDE_FOG_COORDS
    #endif

    // This could also be culled if shadows aren't ever used, since shadows get multiplied into attenuation,
    // then into lightcolor, then blah blah blah.  That would probably be too much to keep track of to exclude a single interpolator.
    // Maybe later.
    #if PROP_RECEIVESHADOWS == 0 && PROP_RECEIVESHADOWSANIMATED == 0
        #define EXCLUDE_SHADOW_COORDS
    #endif

    #if PROP_FLIPPEDNORMALBACKFACES == 0 && PROP_FLIPPEDNORMALBACKFACESANIMATED == 0
        #define EXCLUDE_VFACE
    #endif

    // posWorld and normal culling is too complicated to implement, and only almost completely 
    // unlit materials are the only materials that wouldn't need either value, so skipping for now

#endif


// Reusable macros and functions

// Stereo correct world camera position
#ifdef USING_STEREO_MATRICES
#define _WorldSpaceStereoCameraCenterPos lerp(unity_StereoWorldSpaceCameraPos[0], unity_StereoWorldSpaceCameraPos[1], 0.5)
#else
#define _WorldSpaceStereoCameraCenterPos _WorldSpaceCameraPos
#endif

// UNITY_LIGHT_ATTENUATION macros without the shadow multiplied in, versions with/without shadow coord interpolator
#ifndef EXCLUDE_SHADOW_COORDS
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
#else
    #ifdef POINT
    #define LIGHT_ATTENUATION_NO_SHADOW_MUL(destName, input, worldPos) \
            unityShadowCoord3 lightCoord = mul(unity_WorldToLight, unityShadowCoord4(worldPos, 1)).xyz; \
            fixed shadow = 1; \
            fixed destName = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).r;
    #endif
    #ifdef SPOT
    #define LIGHT_ATTENUATION_NO_SHADOW_MUL(destName, input, worldPos) \
            DECLARE_LIGHT_COORD(input, worldPos); \
            fixed shadow = 1; \
            fixed destName = (lightCoord.z > 0) * UnitySpotCookie(lightCoord) * UnitySpotAttenuate(lightCoord.xyz);
    #endif
    #ifdef DIRECTIONAL
    #define LIGHT_ATTENUATION_NO_SHADOW_MUL(destName, input, worldPos) \
            fixed shadow = 1; \
            fixed destName = 1;
    #endif
    #ifdef POINT_COOKIE
    #define LIGHT_ATTENUATION_NO_SHADOW_MUL(destName, input, worldPos) \
            DECLARE_LIGHT_COORD(input, worldPos); \
            fixed shadow = 1; \
            fixed destName = tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).r * texCUBE(_LightTexture0, lightCoord).w;
    #endif
    #ifdef DIRECTIONAL_COOKIE
    #define LIGHT_ATTENUATION_NO_SHADOW_MUL(destName, input, worldPos) \
            DECLARE_LIGHT_COORD(input, worldPos); \
            fixed shadow = 1; \
            fixed destName = tex2D(_LightTexture0, lightCoord).w;
    #endif
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
// Forwardbase 4 unimportant lights
half3 VertexLightsDiffuse(half3 normalDir, float3 posWorld)
{
    half3 vertexDiffuse = 0;
    #ifdef UNITY_PASS_FORWARDBASE
        #ifdef VERTEXLIGHT_ON
            vertexDiffuse = Shade4PointLights(unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, 
                                              unity_LightColor[0], unity_LightColor[1], unity_LightColor[2], unity_LightColor[3],
                                              unity_4LightAtten0, posWorld, normalDir);
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

// F0 when top layer is IOR 1.5 (clearcoat) rather than 1.0 (air) - via HDRP
half3 ConvertF0ForAirInterfaceToF0ForClearCoat15(half3 fresnel0)
{
    return saturate(-0.0256868 + fresnel0 * (0.326846 + (0.978946 - 0.283835 * fresnel0) * fresnel0));
}
// HDRP StackLit functions, equates to the above function but slightly more accureate
half3 IorToFresnel0(half3 transmittedIor, half3 incidentIor)
{
    half3 val = (transmittedIor - incidentIor) / (transmittedIor + incidentIor);
    return val*val;
}
half3 Fresnel0ToIor(half3 fresnel0)
{
    return (1.0 + sqrt(fresnel0)) / (1.0 - sqrt(fresnel0));
}
float3 ConvertF0ForAirInterfaceToF0ForNewTopIor(float3 fresnel0, float newTopIor)
{
    float3 ior = Fresnel0ToIor(min(fresnel0, float3(1,1,1)*0.999)); // guard against 1.0
    return IorToFresnel0(ior, newTopIor);
}

// HDRP StackLit function
// same as regular refract except there is not the test for total internal reflection + the vector is flipped for processing
half3 CoatRefract(half3 X, half3 N, half ieta)
{
    half XdotN = saturate(dot(N, X));
    return ieta * X + (sqrt(1 + ieta * ieta * (XdotN * XdotN - 1)) - ieta * XdotN) * N;
}

#define CLEAR_COAT_IOR 1.5
#define CLEAR_COAT_IETA (1.0 / CLEAR_COAT_IOR)
#define CLEAR_COAT_F0 0.04
#define CLEAR_COAT_ROUGHNESS 0.01
#define CLEAR_COAT_PERCEPTUAL_SMOOTHNESS RoughnessToPerceptualSmoothness(CLEAR_COAT_ROUGHNESS)
#define CLEAR_COAT_PERCEPTUAL_ROUGHNESS RoughnessToPerceptualRoughness(CLEAR_COAT_ROUGHNESS)

//----------------------------------------------------------------------
// From Walter 2007 eq. 40
// copied from HDRP AxF.hlsl
float3  Refract(float3 incoming, float3 normal, float eta)
{
    float   c = dot(incoming, normal);
    float   b = 1.0 + eta*eta * (c*c - 1.0);
    float   k = eta * c - sign(c) * sqrt(b);
    float3  R = k * normal - eta * incoming;
    return normalize(R);
}

// Use with stack BRDF (clear coat / coat) - This only used same equation to convert from Blinn-Phong spec power to Beckmann roughness
half RoughnessToVariance(half roughness)
{
    return 2.0 / (roughness*roughness) - 2.0;
}
half VarianceToRoughness(half variance)
{
    return sqrt(2.0 / (variance + 2.0));
}
half RoughnessToPerceptualSmoothness(half roughness)
{
    return 1.0 - RoughnessToPerceptualRoughness(roughness);
}


UNITY_INSTANCING_BUFFER_START(Props)
    //UNITY_DEFINE_INSTANCED_PROP
UNITY_INSTANCING_BUFFER_END(Props)


// Culled appdata for vertex shader because although the hlsl compiler can mask out unused inputs
// for the gpu program, afaik CPU side Unity still thinks it needs to provide all vertex stream data,
// which is slower.  (Compiled shader shows "Uses vertex data channel", only indication of this)
struct appdata_full_omega {
    float4 vertex : POSITION;
    #ifndef EXCLUDE_TANGENT_BITANGENT
        float4 tangent : TANGENT;
    #endif
    float3 normal : NORMAL;
    #ifndef EXCLUDE_UV0
        float4 texcoord : TEXCOORD0;
    #endif
    #ifndef EXCLUDE_UV1
        float4 texcoord1 : TEXCOORD1;
    #endif
    #ifndef EXCLUDE_UV2
        float4 texcoord2 : TEXCOORD2;
    #endif
    #ifndef EXCLUDE_UV3
        float4 texcoord3 : TEXCOORD3;
    #endif
    #ifndef EXCLUDE_VERTEX_COLORS
        fixed4 color : COLOR;
    #endif
    UNITY_VERTEX_INPUT_INSTANCE_ID
};
// vert_omega has different output depending on pass type/optimizer's interpolator culling keywords
struct vertex_output_omega
{
    #ifdef UNITY_PASS_SHADOWCASTER
        V2F_SHADOW_CASTER;
    #else
        float4 pos : SV_POSITION;
    #endif
    #ifndef EXCLUDE_UV0AND1
        float4 uv0and1 : TEXCOORD0;
    #endif
    #ifndef EXCLUDE_UV2AND3
        float4 uv2and3 : TEXCOORD1;
    #endif
    #ifndef EXCLUDE_VERTEX_COLORS
        float4 color : TEXCOORD2;
    #endif
        float4 posWorld : TEXCOORD3;
        #ifndef EXCLUDE_POSOBJECT
            float4 posObject : TEXCOORD4;
        #endif
        #ifndef EXCLUDE_NORMALOBJECT
            float3 normalObject : TEXCOORD5;
        #endif
        float3 normalWorld : TEXCOORD6;
        #ifndef EXCLUDE_TANGENT_BITANGENT
            float3 tangentWorld : TEXCOORD7;
            float3 bitangentWorld : TEXCOORD8;
        #endif
        #ifndef EXCLUDE_GRABPOS
            float4 grabPos: TEXCOORD9;
        #endif
    #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_FORWARDADD)
        centroid float3 centroidNormalWorld : TEXCOORD10;
        #ifndef EXCLUDE_TANGENT_VIEWDIR
            float3 tangentViewDir : TEXCOORD11;
        #endif
        #ifndef EXCLUDE_FOG_COORDS
            UNITY_FOG_COORDS(12)
        #endif
        #ifndef EXCLUDE_SHADOW_COORDS
            SHADOW_COORDS(13)
        #endif
    #endif
    #ifdef UNITY_PASS_META
        #ifdef EDITOR_VISUALIZATION
            float2 vizUV        : TEXCOORD14;
            float4 lightCoord   : TEXCOORD15;
        #endif
    #else
        UNITY_VERTEX_INPUT_INSTANCE_ID
        UNITY_VERTEX_OUTPUT_STEREO
    #endif
};
// common function for regular vertex shader operations that can be called from a vertex, domain, or geometry shader
// Tesselation programs also rely on this structure
struct vertex_common_input_omega
{
    float4 vertex : INTERNALTESSPOS;
    #ifndef EXCLUDE_TANGENT_BITANGENT
        float4 tangent : TANGENT;
    #endif
    float3 normal : NORMAL;
    #ifndef EXCLUDE_UV0AND1
        float4 uv0and1 : TEXCOORD0;
    #endif
    #ifndef EXCLUDE_UV2AND3
        float4 uv2and3 : TEXCOORD1;
    #endif
#ifndef EXCLUDE_VERTEX_COLORS
    fixed4 color : COLOR;
#endif
    UNITY_VERTEX_INPUT_INSTANCE_ID
};
vertex_output_omega vert_common_omega (vertex_common_input_omega v)
{
    vertex_output_omega o;
    #ifndef UNITY_PASS_META
        UNITY_SETUP_INSTANCE_ID(v);
        UNITY_INITIALIZE_OUTPUT(vertex_output_omega, o);
        UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
        UNITY_TRANSFER_INSTANCE_ID(v, o);
    #endif
    #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_FORWARDADD)
        #ifndef EXCLUDE_TANGENT_BITANGENT
            #ifdef PROPGROUP_TOGGLE_PARALLAX
                UNITY_BRANCH
                if (group_toggle_Parallax) // batched mehses don't have pre-normalized tangent/normal, and parallax needs that
                {
                    v.tangent.xyz = normalize(v.tangent.xyz);
                    v.normal = normalize(v.normal);
                }
            #endif
        #endif
        o.pos = UnityObjectToClipPos(v.vertex);
    #elif defined(UNITY_PASS_META)
        o.pos = UnityMetaVertexPosition(v.vertex, v.uv0and1.zw, v.uv2and3.xy, unity_LightmapST, unity_DynamicLightmapST);
    #else
        TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
    #endif

    o.posWorld = mul(unity_ObjectToWorld, v.vertex);
    #ifndef EXCLUDE_POSOBJECT
        o.posObject = v.vertex;
    #endif
	o.normalWorld = UnityObjectToWorldNormal(v.normal);
    #ifndef EXCLUDE_NORMALOBJECT
        o.normalObject = v.normal;
    #endif
    #ifndef EXCLUDE_TANGENT_BITANGENT
        o.tangentWorld = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);
        o.bitangentWorld = cross(o.normalWorld, o.tangentWorld) * v.tangent.w;
    #endif
    #ifndef EXCLUDE_UV0AND1
	    o.uv0and1 = v.uv0and1;
    #endif
    #ifndef EXCLUDE_UV2AND3
        o.uv2and3 = v.uv2and3;
    #endif
    #ifndef EXCLUDE_VERTEX_COLORS
        o.color = v.color;
    #endif
    #ifndef EXCLUDE_GRABPOS
        o.grabPos = ComputeGrabScreenPos(o.pos);
    #endif
    #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_FORWARDADD)
        o.centroidNormalWorld = o.normalWorld;
        #ifndef EXCLUDE_TANGENT_VIEWDIR
            float3x3 objectToTangent = float3x3(v.tangent.xyz, cross(v.normal, v.tangent.xyz) * v.tangent.w, v.normal);
	        o.tangentViewDir = mul(objectToTangent, ObjSpaceViewDir(v.vertex));
        #endif
        #ifndef EXCLUDE_SHADOW_COORDS
            TRANSFER_SHADOW(o);
        #endif
        #ifndef EXCLUDE_FOG_COORDS
            UNITY_TRANSFER_FOG(o,o.pos);
        #endif
    #endif
    #if defined(UNITY_PASS_META) && defined(EDITOR_VISUALIZATION)
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

// Main Vertex Shader, completely changes definition based on tess/geom being enabled or not
#if defined(TESSELATION_DISABLED) && defined(GEOMETRY_DISABLED)
vertex_output_omega 
#else
vertex_common_input_omega 
#endif
vert_omega (appdata_full_omega v)
{
    vertex_common_input_omega o;
    
    o.vertex = v.vertex;
    #ifndef EXCLUDE_TANGENT_BITANGENT
        o.tangent = v.tangent;
    #endif
    o.normal = v.normal;
    #ifndef EXCLUDE_UV0
        o.uv0and1.xy = v.texcoord.xy;
    #elif !defined(EXCLUDE_UV1)
        // These stop the 'Output value isn't completely initialized' warnings.
        // Alas #pragma warning (disable : 3578) doesn't work and at most two extra mov instructions must be used
        o.uv0and1.xy = 0; 
    #endif
    #ifndef EXCLUDE_UV1
        o.uv0and1.zw = v.texcoord1.xy;
    #elif !defined(EXCLUDE_UV0)
        o.uv0and1.zw = 0;
    #endif
    #ifndef EXCLUDE_UV2
        o.uv2and3.xy = v.texcoord2.xy;
    #elif !defined(EXCLUDE_UV3)
        o.uv2and3.xy = 0;
    #endif
    #ifndef EXCLUDE_UV3
        o.uv2and3.zw = v.texcoord3.xy;
    #elif !defined(EXCLUDE_UV2)
        o.uv2and3.zw = 0;
    #endif
    #ifndef EXCLUDE_VERTEX_COLORS
        o.color = v.color;
    #endif
    // idk how tesselation will even handle a uint instanceID
    UNITY_TRANSFER_INSTANCE_ID(v, o);
    
#if defined(TESSELATION_DISABLED) && defined(GEOMETRY_DISABLED)
    return vert_common_omega(o);
#else
    return o;
#endif
}


// Tesselation
struct TessellationFactorsTri
{
    float edge[3] : SV_TessFactor;
    float inside : SV_InsideTessFactor;
};
struct TessellationFactorsQuad
{
    float edge[4] : SV_TessFactor;
    float inside[2] : SV_InsideTessFactor;
};
struct TessellationFactorsIsoline
{
    float edge[2] : SV_TessFactor;
};
TessellationFactorsTri patch_constant_omega_tri (InputPatch<vertex_common_input_omega, 3> patch)
{
    TessellationFactorsTri f;
    f.edge[0] = _TesselationEdgeFactor;
    f.edge[1] = _TesselationEdgeFactor;
    f.edge[2] = _TesselationEdgeFactor;
	f.inside = _TesselationEdgeFactor;
	return f;
}
TessellationFactorsQuad patch_constant_omega_quad (InputPatch<vertex_common_input_omega, 3> patch)
{
    //_TesselationInsideFactor
    TessellationFactorsQuad f;
    f.edge[0] = _TesselationEdgeFactor;
    f.edge[1] = _TesselationEdgeFactor;
    f.edge[2] = _TesselationEdgeFactor;
    f.edge[3] = _TesselationEdgeFactor;
	f.inside[0] = _TesselationEdgeFactor;
    f.inside[1] = _TesselationEdgeFactor;
	return f;
}

[UNITY_domain("tri")]
//[UNITY_domain("quad")]
//[UNITY_domain("isoline")]
[UNITY_outputcontrolpoints(3)]
//[outputtopology("point")]
//[outputtopology("line")]
[UNITY_outputtopology("triangle_cw")]
//[outputtopology("triangle_ccw")]
[UNITY_partitioning("fractional_odd")]
//[UNITY_partitioning("integer")]
//[UNITY_patchconstantfunc("patch_constant_omega_quad")]
[UNITY_patchconstantfunc("patch_constant_omega_tri")]
vertex_common_input_omega hull_omega (InputPatch<vertex_common_input_omega, 3> patch, uint id : SV_OutputControlPointID)
{
    return patch[id];
}

[UNITY_domain("tri")]
//[UNITY_domain("quad")]
//[UNITY_domain("isoline")]
#ifdef GEOMETRY_DISABLED
vertex_output_omega 
#else
vertex_common_input_omega 
#endif
domain_omega (TessellationFactorsTri factors, OutputPatch<vertex_common_input_omega, 3> patch, float3 barycentricCoordinates : SV_DomainLocation)
{
    vertex_common_input_omega v;

    #define DOMAIN_PROGRAM_INTERPOLATE(fieldName) v.fieldName = \
		patch[0].fieldName * barycentricCoordinates.x + \
		patch[1].fieldName * barycentricCoordinates.y + \
		patch[2].fieldName * barycentricCoordinates.z;

    DOMAIN_PROGRAM_INTERPOLATE(vertex)
    DOMAIN_PROGRAM_INTERPOLATE(normal)
    #ifndef EXCLUDE_TANGENT_BITANGENT
        DOMAIN_PROGRAM_INTERPOLATE(tangent)
    #endif
    #ifndef EXCLUDE_UV0AND1
        DOMAIN_PROGRAM_INTERPOLATE(uv0and1)
    #endif
    #ifndef EXCLUDE_UV2AND3
        DOMAIN_PROGRAM_INTERPOLATE(uv2and3)
    #endif
#ifndef EXCLUDE_VERTEX_COLORS
    DOMAIN_PROGRAM_INTERPOLATE(color)
#endif
    UNITY_TRANSFER_INSTANCE_ID(patch[0], v); // idk lmao

#ifdef GEOMETRY_DISABLED
    return vert_common_omega(v);
#else
    return v;
#endif
}

// Geometry
// Always expected to do vertex shader part if it is included
[maxvertexcount(3)]
void geom_omega(triangle vertex_common_input_omega IN[3], inout TriangleStream<vertex_output_omega> triStream)
{
    vertex_output_omega o;

    float3 barys[3];
    barys[0] = float3(1,0,0);
    barys[1] = float3(0,1,0);
    barys[2] = float3(0,0,1);

    UNITY_UNROLL
    for(int i=0; i<3; i++)
    {
        o = vert_common_omega(IN[i]);
        #ifndef EXCLUDE_VERTEX_COLORS
            #ifdef UNITY_PASS_FORWARDBASE
                if (_DebugWireframe && group_toggle_Geometry && group_toggle_GeometryForwardBase)
                    o.color.rgb = barys[i];
            #endif
        #endif
        triStream.Append(o);
    }
    triStream.RestartStrip();
}

// Fragment
// needs to be culled similarly to vertex output 
struct fragment_input_omega
{
    #ifdef UNITY_PASS_SHADOWCASTER
        V2F_SHADOW_CASTER_NOPOS
        UNITY_VPOS_TYPE vpos : VPOS;
    #else
        float4 pos : SV_POSITION;
    #endif
    #ifndef EXCLUDE_UV0AND1
        float4 uv0and1 : TEXCOORD0;
    #endif
    #ifndef EXCLUDE_UV2AND3
        float4 uv2and3 : TEXCOORD1;
    #endif
    #ifndef EXCLUDE_VERTEX_COLORS
        float4 color : TEXCOORD2;
    #endif
        float4 posWorld : TEXCOORD3;
        #ifndef EXCLUDE_POSOBJECT
            float4 posObject : TEXCOORD4;
        #endif
        #ifndef EXCLUDE_NORMALOBJECT
            float3 normalObject : TEXCOORD5;
        #endif
        float3 normalWorld : TEXCOORD6;
        #ifndef EXCLUDE_TANGENT_BITANGENT
            float3 tangentWorld : TEXCOORD7;
            float3 bitangentWorld : TEXCOORD8;
        #endif
        #ifndef EXCLUDE_GRABPOS
            float4 grabPos: TEXCOORD9;
        #endif
    #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_FORWARDADD)
        centroid float3 centroidNormalWorld : TEXCOORD10;
        #ifndef EXCLUDE_TANGENT_VIEWDIR
            float3 tangentViewDir : TEXCOORD11;
        #endif
        #ifndef EXCLUDE_FOG_COORDS
            UNITY_FOG_COORDS(12)
        #endif
        #ifndef EXCLUDE_SHADOW_COORDS
            SHADOW_COORDS(13)
        #endif
    #endif
    #ifdef UNITY_PASS_META
        #ifdef EDITOR_VISUALIZATION
            float2 vizUV        : TEXCOORD14;
            float4 lightCoord   : TEXCOORD15;
        #endif
    #else
        UNITY_VERTEX_INPUT_INSTANCE_ID
        UNITY_VERTEX_OUTPUT_STEREO
        #ifndef EXCLUDE_VFACE
            fixed facing : VFACE;
        #endif
    #endif
};

// Macro function for the texture sampling function.  Expects specificly named variables to be declared
//KSOEvaluateMacro
#define OMEGA_SAMPLE_TEX2D(var,tex,samplertex) \
var = omega_sample_texture2D(tex, sampler##samplertex, i, tex##UV, tex##_ST, \
                             tpWorldX, tpWorldY, tpWorldZ, tpWorldBlendFactor, \
                             tpObjX, tpObjY, tpObjZ, tpObjBlendFactor, panoUV);
//KSOEvaluateMacro
#define OMEGA_SAMPLE_TEX2D_BIAS(var,tex,samplertex,bias) \
var = omega_sample_texture2Dbias(tex, sampler##samplertex, i, tex##UV, tex##_ST, \
                                 tpWorldX, tpWorldY, tpWorldZ, tpWorldBlendFactor, \
                                 tpObjX, tpObjY, tpObjZ, tpObjBlendFactor, panoUV, bias);

// Omega shader sampling function allowing a multitude of different UV channels/sampling methods
// This used to be part of one big macro until different sampling modes needed to be culled by the preprocessor
half4 omega_sample_texture2D(Texture2D tex, SamplerState samplertex, fragment_input_omega i, float texUV, float4 ST,
                             float2 tpWorldX, float2 tpWorldY, float2 tpWorldZ, float3 tpWorldBlendFactor,
                             float2 tpObjX, float2 tpObjY, float2 tpObjZ, float3 tpObjBlendFactor, float2 panoUV)
{
    half4 var;

    #ifndef EXCLUDE_UV0AND1
    if (texUV == 0)
        var = tex.Sample (samplertex, i.uv0and1.xy * ST.xy + ST.zw);
    else if (texUV == 1) 
        var = tex.Sample (samplertex, i.uv0and1.zw * ST.xy + ST.zw);
    else 
    #endif
    #ifndef EXCLUDE_UV2AND3
    if (texUV == 2) 
        var = tex.Sample (samplertex, i.uv2and3.xy * ST.xy + ST.zw);
    else if (texUV == 3) 
        var = tex.Sample (samplertex, i.uv2and3.zw * ST.xy + ST.zw);
    else 
    #endif
    if (texUV == 4) 
        var = tex.Sample(samplertex, (tpWorldX + ST.wy) * ST.x) * tpWorldBlendFactor.x
            + tex.Sample(samplertex, (tpWorldY + ST.yz) * ST.x) * tpWorldBlendFactor.y
            + tex.Sample(samplertex, (tpWorldZ + ST.zw) * ST.x) * tpWorldBlendFactor.z;
    else if (texUV == 5) 
        var = tex.Sample(samplertex, (tpObjX + ST.wy) * ST.x) * tpObjBlendFactor.x
            + tex.Sample(samplertex, (tpObjY + ST.yz) * ST.x) * tpObjBlendFactor.y
            + tex.Sample(samplertex, (tpObjZ + ST.zw) * ST.x) * tpObjBlendFactor.z;
    else if (texUV == 6) 
        var = tex.Sample (samplertex, i.posWorld.xy * ST.xy + ST.zw); 
    else if (texUV == 7) 
        var = tex.Sample (samplertex, i.posWorld.yz * ST.xy + ST.zw); 
    else if (texUV == 8) 
        var = tex.Sample (samplertex, i.posWorld.zx * ST.xy + ST.zw); 
    #ifndef EXCLUDE_POSOBJECT
        else if (texUV == 9) 
            var = tex.Sample (samplertex, i.posObject.xy * ST.xy + ST.zw); 
        else if (texUV == 10) 
            var = tex.Sample (samplertex, i.posObject.yz * ST.xy + ST.zw); 
        else if (texUV == 11) 
            var = tex.Sample (samplertex, i.posObject.zx * ST.xy + ST.zw); 
    #endif
    #ifndef EXCLUDE_GRABPOS
        else if (texUV == 12) 
            var = tex.Sample (samplertex, stereoCorrectScreenUV01(i.grabPos) * ST.xy + ST.zw); 
    #endif
    else if (texUV == 13) 
        var = tex.Sample (samplertex, panoUV * ST.xy + ST.zw); 
    else // something went wrong, probably shadow or meta pass with texUV == 12
        var = 0;

    return var;
}
half4 omega_sample_texture2Dbias(Texture2D tex, SamplerState samplertex, fragment_input_omega i, float texUV, float4 ST,
                             float2 tpWorldX, float2 tpWorldY, float2 tpWorldZ, float3 tpWorldBlendFactor,
                             float2 tpObjX, float2 tpObjY, float2 tpObjZ, float3 tpObjBlendFactor, float2 panoUV, float bias)
{
    half4 var;

    #ifndef EXCLUDE_UV0AND1
    if (texUV == 0)
        var = tex.SampleBias (samplertex, i.uv0and1.xy * ST.xy + ST.zw, bias);
    else if (texUV == 1) 
        var = tex.SampleBias (samplertex, i.uv0and1.zw * ST.xy + ST.zw, bias);
    else 
    #endif
    #ifndef EXCLUDE_UV2AND3
    if (texUV == 2) 
        var = tex.SampleBias (samplertex, i.uv2and3.xy * ST.xy + ST.zw, bias);
    else if (texUV == 3) 
        var = tex.SampleBias (samplertex, i.uv2and3.zw * ST.xy + ST.zw, bias);
    else 
    #endif
    if (texUV == 4) 
        var = tex.SampleBias(samplertex, (tpWorldX + ST.wy) * ST.x, bias) * tpWorldBlendFactor.x
            + tex.SampleBias(samplertex, (tpWorldY + ST.yz) * ST.x, bias) * tpWorldBlendFactor.y
            + tex.SampleBias(samplertex, (tpWorldZ + ST.zw) * ST.x, bias) * tpWorldBlendFactor.z;
    else if (texUV == 5) 
        var = tex.SampleBias(samplertex, (tpObjX + ST.wy) * ST.x, bias) * tpObjBlendFactor.x
            + tex.SampleBias(samplertex, (tpObjY + ST.yz) * ST.x, bias) * tpObjBlendFactor.y
            + tex.SampleBias(samplertex, (tpObjZ + ST.zw) * ST.x, bias) * tpObjBlendFactor.z;
    else if (texUV == 6) 
        var = tex.SampleBias (samplertex, i.posWorld.xy * ST.xy + ST.zw, bias); 
    else if (texUV == 7) 
        var = tex.SampleBias (samplertex, i.posWorld.yz * ST.xy + ST.zw, bias); 
    else if (texUV == 8) 
        var = tex.SampleBias (samplertex, i.posWorld.zx * ST.xy + ST.zw, bias); 
    #ifndef EXCLUDE_POSOBJECT
        else if (texUV == 9) 
            var = tex.SampleBias (samplertex, i.posObject.xy * ST.xy + ST.zw, bias); 
        else if (texUV == 10) 
            var = tex.SampleBias (samplertex, i.posObject.yz * ST.xy + ST.zw, bias); 
        else if (texUV == 11) 
            var = tex.SampleBias (samplertex, i.posObject.zx * ST.xy + ST.zw, bias); 
    #endif
    #ifndef EXCLUDE_GRABPOS
        else if (texUV == 12) 
            var = tex.SampleBias (samplertex, stereoCorrectScreenUV01(i.grabPos) * ST.xy + ST.zw, bias); 
    #endif
    else if (texUV == 13) 
        var = tex.SampleBias (samplertex, panoUV * ST.xy + ST.zw, bias); 
    else // something went wrong, probably shadow or meta pass with texUV == 12
        var = 0;

    return var;
}

half4 frag_omega (fragment_input_omega i) : SV_Target
{
    // Early discards, early opaque shadowcaster return, and instancing
    #ifdef UNITY_PASS_SHADOWCASTER
        // This subshader override tag doesn't work, so hard coding it here.
        // Use the shader optimizer to make the override tag work & skip shadowcasting calls entirely
        UNITY_BRANCH
        if (_ForceNoShadowCasting) discard;
        UNITY_SETUP_INSTANCE_ID(i);
        UNITY_APPLY_DITHER_CROSSFADE(i.vpos.xy);
        if (_Mode == 0) // Opaque shadowcaster
        {
            SHADOW_CASTER_FRAGMENT(i)
        }
    #elif !defined(UNITY_PASS_META)
        UNITY_SETUP_INSTANCE_ID(i);
        UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
        UNITY_APPLY_DITHER_CROSSFADE(i.pos.xy);
    #endif
    
    // Geometric specular antialiasing
    #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_FORWARDADD)
        if ( dot( i.normalWorld, i.normalWorld ) >= 1.01 )
            i.normalWorld = i.centroidNormalWorld;
    #endif

    // VFACE flipping
    #ifndef EXCLUDE_VFACE
        #ifndef UNITY_PASS_META
            UNITY_BRANCH
            if (i.facing <= 0 && _FlippedNormalBackfaces)
            {
                #ifndef EXCLUDE_NORMALOBJECT
                    i.normalObject = -i.normalObject;
                #endif
                i.normalWorld = -i.normalWorld;
                #ifndef EXCLUDE_TANGENT_BITANGENT
                    i.tangentWorld = -i.tangentWorld;
                    i.bitangentWorld = -i.bitangentWorld;
                #endif
                #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_FORWARDADD)
                    #ifndef EXCLUDE_TANGENT_VIEWDIR
                        i.tangentViewDir = -i.tangentViewDir; // necessary? test
                    #endif
                #endif
            }
        #endif
    #endif

    // Triplanar UVs
    // Object Space
    #ifndef EXCLUDE_NORMALOBJECT
        float3 tpObjBlendFactor = normalize(abs(i.normalObject));
    #else
        float3 tpObjBlendFactor = 1;
    #endif
    tpObjBlendFactor /= dot(tpObjBlendFactor, (float3)1);
    float2 tpObjX = 0;
    float2 tpObjY = 0;
    float2 tpObjZ = 0;
    if (_TriplanarUseVertexColors)
    {
    #ifndef EXCLUDE_VERTEX_COLORS
        tpObjX = i.color.yz;
        tpObjY = i.color.zx;
        tpObjZ = i.color.xy;
    #endif
    }
    #ifndef EXCLUDE_POSOBJECT
    else
    {
        tpObjX = i.posObject.yz;
        tpObjY = i.posObject.zx;
        tpObjZ = i.posObject.xy;
    }
    #endif

    // World Space
    float3 tpWorldBlendFactor = normalize(abs(i.normalWorld));
    tpWorldBlendFactor /= dot(tpWorldBlendFactor, (float3)1);
    float2 tpWorldX = i.posWorld.yz;
    float2 tpWorldY = i.posWorld.zx;
    float2 tpWorldZ = i.posWorld.xy;

    // Panosphere UVs
    float2 panoUV = PanosphereProjection(i.posWorld, _WorldSpaceCameraPos.xyz);

    #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_FORWARDADD)
        // Clearcoat first because it can affect viewDir and thus base layer parallax
        half3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
        half3 coatViewDir = viewDir;
        fixed4 _ClearcoatMask_var = 1;
        // Texture samples are culled via keywords before an optimized shader is locked in; this makes the
        // Unity editor much faster.  However, it means that a texture MUST exist in a slot before locking in -
        // this might be a problem if the texture slot is animated at runtime but starts empty.
        // It is also assumed to always exist if it exists when locked in, and so is always sampled.
        #ifdef PROP_CLEARCOATMASK
            #ifdef PROPGROUP_TOGGLE_CLEARCOAT
                if (group_toggle_Clearcoat)
                    //KSOInlineSamplerState(_MainTex, _ClearcoatMask)
                    OMEGA_SAMPLE_TEX2D(_ClearcoatMask_var, _ClearcoatMask, _MainTex);
            #endif
        #endif
        fixed clearcoatMask = _ClearcoatMaskMin + _ClearcoatMask_var[_ClearcoatMaskChannel] * (_ClearcoatMaskMax - _ClearcoatMaskMin);
        #ifdef PROPGROUP_TOGGLE_CLEARCOAT
            if (group_toggle_Clearcoat && _ClearcoatRefract)
            {
                half3 newViewDir = -Refract(viewDir, i.normalWorld, CLEAR_COAT_IETA);
                viewDir = lerp(viewDir, newViewDir, clearcoatMask);
            }
        #endif

        // Parallax next because it can affect other UVs
        #ifndef EXCLUDE_TANGENT_VIEWDIR
            #ifdef PROPGROUP_TOGGLE_PARALLAX
                UNITY_BRANCH
                if (group_toggle_Parallax)
                {
                    fixed4 _ParallaxMap_var = 1;
                    #ifdef PROP_PARALLAXMAP
                        // KSOInlineSamplerState   ( _MainTex,  _ParallaxMap )
                        OMEGA_SAMPLE_TEX2D(_ParallaxMap_var, _ParallaxMap, _MainTex);
                    #endif
                    i.tangentViewDir = normalize(i.tangentViewDir);
                    i.tangentViewDir.xy /= (i.tangentViewDir.z + _ParallaxBias);
                    half2 parallaxOffset = i.tangentViewDir.xy * _Parallax * (_ParallaxMap_var[_ParallaxMapChannel] - 0.5f);
                    #ifndef EXCLUDE_UV0
                        if (_ParallaxUV0)
                            i.uv0and1.xy += parallaxOffset;
                    #endif
                    #ifndef EXCLUDE_UV1
                        if (_ParallaxUV1)
                            i.uv0and1.zw += parallaxOffset;
                    #endif
                    #ifndef EXCLUDE_UV2
                        if (_ParallaxUV2)
                            i.uv2and3.xy += parallaxOffset;
                    #endif
                    #ifndef EXCLUDE_UV3
                        if (_ParallaxUV3)
                            i.uv2and3.zw += parallaxOffset;
                    #endif

                    // Triplanar parallax goes here
                }
            #endif
        #endif
    #endif

    // Opacity texture samples (MainTex, Converage, and Detail textures)
    // Also emission texture so Meta pass can return early
    // Default behaviour is to have all textures sampled by Albedo until you lock in with inline samplers
    // However, albedo will always be sampled using its own sampler

    // Texel size is used to determine if a texture is being used, combined with a uniform branch
    // Idk if this is actually more efficient, but it won't matter once the optimizer is run anyway
    // MainTex sample can't be skipped with a keyword as its sampler needs to exist for other textures
    // so it uses the old texel size based branch
    fixed4 _MainTex_var = 1;
    UNITY_BRANCH
    if (_MainTex_TexelSize.x != 1)
        OMEGA_SAMPLE_TEX2D(_MainTex_var, _MainTex, _MainTex);
    fixed4 _CoverageMap_var = 0;
    #ifdef PROP_COVERAGEMAP
        //KSOInlineSamplerState(_MainTex, _CoverageMap)
        OMEGA_SAMPLE_TEX2D(_CoverageMap_var, _CoverageMap, _MainTex);
    #endif
    fixed4 _DetailMask_var = 1;
    #ifdef PROP_DETAILMASK
        //KSOInlineSamplerState(_MainTex, _DetailMask)
        OMEGA_SAMPLE_TEX2D(_DetailMask_var, _DetailMask, _MainTex);
    #endif
    fixed _DetailAlbedoMapUV = _UVSec; // Temporary variables so the macro naming scheme works
    fixed _DetailAlbedoMapGreenUV = _UVSec;
    fixed _DetailAlbedoMapBlueUV = _UVSec;
    fixed _DetailAlbedoMapAlphaUV = _UVSec;
    fixed4 _DetailAlbedoMap_var = 0;
    fixed4 _DetailAlbedoMapGreen_var = 0;
    fixed4 _DetailAlbedoMapBlue_var = 0;
    fixed4 _DetailAlbedoMapAlpha_var = 0;
    #ifdef PROP_DETAILALBEDOMAP
        //KSOInlineSamplerState(_MainTex, _DetailAlbedoMap)
        OMEGA_SAMPLE_TEX2D(_DetailAlbedoMap_var, _DetailAlbedoMap, _MainTex);
    #endif
    #ifdef PROP_DETAILALBEDOMAPGREEN
        //KSOInlineSamplerState(_MainTex, _DetailAlbedoMapGreen)
        OMEGA_SAMPLE_TEX2D(_DetailAlbedoMapGreen_var, _DetailAlbedoMapGreen, _MainTex);
    #endif
    #ifdef PROP_DETAILALBEDOMAPBLUE
        //KSOInlineSamplerState(_MainTex, _DetailAlbedoMapBlue)
        OMEGA_SAMPLE_TEX2D(_DetailAlbedoMapBlue_var, _DetailAlbedoMapBlue, _MainTex);
    #endif
    #ifdef PROP_DETAILALBEDOMAPALPHA
        //KSOInlineSamplerState(_MainTex, _DetailAlbedoMapBlue)
        OMEGA_SAMPLE_TEX2D(_DetailAlbedoMapAlpha_var, _DetailAlbedoMapAlpha, _MainTex);
    #endif
    fixed4 _EmissionMap_var = 1;
    #ifdef PROP_EMISSIONMAP
        //KSOInlineSamplerState(_MainTex, _EmissionMap)
        OMEGA_SAMPLE_TEX2D(_EmissionMap_var, _EmissionMap, _MainTex);
    #endif

    //KSODuplicateTextureCheckStart

    // Early texture samples, _ParallaxMap and _ClearcoatMask must always be sampled independently because they affect other samples
    //KSODuplicateTextureCheck(_MainTex)
    //KSODuplicateTextureCheck(_CoverageMap)
    //KSODuplicateTextureCheck(_DetailMask)
    //KSODuplicateTextureCheck(_DetailAlbedoMap)
    //KSODuplicateTextureCheck(_DetailAlbedoMapGreen)
    //KSODuplicateTextureCheck(_DetailAlbedoMapBlue)
    //KSODuplicateTextureCheck(_DetailAlbedoMapAlpha)
    //KSODuplicateTextureCheck(_EmissionMap)

    // Opacity
    half3 albedo = _MainTex_var.rgb * _Color.rgb;
    #ifndef EXCLUDE_VERTEX_COLORS
        if (_VertexColorsEnabled)
            albedo *= i.color.rgb;
    #endif
    half opacity = 1;
    if (_AlbedoTransparencyEnabled)
        opacity = _MainTex_var.a;
    #ifdef PROP_COVERAGEMAP
        opacity = _CoverageMap_var[_CoverageMapChannel];
    #endif
    #ifdef PROP_DETAILMASK
        // Detail colors only applied if a mask is used
        opacity = lerp(opacity, opacity * _DetailColorR.a, _DetailMask_var.r);
        opacity = lerp(opacity, opacity * _DetailColorG.a, _DetailMask_var.g);
        opacity = lerp(opacity, opacity * _DetailColorB.a, _DetailMask_var.b);
        opacity = lerp(opacity, opacity * _DetailColorA.a, _DetailMask_var.a);
    #endif
    #ifdef PROP_DETAILALBEDOMAP
        // always lerp
        opacity = lerp(opacity, opacity * _DetailAlbedoMap_var.a, _DetailMask_var.r);
    #endif
    #ifdef PROP_DETAILALBEDOMAPGREEN
        opacity = lerp(opacity, opacity * _DetailAlbedoMapGreen_var.a, _DetailMask_var.g);
    #endif
    #ifdef PROP_DETAILALBEDOMAPBLUE
        opacity = lerp(opacity, opacity * _DetailAlbedoMapBlue_var.a, _DetailMask_var.b);
    #endif
    #ifdef PROP_DETAILALBEDOMAPALPHA
        opacity = lerp(opacity, opacity * _DetailAlbedoMapAlpha_var.a, _DetailMask_var.a);
    #endif
    opacity *= _Color.a;
    #ifndef EXCLUDE_VERTEX_COLORS
        if (_VertexColorsEnabled)
            opacity *= i.color.a;
    #endif

    // Shadowcaster clip and return
    #ifdef UNITY_PASS_SHADOWCASTER
        opacity += 0.01;
        UNITY_BRANCH
        if (_DitheredShadows && _Mode >= 1 && _Mode <= 3)
            clip(tex3D(_DitherMaskLOD, float3(i.vpos.xy * 0.25, opacity * 0.9375)).a - 0.01);
        clip(opacity - _Cutoff);
        SHADOW_CASTER_FRAGMENT(i)
    // Meta clip and return
    #elif defined(UNITY_PASS_META)
        UNITY_BRANCH
        if (_Mode >= 1 && _Mode <= 3)
            clip(opacity - _Cutoff);
        UnityMetaInput o;
        UNITY_INITIALIZE_OUTPUT(UnityMetaInput, o);
        o.Albedo = albedo;
        #ifdef EDITOR_VISUALIZATION
            o.VizUV = i.vizUV;
            o.LightCoord = i.lightCoord;
        #endif
        half3 emissionScale;
        if (_EmissionMapChannel < 4)
            emissionScale = _EmissionMap_var[_EmissionMapChannel];
        else emissionScale = _EmissionMap_var.rgb;
        o.Emission = _EmissionColor.rgb * lerp(emissionScale, o.Albedo.rgb * emissionScale, _EmissionTintByAlbedo) * _RealtimeGIIntensity;
        return UnityMetaFragment(o);

#else // The rest of the frag is ForwardBase and ForwardAdd stuff

    // Alpha to Coverage sharpening
    #ifndef EXCLUDE_UV0AND1
        UNITY_BRANCH
        if (_Mode == 1 && _AlphaToMask) // _ALPHATEST_ON
        {
            // Cutout mode with A2C is always sharpened
            // Needs to be corrected if coverage map is used instead and for different UV sets
            opacity *= 1 + max(0, CalcMipLevel(i.uv0and1.xy * _MainTex_TexelSize.zw)) * 0.25;
            opacity = saturate((opacity - _Cutoff) / max(fwidth(opacity), 0.0001) + 0.5);
        }
    #endif
    // Clipping
    UNITY_BRANCH
    if (_Mode >= 1 && _Mode <= 3) // _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
    {
        // Dithering
        #ifndef EXCLUDE_GRABPOS
            UNITY_BRANCH
            if (_DitheringEnabled)
            {
                half dither = ditherBayer(stereoCorrectScreenUV(i.grabPos));
                // hack because opacity with vertex color imprecision makes dithering visible at full white
                // I tried saturating in case it was forced centroid interpolation on COLOR semantic data
                // but that didn't help, so adding this bias to prevent the glitch effect
                dither -= 0.01; 
                UNITY_BRANCH
                if (_AlphaToMask)
                    opacity = opacity - (dither * (1 - opacity) * 0.15);
                else 
                    clip(opacity - dither);
            }
        #endif

        // Cutoff
        UNITY_BRANCH
        if (!_AlphaToMask)
            clip(opacity - _Cutoff);
    }

    // The rest of the texture samples
    fixed4 _MetallicGlossMap_var = 1;
    #ifdef PROP_METALLICGLOSSMAP
        //KSOInlineSamplerState(_MainTex, _MetallicGlossMap)
        OMEGA_SAMPLE_TEX2D(_MetallicGlossMap_var, _MetallicGlossMap, _MainTex);
    #endif
    fixed4 _SpecGlossMap_var = 1;
    #ifdef PROP_SPECGLOSSMAP
        //KSOInlineSamplerState(_MainTex, _SpecGlossMap)
        OMEGA_SAMPLE_TEX2D(_SpecGlossMap_var, _SpecGlossMap, _MainTex);
    #endif
    fixed4 _OcclusionMap_var = 1;
    #ifdef PROP_OCCLUSIONMAP
        //KSOInlineSamplerState(_MainTex, _OcclusionMap)
        OMEGA_SAMPLE_TEX2D(_OcclusionMap_var, _OcclusionMap, _MainTex);
    #endif
    fixed4 _SpecularMap_var = 1;
    #ifdef PROP_SPECULARMAP
        //KSOInlineSamplerState(_MainTex, _SpecularMap)
        OMEGA_SAMPLE_TEX2D(_SpecularMap_var, _SpecularMap, _MainTex);
    #endif
    fixed _DetailNormalMapUV = _UVSec;
    fixed _DetailNormalMapGreenUV = _UVSec;
    fixed _DetailNormalMapBlueUV = _UVSec;
    fixed _DetailNormalMapAlphaUV = _UVSec;
    half4 _BumpMap_var = 0;
    #ifdef PROP_BUMPMAP
        //KSOInlineSamplerState(_MainTex, _BumpMap)
        OMEGA_SAMPLE_TEX2D(_BumpMap_var, _BumpMap, _MainTex);
    #endif
    fixed4 _DetailNormalMap_var = 0;
    #ifdef PROP_DETAILNORMALMAP
        //KSOInlineSamplerState(_MainTex, _DetailNormalMap)
        OMEGA_SAMPLE_TEX2D(_DetailNormalMap_var, _DetailNormalMap, _MainTex);
    #endif
    fixed4 _DetailNormalMapGreen_var = 0;
    #ifdef PROP_DETAILNORMALMAPGREEN
        //KSOInlineSamplerState(_MainTex, _DetailNormalMapGreen)
        OMEGA_SAMPLE_TEX2D(_DetailNormalMapGreen_var, _DetailNormalMapGreen, _MainTex);
    #endif
    fixed4 _DetailNormalMapBlue_var = 0;
    #ifdef PROP_DETAILNORMALMAPBLUE
        //KSOInlineSamplerState(_MainTex, _DetailNormalMapBlue)
        OMEGA_SAMPLE_TEX2D(_DetailNormalMapBlue_var, _DetailNormalMapBlue, _MainTex);
    #endif
    fixed4 _DetailNormalMapAlpha_var = 0;
    #ifdef PROP_DETAILNORMALMAPALPHA
        //KSOInlineSamplerState(_MainTex, _DetailNormalMapAlpha)
        OMEGA_SAMPLE_TEX2D(_DetailNormalMapAlpha_var, _DetailNormalMapAlpha, _MainTex);
    #endif
    fixed4 _TranslucencyMap_var = 0;
    #ifdef PROP_TRANSLUCENCYMAP
        #ifdef PROPGROUP_TOGGLE_SSSTRANSMISSION
            UNITY_BRANCH
            if (group_toggle_SSSTransmission)
                //KSOInlineSamplerState(_MainTex, _TranslucencyMap)
                OMEGA_SAMPLE_TEX2D(_TranslucencyMap_var, _TranslucencyMap, _MainTex);
        #endif
    #endif
    fixed4 blurredWorldNormal_var = 0;
    // only main normal map affects skin, since its going to be blurred anyway
    #ifdef PROP_BUMPMAP
        UNITY_BRANCH
        if (_DiffuseMode == 2) 
            //KSOInlineSamplerState(_MainTex, _BumpMap)
            OMEGA_SAMPLE_TEX2D_BIAS(blurredWorldNormal_var, _BumpMap, _MainTex, _BumpBlurBias);
    #endif
    fixed4 _SpecularAnisotropyTangentMap_var = 1;
    //UNITY_BRANCH
    //if (_SpecularMode == 2 && _SpecularAnisotropyTangentMap_TexelSize.x != 1)
        ////KSOInlineSamplerState(_MainTex, _SpecularAnisotropyTangentMap)
        //OMEGA_SAMPLE_TEX2D(_SpecularAnisotropyTangentMap_var, _SpecularAnisotropyTangentMap, _MainTex);

    // Duplicate texture checks, second bumpmap bias sample always done separately
    //KSODuplicateTextureCheck(_MetallicGlossMap)
    //KSODuplicateTextureCheck(_SpecGlossMap)
    //KSODuplicateTextureCheck(_OcclusionMap)
    //KSODuplicateTextureCheck(_SpecularMap)
    //KSODuplicateTextureCheck(_BumpMap)
    //KSODuplicateTextureCheck(_DetailNormalMap)
    //KSODuplicateTextureCheck(_DetailNormalMapGreen)
    //KSODuplicateTextureCheck(_DetailNormalMapBlue)
    //KSODuplicateTextureCheck(_DetailNormalMapAlpha)
    //KSODuplicateTextureCheck(_TranslucencyMap)

    // Assign shading variables
    // Map textures to PBR variables and filter them
    fixed metallic = 1;
    #ifdef PROP_METALLICGLOSSMAP
        metallic = _MetallicGlossMap_var[_MetallicGlossMapChannel];
    #endif
    metallic = _MetallicMin + metallic * (_Metallic - _MetallicMin);
    fixed3 occlusion = 1;
    #ifdef PROP_OCCLUSIONMAP
        if (_OcclusionMapChannel < 4)
            occlusion = _OcclusionMap_var[_OcclusionMapChannel];
        else occlusion = _OcclusionMap_var.rgb;
    #endif
    occlusion = lerp(1, occlusion, _OcclusionStrength);
    if (_DiffuseMode == 2) // Color bleed only available on Skin diffuse, may change later. Occlusion tint is also a thing
        occlusion = pow(occlusion, 1 - _AOColorBleed);
    fixed perceptualRoughness = 1;
    #ifdef PROP_SPECGLOSSMAP
        perceptualRoughness = _SpecGlossMap_var[_SpecGlossMapChannel];
    #endif
    if (_GlossinessMode == 1)
        perceptualRoughness = 1.0 - perceptualRoughness;
    perceptualRoughness = _GlossinessMin + perceptualRoughness * (_Glossiness - _GlossinessMin);
    fixed3 specular = 1;
    #ifdef PROP_SPECULARMAP
        if (_SpecularMapChannel < 4)
            specular = _SpecularMap_var[_SpecularMapChannel];
        else specular = _SpecularMap_var.rgb;
    #endif
    specular = _SpecularMin + specular * (_SpecularMax - _SpecularMin);
    specular *= _SpecColor;
    // Details
    #ifdef PROP_DETAILMASK
        // Detail colors only applied if a mask is applied
        albedo.rgb = lerp(albedo.rgb, albedo.rgb * _DetailColorR.rgb, _DetailMask_var.r);
        albedo.rgb = lerp(albedo.rgb, albedo.rgb * _DetailColorG.rgb, _DetailMask_var.g);
        albedo.rgb = lerp(albedo.rgb, albedo.rgb * _DetailColorB.rgb, _DetailMask_var.b);
        albedo.rgb = lerp(albedo.rgb, albedo.rgb * _DetailColorA.rgb, _DetailMask_var.a);
    #endif
    #ifdef PROP_DETAILALBEDOMAP
        albedo = switchDetailAlbedo(_DetailAlbedoMap_var, albedo, _DetailAlbedoCombineMode, _DetailMask_var.r);
    #endif
    #ifdef PROP_DETAILALBEDOMAPGREEN
        albedo = switchDetailAlbedo(_DetailAlbedoMapGreen_var, albedo, _DetailAlbedoCombineMode, _DetailMask_var.g);
    #endif
    #ifdef PROP_DETAILALBEDOMAPBLUE
        albedo = switchDetailAlbedo(_DetailAlbedoMapBlue_var, albedo, _DetailAlbedoCombineMode, _DetailMask_var.b);
    #endif
    #ifdef PROP_DETAILALBEDOMAPALPHA
        albedo = switchDetailAlbedo(_DetailAlbedoMapAlpha_var, albedo, _DetailAlbedoCombineMode, _DetailMask_var.a);
    #endif
    // Normals
    half3 blendedNormal = half3(0,0,1);
    #ifdef PROP_BUMPMAP
        blendedNormal = UnpackScaleNormal(_BumpMap_var, _BumpScale);
    #endif
    #ifdef PROP_DETAILNORMALMAP
        blendedNormal = lerp(blendedNormal, BlendNormals(blendedNormal, UnpackScaleNormal(_DetailNormalMap_var, _DetailNormalMapScale)), _DetailMask_var.r);
    #endif
    #ifdef PROP_DETAILNORMALMAPGREEN
        blendedNormal = lerp(blendedNormal, BlendNormals(blendedNormal, UnpackScaleNormal(_DetailNormalMapGreen_var, _DetailNormalMapScaleGreen)), _DetailMask_var.g);
    #endif
    #ifdef PROP_DETAILNORMALMAPBLUE
        blendedNormal = lerp(blendedNormal, BlendNormals(blendedNormal, UnpackScaleNormal(_DetailNormalMapBlue_var, _DetailNormalMapScaleBlue)), _DetailMask_var.b);
    #endif
    #ifdef PROP_DETAILNORMALMAPALPHA
        blendedNormal = lerp(blendedNormal, BlendNormals(blendedNormal, UnpackScaleNormal(_DetailNormalMapAlpha_var, _DetailNormalMapScaleAlpha)), _DetailMask_var.a);
    #endif
    #ifndef EXCLUDE_TANGENT_BITANGENT
        float3x3 tangentToWorld = float3x3(i.tangentWorld, i.bitangentWorld, i.normalWorld);
        fixed3 normalDir = normalize(mul(blendedNormal, tangentToWorld));
    #else
        fixed3 normalDir = i.normalWorld;
    #endif
    fixed translucency = 0;
    #ifdef PROPGROUP_TOGGLE_SSSTRANSMISSION
        if (group_toggle_SSSTransmission)
            translucency = _SSSTranslucencyMin + _TranslucencyMap_var[_TranslucencyMapChannel] * (_SSSTranslucencyMax - _SSSTranslucencyMin);
    #endif
    // Common vars
    #ifndef EXCLUDE_UV0AND1
        float2 lightmapUV = i.uv0and1.zw * unity_LightmapST.xy + unity_LightmapST.zw;
    #else
        float2 lightmapUV = 0;
    #endif
    #ifndef EXCLUDE_UV2AND3
        float2 dynamicLightmapUV = i.uv2and3.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
    #else
        float2 dynamicLightmapUV = 0;
    #endif
    fixed3 lightDir = getLightDirection(i.posWorld.xyz, lightmapUV); 
    #ifdef UNITY_PASS_FORWARDBASE
        if (_FakeLightToggle)
            lightDir = _FakeLightDirection.xyz;
    #endif
    fixed3 viewReflectDir = reflect(-viewDir, normalDir);
    float3 halfDir = Unity_SafeNormalize (lightDir + viewDir); // BRDF friendly normalize
    fixed3 lightReflectDir = reflect(lightDir, normalDir);
    float NdotL = saturate(dot(normalDir, lightDir));
    half NdotV = abs(dot(normalDir, viewDir)); // abs to get backside rimlight?
    float NdotH = saturate(dot(normalDir, halfDir));
    half LdotV = saturate(dot(lightDir, viewDir));
    half LdotH = saturate(dot(lightDir, halfDir));
    fixed RVdotL = max(0, dot(viewReflectDir, lightDir));
    half3 F0;
    half oneMinusReflectivity;
    if (_WorkflowMode == 0) // Metallic workflow
    {
        // ComputeFresnel0?
        F0 = lerp (unity_ColorSpaceDielectricSpec.rgb, albedo, metallic) * specular;
        oneMinusReflectivity = unity_ColorSpaceDielectricSpec.a - metallic * unity_ColorSpaceDielectricSpec.a;
    }
    else // Specular workflow
    {
        F0 = specular;
        oneMinusReflectivity = 1 - SpecularStrength(F0);
    }
    // Set skin specular value (F0 = 0.028)
    // Skin specular isn't so much a separate mode as it is a preset for Specular workflow and a spec color
    // Technically does affect diffuse too
    if (_SpecularMode == 3)
    {
        F0 = unity_ColorSpaceDielectricSpec.rgb * 0.7;
        oneMinusReflectivity = 1 - SpecularStrength(F0);
    }
    // Clearcoat - slightly roughen base layer and modify F0
    half cc_oneMinusReflectivity;
    #ifdef PROPGROUP_TOGGLE_CLEARCOAT
        if (group_toggle_Clearcoat)
        {
            // bsdfData.fresnel0 = lerp(IorToFresnel0(ior).xxx, baseColor, metallic);
            F0 = lerp(F0, ConvertF0ForAirInterfaceToF0ForClearCoat15(F0), _ClearcoatFresnelInfluence * clearcoatMask);
            //F0 = lerp(F0, ConvertF0ForAirInterfaceToF0ForNewTopIor(F0, CLEAR_COAT_IOR), clearcoatMask);
            float ieta = lerp(1.0, CLEAR_COAT_IETA, clearcoatMask);
            float sigma = RoughnessToVariance(PerceptualRoughnessToRoughness(perceptualRoughness));
            perceptualRoughness = lerp(perceptualRoughness, RoughnessToPerceptualRoughness(VarianceToRoughness(sigma * ieta*ieta)), _ClearcoatRoughnessInfluence);
            cc_oneMinusReflectivity = 1 - SpecularStrength(CLEAR_COAT_F0);
        }
    #endif
    // Clearcoat non-refracted, non-normal map affected vars
    fixed3 cc_viewReflectDir = reflect(-coatViewDir, i.normalWorld);
    float3 cc_halfDir = Unity_SafeNormalize (lightDir + coatViewDir); // BRDF friendly normalize
    fixed3 cc_lightReflectDir = reflect(lightDir, i.normalWorld);
    float cc_NdotL = saturate(dot(i.normalWorld, lightDir));
    half cc_NdotV = abs(dot(i.normalWorld, coatViewDir)); // abs to get backside rimlight?
    float cc_NdotH = saturate(dot(i.normalWorld, cc_halfDir));
    half cc_LdotV = saturate(dot(lightDir, coatViewDir));
    half cc_LdotH = saturate(dot(lightDir, cc_halfDir));
    fixed cc_RVdotL = max(0, dot(cc_viewReflectDir, lightDir));
    half smoothness = 1.0f - perceptualRoughness;
    float roughness = max(PerceptualRoughnessToRoughness(perceptualRoughness), 0.002);
    half3 diffColor = albedo * oneMinusReflectivity;
    // Premultiplied transparency
    UNITY_BRANCH
    if (_Mode == 3) // _ALPHAPREMULTIPLY_ON
    {
        diffColor *= opacity;
        opacity = 1-oneMinusReflectivity + opacity*oneMinusReflectivity;
    }
    half4 color = 0;
    color.a = opacity;
    // Pre-Integrated skin variables
    half3 blurredWorldNormal = half3(0,0,1);
    fixed Curvature = 0;
    UNITY_BRANCH
    if (_DiffuseMode == 2)
    {
        #ifndef EXCLUDE_TANGENT_BITANGENT
            #ifdef PROP_BUMPMAP
                // Blur main normal map via tex2Dbias
                blurredWorldNormal = UnpackScaleNormal(blurredWorldNormal_var, _BumpScale);
                // Lerp blurred normal against combined normal by blur strength
                blurredWorldNormal = lerp(blendedNormal, blurredWorldNormal, _BlurStrength);
                blurredWorldNormal = normalize(mul(blurredWorldNormal, tangentToWorld));
            #endif
        #endif

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
    // Anisotropic variables
    // Two roughness params from a single anisotropy parameter
    // Would be better to have full independent roughness control in the future
    float roughnessT = roughness;
    float roughnessB = lerp(0.002, roughness, 1-_SpecularAnisotropy);
    // Use tangent map if it exists
    //UNITY_BRANCH
    //if (_SpecularAnisotropyTangentMap_TexelSize.x != 1)
    //{
        //_SpecularAnisotropyTangentMap_var.xyz = UnpackNormal(_SpecularAnisotropyTangentMap_var);
        // blend with unmultiplied tangent space normal (from normal map?)
        // perturb tangent then recalculate bitangent?
        // rotate tanget and bitangent
        // tangentDirectionMap = mul(tangentToWorld, float3(normalLocalAniso.rg, 0.0)).xyz; ?
    //}
    // Rotate tangent/bitangent via the tangentToWorld matrix
    half anisotropyTheta = radians((_SpecularAnisotropyAngle * 2 - 1) * 90);
    half3 rotatedTangent = half3(cos(anisotropyTheta), sin(anisotropyTheta), 0);
    #ifndef EXCLUDE_TANGENT_BITANGENT
        rotatedTangent = normalize(mul(rotatedTangent, tangentToWorld));
        half3 rotatedBitangent = normalize(cross(i.normalWorld, rotatedTangent));
        half TdotH = dot(rotatedTangent, halfDir);
        half BdotH = dot(rotatedBitangent, halfDir);
        half TdotV = dot(rotatedTangent, viewDir);
        half BdotV = dot(rotatedBitangent, viewDir);
        half TdotL = dot(rotatedTangent, lightDir);
        half BdotL = dot(rotatedBitangent, lightDir);
    #endif


    // GI samples and lighting variables
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
            float zDist = dot(_WorldSpaceCameraPos - i.posWorld.xyz, UNITY_MATRIX_V[2].xyz);
            float fadeDist = UnityComputeShadowFadeDistance(i.posWorld.xyz, zDist);
            attenuation = UnityMixRealtimeAndBakedShadows(attenuation, bakedAtten, UnityComputeShadowFade(fadeDist));
        #endif
        #if UNITY_SHOULD_SAMPLE_SH
            half3 indirect_diffuse_normal = normalDir;
            if (_DiffuseMode == 3) // Flat lit light, vertex lights are sampled with regular normal
                indirect_diffuse_normal = 0;
            indirect_diffuse = VertexLightsDiffuse(indirect_diffuse_normal, i.posWorld.xyz) * _VertexLightIntensity;
            indirect_diffuse += ShadeSHPerPixelModular(indirect_diffuse_normal, i.posWorld.xyz) * _LightProbeIntensity;
            // Stylized indirect diffuse transmission
            #ifndef EXCLUDE_POSOBJECT
                #ifdef PROPGROUP_TOGGLE_SSSTRANSMISSION
                    if (group_toggle_SSSTransmission && _SSSStylizedIndirect > 0)
                    {
                        half3 stylized_transmission_normal = UnityObjectToWorldNormal(i.posObject.xyz); // probably needs to be normalized
                        half3 stylized_indirect_diffuse_transmission = VertexLightsDiffuse(stylized_transmission_normal, i.posWorld.xyz) * _VertexLightIntensity;
                        stylized_indirect_diffuse_transmission += ShadeSHPerPixelModular(stylized_transmission_normal, i.posWorld.xyz) * _LightProbeIntensity;
                        indirect_diffuse = lerp(indirect_diffuse, stylized_indirect_diffuse_transmission, 
                                            _SSSStylizedIndirect * (_SSSStylizedIndrectScaleByTranslucency ? translucency : 1));
                    }
                #endif
            #endif
            #ifdef UNITY_COLORSPACE_GAMMA
                indirect_diffuse = LinearToGammaSpace(indirect_diffuse);
            #endif
            indirect_diffuse *= _IndirectLightIntensity;
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
    indirect_diffuse *= occlusion;
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
    half3 clearcoat_indirect_specular = 0;
    #ifdef UNITY_PASS_FORWARDBASE
        UNITY_BRANCH
        if (_GlossyReflections)
        {
            half3 reflectionsSampleViewReflectDir = viewReflectDir;
            #ifndef EXCLUDE_TANGENT_BITANGENT
                UNITY_BRANCH
                if (_ReflectionsMode == 3) // Anisotropic reflections indirect specular
                    reflectionsSampleViewReflectDir = AngledAnisotropicModifiedNormal(normalDir, i.tangentWorld, i.bitangentWorld, viewDir, _ReflectionsAnisotropyAngle, _ReflectionsAnisotropy);
            #endif

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
        
            #ifdef PROPGROUP_TOGGLE_CLEARCOAT
                UNITY_BRANCH
                if (group_toggle_Clearcoat)
                    clearcoat_indirect_specular = UnityGI_IndirectSpecularModular(cc_viewReflectDir, i.posWorld.xyz, CLEAR_COAT_PERCEPTUAL_ROUGHNESS);
            #endif
        }
        else indirect_specular = unity_IndirectSpecColor.rgb;
        indirect_specular *= occlusion * _ReflectionsIntensity;
    #endif


    // BRDF (apdapted from Unity Standard BRDF1)
    // Diffuse
    half3 diffuse_term = albedo; // Unlit
    #ifdef PROPGROUP_TOGGLE_DIFFUSE
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
                    diffuse_term = diffColor * (indirect_diffuse + lightColorAttenuationNoShadows * wrappedDiffuse * direct_diffuse_occlusion); // ignore received shadows completely?
                }
                else diffuse_term = diffColor * (indirect_diffuse + lightColor * NdotL);
            }
            else if (_DiffuseMode == 1) // PBR
            {
                half3 diffuseTerm = DisneyDiffuse(NdotV, NdotL, LdotH, perceptualRoughness) * NdotL;
                diffuse_term = diffColor * (indirect_diffuse + lightColor * diffuseTerm * direct_diffuse_occlusion);
            }
            else if (_DiffuseMode == 2) // Skin
            {
                float NdotLBlurredUnclamped = dot(blurredWorldNormal, lightDir);
                NdotLBlurredUnclamped = NdotLBlurredUnclamped * 0.5 + 0.5;
                // Pre integrated skin lookup tex serves as the BRDF diffuse term
                //KSOInlineSamplerState(_trilinear_clamp, _PreIntSkinTex)
                half3 brdf = UNITY_SAMPLE_TEX2D_SAMPLER_LOD(_PreIntSkinTex, _trilinear_clamp, half2(NdotLBlurredUnclamped, Curvature), 0);
                diffuse_term = diffColor * (indirect_diffuse + lightColor * brdf * direct_diffuse_occlusion);
            }
            else if (_DiffuseMode == 3) // Flat Lit
            {
                diffuse_term = diffColor * min(half3(1,1,1), indirect_diffuse + lightColor * direct_diffuse_occlusion); // wonky solution so light dosn't go HDR
            }
        }
    #endif

    // Direct Specular
    half3 specular_term = 0;
    #ifdef PROPGROUP_TOGGLE_SPECULAR
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
                specular_term = specularTerm * _PhongSpecularIntensity * lightColor * specular;
            }
            else if (_SpecularMode == 1 || _SpecularMode == 2 || _SpecularMode == 3) // PBR, Anisotropic, and Skin
            {
                float V = 0;
                float D = 0;

                UNITY_BRANCH
                if (_SpecularMode == 2)
                {
                    #ifndef EXCLUDE_TANGENT_BITANGENT
                        V = SmithJointGGXAniso(TdotV, BdotV, NdotV, TdotL, BdotL, NdotL, roughnessT, roughnessB);
                        D = GGXTerm_Aniso(TdotH, BdotH, roughnessT, roughnessB, NdotH);
                    #endif
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
                specular_term = specularTerm * lightColor * FresnelTerm (F0, LdotH);
            }
        }
    #endif

    // Clearcoat specular
    half3 clearcoat_specular_term = 0;
    #ifdef PROPGROUP_TOGGLE_CLEARCOAT
        UNITY_BRANCH
        if (group_toggle_Clearcoat)
        {
            // Isotropic GGX, could probably offer specular modes here too, but best for now to just do a standardized PBR method
            float V = SmithJointGGXVisibilityTerm (cc_NdotL, cc_NdotV, CLEAR_COAT_ROUGHNESS);
            float D = GGXTerm (cc_NdotH, CLEAR_COAT_ROUGHNESS);
            half3 specularTerm = V*D * UNITY_PI;
            #ifdef UNITY_COLORSPACE_GAMMA
                specularTerm = sqrt(max(1e-4h, specularTerm));
            #endif
            specularTerm = max(0, specularTerm * cc_NdotL);
            specularTerm = lerp(specularTerm, specularTerm * occlusion, _OcclusionDirectSpecular); // eh
            clearcoat_specular_term = specularTerm * lightColor * FresnelTerm (CLEAR_COAT_F0, cc_LdotH) * clearcoatMask;
        }
    #endif

    // Reflections (Indirect Specular)
    half3 reflections_term = 0;
    half3 clearcoat_reflections_term = 0;
    #ifdef UNITY_PASS_FORWARDBASE
        #ifdef PROPGROUP_TOGGLE_REFLECTIONS
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
                    reflections_term = surfaceReduction * indirect_specular * FresnelLerp (F0, grazingTerm, NdotV) * _StandardFresnelIntensity;
                }
                else if (_ReflectionsMode == 2) // Skin aka Lazarov environmental
                {
                    const half4 c0 = { -1, -0.0275, -0.572, 0.022 };
                    const half4 c1 = { 1, 0.0425, 1.04, -0.04 };
                    half4 r = perceptualRoughness * c0 + c1;
                    half a004 = min( r.x * r.x, exp2( -9.28 * NdotV ) ) * r.x + r.y;
                    half2 AB = half2( -1.04, 1.04 ) * a004 + r.zw;
                    half3 F_L = F0 * AB.x + AB.y;
                    reflections_term = indirect_specular * F_L;
                }
            }
        #endif
        #ifdef PROPGROUP_TOGGLE_CLEARCOAT
            UNITY_BRANCH
            if (group_toggle_Clearcoat)
            {
                // clearcoat_indirect_specular
                half surfaceReduction;
                #ifdef UNITY_COLORSPACE_GAMMA
                    surfaceReduction = 1.0-0.28*CLEAR_COAT_ROUGHNESS*CLEAR_COAT_PERCEPTUAL_ROUGHNESS;      // 1-0.28*x^3 as approximation for (1/(x^4+1))^(1/2.2) on the domain [0;1]
                #else
                    surfaceReduction = 1.0 / (CLEAR_COAT_ROUGHNESS*CLEAR_COAT_ROUGHNESS + 1.0);           // fade \in [0.5;1]
                #endif
                half grazingTerm = saturate(CLEAR_COAT_PERCEPTUAL_SMOOTHNESS + (1-cc_oneMinusReflectivity));
                clearcoat_reflections_term = surfaceReduction * clearcoat_indirect_specular * FresnelLerp (CLEAR_COAT_F0, grazingTerm, cc_NdotV) * clearcoatMask;
            }
        #endif
    #endif

    // Subsurface Transmission
    half3 transmission_term = 0;
    #ifdef PROPGROUP_TOGGLE_SSSTRANSMISSION
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
                    transmission_term = transDot * _SubsurfaceColor * transmissionLightColor;
                #endif
            }
            else transmission_term = transDot * _SubsurfaceColor * transmissionLightColor;
        }
    #endif

    // Emission
    half3 emission_term = 0;
    #ifdef UNITY_PASS_FORWARDBASE
        half3 emissionScale;
        if (_EmissionMapChannel < 4)
            emissionScale = _EmissionMap_var[_EmissionMapChannel];
        else emissionScale = _EmissionMap_var.rgb;
        emission_term = _EmissionColor.rgb * lerp(emissionScale, albedo.rgb * emissionScale, _EmissionTintByAlbedo);
    #endif

    // Combine all brdf terms and rough conserve energy
    color.rgb += diffuse_term + max(specular_term, clearcoat_specular_term) + max(reflections_term, clearcoat_reflections_term) + transmission_term + emission_term;
    if (!_HDREnabled) // Incorrect HDR limit - needs to affect indirect+direct light intensity
        color.rgb = saturate(color.rgb);

    // Fog
    #ifndef EXCLUDE_FOG_COORDS
        if (_ReceiveFog > 0)
        {
            half4 foggedColor = color;
            UNITY_APPLY_FOG(i.fogCoord, foggedColor);
            color = lerp(color, foggedColor, _ReceiveFog);
        }
    #endif

    // Debug
    if (_DebugWorldNormals)
        #ifdef UNITY_PASS_FORWARDBASE
            color.rgb = normalDir;
        #else
            color.rgb = 0;
        #endif
    if (_DebugOcclusion)
        #ifdef UNITY_PASS_FORWARDBASE
            color.rgb = occlusion;
        #else
            color.rgb = 0;
        #endif
    #ifndef EXCLUDE_VERTEX_COLORS
        if (_DebugWireframe && group_toggle_Geometry && group_toggle_GeometryForwardBase)
        {
            #ifdef UNITY_PASS_FORWARDBASE
                float minBary = min(i.color.x, min(i.color.y, i.color.z));
                float delta = abs(ddx(minBary)) + abs(ddy(minBary));
                color.rgb = smoothstep(0, delta, minBary);
            #else
                color.rgb = 0;
            #endif
        }
    #endif

    return color;
#endif
}


#endif