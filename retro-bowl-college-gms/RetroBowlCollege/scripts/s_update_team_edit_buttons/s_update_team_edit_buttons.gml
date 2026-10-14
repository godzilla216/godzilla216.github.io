function s_update_team_edit_buttons() {
	slog("s_update_team_edit_buttons:" + string(obj_master.edit_conf));
	var b = 0;
	for (var t = 0; t < ds_list_size(obj_master.teamlist); t++) {
		var team = ds_list_find_value(obj_master.teamlist, t);
		if (real(ds_map_find_value(team, "conference")) == obj_master.edit_conf) {
			btn[b].text = ds_map_find_value(team, "name");
			btn[b].uid = real(ds_map_find_value(team, "uid"));
			b++;
		}
	}
	switch (obj_master.edit_conf) {
		case 0:
			inst_100554.colour = global.c_primary;
			inst_100553.colour = global.c_background;
			inst_100560.text = obj_master.name_div1;
			inst_100563.text = obj_master.name_div2;
			inst_100561.text = obj_master.name_div3;
			inst_100562.text = obj_master.name_div4;
			break;
		case 1:
			inst_100554.colour = global.c_background;
			inst_100553.colour = global.c_primary;
			inst_100560.text = obj_master.name_div1b;
			inst_100563.text = obj_master.name_div2b;
			inst_100561.text = obj_master.name_div3b;
			inst_100562.text = obj_master.name_div4b;
			break;
	}
	inst_100554.text = obj_master.name_conf1;
	inst_100553.text = obj_master.name_conf2;
}

