if (global.exhibition_html_1save) {
	s_load_html_save1_exhibition();
}
var bx = 8;
var by = 72;
layer_set_visible(layer_get_id("Instances_Exhibition"), false);
if (global.exhibition) {
	for (var b = 0; b < 16; b++) {
		btn[b] = instance_create_layer(bx, by, "Instances", obj_button_team);
		btn[b].onClickAction = btn_click_ChooseTeamExhibition;
		btn[b].sprite_index = spr_button_104;
		bx += 120;
		if (bx > 368) {
			bx = 8;
			by += 40;
		}
	}
	s_update_team_buttons();
	inst_100041.text = s_str("ui_ChooseTeam");
	inst_100044.visible = false;
	if (!global.exhibition_html_1save) {
		layer_set_visible(layer_get_id("Instances_Exhibition"), true);
	}
} else if (obj_master.year == 1 && obj_master.week == 1) {
	for (var b = 0; b < 16; b++) {
		btn[b] = instance_create_layer(bx, by, "Instances", obj_button);
		btn[b].onClickAction = btn_click_ChooseTeam;
		btn[b].sprite_index = spr_button_104;
		bx += 120;
		if (bx > 368) {
			bx = 8;
			by += 40;
		}
	}
	s_update_team_buttons();
	inst_100041.text = s_str("ui_FavouriteTeam");
	inst_100044.visible = false;
} else {
	inst_100041.text = s_str("ui_JobOffers");
	for (var b = 0; b < 16; b++) {
		btn[b] = instance_create_layer(bx, by, "Instances", obj_button_team);
		btn[b].sprite_index = spr_button_104;
		if (obj_master.qb_mode) {
			btn[b].onClickAction = btn_click_qb_mode_ChooseTeamNew;
		} else {
			btn[b].onClickAction = btn_click_ChooseTeamNew;
		}
		bx += 120;
		if (bx > 368) {
			bx = 8;
			by += 40;
		}
	}
	s_update_job_offer_buttons();
	var offers = s_count_joboffers();
	var won_rb = s_count_achievement("ACH_WIN_RETROBOWL1");
	var msg = "msg_JobOffers_1";
	if (obj_master.year > 3 || offers > 5) {
		msg = "msg_JobOffers_2";
		if (offers > 10 || won_rb) {
			msg = "msg_JobOffers_3";
		}
		if (offers > 20 && obj_master.year > 5) {
			msg = "msg_JobOffers_4";
		}
	}
	if (obj_master.qb_mode) {
		msg = string_replace(msg, "msg_JobOffers_", "msg_JobOffers_QB_");
	}
	if (ds_list_size(obj_master.list_teams_rejected) == 0) {
		s_create_message("", s_str(msg), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
	}
}
inst_100043.text = s_get_string_conference(0);
inst_100042.text = s_get_string_conference(1);
