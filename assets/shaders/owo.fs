#define PHI 1.6180339887

//////////////////////////////////////////////////////////////////////////

// length squared:
#define dot2(X) dot((X),(X))

// Derived from https://www.shadertoy.com/view/WcSSz3 Cotterzz
// https://www.shadertoy.com/view/tcSSzc dray
float sdSphDodeca(vec3 p,float r,float s) {
    p = abs(p);
    vec3 v = vec3( 0., -PHI*s, -s );
    return sqrt( max( max( dot2(p-v), dot2(p-v.zxy) ), dot2(p-v.yzx) ) ) - r;
}

// And by extension ...
float sdInvSphDodeca(vec3 p,float r,float s,float q) {
    p = abs(p);
    vec3 v = vec3( 0., -PHI*s, -s );
    return max( r - sqrt( min( min( dot2(p-v), dot2(p-v.zxy) ), dot2(p-v.yzx) ) ), length(p) - q );
}

//////////////////////////////////////////////////////////////////////////

// https://www.shadertoy.com/view/XcKBWc dray

// Relative sizes of Platonic Polyhedra 
// Compact inexact SDFs
// r is radius of inscribed sphere

#define max4(A,B,C,D) max(max(A,B),max(C,D))
#define max3(A,B,C) max(max(A,B),C)

float sdTetrahedron(vec3 p,float r) {
    return max4(-p.x+p.y+p.z, p.x-p.y+p.z, p.x+p.y-p.z, -p.x-p.y-p.z)/sqrt(3.) - r;
}

float sdCube(vec3 p,float r) {
    p = abs(p);
    return max3(p.x,p.y,p.z) - r;
}

float sdOctahedron(vec3 p,float r) {
    p = abs(p);
    return (p.x+p.y+p.z)/sqrt(3.) - r;
}

float sdDodecahedron(vec3 p,float r) {
    p = abs(p);
    return max3( p.y+p.z*PHI, p.z+p.x*PHI, p.x+p.y*PHI )/sqrt(2.+PHI) - r;
}

float sdIcosahedron(vec3 p,float r) {
    p = abs(p);
    return max4( p.x+p.y+p.z, p.y/PHI+p.z*PHI, p.z/PHI+p.x*PHI, p.x/PHI+p.y*PHI )/sqrt(3.) - r;
}    

// Circumscribed sphere radius ratio to Inscribed sphere radius (thanks spalmer)
#define CircSphTetrahedron  (1./3.)
#define CircSphCube         sqrt(1./3.)
#define CircSphOctahedron   sqrt(1./3.)
#define CircSphDodecahedron sqrt(1./PHI)
#define CircSphIcosahedron  sqrt(1./PHI)

////////////////////////////////

float sdTorus( vec3 p, vec2 t ) // https://www.shadertoy.com/view/Xds3zN IQ
{
    return length( vec2(length(p.xz)-t.x,p.y) )-t.y;
}

float sdSphere(vec3 p,float r) {
    return length(p) - r;
}

float sdBox(vec3 p,vec3 s) // box by distance from middle
{
    p = abs(p) - s;
    return max3(p.x,p.y,p.z);
}

    #if 0
float Sinus(float x) { // from https://www.shadertoy.com/view/w3S3z1 dray
	x = 4. * fract(x) - 2.;
	x = x * (abs(x) - 2.);
	return x * (.225 * abs(x) + .775);
}
float Cosinus(float x) { return Sinus(x+.25); }
#define ROT2(ANG) mat2(Cosinus(ANG),Sinus(ANG),-Sinus(ANG),Cosinus(ANG))
    #else
#define ROT2(ANG) mat2(cos(ANG),sin(ANG),-sin(ANG),cos(ANG))
    #endif

vec3 Spin(float tim,vec3 p) {
   tim += iTime*.5;
   p.xz *= ROT2(tim);
   p.yz *= ROT2(tim*1.5);
   //p.yx *= ROT2(tim*.5);
   return p;
}

/*
Color: MRGB
  M:0=no reflection 9=full reflection
  R,G,B: 0=none 9=max
*/
#define T(SDF,C) if ( (tmp = SDF) < hit.x ) hit = vec2(tmp,C);

vec2 Dist(vec3 pt) {
    vec2 hit = vec2(100000,0);
    float tmp, clr = 0.;
    
    T(70.-pt.z,3345.)
    T(20.-abs(pt.y),7543.)
    T(20.-pt.x,7224.)
    T(20.+pt.x,9634.)
    T(100.+pt.z,7227.)
    
    T(sdTetrahedron( Spin(1.,pt-vec3(3,4,5)),2.),6444.);
    T(sdSphere(              pt-vec3(-8,-6,-6),5.),6171.);
    T(sdOctahedron(  Spin(3.,pt-vec3(-4,4,-9)),2.),6771.);
    T(sdCube(        Spin(2.,pt-vec3(-8,4,-22)),3.),6119.);
    T(sdDodecahedron(Spin(4.,pt-vec3(4,-8,-10)),3.),6882.);
    T(sdIcosahedron( Spin(5.,pt-vec3(10,10,25)),5.),6253.);
    T(sdSphDodeca(Spin(1.5,pt-vec3(-5.,0,49)),9.,1.25),5277.)
    T(sdInvSphDodeca(Spin(1.8,pt-vec3(10.,0,39)),12.,-9.,9.),7913.)
    T(sdTorus(Spin(2.5,pt-vec3(12,-5,-15)).xyz,vec2(4,2)),6727.)
    
    return hit;
}

vec4 March(vec3 beg,vec3 dir) {
    float dist = 0.;
    vec3 pos;
    #define LIMIT 100
    for ( int stps = 0; stps <= LIMIT; ++stps ) {
        pos = beg + dir * dist;
        vec2 obj = Dist( pos );
        dist += obj.x;
        if ( obj.x < .003 || stps == LIMIT ) return vec4( pos, obj.y );
    }
    return vec4( pos, 90. );
}

vec3 Normal(vec3 pt) {
    float delta = .001; // large delta gives rounded corners
    vec3 norm = Dist(pt).x - vec3(
        Dist(pt-vec3(delta, 0., 0.)).x, 
        Dist(pt-vec3( 0.,delta, 0.)).x, 
        Dist(pt-vec3( 0., 0.,delta)).x );
    return normalize( norm );
}

float pow2n(float i,int n)
{
  while ( n-- > 0 ) i *= i;
  return i;
}

void mainImage( out vec4 O, vec2 U )
{
    vec2 R = iResolution.xy;
    vec2 uv = (U+U-R) / min(R.x,R.y);  // -1 ... +1
    uv /= 5.;
    
    vec3 cam = vec3( 5.*sin(iTime*.3), 5.*cos(iTime*.5), -64.);
    //vec3 cam = vec3( 0, 0, -64.);
    vec3 look = vec3( 20.*cos(iTime*.2), 20.*sin(iTime*.4), 40.+35.*sin(iTime*.1) );
    vec3 camdir = normalize( vec3( uv, 1. ) - look*.01 );
    
    vec3 clr = vec3(0);
    float refl = 1.; // how much reflections can contribute
    for ( float refs = 1.; refs < 7.; refs++ ) {
    
        vec4 hit = March( cam, camdir );
        vec3 norm = Normal(hit.xyz);
        float dist = length(cam-hit.xyz);
        
        vec3 light = vec3( 0, 10, -15 );
        vec3 dir = normalize( light - hit.xyz );
        float difu = dot( norm, dir );

        difu = .5 + .5*difu;

        #define CLR(X) (vec3(int(X)/100%10,int(X)/10%10,int(X)%10)/9.)
        
        float ref = floor(hit.w/1000.)/9.; // 9 -> 1=full reflection 0=no reflection
        clr = mix( clr, CLR(hit.w) * (difu + pow2n(difu,9)), refl  * (1.-ref));
        refl *= ref;
        
        if ( refl < .01 ) break;
       
        camdir = reflect(norm,camdir); // new direction
        cam = hit.xyz + camdir * .1; // back away a little
        
    }
    O = vec4( sqrt(clr), 1 );
   
}
