function s_color_to_hex(_arg0) {
	var color, dec;
	color = _arg0;
	dec = (color & 16711680) >> 16 | (color & 65280) | (color & 255) << 16;
	return s_dec_to_hex(dec);
}

