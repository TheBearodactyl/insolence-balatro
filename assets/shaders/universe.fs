#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 universe;
extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;
extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

uniform MY_HIGHP_OR_MEDIUMP vec3 iMouse;
uniform MY_HIGHP_OR_MEDIUMP vec3 iResolution;
uniform float iTime;

#define S(a, b, t) smoothstep(a, b, t)
#define NUM_LAYERS 4.0

//#define SIMPLE

float n21(vec2 p) {
	vec3 a = fract(vec3(p.xyx) * vec3(213.897, 653.453, 253.098));
	a += dot(a, a.yzx + 79.76);

	return fract((a.x + a.y) * a.z);
}

vec2 get_pos(vec2 id, vec2 offset, float t) {
	float n = n21(id + offset);
	float n1 = fract(n * 10.0);
	float n2 = fract(n * 100.0);
	float a = t + n;

	return offset + vec2(sin(a * n1), cos(a * n2)) * 0.4;
}

float get_t(vec2 ro, vec2 rd, vec2 p) {
	return dot(p - ro, rd);
}

float line_dist(vec3 a, vec3 b, vec3 p) {
	return length(cross(b - a, p - a)) / length(p - a);
}

float df_line(in vec2 a, in vec2 b, in vec2 p) {
	vec2 pa = p - a, ba = b - a;
	float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);

	return length(pa - ba * h);
}

float line(vec2 a, vec2 b, vec2 uv) {
	float r1 = 0.04;
	float r2 = 0.01;
	float d = df_line(a, b, uv);
	float d2 = length(a - b);
	float fade = S(1.5, 0.5, d2);

	fade += S(0.05, 0.02, abs(d2 - 0.75));

	return S(r1, r2, d) * fade;
}

float net_layer(vec2 st, float n, float t) {
	vec2 id = floor(st) + n;

	st = fract(st) - 0.5;

	vec2 p[9];
	int i = 0;
	for (float y = -1.0; y <= 1.0; y++) {
		for (float x = -1.0; x <= 1.0; x++) {
			p[i++] = get_pos(id, vec2(x, y), t);
		}
	}

	float m = 0.0;
	float sparkle = 0.0;

	for (int i = 0; i < 9; i++) {
		m += line(p[4], p[i], st);

		float d = length(st - p[i]);
		float s = (0.005 / (d * d));

		s *= S(1.0, 0.7, d);

		float pulse = sin((fract(p[i].x) + fract(p[i].y) + t) * 5.0) * 0.4 + 0.6;
		pulse = pow(pulse, 20.0);

		s *= pulse;
		sparkle += s;
	}

	m += line(p[1], p[3], st);
	m += line(p[1], p[5], st);
	m += line(p[7], p[5], st);
	m += line(p[7], p[3], st);

	float s_phase = (sin(t + n) + sin(t * 0.1)) * 0.25 + 0.5;
	s_phase += pow(sin(t * 0.1) * 0.5 + 0.5, 50.0) * 5.0;
	m += sparkle * s_phase;

	return m;
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
	vec2 M = iMouse.xy * iResolution.xy - 0.5;

	float t = time;
	float s = sin(t);
	float c = cos(t);
	mat2 rot = mat2(c, -s, s, c);
	vec2 st = uv * rot;
	M *= rot * 1.5;

	float m = 0.0;
	for (float i = 0.0; i < 1.0; i += 1.0 / NUM_LAYERS) {
		float z = fract(t + i);
		float size = mix(13.0, 1.0, z);
		float fade = S(0.0, 0.6, z) * S(1.0, 0.8, z);
		m += fade * net_layer(st * size - M * z, i, time);
	}

	float glow = -uv.y * universe.x * 2.0;
	vec3 base_col = vec3(s, cos(t * 0.7), -sin(t * 0.24)) * 0.4 + 0.6;
	vec3 col = base_col * m;

	col += base_col * glow;

#ifdef SIMPLE
	uv *= 10.0;
	col = vec3(1) * net_layer(uv, 0.0, time * 10.0);
	uv = fract(uv);
#else
	col *= 2.0 - dot(uv, uv);
	t = mod(time, 120.0);
	col *= S(0.0, 22.0, t) * S(234.0, 230.0, t);
#endif

	return dissolve_mask(tex * vec4(col, clamp(universe.y, 1, 1)), texture_coords, uv);
}

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