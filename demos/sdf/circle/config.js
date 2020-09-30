import {
    getConfig,
} from '~/commonConfig';

export default async () => {
    const [glsl, commonConfig] = await Promise.all([
        import ('!raw-loader!./index.glsl'),
        getConfig()
    ]);
    commonConfig.javascript.code = glsl;
    return commonConfig;
};