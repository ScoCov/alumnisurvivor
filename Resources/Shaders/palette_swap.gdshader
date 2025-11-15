shader_type canvas_item;

uniform vec4 detection_color: source_color = vec4(1.0);
uniform vec4 modify_color: source_color = vec4(1.0);
uniform float mix_intensity: hint_range(0.0, 1.0, 0.05) = 1;
uniform float color_precision: hint_range(0.01, 1.0, 0.01) = 1;
const float PRECISION = 0.56;
uniform sampler2D palette;

void vertex(){
}
void fragment(){
	vec4 pixel = texture(TEXTURE, UV);
	vec3 pixel_color = pixel.rgb;
	if (distance(pixel_color.rgb, detection_color.rgb) <= color_precision){
		pixel_color.rgb = mix(pixel_color.rgb, modify_color.rgb, mix_intensity);
		COLOR.rgb = pixel_color.rgb;
	}
}