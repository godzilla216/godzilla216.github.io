function s_edit_name(_arg0, _arg1, _arg2) {
	slog("s_edit_name");
	var bg = instance_create_layer(0, 0, "PopUps", obj_msgbg);
	bg.colour = global.c_background;
	bg.alpha = 1;
	var title = instance_create_layer(display_get_gui_width() * 0.5, 32, "PopUps", obj_roomtitle);
	title.ty = 16;
	title.text = s_str("ui_Editor");
	title.depth = bg.depth - 1;
	var tx = display_get_gui_width() * 0.4;
	var txt_1 = instance_create_layer(tx - 10, 72, "PopUps", obj_text);
	txt_1.text = _arg0;
	txt_1.halign = 2;
	txt_1.draw_box = false;
	txt_1.depth = bg.depth - 1;
	obj_master.edit_box1 = instance_create_layer(tx, 64, "PopUps", obj_input_box);
	obj_master.edit_box1.max_length = 5;
	obj_master.edit_box1.image_xscale = 10;
	obj_master.edit_box1.depth = bg.depth - 1;
	obj_master.edit_box1.text = _arg1;
	var btn_1 = instance_create_layer(display_get_gui_width() * 0.33 - 45, 224, "PopUps", obj_button);
	btn_1.text = s_str("ui_Cancel");
	btn_1.onClickAction = s_msg_clear;
	btn_1.depth = bg.depth - 1;
	var btn_2 = instance_create_layer(display_get_gui_width() * 0.66 - 45, 224, "PopUps", obj_button);
	btn_2.text = s_str("ui_Confirm");
	btn_2.onClickAction = _arg2;
	btn_2.depth = bg.depth - 1;
}

