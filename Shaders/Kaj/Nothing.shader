Shader "Kaj/Nothing"
{
	Properties
	{
        [HideInInspector] _LightModes ("__lightmodes", Int) = 0
        [HideInInspector] _DisableBatching ("__disableBatching", Int) = 0
        [HideInInspector] _IgnoreProjector ("__ignoreProjector", Int) = 0
        [HideInInspector] _ForceNoShadowCasting ("__forceNoShadowCasting", Int) = 0
        [HideInInspector] _CanUseSpriteAtlas ("__canUseSpriteAtlas", Int) = 1
        [HideInInspector] _PreviewType ("__previewType", Int) = 0
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
