Shader "Kaj/Nothing"
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
	}
	CustomEditor "Kaj.ShaderEditor"    
	SubShader
	{
		Tags { "RenderType"="Opaque" 
			   "IgnoreProjector"="True" 
			   "ForceNoShadowCasting"="True" 
			 }

		Pass
		{
			Name "Nothing"
			Tags { "LightMode" = "Always" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return fixed4(1,0,0,1); // You shouldn't see red if you have lightmode Always disabled
			}
			ENDCG
		}
	}
}
