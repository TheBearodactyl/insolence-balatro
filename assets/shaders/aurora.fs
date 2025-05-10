#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 aurora;
extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

uniform MY_HIGHP_OR_MEDIUMP vec3 iResolution;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	vec2 u = f * f * (3.0 - 2.0 * f);

	return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

vec3 gen_stars(vec2 r, float star_density) {
	vec2 star_pos = floor(r * r.xy * star_density);

	float noise_layer_one = noise(star_pos * 0.5);
	float noise_layer_two = noise(star_pos * 2.0);
	float noise_layer_thr = noise(star_pos * 8.0);
	float star = mix(noise_layer_one, noise_layer_two, 0.5);

	star = mix(star, noise_layer_thr, 0.2);
	star += 0.05 * sin(time * 2.0 + star_pos.x * 0.2);
	star = smoothstep(0.875, 1.0, star);

	vec3 star_col = vec3(1.0);

	return star * star_col;
}

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv) {
	if (dissolve < 0.001) {
		return vec4(shadow ? vec3(0., 0., 0.) : tex.xyz, shadow ? tex.a * 0.3 : tex.a);
	}

	float adjusted_dissolve =
		(dissolve * dissolve * (3. - 2. * dissolve)) * 1.02 - 0.01; //Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does not pause at extreme values

	float t = time * 10.0 + 2003.;
	vec2 floored_uv = (floor((uv * texture_details.ba))) / max(texture_details.b, texture_details.a);
	vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);

	vec2 field_part1 = uv_scaled_centered + 50. * vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	vec2 field_part2 = uv_scaled_centered + 50. * vec2(cos(t / 53.1532), cos(t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50. * vec2(sin(-t / 87.53218), sin(-t / 49.0000));

	float field =
		(1. + (cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) + cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92)))
		/ 2.;
	vec2 borders = vec2(0.2, 0.8);

	float res = (.5 + .5 * cos((adjusted_dissolve) / 82.612 + (field + -.5) * 3.14))
		- (floored_uv.x > borders.y ? (floored_uv.x - borders.y) * (5. + 5. * dissolve) : 0.) * (dissolve)
		- (floored_uv.y > borders.y ? (floored_uv.y - borders.y) * (5. + 5. * dissolve) : 0.) * (dissolve)
		- (floored_uv.x < borders.x ? (borders.x - floored_uv.x) * (5. + 5. * dissolve) : 0.) * (dissolve)
		- (floored_uv.y < borders.x ? (borders.x - floored_uv.y) * (5. + 5. * dissolve) : 0.) * (dissolve);

	if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8 * (0.5 - abs(adjusted_dissolve - 0.5)) && res > adjusted_dissolve) {
		if (!shadow && res < adjusted_dissolve + 0.5 * (0.5 - abs(adjusted_dissolve - 0.5)) && res > adjusted_dissolve) {
			tex.rgba = burn_colour_1.rgba;
		} else if (burn_colour_2.a > 0.01) {
			tex.rgba = burn_colour_2.rgba;
		}
	}

	return vec4(shadow ? vec3(0., 0., 0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a * 0.3 : tex.a) : .0);
}

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec4 tex = Texel(texture, texture_coords);
	vec2 uv = (((texture_coords) * (image_details)) - texture_details.xy * texture_details.ba) / texture_details.ba;

	int num_bands = 10;
	float bands_spacing = 1.5 / float(num_bands);

	vec3 start_color = vec3(0.4, 0.0, 0.2);
	vec3 end_color = vec3(0.0, 0.0, 0.4);
	vec3 final_color = mix(start_color, end_color, (uv.y + 1.0) / 2.0);

	float star_density = 1;
	vec3 star_color = gen_stars(uv, star_density);

	for (int i = 0; i < num_bands; i++) {
		float offset = -0.7 + bands_spacing * (float(i) + 0.5);
		vec2 r_wave = uv;

		r_wave.y -= offset;

		float noise_seed = float(i) * 0.1;
		float dir = mod(float(i), 2.0) * 2.0 - 1.0;

		float wave_one = noise(vec2(r_wave.x * 3.0 + dir * time * 0.5, noise_seed)) * 0.3;
		float wave_two = noise(vec2(r_wave.x * 5.0 + dir * time * 1.0, noise_seed + 2.0)) * 0.4;
		float wave_thr = noise(vec2(r_wave.x * 2.0 + dir * time * 1.5, noise_seed + 4.0)) * 0.3;
		float wave_off = wave_one + wave_two + wave_thr;

		r_wave.y += wave_off * 0.9;

		float band_thickness = 1.0 - abs(r_wave.y) * 2.2;

		band_thickness = clamp(band_thickness, 0.0, 5.0);

		float shape = band_thickness;
		shape = clamp(shape, 0.0, 1.0);

		vec3 base_color = mix(vec3(0.1, 1.0, 0.6), vec3(0.0, 0.3, 1.0), r_wave.y + 0.5);
		vec3 glow = vec3(0.0, 0.6, 0.9) * smoothstep(-1.0, -0.3, r_wave.y);
		vec3 color = mix(base_color, vec3(0.0), 1.0 - shape);
		color += glow * 0.5;
		final_color += color * shape;
	}

	final_color = mix(final_color, star_color, 0.2 + clamp(aurora.x, 0.00000001, 0.00000001));

	return dissolve_mask(tex * vec4(final_color, 1), texture_coords, uv);
}

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
	if (hovering <= 0.) {
		return transform_projection * vertex_position;
	}
	float mid_dist = length(vertex_position.xy - 0.5 * love_ScreenSize.xy) / length(love_ScreenSize.xy);
	vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy) / screen_scale;
	float scale = 0.2 * (-0.03 - 0.3 * max(0., 0.3 - mid_dist)) * hovering * (length(mouse_offset) * length(mouse_offset)) / (2. - mid_dist);

	return transform_projection * vertex_position + vec4(0, 0, 0, scale);
}
#endif