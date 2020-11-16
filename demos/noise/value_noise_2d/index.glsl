float random(vec2 pos){
    return fract(sin(dot(pos, vec2(11.3,33.3)))*45555.5);
}

float noise(vec2 pos) {
    vec2 i = floor(pos);
    vec2 f = fract(pos);
    
    float a = random(i);
    float b = random(i + vec2(1, 0));
    float c = random(i + vec2(0, 1));
    float d = random(i + vec2(1, 1));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ){    
    vec2 pos = (2.0*fragCoord-iResolution.xy)/iResolution.y;

    vec3 color = vec3(noise(pos * 10.));

    fragColor = vec4(color, 1.0);
}