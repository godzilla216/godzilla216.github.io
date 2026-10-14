function s_get_skin_colour_by_index(_arg0) {
	switch (_arg0) {
		case 2:
			return make_color_rgb(238, 195, 154);
			break;
		case 1:
			return make_color_rgb(186, 136, 87);
			break;
		case 0:
			return make_color_rgb(93, 51, 36);
			break;
	}
	return choose(2, 1, 0);
}

