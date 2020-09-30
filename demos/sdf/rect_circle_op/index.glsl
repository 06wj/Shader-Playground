float sdRect( in vec2 pos, in vec2 b )
{
    vec2 d = abs(pos)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

float sdCircle(vec2 pos, float r) {
    return length(pos) - r;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 pos = (2.0*fragCoord-iResolution.xy)/iResolution.y;

    float sdf = 1e10;
    sdf = min(sdf, sdCircle(pos, .5));
    sdf = max(-sdRect(pos, vec2(.9, .2)), sdf);
    sdf = min(sdf, sdCircle(vec2(abs(pos.x), pos.y) - vec2(.9, .0), 0.2));

    vec3 col = vec3(smoothstep(.0, .01, sdf));

    fragColor = vec4(col, 1.0);
}