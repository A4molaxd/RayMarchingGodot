// shader_type spatial;
shader_type canvas_item;


// sdf from iquilezles.org/articles/distfunctions (Íñigo Quilez) 
float sdfSphere(vec3 pos, vec3 p, float r) {
	return distance(pos, p) - r;
}

float sdfPlane(vec3 pos, vec3 n, float y){
	return dot(pos, n) - y;
}

float sdfBox(vec3 pos, vec3 p, vec3 b){
	vec3 q = abs(p - pos) - b;
	return length(max(q, 0.0)) + min(max(q.x,max(q.y,q.z)), 0.0);
}

void vertex() {
}

uniform vec4 object1; // Sphere
uniform vec4 object3; // Sphere 2
uniform vec3 object21; // Box position
uniform vec3 object22; // Box scale
uniform vec4 sphere1;
uniform vec4 sphere2;

uniform vec3 color1: source_color;
uniform vec3 color2: source_color;
uniform vec3 backgColor: source_color;

uniform vec3 lightDir;

uniform vec3 pos; // = vec3(-1.0, 0.0, 0.5);
uniform vec3 dir; // = vec3(1, 0, 0); 

const float EPSILON = 0.01;

float smax(float a, float b){
	return (a + b + sqrt(pow((a-b), 2.) + EPSILON))/2.;
}
float smin(float a, float b){
	return -smax(-a, -b);
}
vec4 smin(vec4 a, vec4 b){
	return vec4(a.w<b.w?a.xyz:b.xyz, smin(a.w, b.w));
}
vec4 sdfScene(vec3 p){
	return smin(smin(smin(
		vec4(color1, sdfSphere(p, object1.xyz, object1.w)), 
		vec4(color2, sdfSphere(p, object3.xyz, object3.w))), 
		vec4(color1, sdfSphere(p, sphere1.xyz, sphere1.w))), 
		vec4(color2, sdfSphere(p, sphere2.xyz, sphere2.w)));
}

vec3 calcNormalScene(vec3 p){
	const float eps = 0.00001;
	const vec2 h = vec2(eps, 0);
	return normalize(vec3(
		sdfScene(p+h.xyy).w - sdfScene(p-h.xyy).w,
		sdfScene(p+h.yxy).w - sdfScene(p-h.yxy).w,
		sdfScene(p+h.yyx).w - sdfScene(p-h.yyx).w
	));
}

float lightning(vec3 p){
	return dot(calcNormalScene(p), lightDir);
}

vec4 march(vec3 d, vec3 o){
	float l = 0.;
	for (int i = 0; i<10000; i++){
		vec4 s = sdfScene(o);
		float minD = s.w;
		o += d*minD;
		l += minD;
		if (minD < .0001) return vec4(s.xyz, 0.1 + smoothstep(0.1, 1., lightning(o)));
		if (minD > 1000.) return vec4(backgColor, -1.);
	}
	return vec4(backgColor, l);
}

uniform float FOV: hint_range(10, 100, 5);
uniform float v: hint_range(0.0, 3.0, 0.1);
uniform vec3 up;
uniform vec3 right;

uniform bool ortho;

void fragment() {
	float aFOV = tan(radians(FOV)*.5);
	vec3 rayPos = pos;
	vec3 rayDir = dir;
	if (ortho){
		rayPos = pos + right * ((UV.x - 0.5) * v) + up * ((UV.y - 0.5) * v);
	} else{
		rayDir = dir + right * ((UV.x - 0.5) * aFOV) + up * ((UV.y - 0.5) * aFOV);
	}
	vec4 m = march(rayDir, rayPos);
	float d = m.w;
	if (abs(d + 1.) < 0.0001){
		COLOR = vec4(vec3(0.2), 1.);
	} else {
		COLOR = vec4(m.xyz*d, 1.);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
