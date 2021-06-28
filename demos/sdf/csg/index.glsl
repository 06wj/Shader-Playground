const int RAYCAST_STEPS = 100;
const float RAYCAST_MIN = 1.0;
const float RAYCAST_MAX = 500.0;

float sdSphere(vec3 pos, float r) {
    return length(pos) - r;
}

float sdBox( vec3 p, vec3 b )
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

vec2 opU( vec2 d1, vec2 d2 )
{
    return (d1.x<d2.x) ? d1 : d2;
}

vec2 opU( vec2 d1, float d, float id)
{
    return (d1.x<d) ? d1 : vec2(d, id);
}

vec2 map(vec3 pos) {
    vec2 res = vec2( 1e10, 0.0 );

    mat4 trs;
    vec3 p;
    vec4 newPos;
    pos *= 0.1;
    
    
    trs = mat4(7.229454517364502,6.30588061767412e-8,3.885730028152466,0,2.2811806201934814,2.191460132598877,-2.6765685081481934,0,-4.328760147094727,1.1548610925674438,5.079046249389648,0,11.436378479003906,0.1075577512383461,-25.473352432250977,1);
    newPos = trs * vec4(pos, 1);
    p = newPos.xyz;
    res = opU(res, sdBox(p, vec3(2,2,2)), 1.);

    trs = mat4(7.229454517364502,-0.8737834095954895,5.178339958190918,0,2.2811806201934814,2.304964780807495,3.0515739917755127,0,-4.328760147094727,-0.24462828040122986,10.256463050842285,0,11.436378479003906,7.058851718902588,-52.054161071777344,1);
    newPos = trs * vec4(pos, 1);
    p = newPos.xyz;
    res = opU(res, sdBox(p, vec3(2,2,2)), 2.);

    trs = mat4(6.297424793243408,1.2947107553482056,6.841015338897705,0,2.764889717102051,0.828446626663208,-13.364522933959961,0,-5.376317977905273,1.9425761699676514,1.140064001083374,0,11.436378479003906,-10.727654457092285,-44.740684509277344,1);
    newPos = trs * vec4(pos, 1);
    p = newPos.xyz;
    res = opU(res, sdBox(p, vec3(2,2,2)), 2.);


    return res;
}

vec2 raycast(in vec3 rayPos, in vec3 rayDir) {
    float t = RAYCAST_MIN;
    for(int i = 0;i < RAYCAST_STEPS;i ++) {
        if (t > RAYCAST_MAX) {
            break;
        }
        vec2 h = map(rayPos + rayDir * t);
        if (abs(h.x) < 0.0001 * t) {
            return vec2(t, h.y);
        }

        t += h.x;
    }

    return vec2(-1.0, 0);
}

vec3 getNormal(vec3 pos) {
    vec2 e = vec2(1.0,-1.0)*0.5773*0.0005;
    return normalize( e.xyy*map(pos + e.xyy).x+ 
                      e.yyx*map(pos + e.yyx).x+ 
                      e.yxy*map(pos + e.yxy).x+ 
                      e.xxx*map(pos + e.xxx).x); 
}

vec3 render(vec3 cameraPos, vec3 dir) {
    vec3 col = vec3(0.7, 0.7, 0.9) - max(dir.y,0.0)*0.3;
    vec2 res = raycast(cameraPos, dir);
    float t = res.x;
    float id = res.y;
    if (t >= .0) {
        vec3 pos = cameraPos + t * dir;
        vec3 normal = getNormal(pos);
        
        if (id > 0.0) {
            if (id <= 1.0) {
                return vec3(1, 0, 0);
            }
            if (id <= 2.0) {
                return vec3(0, 1, 0);
            }
            if (id <= 3.0) {
                return vec3(0, 0, 1);
            }
            if (id <= 4.0) {
                return vec3(1, 1, 0);
            }
            if (id <= 5.0) {
                return vec3(0, 1, 1);
            }
            if (id <= 6.0) {
                return vec3(1, 0, 1);
            }
            if (id <= 7.0) {
                return vec3(1, 1, 1);
            }
        }
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
    vec2 mo = iMouse.xy/iResolution.xy;

    vec3 cameraTarget = vec3( .0, .0, .0 );
    vec3 cameraPos = cameraTarget + vec3(0, 0, 100.);

    float time = 32.0 + iTime*1.5;
    float angle = 0.1*time + 17.0*mo.x - 1.9;
    cameraPos = cameraTarget + vec3( 40.5*cos(angle), 1.3 + 2.0*mo.y, 100. + 40.5*sin(angle) );

    mat3 cameraMat = setCamera( cameraPos, cameraTarget, 0.0 );

    vec2 p = (2.0*fragCoord-iResolution.xy)/iResolution.y;
    vec3 rayDir = cameraMat * normalize(vec3(p, 3.5));

    vec3 color = render(cameraPos, rayDir);
    
    fragColor = vec4(color, 1.0);
}