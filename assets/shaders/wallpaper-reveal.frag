#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 viewportSize;
    vec2 origin;
    float radius;
};
layout(binding = 1) uniform sampler2D source;
void main() {
    float distanceToOrigin = length(qt_TexCoord0 * viewportSize - origin);
    float coverage = 1.0 - smoothstep(radius - 1.0, radius + 1.0, distanceToOrigin);
    fragColor = texture(source, qt_TexCoord0) * coverage * qt_Opacity;
}
