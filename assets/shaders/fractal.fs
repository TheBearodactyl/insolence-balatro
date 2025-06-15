#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 fractal;
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

#define MaxSteps 30
#define MinimumDistance 0.0009
#define normalDistance 0.0002

#define Iterations 7
#define PI 3.141592
#define Scale 3.0
#define FieldOfView 1.0
#define Jitter 0.05
#define FudgeFactor 0.7
#define NonLinearPerspective 2.0
#define DebugNonlinearPerspective false

#define Ambient 0.32184
#define Diffuse 0.5
#define LightDir vec3(1.0)
#define LightColor vec3(1.0, 1.0, 0.858824)
#define LightDir2 vec3(1.0, -1.0, 1.0)
#define LightColor2 vec3(0.0, 0.333333, 1.0)
#define Offset vec3(0.92858, 0.92858, 0.32858)

vec2 rotate(vec2 v, float a) {
	return vec2(cos(a) * v.x + sin(a) * v.y, -sin(a) * v.x + cos(a) * v.y);
}

// Two light sources. No specular
vec3 getLight(in vec3 color, in vec3 normal, in vec3 dir) {
	vec3 lightDir = normalize(LightDir);
	float diffuse = max(0.0, dot(-normal, lightDir)); // Lambertian

	vec3 lightDir2 = normalize(LightDir2);
	float diffuse2 = max(0.0, dot(-normal, lightDir2)); // Lambertian

	return (diffuse * Diffuse) * (LightColor * color) + (diffuse2 * Diffuse) * (LightColor2 * color);
}

// DE: Infinitely tiled Menger IFS.
//
// For more info on KIFS, see:
// http://www.fractalforums.com/3d-fractal-generation/kaleidoscopic-%28escape-time-ifs%29/
float DE(in vec3 z) {
	// enable this to debug the non-linear perspective
	if (DebugNonlinearPerspective) {
		z = fract(z);
		float d = length(z.xy - vec2(0.5));
		d = min(d, length(z.xz - vec2(0.5)));
		d = min(d, length(z.yz - vec2(0.5)));
		return d - 0.01;
	}
	// Folding 'tiling' of 3D space;
	z = abs(1.0 - mod(z, 2.0));

	float d = 1000.0;
	for (int n = 0; n < Iterations; n++) {
		z.xy = rotate(z.xy, 4.0 + 2.0 * cos(time / 8.0));
		z = abs(z);
		if (z.x < z.y) {
			z.xy = z.yx;
		}
		if (z.x < z.z) {
			z.xz = z.zx;
		}
		if (z.y < z.z) {
			z.yz = z.zy;
		}
		z = Scale * z - Offset * (Scale - 1.0);
		if (z.z < -0.5 * Offset.z * (Scale - 1.0))
			z.z += Offset.z * (Scale - 1.0);
		d = min(d, length(z) * pow(Scale, float(-n) - 1.0));
	}

	return d - 0.001;
}

// Finite difference normal
vec3 getNormal(in vec3 pos) {
	vec3 e = vec3(0.0, normalDistance, 0.0);

	return normalize(vec3(DE(pos + e.yxx) - DE(pos - e.yxx), DE(pos + e.xyx) - DE(pos - e.xyx), DE(pos + e.xxy) - DE(pos - e.xxy)));
}

// Solid color
vec3 getColor(vec3 normal, vec3 pos) {
	return vec3(1.0);
}

// Pseudo-random number
// From: lumina.sourceforge.net/Tutorials/Noise.html
float rand(vec2 co) {
	return fract(cos(dot(co, vec2(4.898, 7.23))) * 23421.631);
}

vec4 rayMarch(in vec3 from, in vec3 dir, in vec2 fragCoord) {
	// Add some noise to prevent banding
	float totalDistance = Jitter * rand(fragCoord.xy + vec2(time));
	vec3 dir2 = dir;
	float distance;
	int steps = 0;
	vec3 pos;
	for (int i = 0; i < MaxSteps; i++) {
		// Non-linear perspective applied here.
		dir.zy = rotate(dir2.zy, totalDistance * cos(time / 4.0) * NonLinearPerspective);

		pos = from + totalDistance * dir;
		distance = DE(pos) * FudgeFactor;
		totalDistance += distance;
		if (distance < MinimumDistance)
			break;
		steps = i;
	}

	// 'AO' is based on number of steps.
	// Try to smooth the count, to combat banding.
	float smoothStep = float(steps) + distance / MinimumDistance;
	float ao = 1.1 - smoothStep / float(MaxSteps);

	// Since our distance field is not signed,
	// backstep when calc'ing normal
	vec3 normal = getNormal(pos - dir * normalDistance * 3.0);

	vec3 color = getColor(normal, pos);
	vec3 light = getLight(color, normal, dir);
	color = (color * Ambient + light) * ao;
	return vec4(color, 1.0);
}

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec4 tex = Texel(texture, texture_coords);
	vec2 uv = (((texture_coords) * (image_details)) - texture_details.xy * texture_details.ba) / texture_details.ba;

	vec3 cam_pos = (0.5 + clamp(fractal.x, 0.000001, 0.000001)) * time * vec3(1.0, 0.0, 0.0);
	vec3 target = cam_pos + vec3(1.0, 0.0 * cos(time), 0.0 * sin(0.4 * time));
	vec3 cam_up = vec3(0.0, 1.0, 0.0);
	vec3 cam_dir = normalize(target - cam_pos);

	cam_up = normalize(cam_up - dot(cam_dir, cam_up) * cam_dir);

	vec3 cam_right = normalize(cross(cam_dir, cam_up));
	vec2 coord = -1.0 + 2.0 * uv.xy / tex.xy;

	coord.x *= tex.x / tex.y;

	vec3 ray_dir = normalize(cam_dir + (coord.x * cam_right + coord.y * cam_up) * FieldOfView);

	vec4 final_color = rayMarch(cam_pos, ray_dir, uv);

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