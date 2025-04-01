struct PixelShaderInput
{
	float4 pos : SV_POSITION;
	float3 color : COLOR0;
    float2 texCoord : TEXCOORD0;
};

Texture2D<float> depthTexture : register(t0);
SamplerState samplerState : register(s0);

cbuffer MatrixBuffer : register(b0)
{
    float4x4 g_ViewProjectionInverseMatrix;
};

float4 main(PixelShaderInput input) : SV_TARGET
{
    float zOverW = depthTexture.Sample(samplerState, input.texCoord);
    float4 H = float4(input.texCoord.x * 2 - 1, (1 - input.texCoord.y) * 2 - 1, zOverW,
                      1); // Transform by the view-projection inverse.
    float4 D = mul(
        H, g_ViewProjectionInverseMatrix); // Divide by w to get the world position.
    float4 worldPos = D / D.w;


    // Current viewport position
    float4 currentPos =
        H; // Use the world position, and transform by the previous view-
    // projection matrix.
    float4 previousPos =
        mul(worldPos,
            g_previousViewProjectionMatrix); // Convert to nonhomogeneous points
    // [-1,1] by dividing by w. previousPos
    // /= previousPos.w; // Use this
    // frame's position and last frame's to
    // compute the pixel
    // velocity.
    float2 velocity = (currentPos - previousPos) / 2.f;


    // Get the initial color at this pixel.
    float4 color = tex2D(sceneSampler, texCoord);
    texCoord += velocity;
    for (int i = 1; i < g_numSamples; ++i, texCoord += velocity)
    {
        // Sample the color buffer along the velocity vector.
        float4 currentColor = tex2D(sceneSampler, texCoord);
        // Add the current color to our color sum.
        color += currentColor;
    } // Average all of the samples to get the final blur color.
    float4 finalColor = color / numSamples;

	return float4(input.color, 1.0f);
}
