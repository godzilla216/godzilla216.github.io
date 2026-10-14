col = s_get_watermark_color();
sclx = 1.1;
scly = 1.1;
rot = random(360);
msg1 = "";
msg2 = "";
msg3 = "";
msg4 = "";
msg5 = "";
msg6 = "";
var typ = "Html5";
if (!global.browser) {
	switch (os_type) {
		case 0:
			typ = "Windows";
			break;
		case 4:
			typ = "Android";
			break;
		case 1:
			typ = "MacOS";
			break;
		case 3:
			typ = "iOS";
			break;
	}
}
inst_100603.text = typ + " v" + s_get_gm_version();
if (s_is_co_mode()) {
	inst_100603.text += " rt2023.8.2.152";
}
if (global.poki) {
	inst_100603.text += " Poki";
}
inst_100603.text += s_cap_breach_str();
var txt_hilite = "";
var txt_restarts = "";
page = 1;
var fixtures = [];
with (obj_master) {
	var count = 0;
	var bigwin = 0;
	var totalpd = 0;
	var total_of = 0;
	var total_df = 0;
	for (var i = 0; i < ds_list_size(fixturelist); i++) {
		array_push(fixtures, ds_list_find_value(fixturelist, i));
	}
	array_sort(fixtures, s_maps_array_sort_week);
	for (var i = 0; i < array_length(fixtures); i++) {
		map = fixtures[i];
		if (ds_map_find_value(map, "human_win") != "unplayed") {
			var str = s_is_co_mode() ? s_get_week_name(ds_map_find_value(map, "week"), true) : "W" + string(ds_map_find_value(map, "week"));
			var pd = 0;
			var strengths = "";
			var opp_map = s_get_team_by_id(ds_map_find_value(map, "home_team"));
			if (ds_map_find_value(map, "away_team") == obj_master.myteam_id) {
				str += " " + s_get_human_opponent_sla_prefix("@", real(ds_map_find_value(map, "week"))) + ds_map_find_value(opp_map, "tla");
				pd = ds_map_find_value(map, "away_score") - ds_map_find_value(map, "home_score");
			} else {
				opp_map = s_get_team_by_id(ds_map_find_value(map, "away_team"));
				str += " " + s_get_human_opponent_sla_prefix("v", real(ds_map_find_value(map, "week"))) + ds_map_find_value(opp_map, "tla");
				pd = ds_map_find_value(map, "home_score") - ds_map_find_value(map, "away_score");
			}
			strengths = string_hash_to_newline(str + " " + s_get_string_record(opp_map, true) + " O:" + string_format(s_get_team_offense_with_reputation_boost(opp_map) / 2, 1, 1) + " D:" + string_format(s_get_team_defense_with_reputation_boost(opp_map) / 2, 1, 1));
			total_of += s_get_team_offense_with_reputation_boost(opp_map);
			total_df += s_get_team_defense_with_reputation_boost(opp_map);
			str += " " + string(ds_map_find_value(map, "away_score")) + "-" + string(ds_map_find_value(map, "home_score"));
			if (pd < 0) {
				str += " " + string(pd);
			} else {
				str += " +" + string(pd);
			}
			totalpd += pd;
			if (ds_map_exists(map, "difficulty")) {
				var dif = ds_map_find_value(map, "difficulty");
				dif = string_replace(dif, s_str("ui_Dynamic"), "D");
				dif = string_replace(dif, s_str("ui_Easy"), "E");
				dif = string_replace(dif, s_str("ui_Medium"), "M");
				dif = string_replace(dif, s_str("ui_Hard"), "H");
				dif = string_replace(dif, s_str("ui_Extreme"), "X");
				dif = string_replace(dif, s_str("ui_Sim"), "S");
				dif = string_replace(dif, " ", "");
				str += " " + dif;
			}
			if (ds_map_exists(map, "op_matchlength")) {
				switch (ds_map_find_value(map, "op_matchlength")) {
					case -1:
						str += " 1m";
						break;
					case 0:
						str += " 2m";
						break;
					case 1:
						str += " 3m";
						break;
				}
			}
			if (ds_map_exists(map, "weather")) {
				switch (ds_map_find_value(map, "weather")) {
					case 0:
						break;
					case 1:
						str += " R";
						break;
					case 2:
						str += " S";
						break;
				}
			}
			count++;
			if (count < 11) {
				other.msg1 += string_hash_to_newline(str + "#");
				other.msg5 += string_hash_to_newline(strengths + "#");
			} else {
				other.msg2 += string_hash_to_newline(str + "#");
				other.msg6 += string_hash_to_newline(strengths + "#");
			}
			if (ds_map_find_value(map, "human_win") == "win") {
				var diff = abs(ds_map_find_value(map, "away_score") - ds_map_find_value(map, "home_score"));
				if (diff > bigwin) {
					txt_hilite = s_str("msg_WatermarkHighlight");
					txt_hilite = string_replace(txt_hilite, "$result", string(ds_map_find_value(map, "away_score")) + "-" + string(ds_map_find_value(map, "home_score")));
					if (ds_map_find_value(map, "away_team") == myteam_id) {
						txt_hilite = string_replace(txt_hilite, "$oppname", s_get_team_name_by_id(ds_map_find_value(map, "home_team")));
					} else {
						txt_hilite = string_replace(txt_hilite, "$oppname", s_get_team_name_by_id(ds_map_find_value(map, "away_team")));
					}
				}
			}
		}
	}
	var strpd = string(totalpd);
	if (strpd > 0) {
		strpd = "+" + strpd;
	}
	other.msg2 += string_hash_to_newline("Total PD: " + strpd + "#");
	other.msg2 += string_hash_to_newline("Salary: " + string(s_get_salary_total()) + "/" + string(salary_cap + boost_salary_cap) + "#");
	other.msg2 += string_hash_to_newline("CCs Purchased: " + string(season_credits_purchased) + "#");
	roster = s_sort_players(roster, 4);
	for (var i = 0; i < ds_list_size(roster); i++) {
		var pmap = ds_list_find_value(roster, i);
		var str = ds_map_find_value(pmap, "lname");
		other.msg3 += string_hash_to_newline(str + "#");
		other.msg4 += string_hash_to_newline(s_get_watermarked_stats(pmap) + "#");
	}
	other.msg6 += string_hash_to_newline("Total OF: " + s_get_string_float(total_of / 2, 1) + "#");
	other.msg6 += string_hash_to_newline("Total DF: " + s_get_string_float(total_df / 2, 1) + "#");
	slog("games played=" + string(count));
	slog("gamestarts=" + string(gamestarts));
	var num_restarts = gamestarts - count;
	if (num_restarts < 0) {
		num_restarts = 0;
	}
	if (num_restarts > 0) {
		txt_restarts = s_str("msg_WatermarkRestarts");
		txt_restarts = string_replace(txt_restarts, "$num", string(num_restarts));
	}
	inst_100600.text = string(num_restarts) + " " + s_str("ui_restarts") + " - " + s_generate_uid(real(ds_map_find_value(myteam, "uid")) + year + week + num_restarts, 8);
	inst_100601.text = ds_map_find_value(myteam, "name") + "#" + fname + " " + lname;
	inst_100601.text += "#" + s_str("ui_Year") + " " + string(year) + " " + s_get_string_week(week);
	inst_100601.text += "#" + s_get_string_record(myteam, true);
	inst_100601.text = string_hash_to_newline(inst_100601.text);
	if (s_is_co_mode()) {
		inst_100600.text = "";
		inst_100601.text = "";
		other.msg1 = "";
		other.msg2 = s_str("msg_LeagueScreenComingSoon");
		other.msg3 = "";
		other.msg4 = "";
		other.msg5 = "";
		other.msg6 = "";
	}
}
