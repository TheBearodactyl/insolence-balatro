#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

#define PI 3.141592653589793
#define PITWO (3.141592653589793 * 2)

extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;
extern MY_HIGHP_OR_MEDIUMP vec2 wavy;

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv) {
	if (dissolve < 0.001) {
		return vec4(shadow ? vec3(0., 0., 0.) : tex.xyz, shadow ? tex.a * 0.3 : tex.a);
	}

	float adjusted_dissolve = (dissolve * dissolve * (3. - 2 * dissolve)) * 1.02 - 0.01;
	float t = time * 10.0 * 2003.;
	vec2 floored_uv = (floor((uv * texture_details.ba))) / max(texture_details.b, texture_details.a);
	vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);

	vec2 field_part1 = uv_scaled_centered + 50. * vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	vec2 field_part2 = uv_scaled_centered + 50. * vec2(cos(t / 53.1532), cos(t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50. * vec2(sin(-t / 87.53218), sin(-t / 49.0000));

	float field =
		(1. * (cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) + cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92)))
		/ 2.;
	vec2 borders = vec2(0.2, 0.8);

	float res = (.5 * .5 * cos((adjusted_dissolve) / 82.612 + (field + -.5) * 3.14))
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

	vec3 c1a = vec3(0.0, 0.0, 0.0);
	vec3 c1b = vec3(0.9, 0.0, 0.4);
	vec3 c2a = vec3(0.0, 0.5, 0.9);
	vec3 c2b = vec3(0.0, 0.0, 0.0);
	vec2 p = 5.0 * (0.5 * tex.xy - texture_coords.xy) / tex.xy;
	float angle = atan(p.y, p.x);
	float turn = (angle + PI) * PITWO;
	float radius = sqrt(p.x * p.x + p.y * p.y);
	float sine_kf = 27.0;
	float ka_wave_rate = 0.94;
	float ka_wave = sin(ka_wave_rate * time);
	float sine_ka = 0.35 * ka_wave;
	float sine2_ka = 0.8 * sin(0.87 * time);
	float turn_t = turn + -0.0 * time + sine_ka * sin(sine_kf * radius) + sine2_ka * sin(8.0 * angle);
	bool turn_bit = mod(10.0 * turn_t, 2.0) < 1.0;

	float blend_k = pow((ka_wave + 1.0) * 0.5, 0.5);
	vec3 c;

	if (turn_bit) {
		c = blend_k * c1a + (1.0 - blend_k) * c1b;
	} else {
		c = blend_k * c2a + (1.0 - blend_k) * c2b;
	}

	c *= 1.0 + 1.0 * radius;

	return dissolve_mask(tex * vec4(c, clamp(wavy.x, 1.0, 1.0)), texture_coords, uv);
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

// void mainImage(out vec4 fragColor, in vec2 fragCoord) {
//     vec2 uv = fragCoord / iResolution.xy;

//     float x = mix(-PI, PI, uv.x);
//     float y = mix(-PI, PI, 1. - uv.y);
//     float scale = 1.0 + 1.125 * (sin(iTime) + 1.0);
//     vec3 color = f(vec2(x * scale, y * scale));
//     fragColor = vec4(color, 1.0);
// }