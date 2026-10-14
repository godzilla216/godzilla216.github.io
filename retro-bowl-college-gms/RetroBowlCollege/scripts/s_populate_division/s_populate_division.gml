function s_populate_division(_arg0, _arg1, _arg2) {
	var infobox = _arg0;
	var conference = _arg1;
	var division = _arg2;
	if (!s_is_co_mode() && conference > 1) {
		return;
	}
	infobox.title = s_get_string_conference(conference) + " " + s_get_string_division(conference, division);
	var divteams = ds_list_create();
	var myid = obj_master.myteam_id;
	var myconf = obj_master.myconference;
	var mydiv = obj_master.mydivision;
	infobox.alpha = 0.6;
	if (conference == myconf && division == mydiv) {
		infobox.alpha = 1;
	}
	for (var i = 0; i < ds_list_size(obj_master.teamlist); i++) {
		var team = ds_list_find_value(obj_master.teamlist, i);
		if (ds_map_find_value(team, "conference") == conference && ds_map_find_value(team, "division") == division) {
			ds_list_add(divteams, team);
		}
	}
	divteams = s_sort_teams(divteams, 0, false);
	for (var i = 0; i < ds_list_size(divteams); i++) {
		var team = ds_list_find_value(divteams, i);
		var txt = ds_map_find_value(team, "name");
		var wins = string(ds_map_find_value(team, "wins"));
		var losses = string(ds_map_find_value(team, "losses"));
		var ties = string(ds_map_find_value(team, "ties"));
		var pct = string_format(s_get_team_winpct(team), 0, 3);
		pct = string_replace(pct, "0.", ".");
		var net = s_get_team_net_points(ds_map_find_value(team, "uid"));
		var of = s_get_team_offense(team);
		var df = s_get_team_defense(team);
		if (obj_master.op_difficulty == 4 && team != obj_master.myteam_id) {
			of = real(ds_map_find_value(team, "offense"));
			df = real(ds_map_find_value(team, "defense"));
		}
		var offense = string_format(of / 2, 1, 1);
		var defense = string_format(df / 2, 1, 1);
		var txt_col = 16777215;
		if (ds_map_find_value(team, "uid") == myid) {
			txt_col = global.c_primary;
		}
		switch (i) {
			case 0:
				infobox.team_name[0] = txt;
				infobox.col_txt[0] = txt_col;
				infobox.wins[0] = wins;
				infobox.losses[0] = losses;
				infobox.ties[0] = ties;
				infobox.pct[0] = pct;
				infobox.net[0] = net;
				infobox.offense[0] = offense;
				infobox.defense[0] = defense;
				break;
			case 1:
				infobox.team_name[1] = txt;
				infobox.col_txt[1] = txt_col;
				infobox.wins[1] = wins;
				infobox.losses[1] = losses;
				infobox.ties[1] = ties;
				infobox.pct[1] = pct;
				infobox.net[1] = net;
				infobox.offense[1] = offense;
				infobox.defense[1] = defense;
				break;
			case 2:
				infobox.team_name[2] = txt;
				infobox.col_txt[2] = txt_col;
				infobox.wins[2] = wins;
				infobox.losses[2] = losses;
				infobox.ties[2] = ties;
				infobox.pct[2] = pct;
				infobox.net[2] = net;
				infobox.offense[2] = offense;
				infobox.defense[2] = defense;
				break;
			case 3:
				infobox.team_name[3] = txt;
				infobox.col_txt[3] = txt_col;
				infobox.wins[3] = wins;
				infobox.losses[3] = losses;
				infobox.ties[3] = ties;
				infobox.pct[3] = pct;
				infobox.net[3] = net;
				infobox.offense[3] = offense;
				infobox.defense[3] = defense;
				break;
		}
	}
	ds_list_destroy(divteams);
	divteams = -1;
}

