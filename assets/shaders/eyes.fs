#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 eyes;
extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

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

#define PI 3.14159265359
#define TWO_PI 6.28318530718
#define EDGE 0.005

vec2 zoom(vec2 uv, vec2 center, float zoom_factor) {
	return center + (uv - center) * zoom_factor;
}

float fold(in float x) {
	return abs(mod(x + 1.0, 2.0) - 1.0);
}

float relative_ramp(in float x, in float s) {
	return floor(x) + clamp((max(1.0, s) * (fract(x) - 0.5)) + 0.5, 0.0, 1.0);
}

float cosine_ramp(in float x, in float s) {
	float y = cos(fract(x) * PI);
	return floor(x) + 0.5 - (0.5 * pow(abs(y), 1.0 / s) * sign(y));
}

float camel_ramp(in float x, in float s) {
	float y = fract(x);
	return floor(x) + pow(0.5 - (0.5 * cos(TWO_PI * y) * cos(PI * y)), s);
}

vec2 rotate_uv(in vec2 uv, in float theta) {
	return uv * mat2(cos(theta), -sin(theta), sin(theta), cos(theta));
}

float scale(in float x, in float in_min, in float in_max, in float out_min, in float out_max) {
	return ((x - in_min) / (in_max - in_min)) * (out_max - out_min) + out_min;
}

float random_one_dim(in vec2 uv, in int seed) {
	return fract(abs(sin(dot(uv, vec2(11.13, 57.05)) + float(seed)) * 48240.41));
}

float value_noise(in vec2 uv, in int seed) {
	vec2 x = floor(uv);
	vec2 m = fract(uv);

	float bl = random_one_dim(x, seed);
	float br = random_one_dim(x + vec2(1.0, 0.0), seed);
	float tl = random_one_dim(x + vec2(0.0, 1.0), seed);
	float tr = random_one_dim(x + vec2(1.0, 1.0), seed);

	vec2 cf = smoothstep(vec2(0.0), vec2(1.0), m);

	float tm = mix(tl, tr, cf.x);
	float bm = mix(bl, br, cf.x);

	return mix(bm, tm, cf.y);
}

float eye_sdf(in vec2 uv, in float s) {
	float o = 0.125;
	vec2 nuv = abs(uv * vec2(1.0 + o, 1.0));
	float x = clamp(nuv.x * (1.0 - o), 0.0, 0.5);

	nuv -= vec2(0.5, pow(cos(x * PI) / s, s));

	return length(max(vec2(0.0), nuv)) + min(0.0, max(nuv.x, nuv.y));
}

vec4 make_tearduct(in float sdf, in float t) {
	vec3 col = mix(vec3(0.0, 0.0, 0.0), vec3(0.8471, 0.8471, 0.8471), cosine_ramp(fold(sdf * 60.0 + t * 0.25), 2.0));
	float a = smoothstep(EDGE, 0.0, sdf + EDGE);

	return vec4(col, a);
}

vec4 make_eyelids(in float sdf) {
	return smoothstep(EDGE * 2.0, 0.0, abs(sdf) - 0.01) * vec4(0.6471, 0.6471, 0.6471, 1.0);
}

vec4 make_sclera(in vec2 uv, in float d, in float t) {
	float g = rotate_uv(uv, length(uv) * TWO_PI * sin(t * 0.1) + t * 0.01).y;
	vec3 glow = smoothstep(EDGE, 0.0, g) * vec3(1.0 + clamp(eyes.x, 0.000001, 0.000001));
	vec4 sclera = smoothstep(EDGE, 0.0, d - 0.25) * vec4(0.8275, 0.8235, 0.8235, 1.0);
	vec4 border = smoothstep(EDGE, 0.0, abs(d - 0.25) - 0.0025) * vec4(0.2549, 0.2549, 0.2549, 1.0);

	sclera.rgb = mix(sclera.rgb, glow, glow.r);
	sclera = mix(sclera, border, border.a);

	return sclera;
}

vec4 make_iris(in vec2 uv, in float d, in float t) {
	float a = atan(uv.x, uv.y);
	vec3 col = mix(vec3(0.6784, 0.7922, 0.8431), vec3(0.6118, 0.7255, 0.7804), fold(cosine_ramp(sin(a * 3.0 * cos(a * 2.0) + t * 0.5), 4.0)));

	col = mix(col, vec3(0.7765, 0.8196, 0.8392), cosine_ramp(cos(3.0 * a * sin(-a * 1.5) + t * 0.4) * 0.5 + 0.5, 4.0));

	vec4 iris = smoothstep(EDGE, 0.0, d - 0.125) * vec4(col, 1.0);
	vec4 border = smoothstep(EDGE, 0.0, abs(d - 0.125) - 0.002) * vec4(0.2627, 0.2353, 0.2353, 1.0);
	float shade = cos(a + t * 0.25) * 0.5 + 0.5;

	shade *= shade;
	shade = cosine_ramp(shade, 4.0);

	iris = mix(iris, border, border.a);
	iris.rgb = mix(iris.rgb, vec3(0.3529, 0.4627, 0.4941), shade * 0.75);

	return iris;
}

vec4 make_pupil(in float d, in float t) {
	t = sin(d + t * 0.125) * 0.01;

	return smoothstep(EDGE, 0.0, d - 0.05 + t) * vec4(0.0627, 0.0588, 0.0588, 1.0);
}

vec4 make_glow(in vec2 uv, in float t) {
	float d = length(uv);

	uv *= vec2(sin(d * 2.123 - t * 0.798347), cos(d * 3.123 + t * 0.91823)) * 0.1 + 1.0;
	d = length((uv - (uv.y * 0.1)) - 0.05);

	vec4 glow = smoothstep(EDGE * 1.5, 0.0, d - 0.03) * vec4(1.0);

	d = length((uv - (uv.y * 0.1)) + 0.05);
	glow = mix(glow, smoothstep(EDGE * 1.25, 0.0, d - 0.02) * vec4(1.0), 1.0 - glow.a);

	return glow;
}

vec4 make_retina(in vec2 uv, in float t) {
	vec4 retina = vec4(0.0);

	uv *= length(uv) * 1.5 + 1.0;
	uv += vec2(cos(t * 0.98), sin(t * 0.234)) * 0.08;

	float d = length(uv);
	vec4 glow = make_glow(uv, t);
	vec4 iris = make_iris(uv, d, t);
	vec4 pupil = make_pupil(d + sin(t * 0.5 + 0.12) * 0.005, t);

	retina = mix(retina, iris, iris.a);
	retina = mix(retina, pupil, pupil.a * retina.a);
	retina = mix(retina, glow, glow.a * 0.975 * iris.a);

	return retina;
}

vec4 make_eyeball(in vec2 uv, in float t) {
	float d = length(uv);
	vec4 eyeball = vec4(0.0);
	vec4 sclera = make_sclera(uv, d, t);
	vec4 retina = make_retina(uv, t + relative_ramp(t, 2.0));

	eyeball = mix(eyeball, sclera, sclera.a);
	eyeball = mix(eyeball, retina, retina.a * sclera.a);

	return eyeball;
}

vec4 make_eye(in vec2 uv, in float b, in float t) {
	vec4 eye = vec4(0.0);
	float eyesdf = eye_sdf(uv * 1.06, b);
	vec4 tearduct = make_tearduct(eyesdf, t);
	vec4 eyelids = make_eyelids(eyesdf);
	vec4 eyeball = make_eyeball(uv, t);

	eye = mix(eye, tearduct, tearduct.a);
	eye = mix(eye, eyeball, eyeball.a * tearduct.a);
	eye = mix(eye, eyelids, eyelids.a);

	return vec4(eye);
}

vec2 bulge(vec2 uv, vec2 center, float strength) {
	vec2 diff = uv - center;
	float dist = length(diff);

	if (dist < 1.0) {
		float scale = 1.0 + strength * pow(1.0 - dist, 4.0);

		return center + diff * scale;
	}

	return uv;
}

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec4 tex = Texel(texture, texture_coords);
	vec2 uv = (((texture_coords) * (image_details)) - texture_details.xy * texture_details.ba) / texture_details.ba;

	float scale_val = 1.75;
	vec2 puv = uv * scale_val + vec2(time * 0.01, time * -0.0107);
	vec4 color = vec4(0.0);
	float sdf = 1.0;

	for (float i = 0.0; i <= 1.0; i++) {
		uv = puv + 7.5 * (1.0 - i);

		vec2 iuv = floor(uv);

		uv = fract(uv) - 0.5;

		float rand = value_noise(iuv, int(uv.x * uv.y));
		float t = (time + 100.0 * (i + 0.5)) * (rand + 1.0);

		uv = rotate_uv(uv, t * 0.01);

		float b = scale(pow(fold(t * 0.1), 100.0), 0.0, 1.0, 2.0, 10.0);
		vec4 eye = make_eye(uv * pow(2.0, rand), b, t * 0.5);

		sdf = min(sdf, eye_sdf(uv * scale_val, b));
		color = mix(color, eye, eye.a);
	}

	sdf = camel_ramp(fold(sdf * (16.0 + sin(time * 0.25) * 2.0) - time * 0.1), 1.0 + clamp(eyes.x, 0.000001, 0.000001));
	sdf *= sdf;
	color = mix(color, sdf * vec4(0.6824, 0.6824, 0.6824, 1.0), sdf * (1.0 - color.a));
	// color.a = 1.0;

	return dissolve_mask(tex * color, texture_coords, uv);
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