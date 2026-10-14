function btn_click_TeamEditDone() {
	with (obj_edit_team) {
		s_update_uniform_name();
		ds_map_set(obj_master.edit_team, "name", current_uni.name);
		ds_map_set(obj_master.edit_team, "tla", current_uni.tla);
		ds_map_set(obj_master.edit_team, "rainfall", current_uni.rainfall);
		ds_map_set(obj_master.edit_team, "snowfall", current_uni.snowfall);
		ds_map_set(obj_master.edit_team, "roof", current_uni.roof);
		s_save_uniform_file2(uid, current_uni, kittype);
		s_savegame();
	}
	s_goto_editor();
}

