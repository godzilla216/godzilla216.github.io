function s_create_dilemma(_arg0) {
	slog("s_create_dilemma");
	var allowProfileClick = false;
	if (s_is_co_mode() && obj_master.stage == 2) {
		allowProfileClick = true;
	}
	if (allowProfileClick) {
		obj_master.profile_back_to = 1;
	}
	obj_master.store_to_dilemma = false;
	var title_txt = ds_map_find_value(_arg0, "title");
	var msg_txt = ds_map_find_value(_arg0, "msg");
	var btn_txt1 = ds_map_find_value(_arg0, "btn_txt1");
	var btn_txt2 = ds_map_find_value(_arg0, "btn_txt2");
	var cost_txt1 = string(ds_map_find_value(_arg0, "cost_amt1"));
	var cost_txt2 = string(ds_map_find_value(_arg0, "cost_amt2"));
	var cost_img1 = ds_map_find_value(_arg0, "cost_img1");
	var cost_img2 = ds_map_find_value(_arg0, "cost_img2");
	var bg = instance_create_layer(0, 0, "PopUps", obj_msgbg);
	var title = instance_create_layer(display_get_gui_width() * 0.5, 32, "PopUps", obj_roomtitle);
	var msg = instance_create_layer(display_get_gui_width() * 0.5, display_get_gui_height() * 0.5, "PopUps", obj_messagebox);
	var btn_1 = instance_create_layer(104, 224, "PopUps", obj_button_big);
	var btn_2 = instance_create_layer(272, 224, "PopUps", obj_button_big);
	var cost_1 = instance_create_layer(32, 224, "PopUps", obj_smallbox);
	var cost_2 = instance_create_layer(384, 224, "PopUps", obj_smallbox);
	var creds = instance_create_layer(32, 16, "PopUps", obj_text_exp);
	var prof_1 = instance_create_layer(32, 136, "PopUps", obj_player_profile);
	var prof_2 = instance_create_layer(384, 136, "PopUps", obj_player_profile);
	var morale_1 = instance_create_layer(32, 184, "PopUps", obj_box_morale);
	var morale_2 = instance_create_layer(384, 184, "PopUps", obj_box_morale);
	bg.colour = global.c_background;
	bg.alpha = 1;
	title.ty = 32;
	title.show_stars = false;
	title.text = string(title_txt);
	msg.text = msg_txt;
	msg.colour = global.c_background;
	msg.msg_width = 260;
	btn_1.text = btn_txt1;
	btn_2.text = btn_txt2;
	btn_1.onClickAction = s_dilemma_choice_1;
	btn_2.onClickAction = s_dilemma_choice_2;
	cost_1.title = s_str("ui_Effect");
	cost_2.title = s_str("ui_Effect");
	cost_1.text = cost_txt1;
	cost_2.text = cost_txt2;
	cost_1.image = s_convert_string_to_sprite(cost_img1);
	cost_2.image = s_convert_string_to_sprite(cost_img2);
	prof_1.active = false;
	prof_2.active = false;
	prof_1.pmap = -4;
	prof_2.pmap = -4;
	morale_1.visible = false;
	morale_2.visible = false;
	switch (ds_map_find_value(_arg0, "effect_on1")) {
		case "player":
			prof_1.pmap = obj_master.player_profile;
			prof_1.active = allowProfileClick;
			slog("DILEMMA1: " + ds_map_find_value(prof_1.pmap, "lname"));
			break;
		case "coaches":
			var of = true;
			if (obj_master.player_profile && !s_is_offensive_player(obj_master.player_profile)) {
				of = false;
			}
			switch (of) {
				case true:
					prof_1.pmap = s_get_staff(102);
					break;
				case false:
					prof_1.pmap = s_get_staff(101);
					break;
			}
			break;
		case "team":
			if (cost_1.image == spr_attitude) {
				morale_1.visible = true;
			}
			break;
		case "self":
			prof_1.pmap = s_get_staff(100);
			break;
	}
	if (cost_1.image == spr_attitude) {
		cost_1.image_num = 2;
		if (ds_map_find_value(_arg0, "cost_amt1") > 0) {
			cost_1.image_num = 5;
		}
		cost_1.text = "";
	} else if (real(ds_map_find_value(_arg0, "cost_amt1")) > 0) {
		cost_1.text = "+" + cost_1.text;
	}
	switch (ds_map_find_value(_arg0, "effect_on2")) {
		case "player":
			prof_2.pmap = obj_master.player_profile;
			prof_2.active = allowProfileClick;
			slog("DILEMMA2: " + ds_map_find_value(prof_2.pmap, "lname"));
			break;
		case "coaches":
			var of = true;
			if (obj_master.player_profile && !s_is_offensive_player(obj_master.player_profile)) {
				of = false;
			}
			switch (of) {
				case true:
					prof_2.pmap = s_get_staff(102);
					break;
				case false:
					prof_2.pmap = s_get_staff(101);
					break;
			}
			break;
		case "team":
			if (cost_2.image == spr_attitude) {
				morale_2.visible = true;
			}
			break;
		case "self":
			prof_2.pmap = s_get_staff(100);
			break;
	}
	if (cost_2.image == spr_attitude) {
		cost_2.image_num = 2;
		if (ds_map_find_value(_arg0, "cost_amt2") > 0) {
			cost_2.image_num = 5;
		}
		cost_2.text = "";
	} else if (real(ds_map_find_value(_arg0, "cost_amt2")) > 0) {
		cost_2.text = "+" + cost_2.text;
	}
	creds.icon = spr_credit;
	creds.text = s_get_credit();
	if (cost_1.image == spr_xp) {
		cost_1.text = "+";
	}
	if (cost_2.image == spr_xp) {
		cost_2.text = "+";
	}
	if (cost_1.image == spr_nrg) {
		cost_1.text = string(ds_map_find_value(_arg0, "cost_amt1")) + "x";
	}
	if (cost_2.image == spr_nrg) {
		cost_2.text = string(ds_map_find_value(_arg0, "cost_amt2")) + "x";
	}
	if (cost_1.image == spr_gpa) {
		if (ds_map_find_value(_arg0, "cost_amt1") > 0) {
			if (ds_map_find_value(_arg0, "cost_typ1") == "choice_FocusGPA") {
				cost_1.text = "+";
			} else {
				prof_1.active = false;
				prof_1.visible = false;
				morale_1.visible = true;
				cost_1.text = "";
				cost_1.image_num = 2;
				cost_1.image = s_convert_string_to_sprite("spr_attitude");
			}
		} else {
			cost_1.text = "-";
		}
	}
	if (cost_2.image == spr_gpa) {
		if (ds_map_find_value(_arg0, "cost_amt2") > 0) {
			if (ds_map_find_value(_arg0, "cost_typ2") == "choice_FocusGPA") {
				cost_2.text = "+";
			} else {
				prof_2.active = false;
				prof_2.visible = false;
				morale_2.visible = true;
				cost_2.text = "";
				cost_2.image_num = 2;
				cost_2.image = s_convert_string_to_sprite("spr_attitude");
			}
		} else {
			cost_2.text = "-";
		}
	}
	if (cost_1.image == -1) {
		cost_1.visible = false;
		prof_1.visible = false;
		morale_1.visible = false;
	}
	if (cost_2.image == -1) {
		cost_2.visible = false;
		prof_2.visible = false;
		morale_2.visible = false;
	}
	if (cost_1.image == spr_credit_rec) {
		cost_1.text = "$" + string(ds_map_find_value(_arg0, "cost_amt1")) + s_str("sla_Thousand");
		cost_1.image = -4;
	}
	if (cost_2.image == spr_credit_rec) {
		cost_2.text = "$" + string(ds_map_find_value(_arg0, "cost_amt2")) + s_str("sla_Thousand");
		cost_2.image = -4;
	}
	title.depth = bg.depth - 1;
	msg.depth = bg.depth - 1;
	btn_1.depth = bg.depth - 1;
	btn_2.depth = bg.depth - 1;
	cost_1.depth = bg.depth - 1;
	cost_2.depth = bg.depth - 1;
	creds.depth = bg.depth - 1;
	prof_1.depth = bg.depth - 2;
	prof_2.depth = bg.depth - 2;
	morale_1.depth = bg.depth - 2;
	morale_2.depth = bg.depth - 2;
	if (title_txt == "") {
		title.visible = false;
	}
	if (btn_txt1 == "") {
		btn_1.visible = false;
		btn_2.x = 360;
	}
	if (btn_txt2 == "") {
		btn_2.visible = false;
		btn_1.x = 360;
	}
	if (cost_txt1 == "") {
		cost_1.visible = false;
	}
	if (cost_txt2 == "") {
		cost_2.visible = false;
	}
	s_load_profile_uni(prof_1);
	s_load_profile_uni(prof_2);
}

