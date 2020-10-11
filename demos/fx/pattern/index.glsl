vec2 brickTile(vec2 pos, float zoom){
    pos *= zoom;

    float time = fract(iTime * .5);
    float col = step(1., mod(pos.x + (1.0 - step(.75, time)) * .5, 2.0));
    float row = step(1., mod(pos.y - step(.5, time) * .5, 2.0));

    pos.x += (clamp(time, .0, .25) + clamp(time - .5, .0, .25)) * (row - .5) * 4.;
    pos.y += (clamp((time - .25), .0, .25) + clamp(time - .75, .0, .25)) * (col - .5) * 4.;

    return fract(pos);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ){    
    vec2 pos = (2.0*fragCoord-iResolution.xy)/iResolution.y;

    pos = brickTile(pos, 6.);
    
    pos = pos - vec2(.5);
    float angle = atan(pos.x, pos.y);
    angle += iTime * 1.;
    float r = length(pos);

    vec3 color = vec3(smoothstep(cos(angle*3.),cos(angle*3.)+.1,r*3. ));
    fragColor = vec4(color,1.0);
}
