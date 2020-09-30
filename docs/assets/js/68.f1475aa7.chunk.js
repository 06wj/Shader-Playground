(window.webpackJsonp=window.webpackJsonp||[]).push([[68],{478:function(n,a,e){"use strict";e.r(a),a.default="const int RAYCAST_STEPS = 200;\nconst float RAYCAST_MIN = 1.0;\nconst float RAYCAST_MAX = 20.0;\n\nfloat sdSphere(vec3 pos, float r) {\n    return length(pos) - r;\n}\n\nfloat sdBox( vec3 p, vec3 b )\n{\n  vec3 q = abs(p) - b;\n  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);\n}\n\nfloat sdPlane(vec3 pos, float y) {\n    return pos.y - y;\n}\n\nfloat map(vec3 pos) {\n    float sdf = sdSphere(pos - vec3(.0, .8, .0), .8);\n    sdf = min(sdf, sdPlane(pos, .0));\n    return sdf;\n}\n\nfloat softShadow( in vec3 rayPos, in vec3 rayDir, in float mint, in float maxt, float k )\n{\n    float res = 1.0;\n    float t = mint;\n    for(int i = 0;i < 16;i ++) {\n        if (t >= maxt) {\n            break;\n        }\n\n        float h = map(rayPos + rayDir*t);\n        if( h<0.001 )\n            return 0.0;\n        res = min( res, k*h/t );\n        t += h;\n    }\n    return floor(sin(iTime*3.0)) < -.5 ? res : 1.0;\n}\n\nfloat raycast(in vec3 rayPos, in vec3 rayDir) {\n    float t = RAYCAST_MIN;\n    for(int i = 0;i < RAYCAST_STEPS;i ++) {\n        if (t > RAYCAST_MAX) {\n            break;\n        }\n        float sdf = map(rayPos + rayDir * t);\n        if (abs(sdf) < 0.0001 * t) {\n            return t;\n        }\n\n        t += sdf;\n    }\n\n    return -1.0;\n}\n\nfloat getAO(in vec3 pos, in vec3 nor)\n{\n    float occ = 0.0;\n    float sca = 1.0;\n    for( int i=0; i<5; i++ )\n    {\n        float h = 0.01 + 0.12*float(i)/4.0;\n        float d = map( pos + h*nor );\n        occ += (h-d)*sca;\n        sca *= 0.95;\n        if( occ>0.35 ) break;\n    }\n    return clamp( 1.0 - 3.0*occ, 0.0, 1.0 ) * (0.5+0.5*nor.y);\n}\n\nvec3 getNormal(vec3 pos) {\n    vec2 e = vec2(1.0,-1.0)*0.5773*0.0005;\n    return normalize( e.xyy*map(pos + e.xyy)+ \n                      e.yyx*map(pos + e.yyx)+ \n                      e.yxy*map(pos + e.yxy)+ \n                      e.xxx*map(pos + e.xxx)); \n}\n\nvec3 render(vec3 cameraPos, vec3 dir) {\n    float t = raycast(cameraPos, dir);\n\n    if (t >= .0) {\n        vec3 pos = cameraPos + t * dir;\n        vec3 normal = getNormal(pos);\n        \n        float ao = getAO(pos, normal);\n        float shadow = softShadow(pos, normalize(vec3(.2, .25, -.1)), 0.02, 2.5, 8.0);\n        return vec3(shadow);\n    }\n\n    return vec3(.4);\n}\n\nmat3 setCamera( in vec3 pos, in vec3 target, float cr )\n{\n    vec3 cw = normalize(target-pos);\n    vec3 cp = vec3(sin(cr), cos(cr),0.0);\n    vec3 cu = normalize( cross(cw,cp) );\n    vec3 cv =          ( cross(cu,cw) );\n    return mat3( cu, cv, cw );\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n    vec3 cameraTarget = vec3( .0, .0, .0 );\n    vec3 cameraPos = cameraTarget + vec3(-2.5, 1.3, 4.5);\n    mat3 cameraMat = setCamera( cameraPos, cameraTarget, 0.0 );\n\n    vec2 p = (2.0*fragCoord-iResolution.xy)/iResolution.y;\n    vec3 rayDir = cameraMat * normalize(vec3(p, 2.5));\n\n    vec3 color = render(cameraPos, rayDir);\n    \n    fragColor = vec4(color, 1.0);\n}"}}]);