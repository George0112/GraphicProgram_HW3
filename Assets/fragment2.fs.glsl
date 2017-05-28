#version 410 core                                                              
#define M_PI 3.1415926535897932384626433832795
	                                                                               
uniform sampler2D tex;  
uniform int effect_mode;                                                       
	                                                                               
out vec4 color;                                                                
	                                                                               
in VS_OUT                                                                      
{                                                                              
	vec2 texcoord;                                                             
} fs_in;                                                                       
	                                                                               
void main(void)                                                                
{
	vec2 offset[9];      
	offset[0] = vec2(-1.0, -1.0);
	offset[1] = vec2(0.0, -1.0);
	offset[2] = vec2(1.0, -1.0);

	offset[3] = vec2(-1.0, 0.0);
	offset[4] = vec2(0.0, 0.0);
	offset[5] = vec2(1.0, 0.0);

	offset[6] = vec2(-1.0, 1.0);
	offset[7] = vec2(0.0, 1.0);
	offset[8] = vec2(1.0, 1.0);     
	if(effect_mode == 0){
		vec4 texture_color_Left = texture(tex, fs_in.texcoord - 0.005);		
		vec4 texture_color_Right = texture(tex, fs_in.texcoord + 0.005);		
		vec4 texture_color = vec4(texture_color_Left.x * 0.299 + texture_color_Left.y * 0.587 + texture_color_Left.z * 0.114, texture_color_Right.y, texture_color_Right.z, 1.0f); 
		color = texture_color;		
	}else if(effect_mode == 1){
		float pixels = 600.0;
		float dx = 15.0 * (1.0 / pixels);
		float dy = 15.0 * (1.0 / pixels);
		vec2 coord = vec2(dx * floor(fs_in.texcoord.x / dx), 
						  dy * floor(fs_in.texcoord.y / dy));
		color = texture(tex, coord);
	}else if(effect_mode == 2){
		/*float x = fs_in.texcoord.x;
		float y = fs_in.texcoord.y;
		float d = atan(sqrt(x*x + y*y), sqrt(10.0 - x*x - y*y)) / M_PI;
		float phi = atan(y, x);
		vec2 coord = vec2(d * cos(phi) + 0.5, d * sin(phi) + 0.5);*/
		
		float maxF = sin(0.5 * 178.0 * (M_PI / 180.0));
		vec2 xy = 2.0 * fs_in.texcoord.xy - 1.0;
		float d = length(xy);
		if(d < (2.0 - maxF)){
			float z = sqrt(1.0 - d*d);
			float r = atan(d, z) / M_PI;
			float phi = atan(xy.y, xy.x);
			float x = r * cos(phi) + 0.5;
			float y = r * sin(phi) + 0.5;
			vec2 coord = vec2(x, y);
			color = texture(tex, coord);
		}else{
			color = texture(tex, fs_in.texcoord.xy);
		}
		
		
	}else if(effect_mode == 3){
		float kernal[9] = float[](
			-1, -1, -1,
			-1, 9, -1,
			-1, -1, -1
		);
		int i = 0;
		vec4 sum = vec4(0.0);
		for(i = 0; i < 9; i++){
			vec2 tmp_coord;
			//tmp_coord.x = (fs_in.texcoord.x)
			vec4 tmp = texture(tex, fs_in.texcoord.xy + offset[i] / 600);
			sum += tmp * kernal[i];
		}
		color = vec4(sum.rgb, 1.0);
	}else{
		color = texture(tex, fs_in.texcoord);
	}                                                                
		
}                           