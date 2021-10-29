const int RAYCAST_STEPS = 300;
const float RAYCAST_MIN = 1.0;
const float RAYCAST_MAX = 1000.0;

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
    
            
            
            

             trs = mat4(3.125,0,0,0,0,7.866515971954868e-8,3.125000476837158,0,0,-2.2982325553894043,1.0696421526290578e-7,0,0,0.2887590825557709,-8,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 1.0);
        
            trs = mat4(16.693849563598633,0,0,0,0,3.633480503140163e-7,15.40661334991455,0,0,-10.615351676940918,5.273459464660846e-7,0,3.416947364807129,5.628068447113037,-37.94633102416992,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 2.0);
        
            trs = mat4(16.693849563598633,0,0,0,0,3.633480503140163e-7,15.40661334991455,0,0,-10.615351676940918,5.273459464660846e-7,0,-3.268789291381836,5.628068447113037,-38.022132873535156,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 3.0);
        
            trs = mat4(24.613990783691406,0,0,0,0,3.6334802189230686e-7,20.459186553955078,0,0,-10.615351676940918,7.002881829976104e-7,0,2.3645997047424316,5.628067970275879,-54.26103210449219,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 4.0);
        
            trs = mat4(100,0,0,0,0,3.633480503140163e-7,65.81632232666016,0,0,-10.615351676940918,0.0000022527970031660516,0,9.606730461120605,5.628067970275879,-175.73155212402344,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 5.0);
        
            trs = mat4(24.613990783691406,0,0,0,0,3.6334802189230686e-7,20.459186553955078,0,0,-10.615351676940918,7.002881829976104e-7,0,-2.9922735691070557,5.628067970275879,-54.26103210449219,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 6.0);
        
            trs = mat4(71.84837341308594,0,0,0,0,3.633480503140163e-7,65.81632232666016,0,0,-10.615351676940918,0.0000022527970031660516,0,-8.025463104248047,5.628067970275879,-175.73155212402344,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 7.0);
        
            trs = mat4(10.773412704467773,0,0,0,0,3.633480503140163e-7,21.205446243286133,0,0,-10.615351676940918,7.258315690705786e-7,0,0.014321636408567429,5.628068447113037,-51.791114807128906,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 8.0);
        
            trs = mat4(15.469316482543945,0,0,0,0,-23.678611755371094,6.2470245361328125,0,0,-46.471954345703125,-3.183013677597046,0,-2.2742679119110107,89.39189147949219,-17.137025833129883,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 9.0);
        
            trs = mat4(13.786048889160156,0,0,0,0,-23.678611755371094,15.64751148223877,0,0,-46.471954345703125,-7.972794532775879,0,-2.0503575801849365,89.39197540283203,-46.27656555175781,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 10.0);
        
            trs = mat4(15.925874710083008,0,0,0,0,-23.678611755371094,6.2470245361328125,0,0,-46.471954345703125,-3.183013677597046,0,2.0185725688934326,89.39189147949219,-17.137025833129883,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 11.0);
        
            trs = mat4(15.947285652160645,0,0,0,0,-23.678611755371094,15.64751148223877,0,0,-46.471954345703125,-7.972794532775879,0,2.0805466175079346,89.39197540283203,-46.27656555175781,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 12.0);
        
            trs = mat4(59.5135383605957,0,0,0,0,3.633480503140163e-7,81.74209594726562,0,0,-10.615351676940918,0.000002797912884489051,0,-0.447809636592865,5.628068447113037,-209.09544372558594,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 13.0);
        
            trs = mat4(3.0216774940490723,0,0,0,0,3.633480503140163e-7,7.419389247894287,0,0,-10.615351676940918,2.539548802360514e-7,0,-0.028337201103568077,2.149735927581787,-20.633838653564453,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 14.0);
        
            trs = mat4(3.0216774940490723,0,0,0,0,3.633480503140163e-7,7.419389247894287,0,0,-10.615351676940918,2.539548802360514e-7,0,-0.028337201103568077,-1.0163476467132568,-20.633838653564453,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 15.0);
        
            trs = mat4(16.75513458251953,0,0,0,0,4.0999196926350123e-7,10.13772201538086,0,0,-11.978071212768555,3.4699945672400645e-7,0,3.1215317249298096,5.121703624725342,-22.146560668945312,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 16.0);
        
            trs = mat4(16.75513458251953,0,0,0,0,4.0999196926350123e-7,10.13772201538086,0,0,-11.978071212768555,3.4699945672400645e-7,0,-3.1210289001464844,5.121703624725342,-22.146560668945312,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 17.0);
        
            trs = mat4(16.75513458251953,0,0,0,0,4.6616514737252146e-7,10.13772201538086,0,0,-13.619192123413086,3.4699945672400645e-7,0,-3.2217609882354736,-1.8652708530426025,-22.146560668945312,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 18.0);
        
            trs = mat4(16.75513458251953,0,0,0,0,4.6616514737252146e-7,10.13772201538086,0,0,-13.619192123413086,3.4699945672400645e-7,0,2.998900890350342,-1.8652708530426025,-22.146560668945312,1);
            newPos = trs * vec4(pos, 1);
            p = newPos.xyz;
            res = opU(res, sdSphere(p, 1.), 19.0);
        
        
        
        


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
                return vec3(1,0.9450980424880981,0.3764705955982208);
            }
        
            if (id <= 2.0) {
                return vec3(1,0.38823530077934265,0.3764705955982208);
            }
        
            if (id <= 3.0) {
                return vec3(1,0.38823530077934265,0.3764705955982208);
            }
        
            if (id <= 4.0) {
                return vec3(0,0,0);
            }
        
            if (id <= 5.0) {
                return vec3(1,1,1);
            }
        
            if (id <= 6.0) {
                return vec3(0,0,0);
            }
        
            if (id <= 7.0) {
                return vec3(1,1,1);
            }
        
            if (id <= 8.0) {
                return vec3(0.7647058963775635,0.14901961386203766,0.1568627506494522);
            }
        
            if (id <= 9.0) {
                return vec3(1,0.9882352948188782,0.3764705955982208);
            }
        
            if (id <= 10.0) {
                return vec3(0,0,0);
            }
        
            if (id <= 11.0) {
                return vec3(1,0.9882352948188782,0.3764705955982208);
            }
        
            if (id <= 12.0) {
                return vec3(0,0,0);
            }
        
            if (id <= 13.0) {
                return vec3(0,0,0);
            }
        
            if (id <= 14.0) {
                return vec3(0.5058823823928833,0.29019609093666077,0.1568627506494522);
            }
        
            if (id <= 15.0) {
                return vec3(0.5058823823928833,0.29019609093666077,0.1568627506494522);
            }
        
            if (id <= 16.0) {
                return vec3(1,0.9450980424880981,0.3764705955982208);
            }
        
            if (id <= 17.0) {
                return vec3(1,0.9450980424880981,0.3764705955982208);
            }
        
            if (id <= 18.0) {
                return vec3(1,0.9450980424880981,0.3764705955982208);
            }
        
            if (id <= 19.0) {
                return vec3(1,0.9450980424880981,0.3764705955982208);
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
    float cameraR = 250.;
    cameraPos = cameraTarget + vec3( cameraR*cos(angle), 100.3 + 2.0*mo.y, cameraR + 40.5*sin(angle) );

    mat3 cameraMat = setCamera( cameraPos, cameraTarget, 0.0 );

    vec2 p = (2.0*fragCoord-iResolution.xy)/iResolution.y;
    vec3 rayDir = cameraMat * normalize(vec3(p, 3.5));

    vec3 color = render(cameraPos, rayDir);
    
    fragColor = vec4(color, 1.0);
}