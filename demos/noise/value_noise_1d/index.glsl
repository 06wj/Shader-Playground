float random(float n){
    return fract(sin(n)*1e4);
}

float noise(float x) {
    float f = fract(x);
    float i = floor(x);

    float a = random(i);
    float b = random(i + 1.0);

    float u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, floor(sin(iTime * 2.0)) < -.5 ? f : u);
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