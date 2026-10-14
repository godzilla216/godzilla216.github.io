varying vec2 v_vTexcoord;

uniform vec3 colorHelmet;
uniform vec3 colorLogo;
uniform vec3 colorShirt;
uniform vec3 colorSleeve;
uniform vec3 colorPants;
uniform vec3 colorPants_b;
uniform vec3 colorStripe;
uniform vec3 colorSocks;
uniform vec3 colorSocks_b;
uniform vec3 colorSkin;
uniform vec3 colorCleats;

uniform vec3 replaceHelmet;
uniform vec3 replaceLogo;
uniform vec3 replaceShirt;
uniform vec3 replaceSleeve;
uniform vec3 replacePants;
uniform vec3 replacePants_b;
uniform vec3 replaceStripe;
uniform vec3 replaceSocks;
uniform vec3 replaceSocks_b;
uniform vec3 replaceSkin;
uniform vec3 replaceCleats;

void main()
{
	vec4 pixel = texture2D( gm_BaseTexture, v_vTexcoord );
	
	if (pixel.a == 1.0)
	{	
		vec3 eps = vec3(0.010, 0.010, 0.010);
		// vec3 eps = vec3(0.009, 0.009, 0.009);
		
		if( all( greaterThanEqual(pixel, vec4(colorShirt - eps, 1.0)) ) && all( lessThanEqual(pixel, vec4(colorShirt + eps, 1.0)) ) )
			pixel = vec4(replaceShirt, 1.0);
		else if( all( greaterThanEqual(pixel, vec4(colorSkin - eps, 1.0)) ) && all( lessThanEqual(pixel, vec4(colorSkin + eps, 1.0)) ) )
			pixel = vec4(replaceSkin, 1.0);
		else if( all( greaterThanEqual(pixel, vec4(colorHelmet - eps, 1.0)) ) && all( lessThanEqual(pixel, vec4(colorHelmet + eps, 1.0)) ) )
			pixel = vec4(replaceHelmet, 1.0);
		else if( all( greaterThanEqual(pixel, vec4(colorPants - eps, 1.0)) ) && all( lessThanEqual(pixel, vec4(colorPants + eps, 1.0)) ) )
			pixel = vec4(replacePants, 1.0);
		else if( all( greaterThanEqual(pixel, vec4(colorPants_b - eps, 1.0)) ) && all( lessThanEqual(pixel, vec4(colorPants_b + eps, 1.0)) ) )
			pixel = vec4(replacePants_b, 1.0);
		else if( all( greaterThanEqual(pixel, vec4(colorStripe - eps, 1.0)) ) && all( lessThanEqual(pixel, vec4(colorStripe + eps, 1.0)) ) )
			pixel = vec4(replaceStripe, 1.0);
		else if( all( greaterThanEqual(pixel, vec4(colorSocks - eps, 1.0)) ) && all( lessThanEqual(pixel, vec4(colorSocks + eps, 1.0)) ) )
			pixel = vec4(replaceSocks, 1.0);
		else if( all( greaterThanEqual(pixel, vec4(colorSocks_b - eps, 1.0)) ) && all( lessThanEqual(pixel, vec4(colorSocks_b + eps, 1.0)) ) )
			pixel = vec4(replaceSocks_b, 1.0);
		else if( all( greaterThanEqual(pixel, vec4(colorCleats - eps, 1.0)) ) && all( lessThanEqual(pixel, vec4(colorCleats + eps, 1.0)) ) )
			pixel = vec4(replaceCleats, 1.0);
		else if( all( greaterThanEqual(pixel, vec4(colorSleeve - eps, 1.0)) ) && all( lessThanEqual(pixel, vec4(colorSleeve + eps, 1.0)) ) )
			pixel = vec4(replaceSleeve, 1.0);
		else if( all( greaterThanEqual(pixel, vec4(colorLogo - eps, 1.0)) ) && all( lessThanEqual(pixel, vec4(colorLogo + eps, 1.0)) ) )
			pixel = vec4(replaceLogo, 1.0);
		
	}
	
	gl_FragColor = pixel;
}


/*  sh_ColorReplaceBlend
//
//      Replaces one color with another. Can replace 
//      similar colors while preserving shading.
//
//      colorIn             color to replace (vec4)
//      colorOut            replacement color (vec4)
//
//  GMLscripts.com
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4  colorIn;
uniform vec4  colorOut;

void main()
{
	vec4 colorPixel = texture2D( gm_BaseTexture, v_vTexcoord );
	
    if (colorPixel.r == 255.0)
	{
	    gl_FragColor = v_vColour * colorOut;
	}
	else
	{
		gl_FragColor = v_vColour * colorPixel;
	}
}

/*
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float pixelW;
uniform float pixelH;

void main()
{
	vec2 offsetx;
	offsetx.x = pixelW;
	vec2 offsety;
	offsety.y = pixelH;
	
	float alpha = texture2D( gm_BaseTexture, v_vTexcoord ).a;
	
	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord + offsetx ).a);
	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord - offsetx ).a);
	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord + offsety ).a);
	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord - offsetx ).a);
	
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	gl_FragColor.a = alpha;
}
*/
