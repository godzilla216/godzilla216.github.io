function s_records_conf_only_games() {
	var w = 0;
	var l = 0;
	for (var i = 0; i < ds_list_size(obj_master.history); i++) {
		var map = ds_list_find_value(obj_master.history, i);
		if (ds_exists(map, 1) && ds_map_exists(map, "wins_cnf") && ds_map_exists(map, "losses_cnf")) {
			w += real(ds_map_find_value(map, "wins_cnf"));
			l += real(ds_map_find_value(map, "losses_cnf"));
			if (ds_map_exists(map, "year") && ds_map_find_value(map, "year") == 1 && w + l > 1) {
				w = 0;
				l = 0;
			}
		}
	}
	return string(w) + "-" + string(l);
}

function s_records_conf_only_pct() {
	var w = 0;
	var l = 0;
	for (var i = 0; i < ds_list_size(obj_master.history); i++) {
		var map = ds_list_find_value(obj_master.history, i);
		if (ds_exists(map, 1) && ds_map_exists(map, "wins_cnf") && ds_map_exists(map, "losses_cnf")) {
			w += real(ds_map_find_value(map, "wins_cnf"));
			l += real(ds_map_find_value(map, "losses_cnf"));
			if (ds_map_exists(map, "year") && ds_map_find_value(map, "year") == 1 && w + l > 1) {
				w = 0;
				l = 0;
			}
		}
	}
	var num_games = w + l;
	if (num_games > 0) {
		return string_format(w / num_games, 0, 3);
	}
	return "0%";
}

draw_set_font(global.fnt_small_flex);
txt_h = string_hd_height("I");
reclist_a = ds_list_create();
reclist_b = ds_list_create();
ds_list_add(reclist_a, s_str("ui_FullSeasons"));
ds_list_add(reclist_b, string(max(0, obj_master.year - 2)));
ds_list_add(reclist_a, s_str("ui_RecordReg"));
ds_list_add(reclist_a, s_str("ui_WinPctReg"));
var wins_reg = 0;
var losses_reg = 0;
var ties_reg = 0;
for (var i = 0; i < ds_list_size(obj_master.history); i++) {
	var map = ds_list_find_value(obj_master.history, i);
	if (ds_exists(map, 1) && ds_map_exists(map, "wins") && ds_map_exists(map, "losses") && ds_map_exists(map, "ties")) {
		wins_reg += real(ds_map_find_value(map, "wins"));
		losses_reg += real(ds_map_find_value(map, "losses"));
		ties_reg += real(ds_map_find_value(map, "ties"));
		if (ds_map_exists(map, "year") && ds_map_find_value(map, "year") == 1 && wins_reg + losses_reg + ties_reg > 1) {
			wins_reg = 0;
			losses_reg = 0;
			ties_reg = 0;
		}
	}
}
var str = string(wins_reg) + "-" + string(losses_reg) + "-" + string(ties_reg);
if (s_is_co_mode()) {
	str = string(wins_reg) + "-" + string(losses_reg);
}
ds_list_add(reclist_b, str);
str = "0%";
var num_games = wins_reg + losses_reg + ties_reg;
if (num_games > 0) {
	str = string_format((wins_reg + ties_reg * 0.5) / num_games, 0, 3);
}
ds_list_add(reclist_b, str);
ds_list_add(reclist_a, s_str("ui_RecordPO"));
ds_list_add(reclist_a, s_str("ui_WinPctPO"));
if (!s_is_co_mode()) {
	ds_list_add(reclist_a, s_str("ui_POsReached"));
}
var wins_po = 0;
var losses_po = 0;
var pocount = 0;
var poatts = 0;
for (var i = 0; i < ds_list_size(obj_master.history); i++) {
	var map = ds_list_find_value(obj_master.history, i);
	if (!ds_map_exists(map, "wins_po")) {
		ds_map_set(map, "wins_po", 0);
	}
	if (!ds_map_exists(map, "losses_po")) {
		ds_map_set(map, "losses_po", 0);
	}
	wins_po += real(ds_map_find_value(map, "wins_po"));
	losses_po += real(ds_map_find_value(map, "losses_po"));
	slog("Year " + string(ds_map_find_value(map, "year")));
	slog("Wins PO " + string(ds_map_find_value(map, "wins_po")));
	slog("Losses PO " + string(ds_map_find_value(map, "losses_po")));
	if (real(ds_map_find_value(map, "wins_po")) + real(ds_map_find_value(map, "losses_po")) > 0) {
		poatts++;
		slog("Attempts " + string(poatts));
	}
	pocount++;
}
ds_list_add(reclist_b, string(wins_po) + "-" + string(losses_po));
str = "0%";
num_games = wins_po + losses_po;
if (num_games > 0) {
	str = string_format(wins_po / num_games, 0, 3);
}
ds_list_add(reclist_b, str);
if (!s_is_co_mode()) {
	ds_list_add(reclist_b, string(poatts) + "/" + string(max(0, pocount - 1)));
}
for (var i = 0; i < ds_list_size(obj_master.records); i++) {
	var map = ds_list_find_value(obj_master.records, i);
	if (ds_exists(map, 1) && ds_map_exists(map, "tag")) {
		if (ds_map_exists(map, "coachstat") && real(ds_map_find_value(map, "coachstat")) == 1) {
			ds_list_add(reclist_a, s_str(ds_map_find_value(map, "tag")));
			ds_list_add(reclist_b, ds_map_find_value(map, "stat_text"));
		}
	}
}
ds_list_add(reclist_a, s_str("ui_SeasonsNoSim"));
if (!s_is_co_mode()) {
	ds_list_add(reclist_a, s_str("ui_SimRecord"));
}
ds_list_add(reclist_b, string(s_count_full_seasons()));
var wins_sim = 0;
var losses_sim = 0;
var ties_sim = 0;
for (var i = 0; i < ds_list_size(obj_master.history); i++) {
	var map = ds_list_find_value(obj_master.history, i);
	if (ds_exists(map, 1) && ds_map_exists(map, "wins_sim") && ds_map_exists(map, "losses_sim") && ds_map_exists(map, "ties_sim")) {
		wins_sim += real(ds_map_find_value(map, "wins_sim"));
		losses_sim += real(ds_map_find_value(map, "losses_sim"));
		ties_sim += real(ds_map_find_value(map, "ties_sim"));
		if (ds_map_exists(map, "year") && ds_map_find_value(map, "year") == 1 && wins_sim + losses_sim + ties_sim > 1) {
			wins_sim = 0;
			losses_sim = 0;
			ties_sim = 0;
		}
	}
}
var str_sim = string(wins_sim) + "-" + string(losses_sim) + "-" + string(ties_sim);
if (!s_is_co_mode()) {
	ds_list_add(reclist_b, str_sim);
}
if (s_is_co_mode()) {
	ds_list_add(reclist_a, s_str("ui_RecordPlayersDrafted"));
	ds_list_add(reclist_b, string(obj_master.pro_drafted_players));
	ds_list_add(reclist_a, s_str("ui_RecordConfGames"));
	ds_list_add(reclist_b, s_records_conf_only_games());
	ds_list_add(reclist_a, s_str("ui_RecordConfPCT"));
	ds_list_add(reclist_b, s_records_conf_only_pct());
	ds_list_add(reclist_a, s_str("ui_RecordConfChampWins"));
	ds_list_add(reclist_b, string(obj_master.rec_conf_champ_wins));
	ds_list_add(reclist_a, s_str("ui_RecordBowlWins"));
	ds_list_add(reclist_b, string(obj_master.rec_bowl_wins));
	ds_list_add(reclist_a, s_str("ui_RecordChampWins"));
	ds_list_add(reclist_b, string(obj_master.rec_champ_wins));
	ds_list_add(reclist_a, string_replace_all(s_str("ui_RecordHighestMajor"), "$FBS", "Major"));
	if (obj_master.rec_highest_rank_major == 999999) {
		ds_list_add(reclist_b, "N/A");
	} else {
		ds_list_add(reclist_b, string(obj_master.rec_highest_rank_major));
	}
	ds_list_add(reclist_a, string_replace_all(s_str("ui_RecordHighestMinor"), "$FCS", "Minor"));
	if (obj_master.rec_highest_rank_minor == 999999) {
		ds_list_add(reclist_b, "N/A");
	} else {
		ds_list_add(reclist_b, string(obj_master.rec_highest_rank_minor));
	}
	ds_list_add(reclist_a, s_str("ui_DonationsReceived"));
	ds_list_add(reclist_b, "$" + string(obj_master.rc_lifetime_earned) + s_str("sla_Thousand"));
	ds_list_add(reclist_a, s_str("ui_ScolarshipsGranted"));
	ds_list_add(reclist_b, "$" + string(-obj_master.rc_lifetime_spent) + s_str("sla_Thousand"));
}
listsize = ds_list_size(reclist_a);
clampsize = -listsize * txt_h + sprite_height;
if (global.gamepad && listsize * txt_h > sprite_height - 16) {
	active = true;
}
active = true;
