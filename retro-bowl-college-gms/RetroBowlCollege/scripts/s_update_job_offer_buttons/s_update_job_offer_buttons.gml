function s_update_job_offer_buttons() {
	slog("s_update_job_offer_buttons: " + string(conference));
	var teams = ds_list_create();
	ds_list_copy(teams, obj_master.teamlist);
	teams = s_sort_teams(teams, 1, true);
	for (var t = 0; t < ds_list_size(teams); t++) {
		var team = ds_list_find_value(teams, t);
		if (ds_map_find_value(team, "conference") != conference) {
			ds_list_delete(teams, t--);
		}
	}
	for (var b = 0; b < 16; b++) {
		var team = ds_list_find_value(teams, b);
		btn[b].text = string_hash_to_newline(ds_map_find_value(team, "name") + "# ");
		btn[b].active = true;
		btn[b].uid = real(ds_map_find_value(team, "uid"));
		btn[b].offense = real(ds_map_find_value(team, "offense"));
		btn[b].defense = real(ds_map_find_value(team, "defense"));
		if (!s_team_interested(team)) {
			btn[b].active = false;
		}
	}
	random_set_seed(current_time);
	ds_list_destroy(teams);
	teams = -1;
	switch (conference) {
		case 0:
			inst_100043.colour = global.c_primary;
			inst_100042.colour = global.c_background;
			break;
		case 1:
			inst_100043.colour = global.c_background;
			inst_100042.colour = global.c_primary;
			break;
	}
}

