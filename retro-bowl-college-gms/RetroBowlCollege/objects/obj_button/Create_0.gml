event_inherited();
if (instance_exists(obj_master) && obj_master.qb_mode) {
	colour = global.c_buttons;
} else {
	colour = global.c_background;
}
if (btn_image) {
	sprite_index = btn_image;
}
