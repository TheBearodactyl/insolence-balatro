#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 dvd;
extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;
uniform vec3 iResolution;

#define PI 3.14159265359

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }

    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01; //Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does not pause at extreme values

	float t = time * 10.0 + 2003.;
	vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
	
	vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5. + 5.*dissolve) : 0.)*(dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : .0);
}

float noise(vec2 p) {
    return sin(p.x * 10.0) * sin(p.y * (3.0 + sin(time / 11.0))) + 0.2;
}

mat2 rotate(float angle) {
    return mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
}

float fbm(vec2 p) {
    p *= 1.1;
    float f = 0.;
    float amp = .5;

    for (int i = 0; i < 3; i++) {
        mat2 modify = rotate(time / 50. * float(i * i));
        f += amp * noise(p);
        p = modify * p;
        p += 2.;
        amp /= 2.2;
    }

    return f;
}

float pattern(vec2 p, out vec2 q, out vec2 r) {
    q = vec2(fbm(p + vec2(1.)), fbm(rotate(.1 * time) * p + vec2(1.)));
    r = vec2(fbm(rotate(.1) * q + vec2(0.)), fbm(q + vec2(0.)));

    return fbm(p + 1. * r);
}

float digit(vec2 p) {
    vec2 grid = vec2(3., 1.) * 15;
    vec2 s = floor(p * grid) / grid;
    p = p * grid;

    vec2 q;
    vec2 r;

    float intensity = pattern(s / 10., q, r) * 1.3 - 0.03;
    p = fract(p);
    p *= vec2(1.2, 1.2);

    float x = fract(p.x * 5.);
    float y = fract((1. - p.y) * 5.);
    int i = int(floor((1. - p.y) * 5.));
    int j = int(floor(p.x * 5.));
    int n = (i - 2) * (i - 2) + (j - 2) * (j - 2);

    float f = float(n) / 16.;
    float is_on = intensity - f > 0.1 ? 1. : 0.;

    return p.x <= 1. && p.y <= 1. ? is_on * (0.2 + y * 4. / 5.) * (0.75 + x / 4.) : 0.;
}

float hash(float x) {
    return fract(sin(x * 234.1) * 324.19 + sin(sin(x * 3214.09) * 34.132 * x) + x * 234.12);
}

float on_off(float a, float b, float c) {
    return step(c, sin(time + a * cos(time * b)));
}

float displace(vec2 look) {
    float y = (look.y - mod(time / 4., 1.));
    float win = 1. / (1. + 50. * y * y);

    return (sin(look.y * 20. + time) / 80. * on_off(4., 2., .8) * (1. + cos(time * 60.)) * win);
}

vec3 get_color(vec2 p) {
    float bar = mod(p.y + time * 20., 1.) < 0.2 ? 1.4 : 1.;
    p.x += displace(p);
    float middle = digit(p);
    float off = 0.002;
    float sum = 0.;

    for (float i = -1.; i < 2.; i += 1.) {
        for (float j = -1.; j < 2.; j += 1.) {
            sum += digit(p + vec2(off * i, off * j));
        }
    }

    return vec3(0.9) * middle + sum / 10. * vec3(0., 1., 0.) * bar;
}

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 tex = Texel(texture, texture_coords);
    vec2 uv = (((texture_coords) * (image_details)) - texture_details.xy * texture_details.ba) / texture_details.ba;

    float time_fast = time / 3. + clamp(dvd.x, 0.001, 0.002);
    vec2 p = texture_coords / uv.xy;
    float off = 0.0001;
    vec3 col = get_color(p);

    vec4 final_colour = vec4(col, clamp(dvd.x, 1.0, 1.0));

    return dissolve_mask(tex * final_colour, texture_coords, uv);
}

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif