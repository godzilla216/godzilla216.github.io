function s_choose_mode_HC() {
	slog("s_choose_mode_HC");
	obj_master.fr_mode = 1;
	obj_master.qb_mode = 0;
	obj_master.co_mode = 0;
	s_msg_clear();
	s_update_ui_colours();
	btn_click_GenerateCharacter();
	s_set_up_purchase_ids();
}

function s_choose_mode_QB() {
	slog("s_choose_mode_QB");
	obj_master.fr_mode = 0;
	obj_master.qb_mode = 1;
	obj_master.co_mode = 0;
	s_msg_clear();
	s_update_ui_colours();
	s_refresh_strings();
	btn_click_GenerateCharacter();
	s_set_up_purchase_ids();
}

function s_choose_mode_CO_loading() {
	s_loading_start(s_choose_mode_CO);
}

function s_choose_mode_CO() {
	slog("s_choose_mode_CO");
	s_msg_clear();
	s_setup_for_mode_CO();
	s_regen_clean_save_mode_dependent_data();
	btn_click_GenerateCharacter();
}

function s_setup_for_mode_CO() {
	with (obj_master) {
		fr_mode = 0;
		qb_mode = 0;
		co_mode = 1;
		slog("s_setup_for_mode_CO: loading conferences");
		conferences = load_data_to_struct_array(s_get_versioned_path("Conferences_CO.txt"));
		competitions = load_data_to_struct_array(s_get_versioned_path("Competitions_CO.txt"));
		editor = s_load_json("Editor.json");
		custom_data = s_custom_data_load();
		s_custom_data_patch();
		rounds = load_data_to_struct_array(s_get_versioned_path("Rounds_CO.txt"));
		s_reset_team_selections(true);
		s_reset_competitions_and_subdivisions_pools_and_rankings();
	}
	s_update_ui_colours();
	s_refresh_strings();
	s_load_co_mode_files();
	s_set_up_purchase_ids();
}

function s_update_details_screen() {
	if (obj_master.qb_mode == 1) {
		inst_100035.visible = true;
		inst_100036.visible = true;
		inst_100036.coach_heads = false;
		inst_100037.visible = false;
		inst_100038.visible = true;
		obj_master.face_type_coach = inst_100036.coach_heads;
		return;
	}
	if (s_is_co_mode()) {
		inst_100035.visible = true;
		inst_100036.visible = true;
		inst_100036.coach_heads = true;
		inst_100037.visible = false;
		inst_100038.visible = true;
		if (s_is_debug_desktop()) {
			inst_100037.visible = true;
			inst_100038.visible = false;
		}
		obj_master.face_type_coach = inst_100036.coach_heads;
		return;
	}
	if (obj_master.fr_mode == 1) {
		inst_100035.visible = true;
		inst_100036.visible = true;
		inst_100036.coach_heads = true;
		inst_100037.visible = true;
		inst_100038.visible = false;
		obj_master.face_type_coach = inst_100036.coach_heads;
		return;
	}
}

