(window.webpackJsonp=window.webpackJsonp||[]).push([[65],{477:function(n,e,o){"use strict";o.r(e),e.default='// The MIT License\n// Copyright \xa9 2013 Inigo Quilez\n// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n// Modified from iq\'s shader https://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm\n\n#define ZERO 0\n\n//------------------------------------------------------------------\nfloat dot2( in vec2 v ) { return dot(v,v); }\nfloat dot2( in vec3 v ) { return dot(v,v); }\nfloat ndot( in vec2 a, in vec2 b ) { return a.x*b.x - a.y*b.y; }\n\n// ------------- sdf utils -----------------\nfloat sdPlane( vec3 p )\n{\n    return p.y;\n}\nfloat sdSphere( vec3 p, float s )\n{\n  return length(p)-s;\n}\n\nfloat sdBox( vec3 p, vec3 b )\n{\n  vec3 q = abs(p) - b;\n  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);\n}\n\nfloat sdCone( in vec3 p, in vec2 q )\n{ \n  vec2 w = vec2( length(p.xz), p.y );\n  vec2 a = w - q*clamp( dot(w,q)/dot(q,q), 0.0, 1.0 );\n  vec2 b = w - q*vec2( clamp( w.x/q.x, 0.0, 1.0 ), 1.0 );\n  float k = sign( q.y );\n  float d = min(dot( a, a ),dot(b, b));\n  float s = max( k*(w.x*q.y-w.y*q.x),k*(w.y-q.y)  );\n  return sqrt(d)*sign(s);\n}\n\nfloat sdCapsule( vec3 p, vec3 a, vec3 b, float r )\n{\n  vec3 pa = p - a, ba = b - a;\n  float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );\n  return length( pa - ba*h ) - r;\n}\n\nfloat sdEllipsoid( vec3 p, vec3 r )\n{\n  float k0 = length(p/r);\n  float k1 = length(p/(r*r));\n  return k0*(k0-1.0)/k1;\n}\n\nfloat smin( float a, float b, float k )\n{\n    float h = max(k-abs(a-b),0.0);\n    return min(a, b) - h*h*0.25/k;\n}\n\n// http://iquilezles.org/www/articles/smin/smin.htm\nvec2 smin( vec2 a, vec2 b, float k )\n{\n    float h = clamp( 0.5+0.5*(b.x-a.x)/k, 0.0, 1.0 );\n    return mix( b, a, h ) - k*h*(1.0-h);\n}\n\n// http://iquilezles.org/www/articles/smin/smin.htm\nfloat smax( float a, float b, float k )\n{\n    float h = max(k-abs(a-b),0.0);\n    return max(a, b) + h*h*0.25/k;\n}\n\nfloat opSmoothUnion( float d1, float d2, float k ) {\n    float h = clamp( 0.5 + 0.5*(d2-d1)/k, 0.0, 1.0 );\n    return mix( d2, d1, h ) - k*h*(1.0-h); }\n\nfloat opSmoothSubtraction( float d1, float d2, float k ) {\n    float h = clamp( 0.5 - 0.5*(d2+d1)/k, 0.0, 1.0 );\n    return mix( d2, -d1, h ) + k*h*(1.0-h); }\n\nfloat opSmoothIntersection( float d1, float d2, float k ) {\n    float h = clamp( 0.5 - 0.5*(d2-d1)/k, 0.0, 1.0 );\n    return mix( d2, d1, h ) + k*h*(1.0-h); }\n\n//------------------------------------------------------------------\n\nvec2 opU( vec2 d1, vec2 d2 )\n{\n    return (d1.x<d2.x) ? d1 : d2;\n}\n\n//------------------------------------------------------------------\nvec2 sdHead(vec3 p) {\n    vec3 hp = vec3( abs(p.x), p.yz );\n\n    float head = sdSphere(p, 1.0);\n    head = smax(sdBox(p - vec3(0, 0, -1.4), vec3(2)), head, 0.2);\n    \n    float horn = sdCone(p - vec3(-p.y*p.y*0.2, 1.38, -p.y*p.y*0.1), vec2(0.25, -0.5));\n    head = opSmoothUnion(head, horn, 0.1);\n    \n    float weight = (sin(iTime*4.0)+1.0)*0.5*0.1;\n    float mouth = sdEllipsoid(p - vec3(0., -.4+.8*hp.x*hp.x, 1.), vec3(1.0, 0.54, 0.45+weight));\n    mouth = max(-mouth, head);\n    \n    if (head < mouth) {\n        return vec2(mouth, 11);\n    }\n    return vec2(mouth, 12);\n}\n\nvec2 map( in vec3 p )\n{\n    p.y -= (sin(iTime*2.0)+1.0) * 0.2;\n    vec3 hp = vec3( abs(p.x), p.yz );\n    vec2 res = vec2( 1e10, 0.0 );\n    \n    res = sdHead(p - vec3(0, 0.35, 0));\n    \n    // eye\n    res = opU(res, vec2(sdSphere(vec3(hp.x/0.8, hp.y/1.5,hp.z/0.5) - vec3(.35, .45, 1.2), .15), 13));\n    \n    return res;\n}\n\n// http://iquilezles.org/www/articles/boxfunctions/boxfunctions.htm\nvec2 iBox( in vec3 ro, in vec3 rd, in vec3 rad ) \n{\n    vec3 m = 1.0/rd;\n    vec3 n = m*ro;\n    vec3 k = abs(m)*rad;\n    vec3 t1 = -n - k;\n    vec3 t2 = -n + k;\n    return vec2( max( max( t1.x, t1.y ), t1.z ),\n                 min( min( t2.x, t2.y ), t2.z ) );\n}\n\nvec2 raycast( in vec3 ro, in vec3 rd )\n{\n    vec2 res = vec2(-1.0,-1.0);\n\n    float tmin = 1.0;\n    float tmax = 20.0;\n\n    // raytrace floor plane\n    float tp1 = (-0.6-ro.y)/rd.y;\n    if( tp1>0.0 )\n    {\n        tmax = min( tmax, tp1 );\n        res = vec2( tp1, 1.0 );\n    }\n    \n    // raymarch primitives   \n    vec2 tb = iBox( ro-vec3(0.0,0.4,-0.5), rd, vec3(2.5,2.0,3.5) );\n    if( tb.x<tb.y && tb.y>0.0 && tb.x<tmax)\n    {\n        //return vec2(tb.x,2.0);\n        tmin = max(tb.x,tmin);\n        tmax = min(tb.y,tmax);\n\n        float t = tmin;\n        for( int i=0; i<70; i++ )\n        {\n            if (t >= tmax) {\n                break;\n            }\n            vec2 h = map( ro+rd*t );\n            if( abs(h.x)<(0.0001*t) )\n            { \n                res = vec2(t,h.y); \n                break;\n            }\n            t += h.x;\n        }\n    }\n    \n    return res;\n}\n\n// http://iquilezles.org/www/articles/rmshadows/rmshadows.htm\nfloat calcSoftshadow( in vec3 ro, in vec3 rd, in float mint, in float tmax )\n{\n    // bounding volume\n    float tp = (0.8-ro.y)/rd.y; if( tp>0.0 ) tmax = min( tmax, tp );\n\n    float res = 1.0;\n    float t = mint;\n    for( int i=ZERO; i<16; i++ )\n    {\n        float h = map( ro + rd*t ).x;\n        float s = clamp(8.0*h/t,0.0,1.0);\n        res = min( res, s*s*(3.0-2.0*s) );\n        t += clamp( h, 0.02, 0.10 );\n        if( res<0.005 || t>tmax ) break;\n    }\n    return clamp( res, 0.0, 1.0 );\n}\n\n// http://iquilezles.org/www/articles/normalsSDF/normalsSDF.htm\nvec3 calcNormal( in vec3 pos )\n{\n\n    vec2 e = vec2(1.0,-1.0)*0.5773*0.0005;\n    return normalize( e.xyy*map( pos + e.xyy ).x + \n                      e.yyx*map( pos + e.yyx ).x + \n                      e.yxy*map( pos + e.yxy ).x + \n                      e.xxx*map( pos + e.xxx ).x );   \n}\n\nfloat calcAO( in vec3 pos, in vec3 nor )\n{\n    float occ = 0.0;\n    float sca = 1.0;\n    for( int i=ZERO; i<5; i++ )\n    {\n        float h = 0.01 + 0.12*float(i)/4.0;\n        float d = map( pos + h*nor ).x;\n        occ += (h-d)*sca;\n        sca *= 0.95;\n        if( occ>0.35 ) break;\n    }\n    return clamp( 1.0 - 3.0*occ, 0.0, 1.0 ) * (0.5+0.5*nor.y);\n}\n\n// http://iquilezles.org/www/articles/checkerfiltering/checkerfiltering.htm\nfloat checkersGradBox( in vec2 p, in vec2 dpdx, in vec2 dpdy )\n{\n    // filter kernel\n    vec2 w = abs(dpdx)+abs(dpdy) + 0.001;\n    // analytical integral (box filter)\n    vec2 i = 2.0*(abs(fract((p-0.5*w)*0.5)-0.5)-abs(fract((p+0.5*w)*0.5)-0.5))/w;\n    // xor pattern\n    return 0.5 - 0.5*i.x*i.y;                  \n}\n\nvec3 render( in vec3 ro, in vec3 rd, in vec3 rdx, in vec3 rdy )\n{ \n    // background\n    vec3 col = vec3(0.7, 0.7, 0.9) - max(rd.y,0.0)*0.3;\n    \n    // raycast scene\n    vec2 res = raycast(ro,rd);\n    float t = res.x;\n    float m = res.y;\n    if( m>-0.5 )\n    {\n        vec3 pos = ro + t*rd;\n        vec3 nor = (m<1.5) ? vec3(0.0,1.0,0.0) : calcNormal( pos );\n        vec3 ref = reflect( rd, nor );\n        \n        // material        \n        float ks = 1.0;\n        \n        if( m<1.5 )\n        {\n            // project pixel footprint into the plane\n            vec3 dpdx = ro.y*(rd/rd.y-rdx/rdx.y);\n            vec3 dpdy = ro.y*(rd/rd.y-rdy/rdy.y);\n\n            float f = checkersGradBox( 3.0*pos.xz, 3.0*dpdx.xz, 3.0*dpdy.xz );\n            col = 0.15 + f*vec3(0.05);\n            ks = 0.4;\n        }\n\n        if (m > 10.5) {\n          if (m < 11.5) {\n            // mouth\n            col = vec3(0.9, 0.02, 0.02);\n          } else if (m < 12.5) {\n            // body\n            col = vec3(0.4, 0.1, 0.01);\n          } else if(m < 13.5) {  \n            // eye\n            col = vec3(0, 0, 0);\n          }\n        }\n\n        // lighting\n        float occ = calcAO( pos, nor );\n        \n        vec3 lin = vec3(0.0);\n\n        // sun\n        {\n            vec3  lig = normalize( vec3(-0.5, 0.4, 0.6) );\n            vec3  hal = normalize( lig-rd );\n            float dif = clamp( dot( nor, lig ), 0.0, 1.0 );\n                  dif *= calcSoftshadow( pos, lig, 0.02, 2.5 );\n            float spe = pow( clamp( dot( nor, hal ), 0.0, 1.0 ),16.0);\n                  spe *= dif;\n                  spe *= 0.04+0.96*pow(clamp(1.0-dot(hal,lig),0.0,1.0),5.0);\n            lin += col*2.20*dif*vec3(1.30,1.00,0.70);\n            lin +=     5.00*spe*vec3(1.30,1.00,0.70)*ks;\n        }\n        // sky\n        {\n            float dif = sqrt(clamp( 0.5+0.5*nor.y, 0.0, 1.0 ));\n                  dif *= occ;\n            float spe = smoothstep( -0.2, 0.2, ref.y );\n                  spe *= dif;\n                  spe *= calcSoftshadow( pos, ref, 0.02, 2.5 );\n                  spe *= 0.04+0.96*pow(clamp(1.0+dot(nor,rd),0.0,1.0), 5.0 );\n            lin += col*0.60*dif*vec3(0.40,0.60,1.15);\n            lin +=     2.00*spe*vec3(0.40,0.60,1.30)*ks;\n        }\n        // back\n        {\n            float dif = clamp( dot( nor, normalize(vec3(0.5,0.0,0.6))), 0.0, 1.0 )*clamp( 1.0-pos.y,0.0,1.0);\n                  dif *= occ;\n            lin += col*0.55*dif*vec3(0.25,0.25,0.25);\n        }\n        // sss\n        {\n            float dif = pow(clamp(1.0+dot(nor,rd),0.0,1.0),2.0);\n                  dif *= occ;\n            lin += col*0.25*dif*vec3(1.00,1.00,1.00);\n        }\n        \n        col = lin;\n\n        col = mix( col, vec3(0.7,0.7,0.9), 1.0-exp( -0.0001*t*t*t ) );\n    }\n\n    return vec3( clamp(col,0.0,1.0) );\n}\n\nmat3 setCamera( in vec3 ro, in vec3 ta, float cr )\n{\n    vec3 cw = normalize(ta-ro);\n    vec3 cp = vec3(sin(cr), cos(cr),0.0);\n    vec3 cu = normalize( cross(cw,cp) );\n    vec3 cv =          ( cross(cu,cw) );\n    return mat3( cu, cv, cw );\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n    vec2 mo = iMouse.xy/iResolution.xy;\n    float time = 32.0 + iTime*1.5;\n\n    // camera   \n    vec3 ta = vec3( 0.2, .4, -0.6 );\n    float angle = 0.1*time + 17.0*mo.x - 1.9;\n    vec3 ro = ta + vec3( 4.5*cos(angle), 1.3 + 2.0*mo.y, 4.5*sin(angle) );\n    // camera-to-world transformation\n    mat3 ca = setCamera( ro, ta, 0.0 );\n\n    vec3 tot = vec3(0.0);\n  \n    vec2 p = (2.0*fragCoord-iResolution.xy)/iResolution.y;\n\n    // ray direction\n    vec3 rd = ca * normalize( vec3(p,2.5) );\n\n     // ray differentials\n    vec2 px = (2.0*(fragCoord+vec2(1.0,0.0))-iResolution.xy)/iResolution.y;\n    vec2 py = (2.0*(fragCoord+vec2(0.0,1.0))-iResolution.xy)/iResolution.y;\n    vec3 rdx = ca * normalize( vec3(px,2.5) );\n    vec3 rdy = ca * normalize( vec3(py,2.5) );\n    \n    // render   \n    vec3 col = render( ro, rd, rdx, rdy );\n\n    // gamma\n    col = pow( col, vec3(0.4545) );\n\n    tot += col;\n    \n    fragColor = vec4( tot, 1.0 );\n}'}}]);