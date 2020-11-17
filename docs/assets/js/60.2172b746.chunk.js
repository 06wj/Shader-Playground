(window.webpackJsonp=window.webpackJsonp||[]).push([[60],{476:function(n,e,c){"use strict";c.r(e),e.default="// See https://iquilezles.org/www/articles/palettes/palettes.htm\nvec3 colorPalette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {\n    return a + b * cos(2.*3.1415926*(c*t+d));\n}\n\nfloat random(vec2 pos){\n    return fract(sin(dot(pos, vec2(11.3,33.3)))*45555.5);\n}\n\nfloat noise(vec2 pos) {\n    vec2 i = floor(pos);\n    vec2 f = fract(pos);\n    \n    float a = random(i);\n    float b = random(i + vec2(1, 0));\n    float c = random(i + vec2(0, 1));\n    float d = random(i + vec2(1, 1));\n\n    vec2 u = f * f * (3.0 - 2.0 * f);\n\n    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);\n}\n\nmat2 rotate2d(float angle){\n    return mat2(cos(angle),-sin(angle),\n                sin(angle),cos(angle));\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord ){    \n    vec2 st = fragCoord.xy/iResolution.xy;\n\n    st.x = fract(2. - st.x);\n    st = rotate2d(noise((st + vec2(iTime*.5)) * 2.5 + .5) * .2) * st;\n   \n    vec3 color = vec3(.0);\n    vec3 a, b, c, d;\n    if (st.y < .0) {\n        a = vec3(.5);\n        b = vec3(.5);\n        c = vec3(1., .7, .4);\n        d = vec3(.0, .15, .2);\n    }\n    else if (st.y < .2) {\n        a = vec3(.5);\n        b = vec3(.5);\n        c = vec3(2., 1., .0);\n        d = vec3(.5, .2, .25);\n    } else if (st.y < .4) {\n        a = vec3(.5);\n        b = vec3(.5);\n        c = vec3(1.);\n        d = vec3(0, .1, .2);\n    } else if (st.y < .6) {\n        a = vec3(.5);\n        b = vec3(.5);\n        c = vec3(1.);\n        d = vec3(.3, .2, .2);\n    } else if (st.y < .8) {\n        a = vec3(.5);\n        b = vec3(.5);\n        c = vec3(1.);\n        d = vec3(0, .33, .67);\n    } else {\n        a = vec3(.8, .5, .4);\n        b = vec3(.2, .4, .2);\n        c = vec3(2., 1., 1.);\n        d = vec3(.0, .25, .25);\n    }\n\n    color += colorPalette(st.x + iTime*.5, a, b, c, d);\n    float f = fract(st.y * 5.0);\n    color *= smoothstep( 0.49, 0.47, abs(f - 0.5));\n    color *= 0.5 + 0.5 * sqrt(4.0 * f * (1.0-f));\n    fragColor = vec4(color, 1.0);\n}"}}]);