function s_set_up_hof_players_screen() {
	inst_100209.visible = false;
	inst_100210.visible = false;
	inst_100211.visible = false;
	var hof_list = ds_list_create();
	for (var r = 0; r < ds_list_size(obj_master.roster); r++) {
		var pmap = ds_list_find_value(obj_master.roster, r);
		if (pmap && ds_map_exists(pmap, "hof")) {
			if (ds_map_find_value(pmap, "hof") == true) {
				ds_list_add(hof_list, pmap);
			}
		}
	}
	for (var r = 0; r < ds_list_size(obj_master.hoflist); r++) {
		var pmap = ds_list_find_value(obj_master.hoflist, r);
		if (ds_exists(pmap, 1) && ds_map_exists(pmap, "hof")) {
			ds_list_add(hof_list, ds_list_find_value(obj_master.hoflist, r));
		}
	}
	var size = ds_list_size(hof_list);
	if (size == 0) {
		ds_list_destroy(hof_list);
		hof_list = -1;
		return;
	}
	hof_list = s_sort_players(hof_list, 3);
	inst_100208.visible = false;
	slog("SIZE = " + string(ds_list_size(hof_list)));
	var max_pages = ceil(size / 10);
	if (max_pages > 1) {
		inst_100211.visible = true;
	}
	if (obj_master.hof_page < 1) {
		obj_master.hof_page = 1;
	} else if (obj_master.hof_page > max_pages) {
		obj_master.hof_page = max_pages;
	}
	inst_100209.visible = false;
	if (obj_master.hof_page > 1) {
		inst_100209.visible = true;
	}
	inst_100210.visible = false;
	if (obj_master.hof_page < max_pages) {
		inst_100210.visible = true;
	}
	inst_100211.text = s_str("ui_Page") + " " + string(obj_master.hof_page) + "/" + string(max_pages);
	if (obj_master.hof_page > 1) {
		for (var r = 0; r < 10 * (obj_master.hof_page - 1); r++) {
			ds_list_delete(hof_list, 0);
		}
	}
	while (ds_list_size(hof_list) > 10) {
		ds_list_delete(hof_list, ds_list_size(hof_list) - 1);
	}
	size = ds_list_size(hof_list);
	var px = round(room_width * 0.5);
	var py = round(room_height * 0.45);
	var pw = sprite_get_width(spr_box_64x80) + 8;
	if (size > 5) {
		py -= 24;
		px -= 4 * (pw * 0.5);
	} else {
		px -= (size - 1) * (pw * 0.5);
	}
	var uniform = instance_create_layer(0, 0, "Instances", obj_uniform);
	uniform.visible = false;
	s_load_uniform_file2(obj_master.myteam_id, uniform, 0, "");
	slog("Hof list size = " + string(size));
	var proTeams = -4;
	if (s_is_co_mode()) {
		proTeams = s_load_pro_teams();
	}
	for (var r = 0; r < size; r++) {
		var pmap = ds_list_find_value(hof_list, r);
		if (!pmap) {
			continue;
		}
		roster_profile[r] = instance_create_layer(0, 0, "Instances", obj_player_profile);
		if (global.jefebuild) {
			roster_profile[r].onHoldAction = btn_click_Profile_JefeOutOfRetirement;
		}
		roster_profile[r].pmap = pmap;
		with (roster_profile[r]) {
			s_set_up_uniform_profile(uniform);
		}
		slog(ds_map_find_value(pmap, "lname"));
		var teamid = ds_map_find_value(pmap, "teamid");
		var team = s_get_team_by_id(teamid);
		if (team) {
			roster_profile[r].my_tla = ds_map_find_value(team, "tla");
		}
		if (s_is_co_mode() && ds_map_exists(pmap, "drafted_pro_team") && ds_map_find_value(pmap, "drafted_pro_team") != "") {
			for (var i = 0; i < ds_list_size(proTeams); i++) {
				var proTeam = ds_list_find_value(proTeams, i);
				if (ds_map_find_value(proTeam, "uid") == ds_map_find_value(pmap, "drafted_pro_team")) {
					roster_profile[r].my_tla = ds_map_find_value(team, "tla") + ">" + ds_map_find_value(proTeam, "tla");
					break;
				}
			}
		}
		roster_profile[r].x = px - pw * 0.5;
		roster_profile[r].y = py - roster_profile[0].sprite_height * 0.5;
		px += pw;
		if (r == 4) {
			var sz = min(size, 10) - 5;
			px = room_width * 0.5;
			px -= (sz - 1) * (pw * 0.5);
			py += 88;
		}
	}
	ds_list_destroy(hof_list);
	hof_list = -1;
}

