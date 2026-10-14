function s_color_picker() {
	var bg = instance_create_layer(0, 0, "PopUps", obj_msgbg);
	var picker = instance_create_layer(display_get_gui_width() / 2, display_get_gui_height() / 2, "PopUps", obj_colpicker);
	bg.alpha = 0.9;
	picker.depth = bg.depth - 1;
}

