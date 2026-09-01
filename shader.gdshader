// shader_type spatial;
shader_type canvas_item;

float sdfSphere(vec3 pos, vec3 p, float r) {
	return distance(pos, p) - r;
}

void vertex() {
}

instance uniform vec4 object1; // = vec4(0.0, 0.0, 0.0, 0.5);
instance uniform vec3 pos; // = vec3(-1.0, 0.0, 0.5);
instance uniform vec3 dir; // = vec3(1, 0, 0); 

float sdfScene(vec3 p){
	float minD = 1000000.;
	float sdf = sdfSphere(p, object1.xyz, object1.w);
	minD = min(sdf, minD);
	return minD;
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
}

void fragment() {
	vec3 upRef = vec3(0, 1, 0);
	vec3 right = normalize(cross(dir, upRef));
	vec3 up    = cross(right, dir);
	float c = 1. - march(dir, vec3(pos + UV.x*right + UV.y*up));
	COLOR = vec4(c, c, c, 1.);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
