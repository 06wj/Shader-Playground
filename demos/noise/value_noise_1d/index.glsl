// hash function copy from https://www.shadertoy.com/view/4djSRW
float hash11(float p)
{
    p = fract(p * .1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}

float noise(float x) {
    float f = fract(x);
    float i = floor(x);

    float a = hash11(i);
    float b = hash11(i + 1.0);

    float u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, fract(iTime * .3) < .5 ? f : u);
}

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ){    
    vec2 pos = (2.0*fragCoord-iResolution.xy)/iResolution.y;

    float y = (noise(pos.x * 3.5 + iTime * 1.) * 2. - 1.) * .5;
    float y2 = (noise(pos.x * 4. + iTime * 3.) * 2. - 1.) * .3;
    float y3 = (noise(pos.x * 5.5 + iTime * 5.) * 2. - 1.) * .2;

    float pct = plot(pos, y);
    float pct2 = plot(pos, y2);
    float pct3 = plot(pos, y3);

    vec3 color = vec3(1.0);
    color = (1.0 - pct) * color + pct * vec3(0.6, .4, 1.);
    color = (1.0 - pct2) * color + pct2 * vec3(1., .4, .6);
    color = (1.0 - pct3) * color + pct3 * vec3(.4, .6, 1.);

    fragColor = vec4(color, 1.0);
}