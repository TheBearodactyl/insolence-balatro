#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 pizza;
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

#define MAX_STEPS 100
#define MAX_DIST 100.
#define SURF_DIST .001
#define TAU 6.283185
#define PI 3.141592
#define S smoothstep
#define T time
#define S01(x) S(0.0, 1.0, x)
#define SAT(x) clamp(x, 0.0, 1.0)
#define LSQ(x) dot(x, x)

vec2 closest(vec2 point, vec2 linea, vec2 lineb) {
	float l2 = LSQ(linea - lineb);
	if (l2 == 0.)
		return linea;

	float t = dot(point - linea, lineb - linea) / l2;
	t = clamp(t, 0.0, 1.0);
	return linea + t * (lineb - linea);
}

vec2 project(vec2 v, vec2 n) {
	return n * dot(v, n);
}

float sdDisk(vec3 uv) {
	vec3 t = uv;
	if (length(t.xz) > 1.0)
		t.xz = normalize(t.xz);
	t.y = 0.0;
	return distance(uv, t);
}

float sdPizza(vec3 uv, float angle) {
	vec3 t = uv;
	if (length(t.xz) > 1.0)
		t.xz = normalize(t.xz);
	t.y = 0.0;
	float a = fract(atan(t.z, t.x) / TAU) * TAU;
	if (a > angle) {
		vec2 l1 = closest(t.xz, vec2(0), vec2(1, 0));
		vec2 l2 = closest(t.xz, vec2(0), vec2(cos(angle), sin(angle)));
		t.xz = LSQ(l1) > LSQ(l2) ? l1 : l2;
	}

	return distance(uv, t);
}

mat2 Rot(float a) {
	float s = sin(a), c = cos(a);
	return mat2(c, -s, s, c);
}

float sdBox(vec3 p, vec3 s) {
	p = abs(p) - s;
	return length(max(p, 0.)) + min(max(p.x, max(p.y, p.z)), 0.);
}

float random_float(vec3 p) {
	vec3 a = fract((p + 1.414) * vec3(31.123, 3.141, 6.762));
	a += dot(a, a + 12.653);
	a = vec3(a.x * a.y, a.x * a.z, a.y * a.z);
	return fract(dot(a, a));
}

vec3 random_vec3(vec3 a) {
	a = vec3(dot(a, vec3(127.1, 311.7, 634.8)), dot(a, vec3(269.5, 183.3, 878.8)), dot(a, vec3(413.2, 631.3, 194.3)));
	return fract(sin(a) * 43758.5453);
}

float voronoi(vec3 uv) {
	vec3 tile = floor(uv);
	vec3 local = uv - tile;

	float d = 100.;

	vec3 r[3 * 3 * 3];

	for (int x = -1; x <= 1; ++x) {
		for (int y = -1; y <= 1; ++y) {
			for (int z = -1; z <= 1; ++z) {
				d = min(d, distance(local, vec3(x, y, z) + random_vec3(tile + vec3(x, y, z))));
			}
		}
	}

	return d;
}

float noise(vec3 uv) {
	vec3 r = fract(uv);
	r = smoothstep(0., 1., r);

	vec3 t = floor(uv);

	float a = random_float(t + vec3(0, 0, 0));
	float b = random_float(t + vec3(1, 0, 0));
	float c = random_float(t + vec3(0, 1, 0));
	float d = random_float(t + vec3(1, 1, 0));
	float e = random_float(t + vec3(0, 0, 1));
	float f = random_float(t + vec3(1, 0, 1));
	float g = random_float(t + vec3(0, 1, 1));
	float h = random_float(t + vec3(1, 1, 1));
	return mix(mix(mix(a, b, r.x), mix(c, d, r.x), r.y), mix(mix(e, f, r.x), mix(g, h, r.x), r.y), r.z);
}

float smin(float a, float b, float k) {
	float h = SAT((b - a) / k + 0.5);
	return b + h * (a - b + k * 0.5 * (h - 1.0));
}

float GetDist(vec3 p) {
	float t = 0.4 + 0.2 * sin(time);
	//t = 0.1;
	t = 0.15 + 0.05 * sin(time * 1.2);
	//t = iMouse.y/iResolution.y;
	float a = sin(time) * PI + PI;
	//a = TAU*0.1;
	//a = iMouse.x/iResolution.x*TAU;
	float d = sdPizza(p, a) - t;
	d = smin(d, -(sdDisk(p * (1.0 + t) - vec3(0, t, 0)) - t * 0.5), -0.1);
	return d;
}

float RayMarch(vec3 ro, vec3 rd) {
	float dO = 0.;

	for (int i = 0; i < MAX_STEPS; i++) {
		vec3 p = ro + rd * dO;
		float dS = GetDist(p);
		dO += dS;
		if (dO > MAX_DIST || abs(dS) < SURF_DIST)
			break;
	}

	return dO;
}

vec3 GetNormal(vec3 p) {
	vec2 e = vec2(.001, 0);
	vec3 n = GetDist(p) - vec3(GetDist(p - e.xyy), GetDist(p - e.yxy), GetDist(p - e.yyx));

	return normalize(n);
}

vec3 GetRayDir(vec2 uv, vec3 p, vec3 l, float z) {
	vec3 f = normalize(l - p), r = normalize(cross(vec3(0, 1, 0), f)), u = cross(f, r), c = f * z, i = c + uv.x * r + uv.y * u;
	return normalize(i);
}

vec2 translate_uv(vec2 uv, float x, float y) {
	return uv - vec2(x, y);
}

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec4 tex = Texel(texture, texture_coords);
	vec2 uv = (((texture_coords) * (image_details)) - texture_details.xy * texture_details.ba) / texture_details.ba;

	uv = translate_uv(uv, 0.5, 0.5);
	vec2 m = vec2(time * 0.1, -0.2 - 0.1 * sin(time * 0.8));
	vec3 ro = vec3(0, 3, -3);
	ro.yz *= Rot(-m.y * PI + 1.);
	ro.xz *= Rot(-m.x * TAU);

	vec3 rd = GetRayDir(uv, ro, vec3(0, 0., 0), 1.);
	vec3 col = vec3(0);

	vec3 V = normalize(rd);

	float d = RayMarch(ro, rd);

	vec3 L = normalize(vec3(2, 3, 1));
	vec3 ambient = vec3(.3, .6, .9);

	if (d < MAX_DIST) {
		vec3 p = ro + rd * d;
		vec3 n = GetNormal(p);
		vec3 r = reflect(rd, n);
		vec3 N = n;
		vec3 H = normalize(L - V);

		vec4 material = mix(vec4(0.9, 0.6, 0.3, 0), vec4(0.9, 0.15, 0.1, 0.5), S(0.5, 0.4, voronoi(p * 5.0)) * S(0.9, 0.89, length(p)));
		material = mix(material, vec4(1.0, 1.0, 0.3, 0.5), S(0.3, 0.2, noise((p + noise(p)) * 20.0)) * S(0.9, 0.89, length(p)));

		vec3 albedo = material.xyz;
		float shiny = material.w;

		vec3 dif = albedo * (ambient / PI + (dot(n, normalize(vec3(1, 2, 3))) * .5 + .5));
		float specular = pow(max(0.001, dot(N, H)), shiny * 100.) * shiny;
		col = dif + specular;
	} else {
		col = sin(V * TAU * 4.0);
		col = vec3(0.3, 0.6, 0.9) + 0.1 * smoothstep(0.0, 0.1, max(max(col.x, col.y), col.z));
	}

	col = pow(col, vec3(.4545));

	vec4 final_color = vec4(col, clamp(pizza.x, 1.0, 1.0));

	return dissolve_mask(tex * final_color, texture_coords, uv);
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