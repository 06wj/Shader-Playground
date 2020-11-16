float random(float n){
    return fract(sin(n)*1e4);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ){    
    vec2 pos = (2.0*fragCoord-iResolution.xy)/iResolution.y;

    vec3 color = vec3(random(floor(pos.x * 10.)));

    fragColor = vec4(color,1.0);
}
