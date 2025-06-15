#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define PRECISION highp
#else
	#define PRECISION mediump
#endif

extern PRECISION vec2 cellular;
extern PRECISION number dissolve;
extern PRECISION number time;
extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;
extern bool shadow;
extern PRECISION vec4 burn_colour_1;
extern PRECISION vec4 burn_colour_2;

float disk(vec2 r, vec2 center, float radius) {
	return 1.0 - smoothstep(radius - 0.008, radius + 0.008, length(r - center));
}

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv);

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec4 tex = Texel(texture, texture_coords);
	vec2 uv = (((texture_coords) * (image_details)) - texture_details.xy * texture_details.ba) / texture_details.ba;

	// Normalize UV coordinates to work similarly to mainImage's fragCoord
	vec2 r = (2.0 * uv - 1.0) * vec2(texture_details.z / texture_details.w, 1.0);
	r *= 1.0 + 0.05 * sin(r.x * 5. + time) + 0.05 * sin(r.y * 3. + time);
	r *= 1.0 + 0.2 * length(r);

	float side = 0.45;
	vec2 r2 = mod(r, side);
	vec2 r3 = r2 - side / 2.0;
	float i = floor(r.x / side) + 2.0;
	float j = floor(r.y / side) + 4.0;
	float ii = r.x / side + 2.0;
	float jj = r.y / side + 4.0;

	// Define colors (converted from RGB to 0-1 range)
	vec3 col1 = vec3(0.216, 0.471, 0.698); // blue
	vec3 col2 = vec3(1.00, 0.329, 0.298); // red
	vec3 col3 = vec3(0.867, 0.910, 0.247); // yellow

	// Disk function
	vec3 pix = vec3(1.0);
	float rad, disks;

	// First disk pattern
	rad = 0.15 + 0.05 * sin(time + ii * jj);
	disks = disk(r3, vec2(0.0, 0.0), rad);
	pix = mix(pix, col2, disks);

	// Moving disks
	float speed = 1.0;
	float tt = time * speed + 0.1 * i + 0.08 * j;
	float stopEveryAngle = 3.14159265359 / 5.0;
	float stopRatio = 0.7 + clamp(cellular.y, 0.0000001, 0.0000001);
	float t1 = (floor(tt) + smoothstep(0.0, 1.0 - stopRatio, fract(tt))) * stopEveryAngle;

	float x = -0.07 * cos(t1 + i);
	float y = 0.055 * (sin(t1 + j) + cos(t1 + i));
	rad = 0.1 + 0.05 * sin(time + i + j);
	disks = disk(r3, vec2(x, y), rad);
	pix = mix(pix, col1, disks);

	// Central disk with glow effect
	rad = 0.2 + 0.05 * sin(time * (1.0 + 0.01 * i));
	disks = disk(r3, vec2(0.0, 0.0), rad);
	pix += 0.2 * col3 * disks * sin(time + i * j - i);

	// Darken edges
	pix -= smoothstep(0.3, 5.5, length(r));

	// Apply the pattern to the original texture
	tex.rgb = mix(tex.rgb, pix, 0.459);

	return dissolve_mask(tex * colour, texture_coords, uv);
}

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv) {
	if (dissolve < 0.001) {
		return vec4(shadow ? vec3(0., 0., 0.) : tex.xyz, shadow ? tex.a * 0.3 : tex.a);
	}

	float adjusted_dissolve = (dissolve * dissolve * (3. - 2. * dissolve)) * 1.02 - 0.01;
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

extern PRECISION float hovering;
extern PRECISION float screen_scale;
extern PRECISION vec2 mouse_screen_pos;

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