float sdCircle(vec2 pos, float r) {
    return length(pos) - r;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 pos = (2.0*fragCoord-iResolution.xy)/iResolution.y;
    
    float sdf = sdCircle(pos, 0.8);
    vec3 col = vec3(smoothstep(0.0, 0.01, sdf));

    fragColor = vec4(col, 1.0);
}