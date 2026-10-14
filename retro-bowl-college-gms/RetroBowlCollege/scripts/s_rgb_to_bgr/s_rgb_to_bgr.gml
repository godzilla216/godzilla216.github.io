function s_rgb_to_bgr(_arg0) {
	return (_arg0 & 255) << 16 | (_arg0 & 65280) | (_arg0 & 16711680) >> 16;
}

