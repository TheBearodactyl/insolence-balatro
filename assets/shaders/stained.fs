#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 stained;
extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

#define PI 3.14159265359

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv) {
	if (dissolve < 0.001) {
		return vec4(shadow ? vec3(0., 0., 0.) : tex.xyz, shadow ? tex.a * 0.3 : tex.a);
	}

	float adjusted_dissolve = (dissolve * dissolve * (3. - 2. * dissolve)) * 1.02 - 0.01; // Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does
	// not pause at extreme values

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

void moda(inout vec2 uv, float rep) {
	float per = 2. * PI / rep;
	float a = atan(uv.y, uv.x);
	float l = length(uv);
	a = mod(a - per / 2., per) - per / 2.;
	uv = vec2(cos(a), sin(a)) * l;
}

mat2 rot(float a) {
	return mat2(cos(a), sin(a), -sin(a), cos(a));
}

vec2 rand(vec2 x) {
	return fract(sin(vec2(dot(x, vec2(1.2, 5.5)), dot(x, vec2(4.54, 2.41)))) * 4.45);
}

// voronoi function which is a mix between Book of Shaders : https://thebookofshaders.com/12/?lan=en
// and iq article : https://iquilezles.org/articles/voronoilines
vec3 voro(vec2 uv) {
	vec2 uv_id = floor(uv);
	vec2 uv_st = fract(uv);

	vec2 m_diff;
	vec2 m_point;
	vec2 m_neighbor;
	float m_dist = 10.;

	for (int j = -1; j <= 1; j++) {
		for (int i = -1; i <= 1; i++) {
			vec2 neighbor = vec2(float(i), float(j));
			vec2 point = rand(uv_id + neighbor);
			point = 0.5 + 0.5 * sin(2. * PI * point + time);
			vec2 diff = neighbor + point - uv_st;

			float dist = length(diff);
			if (dist < m_dist) {
				m_dist = dist;
				m_point = point;
				m_diff = diff;
				m_neighbor = neighbor;
			}
		}
	}

	m_dist = 10.;
	for (int j = -2; j <= 2; j++) {
		for (int i = -2; i <= 2; i++) {
			if (i == 0 && j == 0)
				continue;
			vec2 neighbor = m_neighbor + vec2(float(i), float(j));
			vec2 point = rand(uv_id + neighbor);
			point = 0.5 + 0.5 * sin(point * 2. * PI + time);
			vec2 diff = neighbor + point - uv_st;
			float dist = dot(0.5 * (m_diff + diff), normalize(diff - m_diff));
			m_point = point;
			m_dist = min(m_dist, dist);
		}
	}

	return vec3(m_point, m_dist);
}

vec3 blue_grid(vec2 uv, float detail) {
	uv *= detail;
	vec3 v = voro(uv);
	return clamp(vec3(v.x * 0.8, v.y, 1.) * smoothstep(0.05, 0.07, v.z), 0., 1.);
}

vec3 green_grid(vec2 uv, float detail) {
	uv *= detail;
	vec3 v = voro(uv);
	return clamp(vec3(v.x, 1., v.y) * smoothstep(0.05, 0.07, v.z), 0., 1.);
}

vec3 red_grid(vec2 uv, float detail) {
	uv *= detail;
	vec3 v = voro(uv);
	return clamp(vec3(1., v.x, v.y) * smoothstep(0.05, 0.07, v.z), 0., 1.);
}

vec3 magenta_grid(vec2 uv, float detail) {
	uv *= detail;
	vec3 v = voro(uv);
	return clamp(vec3(1., v.y * 0.8, v.x * 4.) * smoothstep(0.05, 0.07, v.z), 0., 1.);
}

float ground_mask1(vec2 uv, float offset) {
	uv.y += 0.2;
	uv.y += sin(uv.x * 3.) * 0.08;
	return step(uv.y, 0. - offset);
}

float ground_mask2(vec2 uv, float offset) {
	uv.y += 0.37;
	uv.y -= sin(uv.x * 3.) * 0.08;
	return step(uv.y, 0. - offset);
}

float seaweed_mask(vec2 uv, float offset) {
	vec2 uu = uv;
	uv.x = abs(uv.x);
	uv.x -= .7;
	uv.y += 0.8;
	uv.x += sin(uv.y * 8. + time) * 0.05;
	float line = step(abs(uv.x), (0.1 - uv.y * 0.1) - offset);

	uv = uu;
	uv.x = abs(uv.x);
	uv.x -= 0.4;
	uv.y += 1.1;
	uv.x += sin(uv.y * 4. - time) * 0.05;
	float line2 = step(abs(uv.x), (0.1 - uv.y * 0.1) - offset);

	uv = uu;
	uv.y += 1.8;
	uv.x += sin(uv.y * 4. - time) * 0.05;
	float line3 = step(abs(uv.x), (0.2 - uv.y * 0.1) - offset);
	return line + line2 + line3;
}

float sun_mask(vec2 uv, float offset) {
	uv -= vec2(0.4, 0.2);
	uv *= rot(time * 0.15);
	float s = step(length(uv), 0.18 - offset);

	moda(uv, 5.);
	float l = step(abs(uv.y), (0.02 + uv.x * 0.1) - offset);
	return s + l;
}

vec3 ground(vec2 uv) {
	float m1 = clamp(ground_mask1(uv, 0.01) - ground_mask2(uv, 0.) - seaweed_mask(uv, 0.), 0., 1.);
	float m2 = clamp(ground_mask2(uv, 0.01) - seaweed_mask(uv, 0.), 0., 1.);
	return red_grid(uv, 28.) * m2 + magenta_grid(uv, 20.) * m1;
}

vec3 seaweed(vec2 uv) {
	return green_grid(uv, 35.) * seaweed_mask(uv, 0.01);
}

vec3 sun(vec2 uv) {
	float m1 = clamp(sun_mask(uv, 0.01) - (ground_mask1(uv, 0.) + ground_mask2(uv, 0.) + seaweed_mask(uv, 0.)), 0., 1.);
	return red_grid((uv - vec2(0.4, 0.2)) * rot(time * 0.15), 18.) * m1;
}

vec3 sky(vec2 uv) {
	float m1 = clamp(1. - (ground_mask1(uv, 0.) + ground_mask2(uv, 0.) + seaweed_mask(uv, 0.) + sun_mask(uv, 0.)), 0., 1.);
	return blue_grid(uv, 13.) * m1;
}

vec3 framed(vec2 uv) {
	return ground(uv) + seaweed(uv) + sky(uv) + sun(uv);
}

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec4 tex = Texel(texture, texture_coords);
	vec2 uv = (((texture_coords) * (image_details)) - texture_details.xy * texture_details.ba) / texture_details.ba;

	uv -= 0.5;
	uv /= vec2(tex.y / tex.x, 1.0 + clamp(stained.x, 0.000001, 0.000001));

	vec3 col = framed(uv);
	vec4 final_color = vec4(col, 1.0);

	return dissolve_mask(tex * final_color, texture_coords, uv);
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