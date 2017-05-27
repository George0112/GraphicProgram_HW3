#version 410 core                                                              
	                                                                               
uniform sampler2D tex;                                                         
	                                                                               
out vec4 color;                                                                
	                                                                               
in VS_OUT                                                                      
{                                                                              
	vec2 texcoord;                                                             
} fs_in;                                                                       
	                                                                               
void main(void)                                                                
{                                                                              
	vec4 texture_color_Left = texture(tex, fs_in.texcoord - 0.005);		
	vec4 texture_color_Right = texture(tex, fs_in.texcoord + 0.005);		
		vec4 texture_color = vec4(texture_color_Left.x * 0.299 + texture_color_Left.y * 0.587 + texture_color_Left.z * 0.114, texture_color_Right.y, texture_color_Right.z, 1.0f); 
	color = texture_color;			
}                           