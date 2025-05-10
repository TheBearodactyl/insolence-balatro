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
extern MY_HIGHP_OR_MEDIUMP vec2 bubbly;

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

float hash21(vec2 p) {
	p = fract(p * vec2(233.0, 851.0));
	p += dot(p, p + 23.0);

	return fract(p.x * p.y);
}

vec4 hex_coords(vec2 p) {
	vec2 normal = vec2(1.0, 1.7320508075688772);
	vec2 h = normal * 0.5;
	vec2 a = mod(p, normal) - h;
	vec2 b = mod(p - h, normal) - h;
	vec2 gv = dot(a, a) < dot(b, b) ? a : b;

	return vec4(gv, p - gv);
}

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec4 tex = Texel(texture, texture_coords);
	vec2 uv = (((texture_coords) * (image_details)) - texture_details.xy * texture_details.ba) / texture_details.ba;

	uv += vec2(sin(0.11 * time), cos(0.13 * time)) * 0.2;
	uv *= 10.0 + 2.0 * cos(time * 0.1);

	vec4 hc = hex_coords(uv);

	bool nemo = length(hc.zw - vec2(4.0, -2.0)) < 4.0;
	float r0 = nemo ? 0.2 : 0.12;
	float r1 = nemo ? 0.3 : 0.4;
	float w = 0.06;
	float om = 2.0;

	float r = r0 + (sin(om * time + hc.z * 0.71) * sin(om * time + hc.w * 1.1) + 1.0) * 0.53 * (r1 - r0);
	float c = length(hc.xy);

	c = smoothstep(-0.01, 0.01, abs(c - r) - w);

	vec3 lightblue = vec3(67.0, 101.0, 153.0) / 255.0;
	vec3 darkblue = vec3(16.0, 17.0, 73.0) / 255.0;
	vec3 orange = vec3(234.0, 154.0, 58.0) / 255.0;

	vec3 col = c * darkblue;
	col += (1.0 - c) * (nemo ? orange : lightblue);

	return dissolve_mask(tex * vec4(col, clamp(bubbly.x, 0.9, 0.9)), texture_coords, uv);
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