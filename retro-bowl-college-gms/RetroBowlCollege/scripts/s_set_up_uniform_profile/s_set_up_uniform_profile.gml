function s_set_up_uniform_profile(_arg0) {
	if (_arg0) {
		helmet = _arg0.helmet;
		shirt = _arg0.shirt;
		pants = _arg0.pants;
	} else {
		helmet[0] = colour_get_blue(8421504) / 256;
		helmet[1] = colour_get_green(8421504) / 256;
		helmet[2] = colour_get_red(8421504) / 256;
		shirt[0] = colour_get_blue(12632256) / 256;
		shirt[1] = colour_get_green(12632256) / 256;
		shirt[2] = colour_get_red(12632256) / 256;
		pants[0] = colour_get_blue(0) / 256;
		pants[1] = colour_get_green(0) / 256;
		pants[2] = colour_get_red(0) / 256;
	}
}

