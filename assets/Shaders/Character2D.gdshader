shader_type canvas_item;

// 两张立绘
uniform sampler2D tex_from : source_color;   // 当前表情
uniform sampler2D tex_to   : source_color;   // 目标表情
// 0 = 100% tex_from，1 = 100% tex_to
uniform float progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 c_from = texture(tex_from, UV);
	vec4 c_to   = texture(tex_to,   UV);
	COLOR = mix(c_from, c_to, progress);
}