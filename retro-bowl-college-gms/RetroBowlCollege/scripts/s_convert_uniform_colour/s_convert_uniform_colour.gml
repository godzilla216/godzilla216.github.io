function s_convert_uniform_colour(_arg0, _arg1, _arg2) {
	_arg0[0] = colour_get_red(s_hex_string_to_col(_arg1)) / _arg2;
	_arg0[1] = colour_get_green(s_hex_string_to_col(_arg1)) / _arg2;
	_arg0[2] = colour_get_blue(s_hex_string_to_col(_arg1)) / _arg2;
	return _arg0;
}

