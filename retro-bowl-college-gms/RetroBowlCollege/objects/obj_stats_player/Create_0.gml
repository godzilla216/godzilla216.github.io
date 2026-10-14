lines = ds_list_create();
pmap = obj_master.player_profile;
if (pmap == -4) {
	exit;
}
inst_100518.visible = false;
if (obj_master.viewing_hof_players || ds_list_find_index(obj_master.freeagentlist, pmap) > -1) {
	inst_100516.visible = false;
	inst_100517.visible = false;
	inst_100518.visible = true;
	inst_100518.selected = false;
	if (ds_map_exists(pmap, "hof")) {
		inst_100518.selected = ds_map_find_value(pmap, "hof");
	}
}
var rings = 0;
var mvp = 0;
var opoy = 0;
var dpoy = 0;
var roty = 0;
var rbmvp = 0;
if (ds_map_exists(pmap, "rings")) {
	rings = ds_map_find_value(pmap, "rings");
}
if (ds_map_exists(pmap, "mvp")) {
	mvp = ds_map_find_value(pmap, "mvp");
}
if (ds_map_exists(pmap, "opoy")) {
	opoy = ds_map_find_value(pmap, "opoy");
}
if (ds_map_exists(pmap, "dpoy")) {
	dpoy = ds_map_find_value(pmap, "dpoy");
}
if (ds_map_exists(pmap, "roty")) {
	roty = ds_map_find_value(pmap, "roty");
}
if (ds_map_exists(pmap, "rbmvp")) {
	rbmvp = ds_map_find_value(pmap, "rbmvp");
}
inst_100528.text = string(rings);
inst_100519.text = string(mvp);
inst_100520.text = string(opoy);
inst_100521.text = string(dpoy);
inst_100522.text = string(roty);
inst_100529.text = string(rbmvp);
var vrs = "";
var fix = s_get_human_fixture_previous();
if (fix) {
	if (ds_map_find_value(fix, "away_team") == obj_master.myteam_id) {
		vrs = s_str("tla_At") + " " + s_get_team_name_by_id(ds_map_find_value(fix, "home_team"));
	} else {
		vrs = s_str("tla_Versus") + " " + s_get_team_name_by_id(ds_map_find_value(fix, "away_team"));
	}
}
var pos = ds_map_find_value(pmap, "position");
inst_100513.text = s_get_string_position(pos) + " - " + ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname");
var gms = "";
var att = string(ds_map_find_value(pmap, "stat_attempts"));
var cmp = string(ds_map_find_value(pmap, "stat_complete"));
var yds = string(round(ds_map_find_value(pmap, "stat_yards")));
var avg = s_get_string_float(s_get_average_yards(pmap, 0, false), 1);
var lng = string(round(ds_map_find_value(pmap, "stat_longest")));
var tds = string(ds_map_find_value(pmap, "stat_touchdowns"));
var fum = string(ds_map_find_value(pmap, "stat_fumbles"));
var tck = string(ds_map_find_value(pmap, "stat_tackles"));
var int = string(ds_map_find_value(pmap, "stat_int"));
var sck = string(ds_map_find_value(pmap, "stat_sacks"));
if (pos == 1 && ds_map_find_value(pmap, "stat_attempts") > 0) {
	cmp += " (" + string(round(ds_map_find_value(pmap, "stat_complete") / ds_map_find_value(pmap, "stat_attempts") * 100)) + "%)";
}
var r_att = string(ds_map_find_value(pmap, "stat_rush_attempts"));
var r_yds = string(round(ds_map_find_value(pmap, "stat_rush_yards")));
var r_avg = s_get_string_float(s_get_average_yards(pmap, 0, true), 1);
var r_lng = string(round(ds_map_find_value(pmap, "stat_rush_longest")));
var r_tds = string(ds_map_find_value(pmap, "stat_rush_touchdowns"));
var ret_yds = 0;
var ret_tds = 0;
var ret_lng = 0;
var ret_att = 0;
if (ds_map_exists(pmap, "stat_return_attempts")) {
	ret_yds = string(round(ds_map_find_value(pmap, "stat_return_yards")));
	ret_tds = string(round(ds_map_find_value(pmap, "stat_return_tds")));
	ret_lng = string(round(ds_map_find_value(pmap, "stat_return_longest")));
	ret_att = ds_map_find_value(pmap, "stat_return_attempts");
}
var att_xp = 0;
var cmp_xp = 0;
if (ds_map_exists(pmap, "stat_attempts_XP")) {
	att_xp = string(round(ds_map_find_value(pmap, "stat_attempts_XP")));
	cmp_xp = string(round(ds_map_find_value(pmap, "stat_complete_XP")));
}
switch (stat_type) {
	case 1:
		vrs = "";
		gms = string(ds_map_find_value(pmap, "season_games"));
		att = string(ds_map_find_value(pmap, "season_attempts"));
		cmp = string(ds_map_find_value(pmap, "season_complete"));
		yds = string(round(ds_map_find_value(pmap, "season_yards")));
		avg = s_get_string_float(s_get_average_yards(pmap, 1, false), 1);
		lng = string(round(ds_map_find_value(pmap, "season_longest")));
		tds = string(ds_map_find_value(pmap, "season_touchdowns"));
		fum = string(ds_map_find_value(pmap, "season_fumbles"));
		tck = string(ds_map_find_value(pmap, "season_tackles"));
		int = string(ds_map_find_value(pmap, "season_int"));
		sck = string(ds_map_find_value(pmap, "season_sacks"));
		if ((pos == 1 || pos == 10) && ds_map_find_value(pmap, "season_attempts") > 0) {
			cmp += " (" + string(round(ds_map_find_value(pmap, "season_complete") / ds_map_find_value(pmap, "season_attempts") * 100)) + "%)";
		}
		r_att = string(ds_map_find_value(pmap, "season_rush_attempts"));
		r_yds = string(round(ds_map_find_value(pmap, "season_rush_yards")));
		r_avg = s_get_string_float(s_get_average_yards(pmap, 1, true), 1);
		r_lng = string(round(ds_map_find_value(pmap, "season_rush_longest")));
		r_tds = string(ds_map_find_value(pmap, "season_rush_touchdowns"));
		if (ds_map_exists(pmap, "season_return_attempts")) {
			ret_yds = string(round(ds_map_find_value(pmap, "season_return_yards")));
			ret_tds = string(round(ds_map_find_value(pmap, "season_return_tds")));
			ret_lng = string(round(ds_map_find_value(pmap, "season_return_longest")));
			ret_att = ds_map_find_value(pmap, "season_return_attempts");
		}
		if (ds_map_exists(pmap, "season_attempts_XP")) {
			att_xp = string(round(ds_map_find_value(pmap, "season_attempts_XP")));
			cmp_xp = string(round(ds_map_find_value(pmap, "season_complete_XP")));
			if (ds_map_find_value(pmap, "season_attempts_XP") > 0) {
				cmp_xp += " (" + string(round(ds_map_find_value(pmap, "season_complete_XP") / ds_map_find_value(pmap, "season_attempts_XP") * 100)) + "%)";
			}
		}
		break;
	case 2:
		vrs = "";
		gms = string(ds_map_find_value(pmap, "career_games"));
		att = string(ds_map_find_value(pmap, "career_attempts"));
		cmp = string(ds_map_find_value(pmap, "career_complete"));
		yds = string(round(ds_map_find_value(pmap, "career_yards")));
		avg = s_get_string_float(s_get_average_yards(pmap, 2, false), 1);
		lng = string(round(ds_map_find_value(pmap, "career_longest")));
		tds = string(ds_map_find_value(pmap, "career_touchdowns"));
		fum = string(ds_map_find_value(pmap, "career_fumbles"));
		tck = string(ds_map_find_value(pmap, "career_tackles"));
		int = string(ds_map_find_value(pmap, "career_int"));
		sck = string(ds_map_find_value(pmap, "career_sacks"));
		if ((pos == 1 || pos == 10) && ds_map_find_value(pmap, "career_attempts") > 0) {
			cmp += " (" + string(round(ds_map_find_value(pmap, "career_complete") / ds_map_find_value(pmap, "career_attempts") * 100)) + "%)";
		}
		r_att = string(ds_map_find_value(pmap, "career_rush_attempts"));
		r_yds = string(round(ds_map_find_value(pmap, "career_rush_yards")));
		r_avg = s_get_string_float(s_get_average_yards(pmap, 2, true), 1);
		r_lng = string(round(ds_map_find_value(pmap, "career_rush_longest")));
		r_tds = string(ds_map_find_value(pmap, "career_rush_touchdowns"));
		if (ds_map_exists(pmap, "career_return_attempts")) {
			ret_yds = string(round(ds_map_find_value(pmap, "career_return_yards")));
			ret_tds = string(round(ds_map_find_value(pmap, "career_return_tds")));
			ret_lng = string(round(ds_map_find_value(pmap, "career_return_longest")));
			ret_att = ds_map_find_value(pmap, "career_return_attempts");
		}
		if (ds_map_exists(pmap, "career_attempts_XP")) {
			att_xp = string(round(ds_map_find_value(pmap, "career_attempts_XP")));
			cmp_xp = string(round(ds_map_find_value(pmap, "career_complete_XP")));
			if (ds_map_find_value(pmap, "career_attempts_XP") > 0) {
				cmp_xp += " (" + string(round(ds_map_find_value(pmap, "career_complete_XP") / ds_map_find_value(pmap, "career_attempts_XP") * 100)) + "%)";
			}
		}
		break;
}
switch (pos) {
	case 1:
		switch (obj_master.stat_view) {
			case 1:
				ds_list_add(lines, "shad_" + s_str("ui_Passing"));
				if (vrs != "") {
					ds_list_add(lines, vrs);
				}
				if (gms != "") {
					ds_list_add(lines, s_str("ui_stat_games") + ": " + gms);
				}
				ds_list_add(lines, s_str("ui_stat_attempts") + ": " + att);
				ds_list_add(lines, s_str("ui_stat_complete") + ": " + cmp);
				ds_list_add(lines, s_str("ui_stat_yards") + ": " + yds);
				ds_list_add(lines, s_str("ui_stat_average") + ": " + avg);
				ds_list_add(lines, s_str("ui_stat_longest") + ": " + lng);
				ds_list_add(lines, s_str("ui_stat_touchdowns") + ": " + tds);
				ds_list_add(lines, s_str("ui_stat_fumbles") + ": " + fum);
				ds_list_add(lines, s_str("ui_stat_int") + ": " + int);
				ds_list_add(lines, s_str("ui_stat_sacks") + ": " + sck);
				break;
			case 2:
				ds_list_add(lines, "shad_" + s_str("ui_Rushing"));
				if (vrs != "") {
					ds_list_add(lines, vrs);
				}
				if (gms != "") {
					ds_list_add(lines, s_str("ui_stat_games") + ": " + gms);
				}
				ds_list_add(lines, s_str("ui_stat_attempts") + ": " + r_att);
				ds_list_add(lines, s_str("ui_stat_yards") + ": " + r_yds);
				ds_list_add(lines, s_str("ui_stat_average") + ": " + r_avg);
				ds_list_add(lines, s_str("ui_stat_longest") + ": " + r_lng);
				ds_list_add(lines, s_str("ui_stat_touchdowns") + ": " + r_tds);
				ds_list_add(lines, s_str("ui_stat_fumbles") + ": " + fum);
				break;
		}
		break;
	case 2:
		switch (obj_master.stat_view) {
			case 1:
				ds_list_add(lines, "shad_" + s_str("ui_Receiving"));
				if (vrs != "") {
					ds_list_add(lines, vrs);
				}
				if (gms != "") {
					ds_list_add(lines, s_str("ui_stat_games") + ": " + gms);
				}
				ds_list_add(lines, s_str("ui_stat_receive") + ": " + att);
				ds_list_add(lines, s_str("ui_stat_yards") + ": " + yds);
				ds_list_add(lines, s_str("ui_stat_average") + ": " + avg);
				ds_list_add(lines, s_str("ui_stat_longest") + ": " + lng);
				ds_list_add(lines, s_str("ui_stat_touchdowns") + ": " + tds);
				ds_list_add(lines, s_str("ui_stat_fumbles") + ": " + fum);
				break;
			case 2:
				ds_list_add(lines, "shad_" + s_str("ui_Rushing"));
				if (vrs != "") {
					ds_list_add(lines, vrs);
				}
				if (gms != "") {
					ds_list_add(lines, s_str("ui_stat_games") + ": " + gms);
				}
				ds_list_add(lines, s_str("ui_stat_attempts") + ": " + r_att);
				ds_list_add(lines, s_str("ui_stat_yards") + ": " + r_yds);
				ds_list_add(lines, s_str("ui_stat_average") + ": " + r_avg);
				ds_list_add(lines, s_str("ui_stat_longest") + ": " + r_lng);
				ds_list_add(lines, s_str("ui_stat_touchdowns") + ": " + r_tds);
				ds_list_add(lines, s_str("ui_stat_fumbles") + ": " + fum);
				if (ret_att > 0) {
					ds_list_add(lines, s_str("ui_stat_return_yards") + ": " + ret_yds + " (" + string(ret_att) + ")");
					ds_list_add(lines, s_str("ui_stat_return_tds") + ": " + ret_tds);
					ds_list_add(lines, s_str("ui_stat_return_longest") + ": " + ret_lng);
				}
				break;
		}
		break;
	case 3:
	case 4:
		ds_list_add(lines, "shad_" + s_str("ui_Receiving"));
		if (vrs != "") {
			ds_list_add(lines, vrs);
		}
		if (gms != "") {
			ds_list_add(lines, s_str("ui_stat_games") + ": " + gms);
		}
		ds_list_add(lines, s_str("ui_stat_receive") + ": " + att);
		ds_list_add(lines, s_str("ui_stat_yards") + ": " + yds);
		ds_list_add(lines, s_str("ui_stat_average") + ": " + avg);
		ds_list_add(lines, s_str("ui_stat_longest") + ": " + lng);
		ds_list_add(lines, s_str("ui_stat_touchdowns") + ": " + tds);
		ds_list_add(lines, s_str("ui_stat_fumbles") + ": " + fum);
		if (ret_att > 0) {
			ds_list_add(lines, s_str("ui_stat_return_yards") + ": " + ret_yds + " (" + string(ret_att) + ")");
			ds_list_add(lines, s_str("ui_stat_return_tds") + ": " + ret_tds);
			ds_list_add(lines, s_str("ui_stat_return_longest") + ": " + ret_lng);
		}
		break;
	case 10:
		ds_list_add(lines, "shad_" + s_str("ui_Kicking"));
		if (vrs != "") {
			ds_list_add(lines, vrs);
		}
		if (gms != "") {
			ds_list_add(lines, s_str("ui_stat_games") + ": " + gms);
		}
		ds_list_add(lines, s_str("ui_stat_fga") + ": " + att);
		ds_list_add(lines, s_str("ui_stat_fgm") + ": " + cmp);
		ds_list_add(lines, s_str("ui_stat_yards") + ": " + yds);
		ds_list_add(lines, s_str("ui_stat_average") + ": " + avg);
		ds_list_add(lines, s_str("ui_stat_longest") + ": " + lng);
		ds_list_add(lines, s_str("ui_stat_xpa") + ": " + att_xp);
		ds_list_add(lines, s_str("ui_stat_xpm") + ": " + cmp_xp);
		break;
	case 5:
		ds_list_add(lines, "shad_" + s_str("ui_Blocking"));
		if (vrs != "") {
			ds_list_add(lines, vrs);
		}
		if (gms != "") {
			ds_list_add(lines, s_str("ui_stat_games") + ": " + gms);
		}
		ds_list_add(lines, s_str("ui_stat_blocks") + ": " + tck);
		break;
	case 6:
	case 7:
	case 8:
	case 9:
		ds_list_add(lines, "shad_" + s_str("ui_Defense"));
		if (vrs != "") {
			ds_list_add(lines, vrs);
		}
		if (gms != "") {
			ds_list_add(lines, s_str("ui_stat_games") + ": " + gms);
		}
		ds_list_add(lines, s_str("ui_stat_tackles") + ": " + tck);
		ds_list_add(lines, s_str("ui_stat_int") + ": " + int);
		ds_list_add(lines, s_str("ui_stat_sacks") + ": " + sck);
		ds_list_add(lines, s_str("ui_stat_f_fumbles") + ": " + fum);
		if (ret_att > 0) {
			ds_list_add(lines, s_str("ui_stat_return_yards") + ": " + ret_yds + " (" + string(ret_att) + ")");
			ds_list_add(lines, s_str("ui_stat_return_tds") + ": " + ret_tds);
			ds_list_add(lines, s_str("ui_stat_return_longest") + ": " + ret_lng);
		}
		break;
}
