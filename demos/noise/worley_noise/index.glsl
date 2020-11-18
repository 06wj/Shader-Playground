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
    return fract((p3.xx+p3.yz)*p3.zy);

}

mat2 rotate2d(float angle){
    return mat2(cos(angle),-sin(angle),
                sin(angle),cos(angle));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ){    
    vec2 pos = (2.0*fragCoord-iResolution.xy)/iResolution.y;

    vec3 color = vec3(0);

    vec2 st = (pos * .5 + .5) * 3.;

    vec2 i = floor(st);
    vec2 f = fract(st);
    float minDist = 1.0;

    for (int y= -1; y <= 1; y++) {
        for (int x= -1; x <= 1; x++) {
            vec2 center = vec2(x, y) + .5;
            vec2 p = center + rotate2d(iTime * 2.) * (.5 * hash22(i + vec2(x, y)));
            float dist = length(p - f);
            minDist = min(minDist, dist);
        }
    }

    color = vec3(minDist);
    fragColor = vec4(color, 1.0);
}