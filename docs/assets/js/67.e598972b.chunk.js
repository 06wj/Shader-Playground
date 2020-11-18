(window.webpackJsonp=window.webpackJsonp||[]).push([[67],{484:function(n,e,o){"use strict";o.r(e),e.default="// hash function copy from https://www.shadertoy.com/view/4djSRW\nfloat hash12(vec2 p)\n{\n    vec3 p3  = fract(vec3(p.xyx) * .1031);\n    p3 += dot(p3, p3.yzx + 33.33);\n    return fract((p3.x + p3.y) * p3.z);\n}\n\nvec2 hash22(vec2 p)\n{\n    vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));\n    p3 += dot(p3, p3.yzx+33.33);\n    return fract((p3.xx+p3.yz)*p3.zy);\n\n}\n\nmat2 rotate2d(float angle){\n    return mat2(cos(angle),-sin(angle),\n                sin(angle),cos(angle));\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord ){    \n    vec2 pos = (2.0*fragCoord-iResolution.xy)/iResolution.y;\n\n    vec3 color = vec3(0);\n\n    vec2 st = (pos * .5 + .5) * 3.;\n\n    vec2 i = floor(st);\n    vec2 f = fract(st);\n    float minDist = 1.0;\n\n    for (int y= -1; y <= 1; y++) {\n        for (int x= -1; x <= 1; x++) {\n            vec2 center = vec2(x, y) + .5;\n            vec2 p = center + rotate2d(iTime * 2.) * (.5 * hash22(i + vec2(x, y)));\n            float dist = length(p - f);\n            minDist = min(minDist, dist);\n        }\n    }\n\n    color = vec3(minDist);\n    fragColor = vec4(color, 1.0);\n}"}}]);