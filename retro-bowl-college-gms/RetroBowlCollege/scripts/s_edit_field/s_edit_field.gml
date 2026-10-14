function s_edit_field(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8) {
	slog("s_edit_text");
	var bg = instance_create_layer(0, 0, "PopUps", obj_msgbg);
	bg.colour = global.c_background;
	bg.alpha = 1;
	var title = instance_create_layer(display_get_gui_width() * 0.5, 32, "PopUps", obj_roomtitle);
	title.ty = 16;
	title.text = s_str("ui_Editor");
	title.depth = bg.depth - 1;
	var tx = display_get_gui_width() * 0.35;
	var txt_1 = instance_create_layer(tx - 10, 72, "PopUps", obj_text);
	txt_1.text = _arg0;
	txt_1.halign = 2;
	txt_1.draw_box = false;
	txt_1.depth = bg.depth - 1;
	obj_master.edit_box1 = instance_create_layer(tx, 64, "PopUps", obj_input_box);
	obj_master.edit_box1.image_xscale = 10;
	obj_master.edit_box1.depth = bg.depth - 1;
	obj_master.edit_box1.text = _arg2;
	var vbox = instance_create_layer(64, 48, "PopUps", obj_vbox);
	vbox.image_xscale = 2.22;
	vbox.image_yscale = 0.38;
	vbox.depth = bg.depth - 1;
	vbox.title = s_str("ui_Details");
	if (_arg1 != "") {
		var txt_2 = instance_create_layer(tx - 10, 104, "PopUps", obj_text);
		txt_2.text = _arg1;
		txt_2.halign = 2;
		txt_2.draw_box = false;
		txt_2.depth = bg.depth - 1;
		obj_master.edit_box2 = instance_create_layer(tx, 96, "PopUps", obj_input_box);
		obj_master.edit_box2.image_xscale = 10;
		obj_master.edit_box2.depth = bg.depth - 1;
		obj_master.edit_box2.text = _arg3;
		vbox.image_yscale = 0.6;
	}
	var btn_2 = instance_create_layer(display_get_gui_width() * 0.5 - 45, 224, "PopUps", obj_button);
	btn_2.text = s_str("ui_Confirm");
	btn_2.onClickAction = s_edit_confirm_profile;
	btn_2.depth = bg.depth - 1;
	var btn_head = instance_create_layer(display_get_gui_width() * 0.71, 70, "PopUps", obj_headshot);
	btn_head.skin = _arg4;
	btn_head.face_set = _arg8;
	btn_head.face_x = _arg5;
	btn_head.face_y = _arg6;
	btn_head.coach_heads = _arg7;
	btn_head.onClickAction = s_goto_rm_choose_face;
	btn_head.depth = bg.depth - 1;
	slog("face_x=" + string(_arg5));
	slog("face_y=" + string(_arg6));
}

