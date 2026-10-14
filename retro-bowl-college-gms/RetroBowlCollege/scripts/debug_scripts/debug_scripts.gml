function s_debug_window_size() {
	if (!global.debug) {
		return;
	}
	if (keyboard_check_pressed(76) && current_room != rm_edit_competition) {
		slogf("Force change resolution. Current %1p", window_get_height());
		if (window_get_height() == 480 || window_get_height() == 810) {
			window_set_size(1280, 720);
		} else {
			window_set_size(640, 480);
		}
		s_create_camera();
		slogf("Window: %1x%2", window_get_width(), window_get_height());
		slogf("Screen: %1x%2", display_get_width(), display_get_height());
	}
}

function s_is_debug_desktop() {
	return os_type == 1 && !global.browser && global.debug;
}

function s_set_desktop_dev_window_size() {
	if (s_is_debug_desktop()) {
		window_set_size(960, 540);
	} else {
		window_set_size(960, 540);
	}
}

function s_co_debug_access() {
	if (!s_is_co_mode() || !global.debug) {
		return;
	}
	s_create_button(384, 8, { text: "dbg", onClickAction: btn_click_debug_main, image_yscale: 0.53 });
}

function s_debug_room_init() {
	s_init_rm();
	s_set_var_if_missing("init", s_debug_init_menu);
	if (init) {
		init();
	}
}

function s_debug_init_menu() {
	s_create_button(8, 232, { text: "", image: spr_arrowL, onClickAction: btn_click_Home }, obj_button_sqr);
	var r = 1;
	s_create_button(8, 20 * r++, {
		text: "Conferences and Teams",
		onClickAction: btn_click_debug_team_ranking,
		image_xscale: 6,
		image_yscale: 0.5
	});
	s_create_button(8, 20 * r++, {
		text: "Results Screen",
		onClickAction: btn_click_debug_test_screen,
		image_xscale: 6,
		image_yscale: 0.5
	});
	s_create_button(8, 20 * r++, {
		text: "Review Screen",
		onClickAction: btn_click_debug_review_screen,
		image_xscale: 6,
		image_yscale: 0.5
	});
	s_create_button(8, 20 * r++, {
		text: "Team Editor (Franchise)",
		onClickAction: btn_click_debug_team_editor_franchise_screen,
		image_xscale: 6,
		image_yscale: 0.5
	});
	s_create_button(8, 20 * r++, {
		text: "Team Editor (College)",
		onClickAction: btn_click_debug_editor_screen,
		image_xscale: 6,
		image_yscale: 0.5
	});
	s_create_button(8, 20 * r++, {
		text: "Test FCS pool creation",
		onClickAction: btn_click_debug_test_pool_creation,
		image_xscale: 6,
		image_yscale: 0.5
	});
	s_create_button(8, 20 * r++, {
		text: "Test sim odds",
		onClickAction: btn_click_debug_test_sim_odds,
		image_xscale: 6,
		image_yscale: 0.5
	});
	r = 1;
	s_create_button(240, 20 * r++, {
		text: s_get_forced_skip_result_readout(),
		onClickAction: btn_click_debug_force_skip_result,
		image_xscale: 6,
		image_yscale: 0.5
	});
	s_create_button(240, 20 * r++, {
		text: "Skip Next match",
		onClickAction: btn_click_debug_skip_next_match,
		image_xscale: 6,
		image_yscale: 0.5
	});
	s_create_button(240, 20 * r++, {
		text: "Skip Regular Season",
		onClickAction: btn_click_debug_skip_regular_season,
		image_xscale: 6,
		image_yscale: 0.5
	});
	r++;
	s_create_button(240, 20 * r++, {
		text: s_strfl("Switch data version (v%1)", s_get_alternative_data_version()),
		onClickAction: btn_click_debug_switch_data_version,
		_version: s_get_alternative_data_version(),
		image_xscale: 6,
		image_yscale: 0.5
	});
	s_create_button(240, 20 * r++, {
		text: "Trigger Player Awards",
		onClickAction: s_do_player_awards_college,
		image_xscale: 6,
		image_yscale: 0.5
	});
	s_create_button(240, 20 * r++, { text: "Force Crash", onClickAction: s_fake_crash_safe, image_xscale: 6, image_yscale: 0.5 });
	s_create_button(240, 20 * r++, { text: "Rosebud", onClickAction: s_give_debug_cc, image_xscale: 6, image_yscale: 0.5 });
}

function s_give_debug_cc() {
	obj_master.coach_credit += 50;
}

function btn_click_debug_main() {
	s_goto_room(rm_debug);
}

function btn_click_debug_team_ranking() {
	s_goto_room(rm_debug, { init: s_debug_init_team_ranking });
}

function btn_click_debug_test_screen() {
	room_goto(rm_post_match);
}

function btn_click_debug_review_screen() {
	room_goto(rm_season_tally);
}

function btn_click_debug_skip_regular_season() {
	slogf("Skipping to last_week_regular: %1", obj_master.last_week_regular);
	s_skip_to_week(obj_master.first_week_postseason);
	s_competitions_status_update();
	s_update_human_fixtures();
	room_goto(rm_home);
}

function btn_click_debug_skip_next_match() {
	slogf("Skipping to next week: %1", obj_master.week + 1);
	s_skip_to_week(obj_master.week + 1);
	s_competitions_status_update();
	s_update_human_fixtures();
	room_goto(rm_home);
}

function btn_click_debug_force_skip_result() {
	global.debug_force_skip_result++;
	if (global.debug_force_skip_result > 1) {
		global.debug_force_skip_result = -1;
	}
	text = s_get_forced_skip_result_readout();
}

function s_get_forced_skip_result_readout() {
	var t = "Skip result: ";
	switch (global.debug_force_skip_result) {
		case -1:
			return t + "lose";
		case 0:
			return t + "sim";
		case 1:
			return t + "win";
	}
}

function btn_click_debug_test_pool_creation() {
	slogf("Pool creation test");
	if (!s_is_co_postseason()) {
		slogf("Only available in postseason");
		return;
	}
	var config = "tier:2; num:24; tm:best_win:119,123; tm:win:120,121,122,125,126,127,128,129,130,131; tm:excl_any:123,124,133; tm:rank_fill; rnd:1-8; rnd:9-24;";
	var pool = s_get_competition_pool(config);
	slogf("Pool size %1", array_length(pool));
	for (var i = 0; i < array_length(pool); i++) {
		slogf(pool[i].name);
	}
}

function btn_click_debug_team_editor_franchise_screen() {
	s_goto_room(rm_team_editor);
}

function btn_click_debug_editor_screen() {
	s_goto_room(rm_editor, s_get_editor_status());
}

function btn_click_debug_switch_data_version() {
	s_reset_to_version(_version);
}

function s_get_alternative_data_version() {
	return global.g_m.data_version == 1 ? 2 : 1;
}

function s_debug_init_team_ranking() {
	global.rm.conf_index = 0;
	global.rm.action_draw_gui = s_dbg_team_ranking_draw_gui;
	s_create_button(8, 232, { text: "", image: spr_arrowL, onClickAction: btn_click_debug_main }, obj_button_sqr);
	s_create_button(404, 232, { text: "", image: spr_arrowL, onClickAction: btn_dbg_list_prev_conference }, obj_button_sqr);
	s_create_button(440, 232, { text: "", image: spr_arrowR, onClickAction: btn_dbg_list_next_conference }, obj_button_sqr);
	var tl = [];
	with (obj_master) {
		for (var i = min_team_id; i < max_team_id; i++) {
			array_push(tl, {
				team: ds_list_find_value(teamlist, i),
				rank_pts: real(ds_map_find_value(ds_list_find_value(teamlist, i), "ranking_points"))
			});
		}
	}
	array_sort(tl, function(_arg0, _arg1) {
		return _arg1.rank_pts - _arg0.rank_pts;
	});
	global.rm.teams = tl;
}

function btn_dbg_list_prev_conference() {
	with (global.rm) {
		conf_index = s_clamp_conference_id(conf_index - 1);
	}
}

function btn_dbg_list_next_conference() {
	with (global.rm) {
		conf_index = s_clamp_conference_id(conf_index + 1);
	}
}

function s_clamp_conference_id(_arg0) {
	var cl = array_length(obj_master.conferences);
	if (_arg0 >= cl) {
		_arg0 -= cl;
	}
	if (_arg0 < 0) {
		_arg0 += cl - 1;
	}
	return _arg0;
}

function s_dbg_team_ranking_draw_gui() {
	var conf = obj_master.conferences[global.rm.conf_index];
	var teams = global.rm.teams;
	draw_set_halign(0);
	draw_hd_text(8, 8, conf.name);
	var tx = 8;
	var ty = 24;
	var tm;
	var tb = [0, 100, 135, 170, 205, 240, 275, 310, 345, 380];
	draw_hd_text(tx + tb[0], ty, "Name");
	draw_hd_text(tx + tb[1], ty, "Div");
	draw_hd_text(tx + tb[2], ty, "W");
	draw_hd_text(tx + tb[3], ty, "L");
	draw_hd_text(tx + tb[4], ty, "DF");
	draw_hd_text(tx + tb[5], ty, "OF");
	draw_hd_text(tx + tb[6], ty, "DF+");
	draw_hd_text(tx + tb[7], ty, "OF+");
	draw_hd_text(tx + tb[8], ty, "Rank");
	draw_hd_text(tx + tb[9], ty, "Reputation");
	ty += 20;
	for (var i = 0; i < array_length(teams); i++) {
		tm = teams[i];
		if (ds_map_find_value(tm.team, "conference") == conf.uid) {
			draw_hd_text(tx + tb[0], ty, ds_map_find_value(tm.team, "name"));
			draw_hd_text(tx + tb[1], ty, ds_map_find_value(tm.team, "division"));
			draw_hd_text(tx + tb[2], ty, ds_map_find_value(tm.team, "wins"));
			draw_hd_text(tx + tb[3], ty, ds_map_find_value(tm.team, "losses"));
			draw_hd_text(tx + tb[4], ty, ds_map_find_value(tm.team, "defense"));
			draw_hd_text(tx + tb[5], ty, ds_map_find_value(tm.team, "offense"));
			draw_hd_text(tx + tb[6], ty, s_get_team_defense_with_reputation_boost(tm.team));
			draw_hd_text(tx + tb[7], ty, s_get_team_offense_with_reputation_boost(tm.team));
			draw_hd_text(tx + tb[8], ty, ds_map_find_value(tm.team, "ranking_points"));
			draw_hd_text(tx + tb[9], ty, ds_map_find_value(tm.team, "reputation"));
			ty += 10;
		}
	}
}

function btn_click_debug_test_sim_odds() {
	var table = [];
	[];
	var sim, res;
	var smp = 1000;
	for (var as = 0; as <= 20; as++) {
		for (var hs = 0; hs <= 20; hs++) {
			table[as][hs] = 0;
		}
	}
	for (var i = 0; i < smp; i++) {
		randomise();
		for (var as = 0; as <= 20; as++) {
			for (var hs = 0; hs <= 20; hs++) {
				sim = s_co_get_sim_results(undefined, undefined, false, as, hs);
				res = ds_map_find_value(sim.scoredataAway, "points") > ds_map_find_value(sim.scoredataHome, "points") ? 0 : 1;
				table[hs][as] += res;
			}
		}
	}
	var s = "";
	for (var as = 0; as <= 20; as++) {
		s += s_strf("%1:\t", as);
		for (var hs = 0; hs <= 20; hs++) {
			s += s_strf("%1\t", string_format(table[hs][as] / smp * 100, 2, 2));
		}
		s += "\n";
	}
	slog(s);
}

function s_debug_list_bracketed_fixtures() {
	var fix, at, as, ht, hs;
	slogf("\nBracketed fixtures:");
	for (var f = 0; f < ds_list_size(obj_master.schedule); f++) {
		fix = ds_list_find_value(obj_master.schedule, f);
		if (ds_map_find_value(fix, "show") == "bkt") {
			at = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
			as = ds_map_find_value(fix, "away_score");
			ht = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
			hs = ds_map_find_value(fix, "home_score");
			slogf("%5\t%1\t%2-%3\t%4", ds_map_find_value(at, "tla"), as, hs, ds_map_find_value(ht, "tla"), ds_map_find_value(fix, "mid"));
		}
	}
}

function s_debug_start_time() {
	global.g_m.debug_time = get_timer();
	global.g_m.debug_time_last = global.g_m.debug_time;
	slogf("*** Timer reset");
}

function s_debug_show_time(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = "";
	}
	var dt = get_timer();
	if (_arg0 != "") {
		_arg0 = " - " + _arg0;
	}
	slogf("*** Timer: start %1 last %2%3", (dt - global.g_m.debug_time) / 1000000, (dt - global.g_m.debug_time_last) / 1000000, _arg0);
	global.g_m.debug_time_last = dt;
}

function s_set_exception_reporter() {
}

function s_fake_crash() {
	var xdd = obj_master.roster[0];
	slog(xdd);
}

function s_fake_crash_safe() {
	s_safe_run(s_fake_crash);
}

function s_safe_run(_arg0) {
	try {
		_arg0();
	} catch (_exception) {
		s_safe_run_catch(_exception);
	}
}

function s_safe_run_catch(_arg0) {
	var msg = s_safe_run_msg(_arg0);
	show_debug_message(msg);
	s_safe_run_crash_report(msg);
	s_safe_run_crash_save();
	throw msg;
}

function s_safe_run_msg(_arg0) {
	var msg = "\n\nVersion: [" + s_get_gm_version() + "]\n";
	msg += "Exception Message: " + _arg0.message + "\n";
	msg += "Long Message: " + _arg0.longMessage + "\n";
	msg += "Script: " + _arg0.script + "\n";
	var stacktrace_str = "";
	for (var i = 0; i < array_length(_arg0.stacktrace); ++i) {
		stacktrace_str += "\t" + _arg0.stacktrace[i] + "\n";
	}
	msg += "Stack Trace: \n" + stacktrace_str;
	return msg;
}

function s_safe_run_crash_report(_arg0) {
	try {
		if (file_exists("rb_crash.txt")) {
			file_delete("rb_crash.txt");
		}
		var _f = file_text_open_write("crash.txt");
		file_text_write_string(_f, _arg0);
		file_text_close(_f);
	} catch (_exception) {
	}
}

function s_safe_run_crash_save() {
	try {
		var save_name = s_get_savename();
		var backup_name = "rb_crash_save_" + save_name;
		if (file_exists(backup_name)) {
			file_delete(backup_name);
		}
		file_copy(save_name, backup_name);
		s_nx_commit();
	} catch (_exception) {
	}
}

