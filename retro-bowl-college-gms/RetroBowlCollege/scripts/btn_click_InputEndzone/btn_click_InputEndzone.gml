function btn_click_InputEndzone() {
	var new_hexcol = s_format_hex_color(text);
	with (obj_edit_team) {
		current_uni.hex_endzone = new_hexcol;
		s_convert_uniform_colours_all(current_uni);
		s_set_up_edit_screen();
	}
}

