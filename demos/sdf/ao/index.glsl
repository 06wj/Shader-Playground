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

float sdPlane(vec3 pos, float y) {
    return pos.y - y;
}

float map(vec3 pos) {
    float sdf = sdSphere(pos - vec3(-.8, .9, .0), .8);
    sdf = min(sdf, sdPlane(pos, .0));
    sdf = min(sdf, sdBox(pos - vec3(.9, .95, .0), vec3(.8, .8, 1.)));
    return sdf;
}

float raycast(in vec3 rayPos, in vec3 rayDir) {
    float t = RAYCAST_MIN;
    for(int i = 0;i < RAYCAST_STEPS;i ++) {
        if (t > RAYCAST_MAX) {
            break;
        }
        float sdf = map(rayPos + rayDir * t);
        if (abs(sdf) < 0.001 * t) {
            return t;
        }

        t += sdf;
    }

    return -1.0;
}

float getAO(in vec3 pos, in vec3 nor)
{
    float occ = 0.0;
    float sca = 1.0;
    for( int i=0; i<5; i++ )
    {
        float h = 0.01 + 0.12*float(i)/4.0;
        float d = map( pos + h*nor );
        occ += (h-d)*sca;
        sca *= 0.95;
        if( occ>0.35 ) break;
    }
    return clamp( 1.0 - 3.0*occ, 0.0, 1.0 ) * (0.5+0.5*nor.y);
}

vec3 getNormal(vec3 pos) {
    vec2 e = vec2(1.0,-1.0)*0.5773*0.0005;
    return normalize( e.xyy*map(pos + e.xyy)+ 
                      e.yyx*map(pos + e.yyx)+ 
                      e.yxy*map(pos + e.yxy)+ 
                      e.xxx*map(pos + e.xxx)); 
}

vec3 render(vec3 cameraPos, vec3 dir) {
    float t = raycast(cameraPos, dir);

    if (t >= .0) {
        vec3 pos = cameraPos + t * dir;
        vec3 normal = getNormal(pos);
        
        float ao = getAO(pos, normal);

        return vec3(ao);
    }

    return vec3(.4);
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
    vec3 cameraTarget = vec3( .0, .4, .0 );
    vec3 cameraPos = cameraTarget + vec3(-1., 1.5, 4.5);
    mat3 cameraMat = setCamera( cameraPos, cameraTarget, 0.0 );

    vec2 p = (2.0*fragCoord-iResolution.xy)/iResolution.y;
    vec3 rayDir = cameraMat * normalize(vec3(p, 2.5));

    vec3 color = render(cameraPos, rayDir);
    
    fragColor = vec4(color, 1.0);
}