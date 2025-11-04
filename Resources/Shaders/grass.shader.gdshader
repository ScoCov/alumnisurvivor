shader_type canvas_item;

uniform sampler2D image;
uniform vec4 detection_color: source_color = vec4(1.0);
uniform vec4 detection_color_2: source_color = vec4(1.0);
uniform vec4 modify_color: source_color = vec4(1.0);
uniform float mix_intensity: hint_range(0.0, 1.0, 0.05) = 1;
uniform float palette_size: hint_range(1.0, 5.0, 1) = 32;
uniform float palette_step: hint_range(0.1,10.0 , 1) = 0.5;

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d){
	return a + b * cos( TAU *(c * t + d));
}

void vertex(){
	VERTEX.y += sin(2.0 * TIME) + sin(((UV.x * 5.0) * TIME) );
}

void fragment(){
	vec3 color = texture(TEXTURE, UV).rgb;
	// This function "Distance" is used to determine the value of the color and how close to
	// the compared color it is, the number being compared to (0.2 in this this case),
	// is how accurantely we want to get to the color.
	if (distance(color.rgb, detection_color.rgb) < 0.2){
		color.rgb = mix(color.rgb, modify_color.rgb, mix_intensity);
		COLOR.rgb = color.rgb;
	}

}