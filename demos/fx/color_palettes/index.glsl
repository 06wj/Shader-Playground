// See https://iquilezles.org/www/articles/palettes/palettes.htm
vec3 colorPalette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(2.*3.1415926*(c*t+d));
}

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

mat2 rotate2d(float angle){
    return mat2(cos(angle),-sin(angle),
                sin(angle),cos(angle));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ){    
    vec2 st = fragCoord.xy/iResolution.xy;

    st.x = fract(2. - st.x);
    st = rotate2d(noise((st + vec2(iTime*.5)) * 2.5 + .5) * .2) * st;
   
    vec3 color = vec3(.0);
    vec3 a, b, c, d;
    if (st.y < .0) {
        a = vec3(.5);
        b = vec3(.5);
        c = vec3(1., .7, .4);
        d = vec3(.0, .15, .2);
    }
    else if (st.y < .2) {
        a = vec3(.5);
        b = vec3(.5);
        c = vec3(2., 1., .0);
        d = vec3(.5, .2, .25);
    } else if (st.y < .4) {
        a = vec3(.5);
        b = vec3(.5);
        c = vec3(1.);
        d = vec3(0, .1, .2);
    } else if (st.y < .6) {
        a = vec3(.5);
        b = vec3(.5);
        c = vec3(1.);
        d = vec3(.3, .2, .2);
    } else if (st.y < .8) {
        a = vec3(.5);
        b = vec3(.5);
        c = vec3(1.);
        d = vec3(0, .33, .67);
    } else {
        a = vec3(.8, .5, .4);
        b = vec3(.2, .4, .2);
        c = vec3(2., 1., 1.);
        d = vec3(.0, .25, .25);
    }

    color += colorPalette(st.x + iTime*.5, a, b, c, d);
    float f = fract(st.y * 5.0);
    color *= smoothstep( 0.49, 0.47, abs(f - 0.5));
    color *= 0.5 + 0.5 * sqrt(4.0 * f * (1.0-f));
    fragColor = vec4(color, 1.0);
}