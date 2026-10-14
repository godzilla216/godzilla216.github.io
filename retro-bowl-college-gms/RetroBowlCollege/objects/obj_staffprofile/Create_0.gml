pmap = obj_master.player_profile;
if (pmap == -4) {
	exit;
}
if (ds_map_find_value(pmap, "position") == 100) {
	room_goto(rm_profile_boss);
	exit;
}
draw_set_font(global.fnt_small_flex);
draw_set_halign(0);
draw_set_valign(1);
inst_100471.pmap = obj_master.player_profile;
inst_100471.active = false;
inst_100467.title = s_get_string_position_full(ds_map_find_value(pmap, "position"));
inst_100468.text = s_str("ui_Name") + ": " + ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname");
inst_100469.text = s_str("ui_Age") + ": " + string(ds_map_find_value(pmap, "age"));
if (!ds_map_find_value(pmap, "position") == 100 && ds_map_find_value(pmap, "age") >= s_get_max_age(pmap)) {
	inst_100469.text += " (" + s_str("ui_Retiring") + ")";
}
inst_100470.text = s_str("ui_Attitude") + ": " + s_get_string_attitude(ds_map_find_value(pmap, "attitude"));
attitude_img = s_get_attitude_icon(ds_map_find_value(pmap, "attitude"));
inst_100478.text = s_str("ui_Contract") + ": " + string(ds_map_find_value(pmap, "contract")) + s_str("sla_Year");
inst_100476.text = s_str("ui_Trait") + ": " + s_get_string_trait(ds_map_find_value(pmap, "trait"));
layer_nav = layer_get_id("Instances_Nav");
layer_set_visible(layer_nav, true);
layer_xp = layer_get_id("Instances_XP_Continue");
layer_set_visible(layer_xp, false);
layer_hire = layer_get_id("Instances_Hire");
layer_set_visible(layer_hire, true);
layer_training = layer_get_id("Instances_Training");
layer_set_visible(layer_training, true);
inst_100465.visible = false;
if (ds_map_find_value(pmap, "position") == 100) {
	with (inst_100472) {
		y += 32;
	}
	with (obj_text) {
		y += 32;
	}
	with (obj_player_profile) {
		y += 32;
	}
	with (obj_vbox) {
		y += 32;
		image_yscale = 0.78;
	}
	inst_100472.info_msg = "info_HeadCoach";
	inst_100475.visible = false;
	if (global.debug) {
		inst_100478.text = "Rating:" + string(obj_master.coach_rating);
	} else {
		inst_100478.visible = false;
	}
	inst_100476.visible = false;
	inst_100477.visible = false;
	inst_100462.visible = false;
	inst_100463.visible = false;
	inst_100465.visible = true;
	layer_set_visible(layer_training, false);
	layer_set_visible(layer_hire, false);
	if (obj_master.myface_x < 0) {
		obj_master.face_type_coach = true;
		room_goto(rm_choose_face);
	}
} else if (ds_list_find_index(obj_master.stafflist, pmap) < 0) {
	inst_100478.text = "";
	inst_100460.text = s_str("ui_Hire");
	inst_100466.text = s_str("ui_AvailableStaff");
	inst_100467.image_yscale = 1.125;
	inst_100459.visible = false;
	inst_100458.visible = false;
	inst_100455.visible = false;
	inst_100456.visible = false;
	inst_100457.visible = false;
} else {
	s_load_profile_uni(100471);
	inst_100460.text = s_str("btn_ExtendContract");
	inst_100465.visible = true;
	inst_100455.colour = global.c_background;
	inst_100456.colour = global.c_background;
	inst_100457.colour = global.c_background;
	switch (ds_map_find_value(obj_master.player_profile, "position")) {
		case 101:
			slog("POS_STAFF_DF");
			switch (obj_master.training_reg_df) {
				case 1:
					inst_100455.colour = global.c_primary;
					break;
				case 2:
					inst_100456.colour = global.c_primary;
					break;
				case 3:
					inst_100457.colour = global.c_primary;
					break;
			}
			break;
		case 102:
			slog("POS_STAFF_OF");
			switch (obj_master.training_reg_of) {
				case 1:
					slog("1");
					inst_100455.colour = global.c_primary;
					break;
				case 2:
					slog("2");
					inst_100456.colour = global.c_primary;
					break;
				case 3:
					slog("3");
					inst_100457.colour = global.c_primary;
					break;
			}
			break;
	}
}
target = ds_map_find_value(pmap, "xp_level") * 100;
prc = ds_map_find_value(pmap, "xp") / target * 100;
inst_100475.title = s_str("ui_XPLevel") + " " + string(ds_map_find_value(pmap, "xp_level"));
inst_100475.percent = prc;
s_check_intro();
s_check_intro_rm_profile_staff();
