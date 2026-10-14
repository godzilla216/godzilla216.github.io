function s_update_team_buttons() {
	slog("s_update_team_buttons:" + string(conference));
	var teams = ds_list_create();
	var cur_teamlist = obj_master.teamlist;
	var cur_teamid = -1;
	if (global.exhibition) {
		if (global.exh_choosing == 0 && global.exh_teamset_p0 != -1 && !global.exhibition_html_1save) {
			cur_teamlist = global.exh_teamlist_p0;
		} else if (global.exh_choosing == 1 && global.exh_teamset_p1 != -1 && !global.exhibition_html_1save) {
			cur_teamlist = global.exh_teamlist_p1;
		}
		if (global.exh_choosing == 0) {
			cur_teamid = global.exh_teamId_p0;
		} else if (global.exh_choosing == 1) {
			cur_teamid = global.exh_teamId_p1;
		}
	}
	for (var t = 0; t < ds_list_size(cur_teamlist); t++) {
		var tmap = ds_list_find_value(cur_teamlist, t);
		if (ds_map_find_value(tmap, "conference") == conference) {
			ds_list_add(teams, tmap);
		}
	}
	teams = s_sort_teams(teams, 1, true);
	for (var b = 0; b < 16; b++) {
		var team = ds_list_find_value(teams, b);
		btn[b].text = ds_map_find_value(team, "name");
		btn[b].uid = real(ds_map_find_value(team, "uid"));
		if (global.exhibition) {
			btn[b].text = string_hash_to_newline(ds_map_find_value(team, "name") + "# ");
			btn[b].offense = s_get_team_offense_with_reputation_boost(team);
			btn[b].defense = s_get_team_defense_with_reputation_boost(team);
			if (s_is_multicon()) {
				btn[b].gp_allowed = global.gp.id;
			}
			btn[b].colour_text = 16777215;
			btn[b].onClickAction = btn_click_ChooseTeamExhibition;
			if (btn[b].uid == cur_teamid) {
				btn[b].colour_text = global.c_primary;
				btn[b].onClickAction = btn_click_ChoosePlayerExhibition;
			}
		}
	}
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
	inst_100043.text = obj_master.name_conf1;
	inst_100042.text = obj_master.name_conf2;
	if (global.exhibition) {
		inst_100043.text = global.exh_choosing == 0 ? global.exh_confAFC_p0 : global.exh_confAFC_p1;
		inst_100042.text = global.exh_choosing == 0 ? global.exh_confNFC_p0 : global.exh_confNFC_p1;
	}
	if (s_is_multicon()) {
		slog("multicon limit %1", global.gp.id);
		inst_100043.gp_allowed = global.gp.id;
		inst_100042.gp_allowed = global.gp.id;
	}
}

