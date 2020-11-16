float random(float n){
    return fract(sin(n)*1e4);
}

float noise(float x) {
    float a = random(floor(x));
    float b = random(floor(x) + 1.0);
    float f = fract(x);
    float u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, floor(sin(iTime * 5.0)) < -.5 ? f : u);
}

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ){    
    vec2 pos = (2.0*fragCoord-iResolution.xy)/iResolution.y;

    float y = noise(pos.x * 2.5 + iTime * 5.) * .5;
    float y2 = noise(pos.x * 2. + iTime * 3.) * .5;
    float y3 = noise(pos.x * 1.5 + iTime * 1.) * .8;

    float pct = plot(pos, y);
    float pct2 = plot(pos, y2);
    float pct3 = plot(pos, y3);

    vec3 color = vec3(1.0);
    color = (1.0 - pct) * color + pct * vec3(0.6, 0.3, 0.9);
    color = (1.0 - pct2) * color + pct2 * vec3(0.6, 0.9, 0.3);
    color = (1.0 - pct3) * color + pct3 * vec3(0.9, 0.6, 0.3);

    fragColor = vec4(color, 1.0);
}