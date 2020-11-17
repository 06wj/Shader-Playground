// hash function copy from https://www.shadertoy.com/view/4djSRW
float hash12(vec2 p)
{
    vec3 p3  = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

vec2 hash22(vec2 p)
{
    vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx+33.33);
    return fract((p3.xx+p3.yz)*p3.zy) * 2.0 - 1.0;

}

float noise(vec2 pos) {
    vec2 i = floor(pos);
    vec2 f = fract(pos);
    
    float a = dot(hash22(i), f);
    float b = dot(hash22(i + vec2(1, 0)), f - vec2(1, 0));
    float c = dot(hash22(i + vec2(0, 1)), f - vec2(0, 1));
    float d = dot(hash22(i + vec2(1, 1)), f - vec2(1, 1));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ){    
    vec2 pos = (2.0*fragCoord-iResolution.xy)/iResolution.y;

    vec3 color = vec3(noise(pos * 10.) * .5 + .5);

    fragColor = vec4(color, 1.0);
}