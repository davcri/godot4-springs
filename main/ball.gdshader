shader_type canvas_item;

float circle(float r, vec2 suv, float circlePow) {
	vec2 uv = vec2(suv.x * 2. - 1.0, suv.y * 2. - 1.0);
	float d = sqrt(pow(uv.x, 2.0) + pow(uv.y, 2.0));
	return pow(max(0, r - d), circlePow);
}

void fragment() {
	float r = .2;
	float circleVal = circle(.8, UV, .22);
	COLOR = vec4(circleVal, .5 * circleVal, circleVal, circleVal);
}
