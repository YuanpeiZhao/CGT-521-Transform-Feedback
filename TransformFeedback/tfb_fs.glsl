#version 440

layout(location = 0) out vec4 fragcolor;        

in vec3 vel;

float heart(float x, float y){

	return (x*x+y*y-1)*(x*x+y*y-1)*(x*x+y*y-1) - x*x*y*y*y;
}
 
void main(void)
{  
	vec2 pos = gl_PointCoord * 3.0f - vec2(1.5f);
	if(heart(pos.x, -pos.y) >= 0.0f) discard;
	fragcolor = vec4(vel*0.3, 0.3f);
}




















