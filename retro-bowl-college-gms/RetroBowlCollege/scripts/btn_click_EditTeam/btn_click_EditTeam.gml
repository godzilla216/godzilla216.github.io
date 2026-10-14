function btn_click_EditTeam() {
	var choose_teamuid = uid;
	with (obj_master) {
		for (var t = 0; t < ds_list_size(teamlist); t++) {
			var team = ds_list_find_value(teamlist, t);
			if (real(ds_map_find_value(team, "uid")) == choose_teamuid) {
				edit_team = team;
			}
		}
	}
	room_goto(rm_edit_team);
}

