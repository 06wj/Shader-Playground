import glsl from './glsl-language.js';

export const getConfig = async () => {
    const [htmlCode, cssCode] = await Promise.all([
        import ('!raw-loader!~/index.html'),
        import ('!raw-loader!~/style.css'),
    ]);

    return {
        javascript: {
            code: '',
            transformer: 'glsl',
            transform(code) {
                return `shaderToy.init(\`${code}\`)`;
            },
            visible: true,
            editorHook(monaco, code, language) {
                // Register a new language
                monaco.languages.register({ id: 'glsl' });

                // Register a tokens provider for the language
                monaco.languages.setMonarchTokensProvider('glsl', glsl);
            }
        },
        html: {
            code: htmlCode,
            transformer: 'html',
            visible: false
        },
        css: {
            code: cssCode,
            transformer: 'css',
            visible: false
        },
        foldBoxes:['html'],
        packages: {
            js: [
                './libs/Hilo3d.js',
                './libs/shaderToy.js',
            ]
        }
    }
};