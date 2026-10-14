if (!global.poki || global.poki_done_post_match_reward) {
	layer_set_visible(layer_get_id("Poki_Layer"), false);
}
if (s_is_co_mode()) {
	s_co_division_create(100485, s_get_my_conference_uid(), s_get_my_division());
	s_co_subdivision_create(s_get_object_data(100484), s_get_my_conference_data(), 13);
	inst_100485.onClickAction = s_btn_division_postmatch_view;
	inst_100488._panel = 100485;
	inst_100488.onClickAction = s_btn_division_postmatch_view;
	with (inst_100479) {
		post_click_action = onClickAction;
		onClickAction = s_btn_postmatch_co_continue;
	}
	with (inst_100481) {
		post_click_action = onClickAction;
		onClickAction = s_btn_postmatch_co_league;
	}
	var fix = s_get_fix_by_week_and_teams(global.g_m.schedule, global.g_m.week, s_get_map_real(global.g_m.team[0], "uid", -1), s_get_map_real(global.g_m.team[1], "uid", -1));
	if (fix != -4 && s_get_map(fix, "cat", "none") == "sf") {
		var ref = 100487;
		ref.y += 8;
		var sf_text = s_create_label(ref.x + 8, ref.y - 8, s_str("ui_SemiFinal"), 0);
	}
} else {
	s_populate_division(100485, obj_master.myconference, obj_master.mydivision);
	inst_100484.conference = obj_master.myconference;
}
s_check_for_news();
inst_100479.visible = false;
inst_100481.visible = false;
inst_100488.visible = false;
stage_time = current_time;
if (obj_master.qb_mode) {
	inst_100485.y = 136;
	inst_100482.visible = false;
	stage = 2;
	stage_time = 0;
} else {
	if (obj_master.fans_done_update) {
		stage = 2;
		stage_time = 0;
	}
	if (obj_master.fans >= 100) {
		s_complete_achievement("ACH_FANS100");
	}
}
won_match = false;
var fixture = s_get_human_fixture_by_week(obj_master.week);
if (fixture && ds_map_find_value(fixture, "human_win") == "win") {
	won_match = true;
}
with (obj_master) {
	if (!is_undefined(team[0]) && team[0] >= 0) {
		if (team[0] == myteam) {
			inst_100487.col1 = global.c_primary;
		} else {
			inst_100487.col2 = global.c_primary;
		}
		inst_100487.teamnames[0] = ds_map_find_value(team[0], "tla");
		inst_100487.teamnames[1] = ds_map_find_value(team[1], "tla");
		inst_100487.ratings1[0] = s_get_team_offense(team[0]);
		inst_100487.ratings1[1] = s_get_team_defense(team[0]);
		inst_100487.ratings2[0] = s_get_team_offense(team[1]);
		inst_100487.ratings2[1] = s_get_team_defense(team[1]);
		inst_100487.scores1 = [qtr_scores0[0], qtr_scores0[1], qtr_scores0[2], qtr_scores0[3], tscore[0]];
		inst_100487.scores2 = [qtr_scores1[0], qtr_scores1[1], qtr_scores1[2], qtr_scores1[3], tscore[1]];
	}
}
