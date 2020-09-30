const int RAYCAST_STEPS = 200;
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

vec2 map(vec3 pos) {
    float material = 1.0;
    float sphere = sdSphere(pos - vec3(-.8, .8, .0), .8);
    float plane = sdPlane(pos, .0);
    float box = sdBox(pos - vec3(1.9, .8, .0), vec3(.8, .8, 1.));
    float sdf = min(sphere, plane);
    if (plane <= sphere) {
        material = 2.0;
    }
    
    if (box < sdf) {
        material = 3.0;
    }
    sdf = min(sdf, box);
    return vec2(sdf, material);
}

float softShadow( in vec3 rayPos, in vec3 rayDir, in float mint, in float maxt, float k )
{
    float res = 1.0;
    float t = mint;
    for(int i = 0;i < 16;i ++) {
        if (t >= maxt) {
            break;
        }

        float h = map(rayPos + rayDir*t).x;
        if( h<0.001 )
            return 0.0;
        res = min( res, k*h/t );
        t += h;
    }
    return res;
}

vec2 raycast(in vec3 rayPos, in vec3 rayDir) {
    float t = RAYCAST_MIN;
    for(int i = 0;i < RAYCAST_STEPS;i ++) {
        if (t > RAYCAST_MAX) {
            break;
        }
        vec2 sdfInfo = map(rayPos + rayDir * t);
        if (abs(sdfInfo.x) < 0.0001 * t) {
            return vec2(t, sdfInfo.y);
        }

        t += sdfInfo.x;
    }

    return vec2(-1.0, 0.0);
}

float getAO(in vec3 pos, in vec3 nor)
{
    float occ = 0.0;
    float sca = 1.0;
    for( int i=0; i<5; i++ )
    {
        float h = 0.01 + 0.12*float(i)/4.0;
        float d = map( pos + h*nor ).x;
        occ += (h-d)*sca;
        sca *= 0.95;
        if( occ>0.35 ) break;
    }
    return clamp( 1.0 - 3.0*occ, 0.0, 1.0 ) * (0.5+0.5*nor.y);
}

vec3 getNormal(vec3 pos) {
    vec2 e = vec2(1.0,-1.0)*0.5773*0.0005;
    return normalize( e.xyy*map(pos + e.xyy).x+ 
                      e.yyx*map(pos + e.yyx).x+ 
                      e.yxy*map(pos + e.yxy).x+ 
                      e.xxx*map(pos + e.xxx).x); 
}

vec3 render(vec3 cameraPos, vec3 dir) {
    vec2 hitInfo = raycast(cameraPos, dir);
    float t = hitInfo.x;
    float material = hitInfo.y;
    vec3 diffuseColor = vec3(.4);
    if (material > .5) {
        if (material < 1.5) {
            diffuseColor = vec3(.3, .6, .9);
        } else if (material < 2.5) {
            diffuseColor = vec3(.6, .9, .3);
        } else if (material < 3.5) {
            diffuseColor = vec3(.3, .9, .6);
        }
    }
    if (t >= .0) {
        vec3 pos = cameraPos + t * dir;
        vec3 normal = getNormal(pos);
        
        float ao = getAO(pos, normal);
        vec3 lightDir =  normalize(vec3(.5*cos(iTime), .4, .5*sin(iTime)));
        float shadow = softShadow(pos, lightDir, 0.02, 12.5, 8.);
        float diffuse = dot(normal, lightDir) * shadow * ao;
        float ambient = .2 * ao;
        return (diffuse + ambient) * diffuseColor;
    }

    return diffuseColor;
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
    vec3 cameraPos = cameraTarget + vec3(-2.5, 1.3, 4.5);
    mat3 cameraMat = setCamera( cameraPos, cameraTarget, 0.0 );

    vec2 p = (2.0*fragCoord-iResolution.xy)/iResolution.y;
    vec3 rayDir = cameraMat * normalize(vec3(p, 2.5));

    vec3 color = render(cameraPos, rayDir);
    
    fragColor = vec4(color, 1.0);
}