shader_type canvas_item;
render_mode unshaded;

uniform float breath_speed : hint_range(0.1, 10.0) = 2.0;
uniform float darkness : hint_range(0.0, 1.0) = 0.7;   // 最黑能黑到什么程度
uniform float inner_radius : hint_range(0.1, 1.0) = 0.3;
uniform float outer_radius : hint_range(0.1, 1.2) = 0.7;

void fragment() {
    float d = length(UV - 0.5) * 2.0;            // 0 中心 → 1 边缘
    float wave = 0.5 + 0.5 * sin(TIME * breath_speed);  // 0~1 呼吸
    float mask = smoothstep(inner_radius, outer_radius, d) * darkness * wave;
    COLOR = vec4(0.0, 0.0, 0.0, mask);           // 纯黑，透明度=mask
}