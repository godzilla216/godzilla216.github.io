function btn_click_InputSocks1() {
	var new_hexcol = s_format_hex_color(text);
	with (obj_edit_team) {
		current_uni.hex_socks1 = new_hexcol;
		s_convert_uniform_colours_all(current_uni);
		s_set_up_edit_screen();
	}
}

