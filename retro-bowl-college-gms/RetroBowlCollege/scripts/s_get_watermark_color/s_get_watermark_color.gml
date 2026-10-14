function s_get_watermark_color() {
	with (obj_master) {
		random_set_seed(current_time);
		var col = make_color_rgb(random(255), random(255), random(255));
		var col_h = clamp(color_get_hue(col), 0, 255);
		var col_s = clamp(color_get_saturation(col), 0, 255);
		var col_v = clamp(color_get_value(col), 100, 220);
		return make_color_hsv(col_h, col_s, col_v);
	}
}

