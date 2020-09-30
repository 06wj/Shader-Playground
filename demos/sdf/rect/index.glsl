float sdRect( in vec2 pos, in vec2 b )
{
    vec2 d = abs(pos)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 pos = (2.0*fragCoord-iResolution.xy)/iResolution.y;

    float sdf = sdRect(pos, vec2(0.8, 0.4));
    vec3 col = vec3(smoothstep(0.0, 0.01, sdf));

    fragColor = vec4(col, 1.0);
}