event_inherited();
if (obj_master.qb_mode) {
	colour = global.c_buttons;
} else if (s_is_co_mode()) {
	if (colour == 0xFFFFFFFF) {
		colour = global.c_background;
	}
} else {
	colour = global.c_background;
}
if (btn_image) {
	sprite_index = btn_image;
}
