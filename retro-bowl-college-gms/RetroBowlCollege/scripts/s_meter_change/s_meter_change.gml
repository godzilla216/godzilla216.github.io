function s_meter_change(_arg0, _arg1, _arg2, _arg3) {
	slog("s_meter_change: " + string(_arg0) + " " + _arg3);
	var bg = instance_create_layer(0, 0, "PopUps", obj_msgbg);
	bg.colour = global.c_background;
	bg.alpha = 1;
	bg.alarm[0] = 100;
	bg.new_room = _arg2;
	var obj = -4;
	switch (_arg0) {
		case 1:
			obj = instance_create_layer(0, 0, "PopUps", obj_meter_fans);
			obj.old_percent = _arg1;
			break;
		case 2:
			obj = instance_create_layer(0, 0, "PopUps", obj_meter_condition);
			obj.old_percent = _arg1;
			break;
		case 3:
			obj = instance_create_layer(0, 0, "PopUps", obj_player_profile);
			obj.old_condition = _arg1;
			obj.pmap = obj_master.player_profile;
			s_load_profile_uni(obj);
			obj.active = false;
			break;
		case 4:
			obj = instance_create_layer(0, 0, "PopUps", obj_box_morale);
			obj.old_percent = _arg1;
			break;
		case 5:
			obj = instance_create_layer(0, 0, "PopUps", obj_player_profile);
			obj.pmap = obj_master.player_profile;
			s_load_profile_uni(obj);
			obj.flash_attitude = true;
			obj.active = false;
			if (_arg1 < ds_map_find_value(obj.pmap, "attitude")) {
				obj.show_arrow = 1;
			} else if (_arg1 > ds_map_find_value(obj.pmap, "attitude")) {
				obj.show_arrow = -1;
			}
			bg.alarm[0] = 160;
			break;
		case 6:
			obj = instance_create_layer(0, 0, "PopUps", obj_box_offense);
			obj.flash_rating = true;
			bg.alarm[0] = 160;
			break;
		case 7:
			obj = instance_create_layer(0, 0, "PopUps", obj_box_defense);
			obj.flash_rating = true;
			bg.alarm[0] = 160;
			break;
		case 8:
			obj = instance_create_layer(0, 0, "PopUps", obj_box_coachcredit);
			obj.flash = true;
			bg.alarm[0] = 160;
			break;
		case 9:
			obj = instance_create_layer(0, 0, "PopUps", obj_meter_coach);
			obj.old_percent = _arg1;
			break;
		case 10:
			obj = instance_create_layer(0, 0, "PopUps", obj_box_recruitmentcredit);
			obj.flash = true;
			bg.alarm[0] = 160;
			break;
	}
	obj.x = g_pBuiltIn.room_width * 0.5 - obj.sprite_width * 0.5;
	obj.y = g_pBuiltIn.room_height * 0.5 - obj.sprite_height * 0.5;
	obj.depth = bg.depth - 1;
	if (_arg3 != "") {
		var msg = instance_create_layer(display_get_gui_width() * 0.5, display_get_gui_height() * 0.35, "PopUps", obj_messagebox);
		msg.text = _arg3;
		msg.colour = global.c_background;
		msg.depth = bg.depth - 1;
		bg.alarm[0] = 0;
		draw_set_font(global.fnt_small_flex);
		draw_set_halign(1);
		draw_set_valign(1);
		var h = 12 + string_hd_height_ext(_arg3, -1, msg.msg_width);
		obj.y = msg.y + h;
		var btn_1 = instance_create_layer(display_get_gui_width() - 128, 224, "PopUps", obj_button);
		btn_1.text = s_str("ui_Continue");
		btn_1.onClickAction = s_meter_change_end;
		btn_1.depth = bg.depth - 1;
	}
}

