function s_convert_uniform_colours_all(_arg0) {
	with (_arg0) {
		helmet = s_convert_uniform_colour(helmet, hex_helmet, 256);
		logo = s_convert_uniform_colour(logo, hex_logo, 256);
		shirt = s_convert_uniform_colour(shirt, hex_shirt, 256);
		sleeve = s_convert_uniform_colour(sleeve, hex_sleeve, 256);
		pants = s_convert_uniform_colour(pants, hex_pants, 256);
		pants_b = s_convert_uniform_colour(pants_b, hex_pants, 300);
		stripe = s_convert_uniform_colour(stripe, hex_stripe, 256);
		socks1 = s_convert_uniform_colour(socks1, hex_socks1, 256);
		socks2 = s_convert_uniform_colour(socks2, hex_socks2, 256);
		endzone = s_convert_uniform_colour(endzone, hex_endzone, 256);
	}
}

