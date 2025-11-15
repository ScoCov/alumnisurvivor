shader_type canvas_item;

uniform vec4 modify_color: source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float mix_intensity: hint_range(0.0, 1.0, 0.05) = 0.5;
uniform bool pulse = false;
uniform float frequency: hint_range(1.0, 20.0, 0.5) = 7.0;

void fragment(){
	vec4 pixel = texture(TEXTURE, UV);
	if (pixel.a > 0.2 && pulse){ // If it's not totally translusent and it's set to pulse.
		// Get a 'moving' variable to create a difference over time.
		float sin_time = cos(frequency * TIME);
		// Mix the rgb values of the pixel and modification colors.bool
		pixel.rgb = mix(pixel.rgb, modify_color.rgb, mix_intensity * sin_time);
		// Apply the new pixel values to the COLOR (current pixel).
		COLOR.rgb = pixel.rgb;
	}
}