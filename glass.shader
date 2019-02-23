// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/glass"
{
    Properties
    {
        _MainTex("Base (RGB) Trans(A)",2D)="white"{}
        _BumpMap("Noise text",2D)="bump"{}
        _Magnitude("Magnitude",Range(0,1)) = 0.05
        _Color("Color",Color)=(1,1,1,1)
        //cd
        _LightColor3("Light Color 3", Color) = (1,1,1,1)
        _LightTex3("Light Texture 3", 2D) = "" {}
       
       
       
    }
    SubShader
    {
    Tags { "Queue"="Transparent" "RenderType"="Transparent" }
    
    GrabPass
    {
        "_GrabTexture"
    }
    pass{
        
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        //#pragma surface surf Standard fullforwardshadows
        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
        
        sampler2D _GrabTexture;
        sampler2D _MainTex;
        sampler2D _BumpMap;
        float _Magnitude;
        float4 _Color;
        
        
        
        
        
        struct vertInput
        {
            float4 vertex: POSITION;
            float2 texcoord:TEXCOORD0;
        };
        
        struct vertOutput
        {
            float4 vertex : POSITION;
            float2 texcoord: TEXCOORD0;
            float4 uvgrab: TEXCOORD1;
        };

      

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        vertOutput vert(vertInput v)
        {
            vertOutput o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.texcoord = v.texcoord;
            o.uvgrab = ComputeGrabScreenPos(o.vertex);
            
            return o;
        }
        
        half4 frag(vertOutput i):Color
        {
                half4 mainColor = tex2D(_MainTex, i.texcoord);
                half4 bump = tex2D(_BumpMap, i.texcoord);
                half2 distortion = UnpackNormal(bump).rg;
                i.uvgrab.xy += distortion * _Magnitude;
                fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
                return col * mainColor * _Color;

        }
        
        ENDCG
        }
        Pass
        {
        Tags{"Queue" = "Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
        
        CGPROGRAM
        
        #pragma fragmentoption ARB_precision_fastest
        #pragma vertex vert
        #pragma fragment frag
        
        #include "UnityCG.cginc"
        
        uniform float4 _LightColor3;
        uniform sampler2D _LightTex3;
        
        struct vertexInput
        {
        float4 vertex : POSITION;
        float4 texcoord : TEXCOORD0;
        };
        
        struct fragmentInput
        {
        float4 pos : SV_POSITION;
        half2 uv : TEXCOORD0;
        fixed4 col : COLOR;
        };
        
        fragmentInput vert(vertexInput i)
        {
        fragmentInput o;
        o.pos = UnityObjectToClipPos(i.vertex);
        o.uv = i.texcoord;
        o.col = _LightColor3;
        o.col.a = _LightColor3.r + _LightColor3.g + _LightColor3.b;
        return o;
        }
        
        half4 frag(fragmentInput i) : COLOR
        {
        float4 color = tex2D(_LightTex3, i.uv) * i.col;
        return color;
        }
        
        ENDCG
        
        }
        
        

    }
    FallBack "Diffuse"
}
