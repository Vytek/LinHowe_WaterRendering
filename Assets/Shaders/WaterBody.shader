﻿Shader "LinHowe/WaterBody"
{
	Properties
	{
		_MainTex ("CurTex", 2D) = "white" {}
		_RayStep("RayStep",float) = 64
		_Height("Height", float) = 3.67
	}
	SubShader
	{ 
		Tags { "RenderType" = "Transparent" "Queue" = "Transparent" "IgnoreProjector" = "true" }

		Pass
		{
			//不写入深度缓存
			zwrite off

			//透明度混合
			blend srcalpha oneminussrcalpha

			colormask rgb

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			#include "internal.cginc"
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 color:COLOR;
			};

			struct v2f
			{
				float3 worldPos : TEXCOORD0;
				float4 vertex : SV_POSITION;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex;
			sampler2D _WaterHeightMap;
			float _RayStep;
			float _Height;
			
			v2f vert (appdata v)
			{
				v2f o;

				float height = DecodeHeight(tex2Dlod(_WaterHeightMap, float4(v.uv.xy, 0, 0)));
				v.vertex.y += height * _Height;

				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.vertex = UnityObjectToClipPos(v.vertex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			float4 frag (v2f i) : SV_Target
			{
				float4 col = float4(0, 0, 0, 1);
				float4 lightDeltaColor = internalWorldLightColor;
				return lightDeltaColor ;
			}
			ENDCG
		}
	}
}
