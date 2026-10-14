function s_draw_kicking_power() {
	if (s_is_kickoff(false) && s_cpu_is_kicking_off()) {
		return;
	}
	var c = 0;
	var gw = display_get_gui_width();
	var rw = 256;
	var rx = gw * 0.5 - rw * 0.5;
	draw_rectangle_color(rx, 32, rx + rw, 64, c, c, c, c, 0);
	var kickp = clamp(kickpow * 2, 1, 100);
	var pow = (rw - 2) * 0.01;
	var red_pow = pow * min(30, kickp);
	var grn_pow = pow * min(100, kickp);
	c = 65280;
	draw_rectangle_color(rx + 2, 34, rx + grn_pow, 62, c, c, c, c, 0);
	c = 255;
	draw_rectangle_color(rx + 2, 34, rx + red_pow, 62, c, c, c, c, 0);
}

