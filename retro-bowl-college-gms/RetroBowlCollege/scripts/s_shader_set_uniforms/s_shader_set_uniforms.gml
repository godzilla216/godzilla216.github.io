function s_shader_set_uniforms() {
	shader_set(sh_ColorReplaceBlend);
	shader_set_uniform_f(global.colorHelmet, 1, 0, 0);
	shader_set_uniform_f(global.colorLogo, 0.5, 0, 0);
	shader_set_uniform_f(global.colorShirt, 0.5, 0.5, 1);
	shader_set_uniform_f(global.colorSleeve, 0.5, 0.5, 0.5);
	shader_set_uniform_f(global.colorPants, 1, 0, 1);
	shader_set_uniform_f(global.colorPants_b, 0.5, 0, 0.5);
	shader_set_uniform_f(global.colorStripe, 0, 0, 0.5);
	shader_set_uniform_f(global.colorSocks, 0, 1, 0);
	shader_set_uniform_f(global.colorSocks_b, 0, 0.5, 0);
	shader_set_uniform_f(global.colorSkin, 0, 0, 1);
	shader_set_uniform_f(global.colorCleats, 1, 1, 0);
	shader_set_uniform_f(global.replaceHelmet, helmet[2], helmet[1], helmet[0]);
	shader_set_uniform_f(global.replaceLogo, logo[2], logo[1], logo[0]);
	shader_set_uniform_f(global.replaceShirt, shirt[2], shirt[1], shirt[0]);
	shader_set_uniform_f(global.replaceSleeve, sleeve[2], sleeve[1], sleeve[0]);
	shader_set_uniform_f(global.replacePants, pants[2], pants[1], pants[0]);
	shader_set_uniform_f(global.replacePants_b, pants_b[2], pants_b[1], pants_b[0]);
	shader_set_uniform_f(global.replaceStripe, stripe[2], stripe[1], stripe[0]);
	shader_set_uniform_f(global.replaceSocks, socks1[2], socks1[1], socks1[0]);
	shader_set_uniform_f(global.replaceSocks_b, socks2[2], socks2[1], socks2[0]);
	shader_set_uniform_f(global.replaceSkin, col_skin_r, col_skin_g, col_skin_b);
	shader_set_uniform_f(global.replaceCleats, cleats[2], cleats[1], cleats[0]);
}

function s_blackwhite_colour_hack(_arg0) {
	if (_arg0[0] + _arg0[1] + _arg0[2] == 0) {
		_arg0[0] = 0.001;
	}
}

