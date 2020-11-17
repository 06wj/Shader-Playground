// hash function copy from https://www.shadertoy.com/view/4djSRW
float hash11(float p)
{
    p = fract(p * .1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}


void mainImage( out vec4 fragColor, in vec2 fragCoord ){    
    vec2 pos = (2.0*fragCoord-iResolution.xy)/iResolution.y;

    vec3 color = vec3(hash11(floor(pos.x * 10.)));

    fragColor = vec4(color,1.0);
}
