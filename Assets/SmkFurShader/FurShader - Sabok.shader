Shader "Benisi/SurfaceShader/FurShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	    _NormalMap("NormalMap",2D) = "bump"{}
		_Mask("Mask",2D) = "white"{}
	    _FurLength ("Fur length", Range(0.0, 10)) = 0.5
	    _FurDirection("FurDirection", Vector) = (0,0,0,0)
		_CutOff ("Alpha cutoff", Range(0, 1)) = 0.5
		_Alpha("Alpha",Range(0,1)) = 0
		_Thickness ("Thickness", Range(0, 0.5)) = 0
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
		LOD 200
		Pass{
		ColorMask 0
		}
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off
		ColorMask RGB

//_____________________________________________________________________________
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows vertex:vert
#include "furshader.cginc"
sampler2D _NormalMap;





		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color; 
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			o.Normal = UnpackNormal(tex2D(_NormalMap,IN.uv_NormalMap));
		
		}

 void vert (inout appdata_full v, out Input o) {
   UNITY_INITIALIZE_OUTPUT(Input,o);
 }
		ENDCG
//_____________________________________________________________________________



//_____________________________________________________________________________
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows vertex:vert alpha:fade
		float _FurLength; float4 _FurDirection;
		float _Smooth;
		sampler2D _NormalMap;
		float _CutOff;
		float _Thickness,_Alpha;

#include "furshader.cginc"
#define FURSTEP 0.5

 void vert (inout appdata_full v, out Input o) {
// _FurLength = 50;
   UNITY_INITIALIZE_OUTPUT(Input,o);
float4 mask = tex2Dlod(_Mask,float4(v.texcoord.xy,0,0));
   v.vertex.xyz += _FurLength * _FurDirection * v.normal * FURSTEP; //* smoothstep(mask,0,_Smooth);
 }

 		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;  fixed4 mask = tex2D(_Mask,IN.uv_Mask);
			o.Albedo = c.rgb;
			o.Alpha = step(lerp(_CutOff, _CutOff + _Thickness, FURSTEP), mask) * (_Alpha / FURSTEP);
			o.Normal = UnpackNormal(tex2D(_NormalMap,IN.uv_NormalMap));

		
		}
		ENDCG
//_____________________________________________________________________________

//_____________________________________________________________________________
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows vertex:vert alpha:fade
		float _FurLength; float4 _FurDirection;
		float _Smooth;
		sampler2D _NormalMap;
		float _CutOff;
		float _Thickness,_Alpha;



#include "furshader.cginc"
#define FURSTEP 1

 void vert (inout appdata_full v, out Input o) {
// _FurLength = 50;
   UNITY_INITIALIZE_OUTPUT(Input,o);
float4 mask = tex2Dlod(_Mask,float4(v.texcoord.xy,0,0));
   v.vertex.xyz += _FurLength * v.normal * FURSTEP * _FurDirection;
 }

 		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;  fixed4 mask = tex2D(_Mask,IN.uv_Mask);
			o.Albedo += c.rgb;
			o.Alpha = step(lerp(_CutOff, _CutOff + _Thickness, FURSTEP), mask) * (_Alpha / FURSTEP);
			o.Normal = UnpackNormal(tex2D(_NormalMap,IN.uv_NormalMap));

		}
		ENDCG
//_____________________________________________________________________________

}
	FallBack "Diffuse"
}
