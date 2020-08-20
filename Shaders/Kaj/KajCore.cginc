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
UNITY_DECLARE_TEX2D(_MainTex);                          // Standard main texture
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
// Problem using tex2Dbias with the Unity sampler definition
UNITY_DECLARE_TEX2D(_BumpMap);                          // Standard normal map
//sampler2D _BumpMap;
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
UNITY_DECLARE_TEX2D(_DetailAlbedoMap);                  // Standard mid-gray detail map
    uniform float4 _DetailAlbedoMap_ST;
    uniform float4 _DetailAlbedoMap_TexelSize;
uniform half _DetailNormalMapScale;                     // Standard detail normal map scale
UNITY_DECLARE_TEX2D(_DetailNormalMap);                  // Standard detail normal map
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
uniform float _ForceOpaque;                             // In case albedo alpha isn't transparency
uniform float _DitheringEnabled;                        // Dithered transparency toggle

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
uniform float _MetallicGlossMapCombinedMapChannel;      // _CombinedMap RGBA selection for Metallic
uniform float _SpecGlossMapCombinedMapChannel;          // _CombinedMap RGBA selection for Roughness/Smoothness
uniform float _OcclusionMapCombinedMapChannel;          // _CombinedMap RGBA selection for Occlusion
uniform float _SpecularMapCombinedMapChannel;           // _CombinedMap RGBA selection for Specular scale
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
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailAlbedoMapGreen);   // 2nd detail map
    uniform float4 _DetailAlbedoMapGreen_ST;
    uniform float4 _DetailAlbedoMapGreen_TexelSize;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailAlbedoMapBlue);    // 3rd detail map
    uniform float4 _DetailAlbedoMapBlue_ST;
    uniform float4 _DetailAlbedoMapBlue_TexelSize;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailNormalMapGreen);   // 2nd detail normal map
    uniform float4 _DetailNormalMapGreen_ST;
    uniform float4 _DetailNormalMapGreen_TexelSize;
    uniform float _DetailNormalMapScaleGreen;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailNormalMapBlue);    // 3rd detail normal map
    uniform float4 _DetailNormalMapBlue_ST;
    uniform float4 _DetailNormalMapBlue_TexelSize;
    uniform float _DetailNormalMapScaleBlue;
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
// Problem using tex2Dlod with the Unity texture macro
//UNITY_DECLARE_TEX2D(_PreIntSkinTex);
sampler2D _PreIntSkinTex;                               // BRDF diffuse term lookup texture
uniform float _BumpBlurBias;                            // Pre-Integrated Skin parameters
uniform float _BlurStrength;                            // Pre-Integrated Skin parameters
uniform float _CurvatureInfluence;                      // Pre-Integrated Skin parameters
uniform float _CurvatureScale;                          // Pre-Integrated Skin parameters
uniform float _CurvatureBias;                           // Pre-Integrated Skin parameters
uniform float group_toggle_SSSTransmission;
UNITY_DECLARE_TEX2D_NOSAMPLER(_TranslucencyMap);        // Subsurface Transmission relative thickness map
    uniform float4 _TranslucencyMap_ST;
    uniform float4 _TranslucencyMap_TexelSize;
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
uniform float _SSSStylizedIndirectIntensity;
uniform float _BumpMapUV;
uniform float _EmissionMapUV;
uniform float _MetallicGlossMapUV;
uniform float _SpecGlossMapUV;
uniform float _SpecularMapUV;
uniform float _CombinedMapUV;
uniform float _DetailMaskUV;
uniform float _ParallaxMapUV;
uniform float _TranslucencyMapUV;
uniform float _ParallaxUV0;
uniform float _ParallaxUV1;
uniform float _ParallaxUV2;
uniform float _ParallaxUV3;
uniform float _TriplanarUseVertexColors;

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

// Unity texture declarations and sampler macros (HLSLSupport.cginc) don't have tex2Dbias or tex2Dlod
#define UNITY_SAMPLE_TEX2D_BIAS(tex,coord,bias) tex.SampleBias (sampler##tex,coord,bias)
#define UNITY_SAMPLE_TEX2D_SAMPLER_BIAS(tex,samplertex,coord,bias) tex.SampleBias (sampler##samplertex,coord,bias)
#define UNITY_SAMPLE_TEX2D_LOD(tex,coord,lod) tex.SampleLevel (sampler##tex,coord,lod)
#define UNITY_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord,lod) tex.SampleLevel (sampler##samplertex,coord,lod)

// Triplanar and texture sampling switchers
#define UNITY_SAMPLE_TEX2D_TRIPLANAR(tex,coordX,coordY,coordZ,scale,blend) \
    UNITY_SAMPLE_TEX2D(tex,coordX * scale) * blend.x \
    + UNITY_SAMPLE_TEX2D(tex,coordY * scale) * blend.y \
    + UNITY_SAMPLE_TEX2D(tex,coordZ * scale) * blend.z

#define UNITY_SAMPLE_TEX2D_SAMPLER_TRIPLANAR(tex,samplertex,coordX,coordY,coordZ,scale,blend) \
    UNITY_SAMPLE_TEX2D_SAMPLER(tex,samplertex,coordX * scale) * blend.x \
    + UNITY_SAMPLE_TEX2D_SAMPLER(tex,samplertex,coordY * scale) * blend.y \
    + UNITY_SAMPLE_TEX2D_SAMPLER(tex,samplertex,coordZ * scale) * blend.z

// Specific variation for triplanar blurred normal sampling
#define UNITY_SAMPLE_TEX2D_TRIPLANAR_BIAS(tex,coordX,coordY,coordZ,scale,bias,blend) \
    UNITY_SAMPLE_TEX2D_BIAS(tex,coordX * scale,bias) * blend.x \
    + UNITY_SAMPLE_TEX2D_BIAS(tex,coordY * scale,bias) * blend.y \
    + UNITY_SAMPLE_TEX2D_BIAS(tex,coordZ * scale,bias) * blend.z

// PBR shader specific branching and sampling, expects convention texture variables and specific triplanar variable names
// Branches if texture does not exist, as indicated by texel size.  Then checks the convention UV set for the texture.
// either UVs 0-3 are used and transformed using Tiling/Offset or shader triplanar variables are used with custom Tiling/Offset setup
#define PBR_SAMPLE_TEX2DS(var,tex) \
    UNITY_BRANCH \
    if (tex##UV < 4) \
        var = UNITY_SAMPLE_TEX2D(tex, TRANSFORM_TEX(switchUV(tex##UV, i.uv, i.uv1, i.uv2, i.uv3), tex)); \
    else if (tex##UV == 4) \
        var = UNITY_SAMPLE_TEX2D_TRIPLANAR(tex, (tpWorldX + tex##_ST.wy), (tpWorldY + tex##_ST.yz), (tpWorldZ + tex##_ST.zw), tex##_ST.x, tpWorldBlendFactor); \
    else var = UNITY_SAMPLE_TEX2D_TRIPLANAR(tex, (tpObjX + tex##_ST.wy), (tpObjY + tex##_ST.yz), (tpObjZ + tex##_ST.zw), tex##_ST.x, tpObjBlendFactor);

#define PBR_SAMPLE_TEX2DS_SAMPLER(var,tex,samplertex) \
    UNITY_BRANCH \
    if (tex##UV < 4) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER(tex, samplertex, TRANSFORM_TEX(switchUV(tex##UV, i.uv, i.uv1, i.uv2, i.uv3), tex)); \
    else if (tex##UV == 4) \
        var = UNITY_SAMPLE_TEX2D_SAMPLER_TRIPLANAR(tex, samplertex, (tpWorldX + tex##_ST.wy), (tpWorldY + tex##_ST.yz), (tpWorldZ + tex##_ST.zw), tex##_ST.x, tpWorldBlendFactor); \
    else var = UNITY_SAMPLE_TEX2D_SAMPLER_TRIPLANAR(tex, samplertex, (tpObjX + tex##_ST.wy), (tpObjY + tex##_ST.yz), (tpObjZ + tex##_ST.zw), tex##_ST.x, tpObjBlendFactor);

// Specific variation for bias sampling (blurred normal)
#define PBR_SAMPLE_TEX2DS_BIAS(var,tex,bias) \
    UNITY_BRANCH \
    if (tex##UV < 4) \
        var = UNITY_SAMPLE_TEX2D_BIAS(tex, TRANSFORM_TEX(switchUV(tex##UV, i.uv, i.uv1, i.uv2, i.uv3), tex), bias); \
    else if (tex##UV == 4) \
        var = UNITY_SAMPLE_TEX2D_TRIPLANAR_BIAS(tex, (tpWorldX + tex##_ST.wy), (tpWorldY + tex##_ST.yz), (tpWorldZ + tex##_ST.zw), tex##_ST.x, bias, tpWorldBlendFactor); \
    else var = UNITY_SAMPLE_TEX2D_TRIPLANAR_BIAS(tex, (tpObjX + tex##_ST.wy), (tpObjY + tex##_ST.yz), (tpObjZ + tex##_ST.zw), tex##_ST.x, bias, tpObjBlendFactor);

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
half3 UnityGI_IndirectSpecularModular(half3 viewReflectDir, float3 posWorld, half perceptualRoughness, half3 occlusion, bool glossyReflections)
{
    half3 indirect_specular = 0;

    #ifdef UNITY_PASS_FORWARDBASE
        #ifdef UNITY_SPECCUBE_BOX_PROJECTION
            half3 viewReflectDirTemp = BoxProjectedCubemapDirection (viewReflectDir, posWorld, unity_SpecCube0_ProbePosition, unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);
        #endif
        
        UNITY_BRANCH
        if (glossyReflections)
        {
            half3 env0 = Unity_GlossyEnvironmentModular (UNITY_PASS_TEXCUBE(unity_SpecCube0), unity_SpecCube0_HDR, perceptualRoughness, viewReflectDirTemp);
            #ifdef UNITY_SPECCUBE_BLENDING
                const float kBlendFactor = 0.99999;
                float blendLerp = unity_SpecCube0_BoxMin.w;
                UNITY_BRANCH
                if (blendLerp < kBlendFactor)
                {
                    #ifdef UNITY_SPECCUBE_BOX_PROJECTION
                        viewReflectDirTemp = BoxProjectedCubemapDirection (viewReflectDir, posWorld, unity_SpecCube1_ProbePosition, unity_SpecCube1_BoxMin, unity_SpecCube1_BoxMax);
                    #endif

                    half3 env1 = Unity_GlossyEnvironmentModular (UNITY_PASS_TEXCUBE_SAMPLER(unity_SpecCube1,unity_SpecCube0), unity_SpecCube1_HDR, perceptualRoughness, viewReflectDirTemp);
                    indirect_specular = lerp(env1, env0, blendLerp);
                }
                else indirect_specular = env0;
            #else
                indirect_specular = env0;
            #endif
        }
        else indirect_specular = unity_IndirectSpecColor.rgb;

        indirect_specular *= occlusion;
    #endif
    return indirect_specular;
}

// Vertex lights diffuse-only helper
half3 VertexLightsDiffuse(half3 normalDir, float3 posWorld)
{
    half3 vertexDiffuse = 0;
    #ifdef UNITY_PASS_FORWARDBASE
        #ifdef VERTEXLIGHT_ON
            for (int index = 0; index < 4; index++)
            {
                float4 lightPosition = float4(unity_4LightPosX0[index],  unity_4LightPosY0[index], unity_4LightPosZ0[index], 1.0);
		 
		        float3 vertexToLightSource = lightPosition.xyz - posWorld;
		        float3 vertLightDirection = normalize(vertexToLightSource);
		        float squaredDistance = dot(vertexToLightSource, vertexToLightSource);
		        float vertexAttenuation = 1.0 / (1.0 +  unity_4LightAtten0[index] * squaredDistance);
		        vertexDiffuse += vertexAttenuation * unity_LightColor[index].rgb * max(0.0, dot(normalDir, vertLightDirection));     
            }
        #endif
    #endif
    return vertexDiffuse;
}

// Unity GI for ambient light and lightmaps converted to not use roundabout structs
// Would be nice if light color wasn't applied here, will change later
half3 UnityGI_BaseModular(half attenuation, half3 occlusion, float2 lightmapUV, float2 dynamicLightmapUV, float3 posWorld, half3 normalDir, out float3 lightColor)
{
    float3 indirect_diffuse = 0;
    lightColor = _LightColor0.rgb;
    #ifdef UNITY_PASS_FORWARDBASE
        #if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
            half bakedAtten = UnitySampleBakedOcclusion(lightmapUV, posWorld);
            float zDist = dot(_WorldSpaceCameraPos - posWorld, UNITY_MATRIX_V[2].xyz);
            float fadeDist = UnityComputeShadowFadeDistance(posWorld, zDist);
            attenuation = UnityMixRealtimeAndBakedShadows(attenuation, bakedAtten, UnityComputeShadowFade(fadeDist));
        #endif
        #if UNITY_SHOULD_SAMPLE_SH
            indirect_diffuse = ShadeSHPerPixel(normalDir, VertexLightsDiffuse(normalDir, posWorld), posWorld);
        #endif
        #ifdef LIGHTMAP_ON
            half3 bakedColor = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, lightmapUV));
            #ifdef DIRLIGHTMAP_COMBINED
                fixed4 bakedDirTex = UNITY_SAMPLE_TEX2D_SAMPLER (unity_LightmapInd, unity_Lightmap, lightmapUV);
                indirect_diffuse += DecodeDirectionalLightmap (bakedColor, bakedDirTex, normalDir);

                #if defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN)
                    lightColor = 0;
                    indirect_diffuse = SubtractMainLightWithRealtimeAttenuationFromLightmap (indirect_diffuse, attenuation, bakedColorTex, normalDir);
                #endif

            #else // not directional lightmap
                indirect_diffuse += bakedColor;

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
                    normalDir);
            #else
                indirect_diffuse += realtimeColor;
            #endif
        #endif
        indirect_diffuse *= occlusion;
    #endif
    return indirect_diffuse;
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

fixed switchChannel(half channel, fixed4 combinedTex)
{
    if (channel == 0)
        return combinedTex.r;
    else if (channel == 1)
        return combinedTex.g;
    else if (channel == 2)
        return combinedTex.b;
    else return combinedTex.a;
}

float2 switchUV(half selection, float2 uv0, float2 uv1, float2 uv2, float2 uv3)
{
    if (selection == 0) return uv0;
    else if (selection == 1) return uv1;
    else if (selection == 2) return uv2;
    else return uv3;
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

// Reusable vert/frag/geoms

UNITY_INSTANCING_BUFFER_START(Props)
    //UNITY_DEFINE_INSTANCED_PROP
UNITY_INSTANCING_BUFFER_END(Props)

// Full v2f, if you need fewer interpolators make a new vert/v2f
struct v2f_full
{
	float4 pos : SV_POSITION;
	float4 uv : TEXCOORD0;
    float4 uv1 : TEXCOORD1;
    float2 uv2 : TEXCOORD2;
    float2 uv3 : TEXCOORD3;
	float4 color : TEXCOORD4;
    float4 posWorld : TEXCOORD5;    
    float4 posObject : TEXCOORD6;
    float3 normalObject : TEXCOORD7;
	float3 normalWorld : TEXCOORD8;
	float3 tangentWorld : TEXCOORD9;
	float3 bitangentWorld : TEXCOORD10;
    float4 grabPos: TEXCOORD11;
    float4 screenPos: TEXCOORD12;
    float3 tangentViewDir : TEXCOORD13;
	UNITY_FOG_COORDS(14)
#ifndef UNITY_PASS_SHADOWCASTER
	SHADOW_COORDS(15)
#endif
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};

v2f_full vert_full (appdata_full v)
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

	o.pos = UnityObjectToClipPos(v.vertex);
    o.posWorld = mul(unity_ObjectToWorld, v.vertex);
    o.posObject = v.vertex;
	o.normalWorld = normalize(UnityObjectToWorldNormal(v.normal));
    o.normalObject = v.normal;
	o.tangentWorld = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
	o.bitangentWorld = normalize(cross(o.normalWorld, o.tangentWorld) * v.tangent.w);
	o.uv = v.texcoord;
    o.uv1 = v.texcoord1;
    o.uv2 = v.texcoord2;
    o.uv3 = v.texcoord3;
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
	return UNITY_SAMPLE_TEX2D(_MainTex, TRANSFORM_TEX(i.uv, _MainTex)) * _Color * i.color;
}

half4 frag_full_pbr (v2f_full i) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(i);
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
    UNITY_APPLY_DITHER_CROSSFADE(i.pos.xy); // idk if this vpos is stereo correct

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

    // Parallax
    fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
    UNITY_BRANCH
    if (group_toggle_Parallax)
    {
        fixed4 _ParallaxMap_var = 1;
        if (_ParallaxMap_TexelSize.x != 1)
            PBR_SAMPLE_TEX2DS_SAMPLER(_ParallaxMap_var, _ParallaxMap, _MainTex);
        i.tangentViewDir = normalize(i.tangentViewDir);
        i.tangentViewDir.xy /= (i.tangentViewDir.z + _ParallaxBias);
        half2 parallaxOffset = i.tangentViewDir.xy * _Parallax * (_ParallaxMap_var.g - 0.5f);;
        if (_ParallaxUV0)
		    i.uv.xy += parallaxOffset;
        if (_ParallaxUV1)
		    i.uv1.xy += parallaxOffset;
        if (_ParallaxUV2)
		    i.uv2.xy += parallaxOffset;
        if (_ParallaxUV3)
		    i.uv3.xy += parallaxOffset;

        // Triplanar parallax goes here
    }

    // Base opacity
    fixed4 _MainTex_var = 0;
    PBR_SAMPLE_TEX2DS(_MainTex_var, _MainTex);
    half3 albedo = _MainTex_var.rgb * _Color.rgb;
    if (_VertexColorsEnabled)
        albedo *= i.color.rgb;
    float opacity = _MainTex_var.a; // detail abledo doesn't affect transparency
    UNITY_BRANCH
    if (_CoverageMap_TexelSize.x != 1)  // Texel size is used to determine if a texture is being used
    {
        fixed4 _CoverageMap_var = 0;
        PBR_SAMPLE_TEX2DS_SAMPLER(_CoverageMap_var, _CoverageMap, _MainTex);
        opacity = _CoverageMap_var.r;
    }
    opacity *= _Color.a;
    if (_VertexColorsEnabled)
        opacity *= i.color.a;

    // A2C
    #ifdef _ALPHATEST_ON
        UNITY_BRANCH
        if (_AlphaToCoverage && _AlphaToMask)
        {
            opacity *= 1 + max(0, CalcMipLevel(i.uv.xy * _MainTex_TexelSize.zw)) * 0.25;
            opacity = (opacity - _Cutoff) / max(fwidth(opacity), 0.0001) + 0.5;
        }
    #endif

    // Dithering
    #if defined(_ALPHATEST_ON) || defined(_ALPHABLEND_ON) || defined(_ALPHAPREMULTIPLY_ON)
        UNITY_BRANCH
        if (_DitheringEnabled)
        {
            half dither = ditherBayer(stereoCorrectScreenUV(i.grabPos));
            dither -= 0.01; // hack because opacity with vertex color imprecision makes dithering visible at full white
            UNITY_BRANCH
            if (_AlphaToMask)
                opacity = opacity - (dither * (1 - opacity) * 0.15);
            else 
            {
                if (_ForceOpaque) opacity = 1;
                clip(opacity - dither);
            }
        }
    #endif

    // Cutoff clipping
    #if defined(_ALPHATEST_ON) || defined(_ALPHABLEND_ON) || defined(_ALPHAPREMULTIPLY_ON)
        if (_ForceOpaque) opacity = 1;
        UNITY_BRANCH
        if (!_AlphaToCoverage)
            clip(opacity - _Cutoff);
    #endif

    // PBR texture samples (if textures are active - is this more efficient?)
    fixed4 _CombinedMap_var = 1;
    UNITY_BRANCH
    if (_CombinedMap_TexelSize.x != 1)
        PBR_SAMPLE_TEX2DS_SAMPLER(_CombinedMap_var, _CombinedMap, _MainTex);
    fixed4 _MetallicGlossMap_var = 1;
    UNITY_BRANCH
    if (_MetallicGlossMap_TexelSize.x != 1)
         PBR_SAMPLE_TEX2DS_SAMPLER(_MetallicGlossMap_var, _MetallicGlossMap, _MainTex);
    fixed4 _SpecGlossMap_var = 1;
    UNITY_BRANCH
    if (_SpecGlossMap_TexelSize.x != 1)
        PBR_SAMPLE_TEX2DS_SAMPLER(_SpecGlossMap_var, _SpecGlossMap, _MainTex);
    fixed4 _OcclusionMap_var = 1;
    UNITY_BRANCH
    if (_OcclusionMap_TexelSize.x != 1)
        PBR_SAMPLE_TEX2DS_SAMPLER(_OcclusionMap_var, _OcclusionMap, _MainTex);
    fixed4 _SpecularMap_var = 1;
    UNITY_BRANCH
    if (_SpecularMap_TexelSize.x != 1)
        PBR_SAMPLE_TEX2DS_SAMPLER(_SpecularMap_var, _SpecularMap, _MainTex);
    
    // Map textures to PBR variables
    fixed metallic = 0;
    if (_MetallicGlossMap_TexelSize.x != 1)
        metallic = _MetallicGlossMap_var.r;
    else metallic = switchChannel(_MetallicGlossMapCombinedMapChannel, _CombinedMap_var);

    fixed3 occlusion = 0;
    if (_OcclusionMap_TexelSize.x != 1)
        occlusion = _OcclusionMap_var.rgb;
    else occlusion = switchChannel(_OcclusionMapCombinedMapChannel, _CombinedMap_var).rrr;

    fixed perceptualRoughness = 0;
    if (_GlossinessSource == 0)
        perceptualRoughness = _SpecGlossMap_var.r;
    else if (_GlossinessSource == 1)
        perceptualRoughness = switchChannel(_SpecGlossMapCombinedMapChannel, _CombinedMap_var);
    else if (_GlossinessSource == 2)
        perceptualRoughness = _MetallicGlossMap_var.a;
    else if (_GlossinessSource == 3)
        perceptualRoughness = _SpecularMap_var.a;
    else perceptualRoughness = _MainTex_var.a;

    fixed3 specularScale;
    if (_SpecularMap_TexelSize.x != 1)
        specularScale = _SpecularMap_var.rgb;
    else specularScale = switchChannel(_SpecularMapCombinedMapChannel, _CombinedMap_var).rrr;

    // Filter PBR variables
    metallic = _MetallicMin + metallic * (_Metallic - _MetallicMin);
    if (_GlossinessMode == 1)
        perceptualRoughness = 1.0 - perceptualRoughness;
    perceptualRoughness = _GlossinessMin + perceptualRoughness * (_Glossiness - _GlossinessMin);
    occlusion = lerp(1, occlusion, _OcclusionStrength);
    specularScale = _SpecularMin + specularScale * (_SpecularMax - _SpecularMin);
    specularScale *= _SpecColor;

    // Details
    half3 _DetailMask_var = 1;
    UNITY_BRANCH
    if (_DetailMask_TexelSize.x != 1)
    {
        PBR_SAMPLE_TEX2DS_SAMPLER(_DetailMask_var, _DetailMask, _MainTex);
        // Detail colors only applied if a mask is applied
        albedo.rgb = lerp(albedo.rgb, albedo.rgb * _DetailColorR.rgb, _DetailMask_var.r);
        albedo.rgb = lerp(albedo.rgb, albedo.rgb * _DetailColorG.rgb, _DetailMask_var.g);
        albedo.rgb = lerp(albedo.rgb, albedo.rgb * _DetailColorB.rgb, _DetailMask_var.b);
    }

    float2 detailUV = switchUV(_UVSec, i.uv, i.uv1, i.uv2, i.uv3);
    UNITY_BRANCH
    if (_DetailAlbedoMap_TexelSize.x != 1)
    {
        fixed _DetailAlbedoMapUV = _UVSec; // Temporary defines so the macro works, could change macro to switch UVselection just for these details
        fixed4 _DetailAlbedoMap_var = 0;
        PBR_SAMPLE_TEX2DS(_DetailAlbedoMap_var, _DetailAlbedoMap);
        albedo = switchDetailAlbedo(_DetailAlbedoMap_var, albedo, _DetailAlbedoCombineMode, _DetailMask_var.r);
    }
    UNITY_BRANCH
    if (_DetailAlbedoMapGreen_TexelSize.x != 1)
    {
        fixed _DetailAlbedoMapGreenUV = _UVSec;
        fixed4 _DetailAlbedoMapGreen_var = 0;
        PBR_SAMPLE_TEX2DS_SAMPLER(_DetailAlbedoMapGreen_var, _DetailAlbedoMapGreen, _DetailAlbedoMap);
        albedo = switchDetailAlbedo(_DetailAlbedoMapGreen_var, albedo, _DetailAlbedoCombineMode, _DetailMask_var.g);
    }
    UNITY_BRANCH
    if (_DetailAlbedoMapBlue_TexelSize.x != 1)
    {
        fixed _DetailAlbedoMapBlueUV = _UVSec;
        fixed4 _DetailAlbedoMapBlue_var = 0;
        PBR_SAMPLE_TEX2DS_SAMPLER(_DetailAlbedoMapBlue_var, _DetailAlbedoMapBlue, _DetailAlbedoMap);
        albedo = switchDetailAlbedo(_DetailAlbedoMapBlue_var, albedo, _DetailAlbedoCombineMode, _DetailMask_var.b);
    }

    // Normals
    half4 _BumpMap_var = 0;
    PBR_SAMPLE_TEX2DS(_BumpMap_var, _BumpMap);
    half3 blendedNormal = UnpackScaleNormal(_BumpMap_var, _BumpScale);
    UNITY_BRANCH
    if (_DetailNormalMap_TexelSize.x != 1)
    {
        fixed _DetailNormalMapUV = _UVSec;
        fixed4 _DetailNormalMap_var = 0;
        PBR_SAMPLE_TEX2DS(_DetailNormalMap_var, _DetailNormalMap);
        _DetailNormalMap_var.xyz = UnpackScaleNormal(_DetailNormalMap_var, _DetailNormalMapScale);
        blendedNormal = lerp(blendedNormal, BlendNormals(blendedNormal, _DetailNormalMap_var.xyz), _DetailMask_var.r);
    }
    UNITY_BRANCH
    if (_DetailNormalMapGreen_TexelSize.x != 1)
    {
        fixed _DetailNormalMapGreenUV = _UVSec;
        fixed4 _DetailNormalMapGreen_var = 0;
        PBR_SAMPLE_TEX2DS_SAMPLER(_DetailNormalMapGreen_var, _DetailNormalMapGreen, _DetailNormalMap);
        _DetailNormalMapGreen_var.xyz = UnpackScaleNormal(_DetailNormalMapGreen_var, _DetailNormalMapScaleGreen);
        blendedNormal = lerp(blendedNormal, BlendNormals(blendedNormal, _DetailNormalMapGreen_var.xyz), _DetailMask_var.g);
    }
    UNITY_BRANCH
    if (_DetailNormalMapBlue_TexelSize.x != 1)
    {
        fixed _DetailNormalMapBlueUV = _UVSec;
        fixed4 _DetailNormalMapBlue_var = 0;
        PBR_SAMPLE_TEX2DS_SAMPLER(_DetailNormalMapBlue_var, _DetailNormalMapBlue, _DetailNormalMap);
        _DetailNormalMapBlue_var.xyz = UnpackScaleNormal(_DetailNormalMapBlue_var, _DetailNormalMapScaleBlue);
        blendedNormal = lerp(blendedNormal, BlendNormals(blendedNormal, _DetailNormalMapBlue_var.xyz), _DetailMask_var.b);
    }
    float3x3 tangentTransform = float3x3(i.tangentWorld, i.bitangentWorld, i.normalWorld);
    fixed3 normalDir = normalize(mul(blendedNormal, tangentTransform));


    // Common vars
    float2 lightmapUV = i.uv1 * unity_LightmapST.xy + unity_LightmapST.zw;
    float2 dynamicLightmapUV = i.uv2 * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
    fixed3 lightDir = getLightDirection(i.posWorld.xyz, lightmapUV); 
    float3 lightColor = getLightColor();
    fixed3 viewReflectDir = reflect(-viewDir, normalDir);
    float3 halfDir = Unity_SafeNormalize (lightDir + viewDir); // BRDF friendly normalize
    fixed3 lightReflectDir = reflect(lightDir, normalDir);
    float NdotL = saturate(dot(normalDir, lightDir));
    half NdotV = abs(dot(normalDir, viewDir)); // abs to get backside rimlight?
    float NdotH = saturate(dot(normalDir, halfDir));
    half LdotV = saturate(dot(lightDir, viewDir));
    half LdotH = saturate(dot(lightDir, halfDir));
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
    LIGHT_ATTENUATION_NO_SHADOW_MUL(attenuation, i, i.posWorld.xyz);
    fixed attenuation_noshadows = attenuation;
    if (_ReceiveShadows)
        attenuation *= shadow;
    half3 indirect_diffuse = UnityGI_BaseModular(attenuation, occlusion, lightmapUV, dynamicLightmapUV, i.posWorld.xyz, normalDir, /* out */ lightColor);
    half3 lightColorNoAttenuation = lightColor;
    half3 lightColorAttenuationNoShadows = lightColor * attenuation_noshadows;
    lightColor *= attenuation;
    half3 indirect_specular = UnityGI_IndirectSpecularModular(viewReflectDir, i.posWorld.xyz, perceptualRoughness, occlusion, _GlossyReflections);

    // Stylized indirect diffuse transmission
    #ifdef UNITY_PASS_FORWARDBASE
        if (group_toggle_SSSTransmission && _SSSStylizedIndirect)
            indirect_diffuse = lerp(indirect_diffuse, ShadeSH9(half4(UnityObjectToWorldNormal(i.posObject), 1)), _SSSStylizedIndirectIntensity);
    #endif


    // Pre-Integrated skin variables
    fixed3 blurredWorldNormal = 0;
    fixed Curvature = 0;
    UNITY_BRANCH
    if (_DiffuseMode == 2)
    {
        // Blur main normal map via tex2Dbias
        fixed4 blurredWorldNormal_var = 0;
        PBR_SAMPLE_TEX2DS_BIAS(blurredWorldNormal_var, _BumpMap, _BumpBlurBias);
        blurredWorldNormal = UnpackScaleNormal(blurredWorldNormal_var, _BumpScale);
        // Lerp blurred normal against combined normal by blur strength
        blurredWorldNormal = lerp(blendedNormal, blurredWorldNormal, _BlurStrength);
        blurredWorldNormal = normalize(mul(blurredWorldNormal, tangentTransform));

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
    #ifdef _ALPHAPREMULTIPLY_ON // Premultiplied transparency
        diffColor *= opacity;
        opacity = 1-oneMinusReflectivity + opacity*oneMinusReflectivity;
        if (_ForceOpaque) opacity = 1;
    #endif

    //BRDF (PBR apdapted from Unity Standard BRDF1)
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
            // change diffuse wrap to checkbox to shadow attenuation can be ignored
            UNITY_BRANCH
            if (_DiffuseWrapIntensity)
            {
                half wrappedDiffuse = 0;
                if (_DiffuseWrapConserveEnergy)
                    wrappedDiffuse = saturate((dot(lightDir, normalDir) + _DiffuseWrap) / ((1 + _DiffuseWrap) * (1 + _DiffuseWrap)));
                else
                    wrappedDiffuse = saturate((dot(lightDir, normalDir) + _DiffuseWrap) / ((1 + _DiffuseWrap)));
                color.rgb += diffColor * (indirect_diffuse + lightColorAttenuationNoShadows * wrappedDiffuse);
            }
            else color.rgb += diffColor * (indirect_diffuse + lightColor * NdotL);
        }
        else if (_DiffuseMode == 1) // PBR
        {
            half3 diffuseTerm = DisneyDiffuse(NdotV, NdotL, LdotH, perceptualRoughness) * NdotL;
            color.rgb += diffColor * (indirect_diffuse + lightColor * diffuseTerm);
        }
        else if (_DiffuseMode == 2) // Skin
        {
            float NdotLBlurredUnclamped = dot(blurredWorldNormal, lightDir);
            //NdotLBlurredUnclamped = NdotLBlurredUnclamped * _DiffuseWrap + (1-_DiffuseWrap);
            NdotLBlurredUnclamped = NdotLBlurredUnclamped * 0.5 + 0.5;
            // Pre integrated skin lookup tex serves as the BRDF diffuse term
            half3 brdf = tex2Dlod(_PreIntSkinTex, float4(NdotLBlurredUnclamped , Curvature, 0, 0));
            color.rgb += diffColor * (indirect_diffuse + lightColor * brdf);
        }
        else if (_DiffuseMode == 3) // Flat Lit
        {
            #ifdef UNITY_PASS_FORWARDBASE
                half3 flatLitLight = ShadeSH9(float4(0,0,0,1));
                // Special exception for stylized indirect diffuse transmission on flat lit shading
                if (group_toggle_SSSTransmission && _SSSStylizedIndirect)
                    flatLitLight = lerp(flatLitLight, ShadeSH9(half4(UnityObjectToWorldNormal(i.posObject), 1)), _SSSStylizedIndirectIntensity);
                color.rgb += diffColor * (lightColor + flatLitLight);
            #endif
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
            color.rgb += pow(RVdotL, _PhongSpecularPower) * _PhongSpecularIntensity * lightColor * specularScale;
        }
        else if (_SpecularMode == 1 || _SpecularMode == 3) // PBR
        {
            float V = SmithJointGGXVisibilityTerm (NdotL, NdotV, roughness);
            float D = GGXTerm (NdotH, roughness);
            half3 specularTerm = V*D * UNITY_PI; // Torrance-Sparrow model, Fresnel is applied later
            #ifdef UNITY_COLORSPACE_GAMMA
                specularTerm = sqrt(max(1e-4h, specularTerm));
            #endif
            specularTerm = max(0, specularTerm * NdotL) * occlusion; // added ao
            color.rgb += specularTerm * lightColor * FresnelTerm (specColor, LdotH);
        }
    }

    // Reflections (Indirect Specular)
    UNITY_BRANCH
    if (group_toggle_Reflections)
    {
        UNITY_BRANCH
        if (_ReflectionsMode == 1) // PBR
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

    // Subsurface Transmission
    // Needs energy conservation
    UNITY_BRANCH
    if (group_toggle_SSSTransmission)
    {
        half3 transmissionLightColor = _SSSTransmissionIgnoreShadowAttenuation ? lightColorAttenuationNoShadows : lightColor;
        fixed4 _TranslucencyMap_var = 0;
        PBR_SAMPLE_TEX2DS_SAMPLER(_TranslucencyMap_var, _TranslucencyMap, _MainTex);
        fixed translucency = _SSSTranslucencyMin + _TranslucencyMap_var.r * (_SSSTranslucencyMax - _SSSTranslucencyMin);
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
    fixed4 _EmissionMap_var = 0;
    PBR_SAMPLE_TEX2DS_SAMPLER(_EmissionMap_var, _EmissionMap, _MainTex);
    color.rgb += _EmissionColor.rgb * _EmissionMap_var.rgb;

    UNITY_APPLY_FOG(i.fogCoord, color);
	return color;
}

// Full shadowcaster with cutout support
struct v2f_shadow_full
{
    V2F_SHADOW_CASTER;
    float4 uv : TEXCOORD0;
    float4 uv1 : TEXCOORD1;
    float2 uv2 : TEXCOORD2;
    float2 uv3 : TEXCOORD3;
    float4 color : TEXCOORD4;
    float4 posWorld : TEXCOORD5;
    float4 posObject : TEXCOORD6;
    float3 normalObject : TEXCOORD7;
	float3 normalWorld : TEXCOORD8;
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};
v2f_shadow_full vert_shadow_full (appdata_full v)
{
    v2f_shadow_full o;
    o.uv = v.texcoord;
    o.uv1 = v.texcoord1;
    o.uv2 = v.texcoord2;
    o.uv3 = v.texcoord3;
    o.color = v.color;
    o.posWorld = mul(unity_ObjectToWorld, v.vertex);
    o.posObject = v.vertex;
	o.normalWorld = normalize(UnityObjectToWorldNormal(v.normal));
    o.normalObject = v.normal;
    TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
    return o;
}
// Separate vpos struct for frag input instead of V2F_SHADOW_CASTER because you can't have both SV_Position and VPOS
struct v2f_shadow_full_vpos
{
    V2F_SHADOW_CASTER_NOPOS
    UNITY_VPOS_TYPE vpos : VPOS;
    float4 uv : TEXCOORD0;
    float4 uv1 : TEXCOORD1;
    float2 uv2 : TEXCOORD2;
    float2 uv3 : TEXCOORD3;
    float4 color : TEXCOORD4;
    float4 posWorld : TEXCOORD5;
    float4 posObject : TEXCOORD6;
    float3 normalObject : TEXCOORD7;
	float3 normalWorld : TEXCOORD8;
};
fixed4 frag_shadow_full (v2f_shadow_full_vpos i) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(v);

    UNITY_BRANCH
    if (_ForceNoShadowCasting) discard; // This subshader override tag doesn't work, so hard coding it here

    #if defined(_ALPHATEST_ON) || defined(_ALPHABLEND_ON) || defined(_ALPHAPREMULTIPLY_ON)

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

        // Base Opacity
        fixed opacity = 0;
        UNITY_BRANCH
        if (_CoverageMap_TexelSize.x != 1)
        {
            fixed4 _CoverageMap_var = 0;
            PBR_SAMPLE_TEX2DS_SAMPLER(_CoverageMap_var, _CoverageMap, _MainTex);
            opacity = _CoverageMap_var.r;
        }
        else
        {
            fixed4 _MainTex_var = 0;
            PBR_SAMPLE_TEX2DS(_MainTex_var, _MainTex);
            opacity = _MainTex_var.a;
        }
        
        opacity *= _Color.a;
        if (_VertexColorsEnabled)
            opacity *= i.color.a;
        if (_ForceOpaque) opacity = 1;

        // Dithered shadows
        UNITY_BRANCH
        if (_DitheredShadows)
            clip(tex3D(_DitherMaskLOD, float3(i.vpos.xy * 0.25, opacity * 0.9375)).a - 0.01);

        // Cutoff clipping
        clip(opacity - _Cutoff);
    #endif
    SHADOW_CASTER_FRAGMENT(i)
}

// Full meta pass
struct v2f_meta_full
{
    float4 pos : SV_POSITION;
	float4 uv : TEXCOORD0;
    float4 uv1 : TEXCOORD1;
    float2 uv2 : TEXCOORD2;
    float2 uv3 : TEXCOORD3;
    float4 color : TEXCOORD4;
    float4 posWorld : TEXCOORD5;
    float4 posObject : TEXCOORD6;
    float3 normalObject : TEXCOORD7;
	float3 normalWorld : TEXCOORD8;
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
    o.uv2 = v.texcoord2;
    o.uv3 = v.texcoord3;
    o.color = v.color;
    o.posWorld = mul(unity_ObjectToWorld, v.vertex);
    o.posObject = v.vertex;
	o.normalWorld = normalize(UnityObjectToWorldNormal(v.normal));
    o.normalObject = v.normal;
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

    fixed4 _MainTex_var = 0;
    PBR_SAMPLE_TEX2DS(_MainTex_var, _MainTex);

    #if defined(_ALPHATEST_ON)
        fixed opacity = _MainTex_var.a;
        UNITY_BRANCH
        if (_CoverageMap_TexelSize.x != 1)
        {
            fixed4 _CoverageMap_var = 0;
            PBR_SAMPLE_TEX2DS_SAMPLER(_CoverageMap_var, _CoverageMap, _MainTex);
            opacity = _CoverageMap_var.r;
        }
        opacity *= _Color.a;
        if (_VertexColorsEnabled)
            opacity *= i.color.a;
        if (_ForceOpaque) opacity = 1;
        clip(opacity - _Cutoff);
    #endif

    fixed4 _EmissionMap_var = 0;
    PBR_SAMPLE_TEX2DS_SAMPLER(_EmissionMap_var, _EmissionMap, _MainTex);

    UnityMetaInput o;
    UNITY_INITIALIZE_OUTPUT(UnityMetaInput, o);
    o.Albedo = _MainTex_var.rgb * _Color.rgb;
    if (_VertexColorsEnabled)
        o.Albedo *= i.color.rgb;
#ifdef EDITOR_VISUALIZATION
    o.VizUV = i.vizUV;
    o.LightCoord = i.lightCoord;
#endif
    o.Emission = _EmissionColor.rgb * _EmissionMap_var.rgb;
    return UnityMetaFragment(o);
}


#endif