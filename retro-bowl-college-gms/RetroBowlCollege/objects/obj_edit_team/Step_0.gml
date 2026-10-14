if (new_col > -1) {
	slog("New colour = " + s_color_to_hex(new_col));
	switch (newpick) {
		case 0:
			current_uni.hex_helmet = "$" + s_color_to_hex(new_col);
			break;
		case 1:
			current_uni.hex_logo = "$" + s_color_to_hex(new_col);
			break;
		case 2:
			current_uni.hex_shirt = "$" + s_color_to_hex(new_col);
			break;
		case 3:
			current_uni.hex_sleeve = "$" + s_color_to_hex(new_col);
			break;
		case 4:
			current_uni.hex_pants = "$" + s_color_to_hex(new_col);
			break;
		case 5:
			current_uni.hex_stripe = "$" + s_color_to_hex(new_col);
			break;
		case 6:
			current_uni.hex_socks1 = "$" + s_color_to_hex(new_col);
			break;
		case 7:
			current_uni.hex_socks2 = "$" + s_color_to_hex(new_col);
			break;
		case 8:
			current_uni.hex_endzone = "$" + s_color_to_hex(new_col);
			break;
	}
	new_col = -1;
	s_convert_uniform_colours_all(current_uni);
	s_set_up_edit_screen();
}
