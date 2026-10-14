function s_create_message(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9) {
	if (_arg8 == undefined) {
		_arg8 = -4;
	}
	if (_arg9 == undefined) {
		_arg9 = 3;
	}
	slog("s_create_message[" + _arg1 + "]");
	var bx1 = display_get_gui_width() * 0.33 - 45;
	var bx2 = display_get_gui_width() * 0.66 - 45;
	var bx3 = display_get_gui_width() - 128;
	var bg = instance_create_layer(0, 0, "PopUps", obj_msgbg);
	var title = instance_create_layer(display_get_gui_width() * 0.5, 0, "PopUps", obj_roomtitle);
	var msg = instance_create_layer(display_get_gui_width() * 0.5, -8 + display_get_gui_height() * 0.5, "PopUps", obj_messagebox);
	var btn_1 = instance_create_layer(bx1, 224, "PopUps", obj_button);
	var btn_2 = instance_create_layer(bx2, 224, "PopUps", obj_button);
	bg.inst_bg = bg;
	bg.inst_title = title;
	bg.inst_msg = msg;
	bg.inst_btn_1 = btn_1;
	bg.inst_btn_2 = btn_2;
	if (string_length(_arg2) > 10 || string_length(_arg3) > 10) {
		instance_destroy(btn_1);
		instance_destroy(btn_2);
		btn_1 = instance_create_layer(bx1, 224, "PopUps", obj_button_big);
		btn_2 = instance_create_layer(bx2, 224, "PopUps", obj_button_big);
	}
	bg.colour = _arg6;
	bg.alpha = _arg7;
	title.ty = 16;
	title.show_stars = false;
	if (_arg0 == s_str("ui_News") || _arg0 == s_str("ui_Tip")) {
		title.show_stars = true;
	}
	title.text = string(_arg0);
	msg.text = _arg1;
	msg.colour = global.c_background;
	if (instance_exists(obj_camera)) {
		msg.msg_width = 260;
	}
	btn_1.text = _arg2;
	btn_2.text = _arg3;
	btn_1.onClickAction = _arg4;
	btn_2.onClickAction = _arg5;
	title.depth = bg.depth - 1;
	msg.depth = bg.depth - 1;
	btn_1.depth = bg.depth - 1;
	btn_2.depth = bg.depth - 1;
	btn_1.gp_allowed = _arg9;
	btn_2.gp_allowed = _arg9;
	if (_arg0 == "") {
		title.visible = false;
	}
	if (_arg2 == "") {
		btn_1.visible = false;
		btn_2.x = bx3;
	}
	if (_arg3 == "") {
		btn_2.visible = false;
		btn_1.x = bx3;
	}
	if (_arg8 != -4) {
		slog("Show profile for player");
		var prof_1 = instance_create_layer(32, 180, "PopUps", obj_player_profile);
		prof_1.pmap = _arg8;
		prof_1.depth = bg.depth - 1;
	}
	return bg;
}

function s_message_recenter() {
	with (inst_bg) {
		image_xscale = 1;
		image_yscale = 1;
		image_xscale = display_get_gui_width() / sprite_width;
		image_yscale = display_get_gui_height() / sprite_height;
	}
	if (variable_instance_exists(id, "title")) {
		with (title) {
			x = display_get_gui_width() * 0.5;
		}
	}
	with (inst_msg) {
		x = display_get_gui_width() * 0.5;
	}
	with (inst_btn_1) {
		x = display_get_gui_width() * 0.33 - 45;
	}
	with (inst_btn_2) {
		x = display_get_gui_width() * 0.66 - 45;
	}
}

function s_message_toggle(_arg0) {
	with (inst_bg) {
		visible = _arg0;
	}
	with (title) {
		visible = _arg0;
	}
	with (inst_msg) {
		visible = _arg0;
	}
	with (inst_btn_1) {
		visible = _arg0;
	}
	with (inst_btn_2) {
		visible = _arg0;
	}
}

function s_create_message3(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9) {
	var bx1 = display_get_gui_width() * 0.25 - 45;
	var bx2 = display_get_gui_width() * 0.5 - 45;
	var bx3 = display_get_gui_width() * 0.75 - 45;
	var bg = instance_create_layer(0, 0, "PopUps", obj_msgbg);
	var title = instance_create_layer(display_get_gui_width() * 0.5, 0, "PopUps", obj_roomtitle);
	var msg = instance_create_layer(display_get_gui_width() * 0.5, -8 + display_get_gui_height() * 0.5, "PopUps", obj_messagebox);
	var btn_1 = instance_create_layer(bx1, 224, "PopUps", obj_button);
	var btn_2 = instance_create_layer(bx2, 224, "PopUps", obj_button);
	var btn_3 = instance_create_layer(bx3, 224, "PopUps", obj_button);
	if (string_length(_arg2) > 10 || string_length(_arg3) > 10 || string_length(_arg4) > 10) {
		instance_destroy(btn_1);
		instance_destroy(btn_2);
		instance_destroy(btn_3);
		btn_1 = instance_create_layer(bx1, 224, "PopUps", obj_button_big);
		btn_2 = instance_create_layer(bx2, 224, "PopUps", obj_button_big);
		btn_3 = instance_create_layer(bx3, 224, "PopUps", obj_button_big);
	}
	bg.colour = _arg8;
	bg.alpha = _arg9;
	title.ty = 16;
	title.show_stars = false;
	if (_arg0 == s_str("ui_News") || _arg0 == s_str("ui_Tip")) {
		title.show_stars = true;
	}
	title.text = string(_arg0);
	msg.text = _arg1;
	msg.colour = global.c_background;
	if (instance_exists(obj_camera)) {
		msg.msg_width = 260;
	}
	btn_1.text = _arg2;
	btn_2.text = _arg3;
	btn_3.text = _arg4;
	btn_1.onClickAction = _arg5;
	btn_2.onClickAction = _arg6;
	btn_3.onClickAction = _arg7;
	title.depth = bg.depth - 1;
	msg.depth = bg.depth - 1;
	btn_1.depth = bg.depth - 1;
	btn_2.depth = bg.depth - 1;
	btn_3.depth = bg.depth - 1;
	if (_arg0 == "") {
		title.visible = false;
	}
}

function s_do_message(_arg0) {
	s_create_message("", _arg0, s_str("ui_Ok"), "", s_msg_clear, -1, global.c_background, 1);
}

function s_msg(_arg0) {
	s_do_message(_arg0);
}

function s_loading_button_hijack(_arg0) {
	_arg0._original_action = _arg0.onClickAction;
	_arg0.onClickAction = s_loading_trigger;
}

function s_loading_trigger() {
	s_loading_start(_original_action);
}

function s_loading_start(_arg0) {
	if (!s_is_co_mode()) {
		_arg0();
		return;
	}
	s_msg_clear();
	s_create_message("", "Loading...", "", "", -1, -1, global.c_background, 1);
	instance_create_layer(0, 0, "Instances", obj_blank, { callback: _arg0, action_step: s_loading_callback });
}

function s_loading_callback() {
	s_msg_clear();
	if (callback != -4) {
		callback();
	}
	callback = -4;
	instance_destroy();
}

