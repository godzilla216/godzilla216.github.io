slog("------> Create: obj_home");
s_update_game_title();
s_competitions_status_update();
_poki_gameplay_start();
switch (obj_master.retrobowlwinner) {
	case -1:
		obj_master.retrobowlwinner = 0;
		s_do_player_awards();
		break;
	case 1:
		obj_master.retrobowlwinner = 0;
		s_show_rm_winners(1, -1, "", "", btn_click_Home, false);
		exit;
}
if (s_resolve_non_champ_conferences()) {
	exit;
}
if (!instance_exists(obj_store_async)) {
	instance_create_layer(0, 0, "Instances", obj_store_async);
}
obj_master.roster_from_store = false;
obj_master.viewing_hof_players = false;
obj_master.force_uniform_sel1 = 0;
obj_master.force_uniform_sel2 = 0;
inst_100244.hspeed = -1.5;
inst_100244.text = s_get_ticker_text();
s_update_music_safe();
alarm[0] = 10;
var layer_fm = layer_get_id("Instances_FM");
var layer_qb = layer_get_id("Instances_QB");
switch (obj_master.qb_mode) {
	case 0:
		layer_set_visible(layer_fm, true);
		layer_set_visible(layer_qb, false);
		break;
	case 1:
		layer_set_visible(layer_fm, false);
		layer_set_visible(layer_qb, true);
		break;
}
inst_100238.text = s_str("ui_Continue");
if (!obj_master.qb_mode || obj_master.year > 1) {
	if (s_is_co_mode()) {
		if (obj_master.week == 1 && obj_master.college_admissions_draft_round > 0) {
			inst_100238.text = s_str("ui_Draft");
		}
	} else if (obj_master.week == 1 && obj_master.draft_round < 4 && ds_list_size(obj_master.freeagentlist) < 1) {
		inst_100238.text = s_str("ui_Draft");
	}
}
if (obj_master.stage == -11) {
	inst_100238.text = s_str("ui_DraftCollege");
}
if (s_is_co_mode()) {
	inst_100241.mode = 0;
	s_co_division_create(100241, s_get_my_conference_uid(), s_get_my_division());
	b_view = s_create_button(45, 232, {
		text: s_str("ui_View"),
		onClickAction: s_btn_division_home_view,
		_panel: 100241,
		image_xscale: 1.25
	});
} else {
	s_populate_division(100241, obj_master.myconference, obj_master.mydivision);
}
if (current_time > global.g_savedelay + 5000) {
	s_savegame();
	if (obj_master.week == 1) {
		s_save_backup();
	}
	global.g_savedelay = current_time;
}
s_check_intro_rm_home();
s_check_for_news();
if (s_get_morale() >= 100) {
	s_complete_achievement("ACH_MORALE100");
}
if (obj_master.fans >= 100) {
	s_complete_achievement("ACH_FANS100");
}
if (s_get_team_defense(obj_master.myteam) >= 10) {
	s_complete_achievement("ACH_DEFENSE5");
}
if (s_get_team_offense(obj_master.myteam) >= 10) {
	s_complete_achievement("ACH_OFFENSE5");
}
s_check_repeat_retrobowls();
if (global.mobile_device) {
	os_powersave_enable(true);
}
s_clear_last_selected_history();
s_update_btn_bengrams();
s_refresh_gamepads();
if (s_is_co_mode()) {
}
s_co_debug_access();
