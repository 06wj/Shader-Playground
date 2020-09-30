window.shaderToy = {
    init:function(shaderToyCode){
        var camera = new Hilo3d.PerspectiveCamera({
            aspect: innerWidth / innerHeight,
            far: 100,
            near: 0.1,
            z: 3
        });

        var stage = new Hilo3d.Stage({
            canvas: document.getElementById('canvas'),
            camera: camera,
            clearColor: new Hilo3d.Color(0.4, 0.4, 0.4),
            width: innerWidth,
            height: innerWidth/1.77777777
        });

        window.onresize = function(){
            camera.aspect = innerWidth / innerHeight;
            stage.resize(innerWidth, innerHeight);
        }

        renderer = stage.renderer;
        Hilo3d.extensions.use("OES_standard_derivatives");
        renderer.clearColor = new Hilo3d.Color(0, 0, 0, 1);
        var commonUniformGetMethod = function(mesh, material, programInfo){
            return this.value;
        }
        stage.enableDOMEvent([Hilo3d.browser.POINTER_MOVE, Hilo3d.browser.POINTER_START, Hilo3d.browser.POINTER_END]);
        stage.on(Hilo3d.browser.POINTER_MOVE, function(e){
            if (stage.isMouseDown) {
                stage.stageDeltaX = e.stageX - stage.stageX;
                stage.stageDeltaY = e.stageY - stage.stageY;
                stage.stageX = e.stageX;
                stage.stageX = e.stageX;
            }
        });
        stage.on(Hilo3d.browser.POINTER_START, function(e){
            stage.stageDeltaX = e.stageX - stage.stageX;
            stage.stageDeltaY = e.stageY - stage.stageY;
            stage.stageX = e.stageX;
            stage.stageX = e.stageX;
            stage.isMouseDown = true;
        });
        stage.on(Hilo3d.browser.POINTER_END, function(e){
            stage.stageDeltaX = e.stageX - stage.stageX;
            stage.stageDeltaY = e.stageY - stage.stageY;
            stage.stageX = e.stageX;
            stage.stageX = e.stageX;
            stage.isMouseDown = false;
        });
        var mesh = new Hilo3d.Mesh({
            frustumTest:false,
            geometry: new Hilo3d.Geometry({
                mode:Hilo3d.constants.TRIANGLE_STRIP,
                vertices:new Hilo3d.GeometryData(new Float32Array([-1, -1, 1, -1, -1, 1, 1, 1]), 2)
            }),
            material: new Hilo3d.ShaderMaterial({
                depthTest:false,
                side:Hilo3d.constants.FRONT,
                needBasicUnifroms: false,
                needBasicAttributes: false,
                iChannel0: new Hilo3d.LazyTexture({
                    crossOrigin: true,
                    src: '//gw.alicdn.com/tfs/TB1lwwSGgHqK1RjSZFPXXcwapXa-1024-1024.jpg'
                }),
                iChannel1: null,
                iChannel2: null,
                iChannel3: null,
                uniforms:{
                    // vec3
                    iResolution:{
                        value:new Float32Array([stage.width, stage.height, 1]),
                        get:commonUniformGetMethod
                    },
                    // value:0,
                    iTime:{
                        value:new Date().getTime(),
                        get:commonUniformGetMethod
                    },
                    // float
                    iTimeDelta:{
                        value:0,
                        get:commonUniformGetMethod
                    },
                    // int
                    iFrame:{
                        value:0,
                        get:commonUniformGetMethod
                    },
                    // float
                    iFrameRate:{
                        value:0,
                        get:commonUniformGetMethod
                    },
                    // float[4]
                    iChannelTime:{
                        value: new Float32Array(4),
                        get:commonUniformGetMethod
                    },
                    // vec4
                    iMouse:{
                        value: new Float32Array(4),
                        get:commonUniformGetMethod
                    },
                    // vec4
                    iDate:{
                        value: new Float32Array(4),
                        get:commonUniformGetMethod
                    },
                    // float
                    iSampleRate:{
                        value:0,
                        get:commonUniformGetMethod
                    },
                    // vec3[4]
                    iChannelResolution:{
                        value: new Float32Array(12),
                        get:commonUniformGetMethod
                    },
                    // sampler2D
                    iChannel0:{
                        get:function(mesh, material, programInfo){
                            Hilo3d.semantic.handlerTexture(material.iChannel0, programInfo.textureIndex);
                        }
                    },
                    // sampler2D
                    iChannel1:{
                        get:function(mesh, material, programInfo){
                            Hilo3d.semantic.handlerTexture(material.iChannel1, programInfo.textureIndex);
                        }
                    },
                    // sampler2D
                    iChannel2:{
                        get:function(mesh, material, programInfo){
                            Hilo3d.semantic.handlerTexture(material.iChannel2, programInfo.textureIndex);
                        }
                    },
                    // sampler2D
                    iChannel3:{
                        get:function(mesh, material, programInfo){
                            Hilo3d.semantic.handlerTexture(material.iChannel3, programInfo.textureIndex);
                        }
                    }
                },
                attributes:{
                    a_position: 'POSITION',
                    a_texcoord0:'TEXCOORD_0'
                },
                fs:`
                    #extension GL_OES_standard_derivatives: enable
                    #define texture texture2D
                    precision HILO_MAX_FRAGMENT_PRECISION float;
                    uniform vec3 iResolution;
                    uniform float iTime;
                    uniform float iTimeDelta;
                    uniform int iFrame;
                    uniform float iFrameRate;
                    uniform float iChannelTime[4];
                    uniform vec4 iMouse;
                    uniform vec4 iDate;
                    uniform float iSampleRate;
                    uniform vec3 iChannelResolution[4];
                    uniform sampler2D iChannel0;
                    uniform sampler2D iChannel1;
                    uniform sampler2D iChannel2;
                    uniform sampler2D iChannel3;

                    ${shaderToyCode}
                    
                    void main(void) {   
                        vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
                        mainImage( color, vec2(gl_FragCoord.x, gl_FragCoord.y));
                        gl_FragColor = color;
                    }
                `,
                vs:Hilo3d.Shader.shaders['screen.vert'],
                autoUpdateWorldMatrix: false
            }),
            onUpdate(dt){
                var uniforms = this.material.uniforms;

                uniforms.iFrame.value ++;

                var nowDate = new Date();
                var nowTime = nowDate.getTime();
            
                uniforms.iResolution.value[0] = stage.renderer.width;
                uniforms.iResolution.value[1] = stage.renderer.height;

                uniforms.iDate.value[0] = nowDate.getFullYear();
                uniforms.iDate.value[1] = nowDate.getMonth();
                uniforms.iDate.value[2] = nowDate.getDate();
                uniforms.iDate.value[3] = nowDate.getHours()*60.0*60 + nowDate.getMinutes()*60 + nowDate.getSeconds() + nowDate.getMilliseconds()/1000;

                uniforms.iTimeDelta.value = nowTime - uniforms.iTime.value;
                uniforms.iTime.value = uniforms.iDate.value[3];

                uniforms.iMouse.value[0] = stage.stageX||0;
                uniforms.iMouse.value[1] = stage.stageY||0;
                uniforms.iMouse.value[2] = stage.stageDeltaX||0;
                uniforms.iMouse.value[3] = stage.stageDeltaY||0;

                uniforms.iFrameRate.value = ticker.getMeasuredFPS();
            }
        });
        stage.addChild(mesh);

        var ticker = new Hilo3d.Ticker();
        ticker.addTick(stage);
        ticker.start();
    }
};