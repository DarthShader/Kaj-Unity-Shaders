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
uniform float _SpecularHighlights;                      // Standard specular highlights toggle
uniform float _GlossyReflections;                       // Standard reflections toggle
uniform half _BumpScale;                                // Standard normal map scale
UNITY_DECLARE_TEX2D(_BumpMap);                          // Standard normal map
    uniform float4 _BumpMap_ST;
uniform half _Parallax;                                 // Standard height map scale
UNITY_DECLARE_TEX2D_NOSAMPLER(_ParallaxMap);            // Standard height map
    uniform float4 _ParallaxMap_ST;
uniform half _OcclusionStrength;                        // Standard AO strength
UNITY_DECLARE_TEX2D_NOSAMPLER(_OcclusionMap);           // Standard AO map
    uniform float4 _OcclusionMap_ST;
uniform float4 _EmissionColor;                          // Standard emission color (HDR)
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissionMap);            // Standard emission map
    uniform float4 _EmissionMap_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailMask);             // Standard detail mask
    uniform float4 _DetailMask_ST;
UNITY_DECLARE_TEX2D(_DetailAlbedoMap);                  // Standard mid-gray detail map
    uniform float4 _DetailAlbedoMap_ST;
uniform half _DetailNormalMapScale;                     // Standard detail normal map scale
UNITY_DECLARE_TEX2D(_DetailNormalMap);                  // Standard detail normal map
    uniform float4 _DetailNormalMap_ST;
uniform half _UVSec;                                    // Standard UV selection for secondary textures
uniform float _Mode;                                    // Standard rendering mode (opaque, cutout, fade, transparent)
uniform float _SrcBlend;                                // Standard blending source mode
uniform float _DstBlend;                                // Standard blending destination mode
uniform float _ZWrite;                                  // Blending option
// Standard Specular            
UNITY_DECLARE_TEX2D_NOSAMPLER(_SpecGlossMap);           // Standard Specular specular map, also roughness map in Autodesk Interactive
    uniform float4 _SpecGlossMap_ST;
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
UNITY_DECLARE_TEX2D(_SoulCaliburColorMask);             // SC6 RGB color mask
uniform float4 _SoulCaliburTintR;                       // SC6 tinting
uniform float4 _SoulCaliburTintG;                       // SC6 tinting
uniform float4 _SoulCaliburTintB;                       // SC6 tinting
UNITY_DECLARE_TEX2D(_WarframeTintMask);                 // Warframe 3-channel tint mask
uniform float4 _WarframeTintR;                          // Warframe tinting
uniform float4 _WarframeTintG;                          // Warframe tinting
uniform float4 _WarframeTintB;                          // Warframe tinting
uniform float _SpecularMax;                             // PBR Scaling utilities
uniform float _SpecularMin;                             // PBR Scaling utilities
uniform float _GlossinessMin;                           // PBR Scaling utilities
uniform float _MetallicMin;                             // PBR Scaling utilities
uniform float _OcclusionMin;                            // PBR Scaling utilities
uniform float _BumpBias;                                // SSS normal map LOD sample bias
uniform float _BlurStrength;                            // SSS blur strength
uniform float _CurvatureScale;                          // SSS coverage scalar
uniform fixed _CurvatureInfluence;                      // SSS coverage 
uniform half _Bias;                                     // SSS ??
UNITY_DECLARE_TEX2D(_PreIntSkinTex);                    // SSS Pre-integrated skin texture for diffuse wrapping
    float4 _PreIntSkinTex_ST;
uniform float _PhongSpecularEnabled;                    // Custom phong toggle
uniform float _PhongSpecularPower;                      // Custom phong power
uniform float4 _PhongSpecularColor;                     // Custom phong color
uniform float _PhongSpecularIntensity;                  // Custom phong specular range
uniform float _AlphaToCoverage;                         // A2C toggle
uniform float _TestRange;                               // Dedicated 0-1 value for testing purposes
uniform float _StandardFresnelIntensity;                // Standard BRDF fresnel control
UNITY_DECLARE_TEX2D(_SkyrimSkinTex);                    // Skyrim SSS map
uniform float _SkyrimLightingEffectOne;                 // Skyrim generic shader property - varies with shaders
uniform float _SkyrimLightingEffectTwo;                 // Skyrim generic shader property - varies with shaders
UNITY_DECLARE_TEX2D_NOSAMPLER(_CombinedMap);            // Reusable mask texture for roughness, AO, blah blah blah
    uniform float4 _CombinedMap_ST;
    uniform float _CombinedMapActive;
uniform float _MetallicGlossMapCombinedMapChannel;      // _CombinedMap RGBA selection for Metallic
uniform float _SpecGlossMapCombinedMapChannel;          // _CombinedMap RGBA selection for Roughness/Smoothness
uniform float _OcclusionMapCombinedMapChannel;          // _CombinedMap RGBA selection for Occlusion
uniform float _SpecularMapCombinedMapChannel;           // _CombinedMap RGBA selection for Specular scale
uniform float _GlossinessMode;                          // Roughnes s/Smoothness toggle
uniform float _MetallicGlossMapActive;                  // Texture active var
uniform float _SpecGlossMapActive;                      // Texture active var
uniform float _OcclusionMapActive;                      // Texture active var
uniform float _ParallaxMapActive;                       // Texture active var
uniform float _DetailMaskActive;                        // Active var
uniform float _DetailAlbedoMapActive;                   // Active var
uniform float _DetailNormalMapActive;                   // Active var
UNITY_DECLARE_TEX2D_NOSAMPLER(_CoverageMap);            // Dedicated alpha channel texture
    uniform float4 _CoverageMap_ST;
    uniform float _CoverageMapActive;
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
    uniform float _SpecularMapActive;
uniform float _WorkflowMode;                            // Metallic or Specular Toggle
uniform float4 _DetailColorR;                           // Detail mask coloring
uniform float4 _DetailColorG;                           // Detail mask coloring
uniform float4 _DetailColorB;                           // Detail mask coloring
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailAlbedoMapGreen);   // 2nd detail map
    uniform float4 _DetailAlbedoMapGreen_ST;
    uniform float _DetailAlbedoMapGreenActive;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailAlbedoMapBlue);    // 3rd detail map
    uniform float4 _DetailAlbedoMapBlue_ST;
    uniform float _DetailAlbedoMapBlueActive;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailNormalMapGreen);   // 2nd detail normal map
    uniform float4 _DetailNormalMapGreen_ST;
    uniform float _DetailNormalMapGreenActive;
    uniform float _DetailNormalMapScaleGreen;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailNormalMapBlue);    // 3rd detail normal map
    uniform float4 _DetailNormalMapBlue_ST;
    uniform float _DetailNormalMapBlueActive;
    uniform float _DetailNormalMapScaleBlue;
uniform float _MainTexUV;                   // Main texture UV selector
uniform float _Version;                     // Kaj Shader version
uniform float _BlendOpAlpha;                // Blend op parameter for alpha
uniform float _SrcBlendAlpha;               // Blend ops for alpha
uniform float _DstBlendAlpha;               // Blend ops for alpha
uniform float group_toggle_Parallax;        // new Parallax toggle
uniform float _GlossinessSource;            // PBR shader specific glossiness source toggle

// Reusable defines and functions

// Stereo correct world camera position
#if defined(USING_STEREO_MATRICES)
#define _WorldSpaceStereoCameraCenterPos lerp(unity_StereoWorldSpaceCameraPos[0], unity_StereoWorldSpaceCameraPos[1], 0.5)
#else
#define _WorldSpaceStereoCameraCenterPos _WorldSpaceCameraPos
#endif

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
    UNITY_BRANCH
    if (any(_WorldSpaceLightPos0.xyz))
        return _WorldSpaceLightPos0.xyz;
    else
    {
        #ifdef UNITY_PASS_FORWARDBASE
            //return half3(0, 1, 0);
            return _WorldSpaceLightPos0.xyz;
            #ifdef LIGHTMAP_ON
                #ifdef DIRLIGHTMAP_COMBINED
                #endif
            #endif
        #endif
    }
    return normalize(_WorldSpaceLightPos0.xyz - worldPosition);
}

// Light color with fallback that estimates
// WIP
half3 getLightColor()
{
    //if (any(_LightColor0.rgb))
    return _LightColor0.rgb;
    //else return half3(1, 0, 1); // pink of black light
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

// Per-pixel vertex lights helper
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
// Would be nice if direct light atten wasn't applied here, will change later
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
    lightColor *= attenuation;
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
    float4 posWorld : TEXCOORD4;
    float4 posObject : TEXCOORD5;
	float3 normalWorld : TEXCOORD6;
	float3 tangentWorld : TEXCOORD7;
	float3 bitangentWorld : TEXCOORD8;
	float4 color : TEXCOORD9;
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

v2f_full vert_full (appdata_full v)
{
	v2f_full o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_OUTPUT(v2f_full, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    UNITY_TRANSFER_INSTANCE_ID(v, o);

    UNITY_BRANCH
    if (_ParallaxMapActive)
    {
        v.tangent.xyz = normalize(v.tangent.xyz);
	    v.normal = normalize(v.normal);
    }

	o.pos = UnityObjectToClipPos(v.vertex);
    o.posWorld = mul(unity_ObjectToWorld, v.vertex);
    o.posObject = v.vertex;
	o.normalWorld = normalize(UnityObjectToWorldNormal(v.normal));
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
    //UNITY_APPLY_DITHER_CROSSFADE(i.pos.xy)

    // Parallax
    fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
    float2 parallaxUV = i.uv.xy;
    UNITY_BRANCH
    if (group_toggle_Parallax) // only affects UV1 right now
    {
        fixed4 _ParallaxMap_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ParallaxMap, _MainTex, TRANSFORM_TEX(i.uv, _ParallaxMap));
        _ParallaxMap_var.g -= 0.5f;
        i.tangentViewDir = normalize(i.tangentViewDir);
        i.tangentViewDir.xy /= (i.tangentViewDir.z + _ParallaxBias);
		parallaxUV = i.uv.xy + i.tangentViewDir.xy * _Parallax * _ParallaxMap_var.g;
    }

    // Cutout and A2C
    fixed4 _MainTex_var = UNITY_SAMPLE_TEX2D(_MainTex, TRANSFORM_TEX(switchUV(_MainTexUV, parallaxUV, i.uv1, i.uv2, i.uv3), _MainTex));
    half3 albedo = _MainTex_var.rgb * _Color.rgb * i.color.rgb;
    fixed opacity = _MainTex_var.a; // detail abledo doesn't affect transparency
    UNITY_BRANCH
    if (_CoverageMapActive)
        opacity = UNITY_SAMPLE_TEX2D_SAMPLER(_CoverageMap, _MainTex, TRANSFORM_TEX(parallaxUV, _CoverageMap)).r;
    opacity *= _Color.a * i.color.a;
    if (_ForceOpaque) opacity = 1;
    #ifdef _ALPHATEST_ON
        UNITY_BRANCH
        if (_AlphaToCoverage)
        {
            opacity *= 1 + max(0, CalcMipLevel(i.uv * _MainTex_TexelSize.zw)) * 0.25;
            opacity = (opacity - _Cutoff) / max(fwidth(opacity), 0.0001) + 0.5;
        }
        else clip(opacity - _Cutoff);
    #endif

    // PBR texture samples (if textures are active - is this more efficient?)
    fixed4 _CombinedMap_var = 1;
    if (_CombinedMapActive)
        _CombinedMap_var = UNITY_SAMPLE_TEX2D_SAMPLER(_CombinedMap, _MainTex, TRANSFORM_TEX(parallaxUV, _CombinedMap));
    fixed4 _MetallicGlossMap_var = 1;
    UNITY_BRANCH
    if (_MetallicGlossMapActive)
        _MetallicGlossMap_var = UNITY_SAMPLE_TEX2D_SAMPLER(_MetallicGlossMap, _MainTex, TRANSFORM_TEX(parallaxUV, _MetallicGlossMap));
    fixed4 _SpecGlossMap_var = 1;
    UNITY_BRANCH
    if (_SpecGlossMapActive)
        _SpecGlossMap_var = UNITY_SAMPLE_TEX2D_SAMPLER(_SpecGlossMap, _MainTex, TRANSFORM_TEX(parallaxUV, _SpecGlossMap));
    fixed4 _OcclusionMap_var = 1;
    UNITY_BRANCH
    if (_OcclusionMapActive)
        _OcclusionMap_var = UNITY_SAMPLE_TEX2D_SAMPLER(_OcclusionMap, _MainTex, TRANSFORM_TEX(switchUV(_OcclusionMapUV, parallaxUV, i.uv1, i.uv2, i.uv3), _OcclusionMap));
    fixed4 _SpecularMap_var = 1;
    UNITY_BRANCH
    if (_SpecularMapActive)
        _SpecularMap_var = UNITY_SAMPLE_TEX2D_SAMPLER(_SpecularMap, _MainTex, TRANSFORM_TEX(parallaxUV, _SpecularMap));
    
    // Map textures to PBR variables
    fixed metallic = 0;
    if (_MetallicGlossMapActive)
        metallic = _MetallicGlossMap_var.r;
    else metallic = switchChannel(_MetallicGlossMapCombinedMapChannel, _CombinedMap_var);

    fixed3 occlusion = 0;
    if (_OcclusionMapActive)
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
    if (_SpecularMapActive)
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
    if (_DetailMaskActive)
    {
        _DetailMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_DetailMask, _MainTex, TRANSFORM_TEX(parallaxUV, _DetailMask));
        // Detail colors only applied if a mask is applied
        albedo.rgb = lerp(albedo.rgb, albedo.rgb * _DetailColorR.rgb, _DetailMask_var.r);
        albedo.rgb = lerp(albedo.rgb, albedo.rgb * _DetailColorG.rgb, _DetailMask_var.g);
        albedo.rgb = lerp(albedo.rgb, albedo.rgb * _DetailColorB.rgb, _DetailMask_var.b);
    }

    float2 detailUV = switchUV(_UVSec, parallaxUV, i.uv1, i.uv2, i.uv3);
    UNITY_BRANCH
    if (_DetailAlbedoMapActive)
        albedo = switchDetailAlbedo(UNITY_SAMPLE_TEX2D(_DetailAlbedoMap, TRANSFORM_TEX(detailUV, _DetailAlbedoMap)), albedo, _DetailAlbedoCombineMode, _DetailMask_var.r);
    UNITY_BRANCH
    if (_DetailAlbedoMapGreenActive)
        albedo = switchDetailAlbedo(UNITY_SAMPLE_TEX2D_SAMPLER(_DetailAlbedoMapGreen, _DetailAlbedoMap, TRANSFORM_TEX(detailUV, _DetailAlbedoMapGreen)), albedo, _DetailAlbedoCombineMode, _DetailMask_var.g);
    UNITY_BRANCH
    if (_DetailAlbedoMapBlueActive)
        albedo = switchDetailAlbedo(UNITY_SAMPLE_TEX2D_SAMPLER(_DetailAlbedoMapBlue, _DetailAlbedoMap, TRANSFORM_TEX(detailUV, _DetailAlbedoMapBlue)), albedo, _DetailAlbedoCombineMode, _DetailMask_var.b);

    // Normals
    half3 _BumpMap_var = UnpackScaleNormal(UNITY_SAMPLE_TEX2D(_BumpMap, TRANSFORM_TEX(parallaxUV, _BumpMap)), _BumpScale);
    half3 blendedNormal = _BumpMap_var;
    UNITY_BRANCH
    if (_DetailNormalMapActive)
    {
        fixed3 _DetailNormalMap_var = UnpackScaleNormal(UNITY_SAMPLE_TEX2D(_DetailNormalMap, TRANSFORM_TEX(detailUV, _DetailNormalMap)), _DetailNormalMapScale);
        blendedNormal = lerp(blendedNormal, BlendNormals(blendedNormal, _DetailNormalMap_var), _DetailMask_var.r);
    }
    UNITY_BRANCH
    if (_DetailNormalMapGreenActive)
    {
        fixed3 _DetailNormalMapGreen_var = UnpackScaleNormal(UNITY_SAMPLE_TEX2D_SAMPLER(_DetailNormalMapGreen, _DetailNormalMap, TRANSFORM_TEX(detailUV, _DetailNormalMapGreen)), _DetailNormalMapScaleGreen);
        blendedNormal = lerp(blendedNormal, BlendNormals(blendedNormal, _DetailNormalMapGreen_var), _DetailMask_var.g);
    }
    UNITY_BRANCH
    if (_DetailNormalMapBlueActive)
    {
        fixed3 _DetailNormalMapBlue_var = UnpackScaleNormal(UNITY_SAMPLE_TEX2D_SAMPLER(_DetailNormalMapBlue, _DetailNormalMap, TRANSFORM_TEX(detailUV, _DetailNormalMapBlue)), _DetailNormalMapScaleBlue);
        blendedNormal = lerp(blendedNormal, BlendNormals(blendedNormal, _DetailNormalMapBlue_var), _DetailMask_var.b);
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
    half3 diffColor = albedo * oneMinusReflectivity;
    #ifdef _ALPHAPREMULTIPLY_ON
        diffColor *= opacity;
        opacity = 1-oneMinusReflectivity + opacity*oneMinusReflectivity;
        if (_ForceOpaque) opacity = 1;
    #endif

    // GI
    UNITY_LIGHT_ATTENUATION(attenuation, i, i.posWorld.xyz);
    half3 indirect_diffuse = UnityGI_BaseModular(attenuation, occlusion, lightmapUV, dynamicLightmapUV, i.posWorld.xyz, normalDir, lightColor);
    half3 indirect_specular = UnityGI_IndirectSpecularModular(viewReflectDir, i.posWorld.xyz, perceptualRoughness, occlusion, _GlossyReflections);

    //BRDF adapted from Unity Standard BRDF1
    // Diffuse
    half diffuseTerm = DisneyDiffuse(NdotV, NdotL, LdotH, perceptualRoughness) * NdotL;
    // Specular
    float roughness = PerceptualRoughnessToRoughness(perceptualRoughness);
    roughness = max(roughness, 0.002);
    float V = SmithJointGGXVisibilityTerm (NdotL, NdotV, roughness);
    float D = GGXTerm (NdotH, roughness);
    float specularTerm = V*D * UNITY_PI; // Torrance-Sparrow model, Fresnel is applied later
#   ifdef UNITY_COLORSPACE_GAMMA
        specularTerm = sqrt(max(1e-4h, specularTerm));
#   endif
    specularTerm = max(0, specularTerm * NdotL) * occlusion; // added ao
    if (_SpecularHighlights == 0) specularTerm = 0;
    half surfaceReduction;
#   ifdef UNITY_COLORSPACE_GAMMA
        surfaceReduction = 1.0-0.28*roughness*perceptualRoughness;      // 1-0.28*x^3 as approximation for (1/(x^4+1))^(1/2.2) on the domain [0;1]
#   else
        surfaceReduction = 1.0 / (roughness*roughness + 1.0);           // fade \in [0.5;1]
#   endif
    specularTerm *= any(specColor) ? 1.0 : 0.0;
    half grazingTerm = saturate(smoothness + (1-oneMinusReflectivity));
    half3 color =   diffColor * (indirect_diffuse + lightColor * diffuseTerm)
                    + specularTerm * lightColor * FresnelTerm (specColor, LdotH)
                    + surfaceReduction * indirect_specular * FresnelLerp (specColor, grazingTerm, NdotV) * _StandardFresnelIntensity;

    fixed4 _EmissionMap_var = UNITY_SAMPLE_TEX2D_SAMPLER(_EmissionMap, _MainTex, TRANSFORM_TEX(parallaxUV, _EmissionMap));
    color += _EmissionColor.rgb * _EmissionMap_var.rgb;
	return fixed4(color, opacity);
}

// Full shadowcaster with cutout support
struct v2f_shadow_full
{
    V2F_SHADOW_CASTER;
    float4 uv : TEXCOORD0;
    float4 color : TEXCOORD1;
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};
v2f_shadow_full vert_shadow_full (appdata_full v)
{
    v2f_shadow_full o;
    o.uv = v.texcoord;
    o.color = v.color;
    TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
    return o;
}
struct v2f_shadow_full_vpos
{
    V2F_SHADOW_CASTER_NOPOS
    UNITY_VPOS_TYPE vpos : VPOS;
    float4 uv : TEXCOORD0;
    float4 color : TEXCOORD1;
};
fixed4 frag_shadow_full (v2f_shadow_full_vpos i) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(v);

    UNITY_BRANCH
    if (_ForceNoShadowCasting) discard; // This subshader tag toggle doesn't work, so hard coding it here

    #if defined(_ALPHATEST_ON) || defined(_ALPHABLEND_ON) || defined(_ALPHAPREMULTIPLY_ON)
        fixed opacity = UNITY_SAMPLE_TEX2D(_MainTex, TRANSFORM_TEX(i.uv, _MainTex)).a;
        UNITY_BRANCH
        if (_CoverageMapActive)
            opacity = UNITY_SAMPLE_TEX2D_SAMPLER(_CoverageMap, _MainTex, TRANSFORM_TEX(i.uv, _CoverageMap)).r;
        opacity *= _Color.a * i.color.a;
        if (_ForceOpaque) opacity = 1;

        #if defined(_ALPHABLEND_ON) || defined(_ALPHAPREMULTIPLY_ON)
            UNITY_BRANCH
            if (_DitheredShadows)
                clip(tex3D(_DitherMaskLOD, float3(i.vpos.xy * 0.25, opacity * 0.9375)).a - 0.01);
        #endif 
        clip(opacity - _Cutoff);
    #endif
    SHADOW_CASTER_FRAGMENT(i)
}

// Full meta pass
struct v2f_meta_full
{
    float4 pos : SV_POSITION;
	float2 uv : TEXCOORD0;
    float4 color : TEXCOORD1;
#ifdef EDITOR_VISUALIZATION
    float2 vizUV        : TEXCOORD2;
    float4 lightCoord   : TEXCOORD3;
#endif
};
v2f_meta_full vert_meta_full(appdata_full v)
{
    v2f_meta_full o;
    o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);
    o.uv = v.texcoord;
    o.color = v.color;
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
    fixed4 _MainTex_var = UNITY_SAMPLE_TEX2D(_MainTex, TRANSFORM_TEX(i.uv, _MainTex));

    #if defined(_ALPHATEST_ON)
        fixed opacity = _MainTex_var.a;
        UNITY_BRANCH
        if (_CoverageMapActive)
            opacity = UNITY_SAMPLE_TEX2D_SAMPLER(_CoverageMap, _MainTex, TRANSFORM_TEX(i.uv, _CoverageMap)).r;
        if (_ForceOpaque) opacity = 1;
        clip(opacity * _Color.a * i.color.a - _Cutoff);
    #endif

    fixed4 _EmissionMap_var = UNITY_SAMPLE_TEX2D_SAMPLER(_EmissionMap, _MainTex, TRANSFORM_TEX(i.uv, _EmissionMap));

    UnityMetaInput o;
    UNITY_INITIALIZE_OUTPUT(UnityMetaInput, o);
    o.Albedo = _MainTex_var.rgb * _Color.rgb * i.color.rgb;
#ifdef EDITOR_VISUALIZATION
    o.VizUV = i.vizUV;
    o.LightCoord = i.lightCoord;
#endif
    o.Emission = _EmissionColor.rgb * _EmissionMap_var.rgb;
    return UnityMetaFragment(o);
}


#endif