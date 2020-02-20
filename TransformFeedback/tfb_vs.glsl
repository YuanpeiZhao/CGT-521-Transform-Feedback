#version 440            

layout(location = 0) uniform mat4 PVM;
layout(location = 1) uniform float time;
layout(location = 2) uniform float slider = 0.5;

layout(location = 0) in vec3 pos_attrib;
layout(location = 1) in vec3 vel_attrib;
layout(location = 2) in float age_attrib;

layout(xfb_buffer = 0) out;

layout(xfb_offset = 0, xfb_stride = 28) out vec3 pos_out; 
layout(xfb_offset = 12, xfb_stride = 28) out vec3 vel_out; 
layout(xfb_offset = 24, xfb_stride = 28) out float age_out;

out vec3 vel;

//Basic velocity field
vec3 v0(vec3 p);
vec3 v1(vec3 p);

//pseudorandom number
float rand(vec2 co);

void main(void)
{
	//Draw current particles
	gl_Position = PVM*vec4(pos_attrib, 1.0);
	gl_PointSize = age_attrib / 20;

	//Compute particle attributes for next frame
	vel_out = v1(pos_attrib);
	vel = vel_out;
	pos_out = pos_attrib + 0.003*vel_out;
	age_out = age_attrib - 1.0;

	//Reinitialize particles as needed
	if(age_out <= 0.0 || length(pos_out) > (2 * gl_VertexID + 10000.0f)/20000.0f)
	{
		vec2 seed = vec2(float(gl_VertexID), time); //seed for the random number generator

		age_out = 300.0 + pos_attrib.y*0.02;
		//Pseudorandom position
		pos_out = pos_attrib*0.02 + 0.5*vec3(rand(seed.xx), rand(seed.xy), rand(seed.xy));
	}
}

vec3 v0(vec3 p)
{
	return vec3(sin(p.y*10.0+time-10.0), -sin(p.x*10.0+9.0*time+10.0), +cos(2.4*p.z+2.0*time));
}

vec3 v1(vec3 p)
{
	vec2 seed = vec2(float(gl_VertexID), time);
	if(gl_VertexID % 6 == 0) return 0.3*vec3(10*p.z , 3*sin(time)*p.length, -10*p.x)+ 0.5*vec3(rand(seed.xx), rand(seed.xy), rand(seed.xy));
	if(gl_VertexID % 6 == 1) return 0.3*vec3(-10*p.z , 3*sin(time)*p.length, -10*p.x)+ 0.5*vec3(rand(seed.xx), rand(seed.xy), rand(seed.xy));
	if(gl_VertexID % 6 == 2) return 0.3*vec3(3*sin(time)*p.length, 10*p.z, -10*p.x)+ 0.5*vec3(rand(seed.xx), rand(seed.xy), rand(seed.xy));
	if(gl_VertexID % 6 == 3) return 0.3*vec3(-3*sin(time)*p.length, 10*p.z, -10*p.x)+ 0.5*vec3(rand(seed.xx), rand(seed.xy), rand(seed.xy));
	if(gl_VertexID % 6 == 4) return 0.3*vec3(10*p.z, -10*p.x, 3*sin(time)*p.length)+ 0.5*vec3(rand(seed.xx), rand(seed.xy), rand(seed.xy));
	if(gl_VertexID % 6 == 5) return 0.3*vec3(10*p.z, -10*p.x, -3*sin(time)*p.length)+ 0.5*vec3(rand(seed.xx), rand(seed.xy), rand(seed.xy));
}

float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

