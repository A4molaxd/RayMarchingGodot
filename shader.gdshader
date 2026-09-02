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
uniform vec3 object21; // Box position
uniform vec3 object22; // Box scale


uniform vec3 pos; // = vec3(-1.0, 0.0, 0.5);
uniform vec3 dir; // = vec3(1, 0, 0); 

float sdfScene(vec3 p){
	return min(sdfSphere(p, object1.xyz, object1.w), 10000.); //sdfBox(p, object21, object22)), 10000.);
}

float march(vec3 d, vec3 o){
	float l = 0.;
	for (int i = 0; i<1000; i++){
		float minD = sdfScene(o);
		o += d*minD;
		l += minD;
		if (minD < .01) return l;
		if (minD > 1000.) return l;
	}
	return l;
}
uniform float FOV: hint_range(10, 100, 5);
uniform float v: hint_range(0.0, 3.0, 0.1);
uniform vec3 up;
uniform vec3 right;
void fragment() {
	vec3 rayPos = pos + right * ((UV.x - 0.5) * v) + up * ((UV.y - 0.5) * v);
	float d = march(dir, rayPos);
	float c = exp(-d*5.0);
	COLOR = vec4(vec3(c), 1.);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
