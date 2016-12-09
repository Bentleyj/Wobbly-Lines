Shader "Custom/WobbleNoise"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color1("Color 1", Color) = (1, 1, 1, 1)
		_Color2("Color 2", Color) = (1, 1, 1, 1)
		_Speed1("Speed 1", Float) = 1
		_Scale1("Scale 1", Float) = 1
		_StepSize1("Step Size 1", Float) = 1
		//_Speed2("Speed 2", Float) = 1
		//_Scale2("Scale 2", Float) = 1
		//_StepSize2("Step Size 2", Float) = 1

	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			float hash(float n) { return frac(sin(n)*753.5453123); }
			float noise(in float3 x)
			{
				float3 p = floor(x);
				float3 f = frac(x);
				f = f*f*(3.0 - 2.0*f);

				float n = p.x + p.y*157.0 + 113.0*p.z;
				return lerp(lerp(lerp(hash(n + 0.0), hash(n + 1.0),f.x),
					lerp(hash(n + 157.0), hash(n + 158.0),f.x),f.y),
					lerp(lerp(hash(n + 113.0), hash(n + 114.0),f.x),
						lerp(hash(n + 270.0), hash(n + 271.0),f.x),f.y),f.z);
			}

			float Map(float x, float in_min, float in_max, float out_min, float out_max)
			{
				return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
			}

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color1;
			float4 _Color2;

			float _Speed1;
			float _Scale1;
			float _StepSize1;

			//float _Speed2;
			//float _Scale2;
			//float _StepSize2;

			
			v2f vert (appdata v)
			{
				v2f o;
				float n1X = Map(noise(v.vertex * _StepSize1 + _Time * _Speed1 + v.vertex.x), 0, 1, -_Scale1, _Scale1);
				float n1Y = Map(noise(v.vertex * _StepSize1 + _Time * _Speed1 + v.vertex.y), 0, 1, -_Scale1, _Scale1);
				float n1Z = Map(noise(v.vertex * _StepSize1 + _Time * _Speed1 + v.vertex.z), 0, 1, -_Scale1, _Scale1);
				float3 n1V = float3(n1X, n1Y, n1Z);
				float4 vert1 = v.vertex + float4(n1V.x, n1V.y, n1V.z, v.vertex.w);

				//float n2X = Map(noise(v.vertex * _StepSize2 + _Time * _Speed2 + v.vertex.x), 0, 1, -_Scale2, _Scale2);
				//float n2Y = Map(noise(v.vertex * _StepSize2 + _Time * _Speed2 + v.vertex.y), 0, 1, -_Scale2, _Scale2);
				//float n2Z = Map(noise(v.vertex * _StepSize2 + _Time * _Speed2 + v.vertex.z), 0, 1, -_Scale2, _Scale2);
				//float3 n2V = float3(n2X, n2Y, n2Z);
				//float4 vert2 = v.vertex + float4(n2V.x, n2V.y, n2V.z, v.vertex.w);

				//float4 vert = vert1 + vert2;

				float dist = distance(v.vertex, float4(0, 0, 0, 0));
				dist /= 10;

				float4 col = lerp(_Color1, _Color2, dist);

				o.color = col;

				o.vertex = UnityObjectToClipPos(vert1);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
