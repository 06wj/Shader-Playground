const int RAYCAST_STEPS = 100;
const float RAYCAST_MIN = 1.0;
const float RAYCAST_MAX = 20.0;

float sdSphere(vec3 pos, float r) {
    return length(pos) - r;
}

float sdBox( vec3 p, vec3 b )
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float map(vec3 pos) {
    float sdf = sdSphere(pos, .8);
    return sdf;
}

float raycast(in vec3 rayPos, in vec3 rayDir) {
    float t = RAYCAST_MIN;
    for(int i = 0;i < RAYCAST_STEPS;i ++) {
        if (t > RAYCAST_MAX) {
            break;
        }
        float sdf = map(rayPos + rayDir * t);
        if (abs(sdf) < 0.0001 * t) {
            return t;
        }

        t += sdf;
    }

    return -1.0;
}

vec3 getNormal(vec3 pos) {
    vec2 e = vec2(1.0,-1.0)*0.5773*0.0005;
    return normalize( e.xyy*map(pos + e.xyy)+ 
                      e.yyx*map(pos + e.yyx)+ 
                      e.yxy*map(pos + e.yxy)+ 
                      e.xxx*map(pos + e.xxx)); 
}

vec3 render(vec3 cameraPos, vec3 dir) {
    vec3 col = vec3(0.7, 0.7, 0.9) - max(dir.y,0.0)*0.3;
    float t = raycast(cameraPos, dir);

    if (t >= .0) {
        vec3 pos = cameraPos + t * dir;
        vec3 normal = getNormal(pos);
        
        return vec3(normal);
    }

    return col;
}

mat3 setCamera( in vec3 pos, in vec3 target, float cr )
{
    vec3 cw = normalize(target-pos);
    vec3 cp = vec3(sin(cr), cos(cr),0.0);
    vec3 cu = normalize( cross(cw,cp) );
    vec3 cv =          ( cross(cu,cw) );
    return mat3( cu, cv, cw );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec3 cameraTarget = vec3( .0, .0, .0 );
    vec3 cameraPos = cameraTarget + vec3(0, 0, 4.5);
    mat3 cameraMat = setCamera( cameraPos, cameraTarget, 0.0 );

    vec2 p = (2.0*fragCoord-iResolution.xy)/iResolution.y;
    vec3 rayDir = cameraMat * normalize(vec3(p, 2.5));

    vec3 color = render(cameraPos, rayDir);
    
    fragColor = vec4(color, 1.0);
}