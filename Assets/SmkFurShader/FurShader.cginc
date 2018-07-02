		#pragma target 3.0



sampler2D _MainTex;
sampler2D _Mask;
sampler2D _HeightMap;

float _Blur;


struct Input {
	float2 uv_MainTex;
	float2 uv_NormalMap;
	float2 uv_Mask;
	float4 uv_Mask_ST;
};


		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END




