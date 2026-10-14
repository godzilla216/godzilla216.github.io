if (global.mobile_device) {
	os_powersave_enable(false);
}
s_sound_audience_idle();
s_qb_mode_update_resting();
if (obj_master.qb_mode) {
	obj_master.prematch_team_morale_qb = s_get_morale();
}
myfps = g_pBuiltIn.fps_real;
fps_timer = 0;
global.replay_frame = 0;
global.replay_tick = 0;
global.replay_end = 0;
global.replay_do = false;
global.replay_drag_x = 0;
global.poki_done_post_match_reward = false;
difficulty = obj_master.suppress_difficulty;
switch (obj_master.op_difficulty) {
	case 0:
		break;
	case 1:
		difficulty = 7;
		break;
	case 2:
		difficulty = 2;
		break;
	case 3:
		difficulty = -5;
		break;
	case 4:
		difficulty = -5;
		break;
}
state = 1;
comm_stage = 0;
comm_next_stage = 0;
last_stage = 0;
tap_msg = "";
comm_txt = string_upper(s_str("match_GetReady"));
comm_proceed = false;
comm_defender = -4;
comm_gain = 35;
goforit = false;
hailmary = false;
poss_txt = 1;
last_play = 0;
scorer = "";
scored_by = -1;
play_start = 0;
had_ot_possession = [];
had_ot_possession[0] = 0;
had_ot_possession[1] = 0;
state_previous = state;
pause_state_previous = state;
draw_pause_ui = true;
skip_half = false;
gametimer = 0;
minutes = 2 + obj_master.op_matchlength;
seconds = 0;
time_subtract = 0;
td_time = 0;
s_reset_match_stats(false);
randomise();
human_team = max(obj_master.playerteamindex, 0);
slog("human_team index:[" + string(human_team) + "]");
team = [];
team_name = [];
team_score = [];
team_offense = [];
team_defense = [];
team_roster = [];
team[0] = obj_master.team[0];
team[1] = obj_master.team[1];
team_name[0] = ds_map_find_value(team[0], "name");
team_name[1] = ds_map_find_value(team[1], "name");
team_score[0] = 0;
team_score[1] = 0;
team_offense[0] = s_get_team_offense(team[0]);
team_offense[1] = s_get_team_offense(team[1]);
team_defense[0] = s_get_team_defense(team[0]);
team_defense[1] = s_get_team_defense(team[1]);
team_roster[human_team] = obj_master.roster;
team_roster[!human_team ? 1 : 0] = -4;
team_conf_tag[0] = "";
team_conf_tag[1] = "";
if (global.exhibition) {
	team_offense[0] = s_get_team_offense_exh(team[0], global.exh_roster_p0);
	team_offense[1] = s_get_team_offense_exh(team[1], global.exh_roster_p1);
	team_defense[0] = s_get_team_defense_exh(team[0], global.exh_roster_p0);
	team_defense[1] = s_get_team_defense_exh(team[1], global.exh_roster_p1);
	team_roster[0] = global.exh_use_roster_p0 ? global.exh_roster_p0 : -4;
	team_roster[1] = global.exh_use_roster_p1 ? global.exh_roster_p1 : -4;
	global.exh_roster_p0 = -4;
	global.exh_roster_p1 = -4;
	slog_roster("Ob_control.create first assign", 0);
	slog_roster("Ob_control.create first assign", 1);
} else if (s_is_co_mode()) {
	team_conf_tag[0] = s_get_string_conf_tag(team[0], team[1]);
	team_conf_tag[1] = s_get_string_conf_tag(team[1], team[0]);
}
possession = irandom(1);
last_h2h_possession = -1;
kickoffteam = possession;
quarter = 1;
bzoom = 2;
drivedir = choose(-1, 1);
ot_count = 0;
if (global.exhibition) {
	if (obj_master.playerteamindex < 1) {
		drivedir = 1;
	} else {
		drivedir = -1;
	}
}
if (ds_map_find_value(obj_master.map_options, "op_drivedir") != 0) {
	drivedir = ds_map_find_value(obj_master.map_options, "op_drivedir");
}
down = 99;
yards = 0;
scrimmage = 0;
drives = 0;
phase = 0;
snaps = 0;
kicks = 0;
kicking = 0;
route_alpha = 2;
running_play = false;
audibles = -1;
audibles_p2 = -1;
timeouts = clamp(2 + obj_master.op_matchlength, 2, 3);
timeouts_p2 = clamp(2 + obj_master.op_matchlength, 2, 3);
timeout_called = false;
if (obj_master.year == 1 && !global.exhibition) {
	timeouts = 0;
}
drop_happened = false;
dist_td = 0;
x_scrim = 0;
x_yards = 0;
y_scrim = 0;
y_down = 300 + irandom_range(-100, 100);
defensive_cover = irandom(3);
defense_success = [];
defense_success[0] = 0;
defense_success[1] = 0;
defense_success[2] = 0;
defense_success[3] = 0;
defense_success[4] = 0;
global.flickVelX = 0;
global.flickVelY = 0;
global.snd_tackle_time = 0;
instance_create_layer(80, 300, "Players", obj_goal_stand);
instance_create_layer(80, 276, "Players", obj_goal_post);
instance_create_layer(80, 332, "Players", obj_goal_post);
instance_create_layer(2520, 300, "Players", obj_goal_stand);
instance_create_layer(2520, 276, "Players", obj_goal_post);
instance_create_layer(2520, 332, "Players", obj_goal_post);
practice_count = 0;
practice_success = 0;
practice_score_qb_mode = 0;
practice_chain_qb_mode = 0;
if (obj_master.gamepractice) {
	s_set_up_practice();
}
camera_set_view_pos(g_pBuiltIn.view_camera[0], 1300 - camera_get_view_width(g_pBuiltIn.view_camera[0]) * 0.5, 0);
field_type = 0;
var tmap = team[1];
switch (real(ds_map_find_value(tmap, "roof"))) {
	case 1:
		field_type = 3;
		slog("FIELD_DOME1");
		break;
	case 2:
		field_type = 4;
		slog("FIELD_DOME2");
		break;
}
instance_create_layer(0, 0, "Weather", obj_weather);
if (instance_exists(obj_weather)) {
	switch (obj_weather.type) {
		case 2:
			field_type = 1;
			break;
		case 1:
			field_type = 2;
			break;
	}
}
if (obj_master.week == s_get_week_superbowl() || s_is_co_bowl_week(obj_master.week)) {
	slogf("game is bowl");
	field_type = 5;
}
s_update_music();
if (obj_master.gamepractice) {
	field_type = 6;
	if (obj_master.qb_mode) {
		field_type = 7;
	}
}
shd_helmet = obj_master.col_helmet_home;
shd_shirt = obj_master.col_shirt_home;
shd_pants = obj_master.col_pants_home;
shd_logo = obj_master.col_logo_home;
shd_socks1 = obj_master.col_socks1_home;
shd_socks2 = obj_master.col_socks2_home;
c_endzone = make_color_rgb(obj_master.col_endzone_home[2] * 256, obj_master.col_endzone_home[1] * 256, obj_master.col_endzone_home[0] * 256);
var col_h = clamp(color_get_hue(c_endzone), 0, 255);
var col_s = clamp(color_get_saturation(c_endzone) - 25, 0, 255);
var col_v = clamp(color_get_value(c_endzone) + 20, 50, 225);
c_endzone = make_color_hsv(col_h, col_s, col_v);
comm_col_h = c_endzone;
comm_col_a = make_color_rgb(obj_master.col_endzone_away[2] * 256, obj_master.col_endzone_away[1] * 256, obj_master.col_endzone_away[0] * 256);
if (comm_col_h == 16777215) {
	comm_col_h = make_color_rgb(175, 175, 175);
}
if (comm_col_a == 16777215) {
	comm_col_a = make_color_rgb(175, 175, 175);
}
if (comm_col_a == comm_col_h) {
	comm_col_a = 8421504;
}
if (colour_get_value(comm_col_h) > 200) {
	comm_col_h = merge_color(comm_col_h, 0, 0.2);
}
if (colour_get_value(comm_col_a) > 200) {
	comm_col_a = merge_color(comm_col_a, 0, 0.2);
}
if (colour_get_value(comm_col_h) < 50) {
	comm_col_h = merge_color(comm_col_h, 16777215, 0.2);
}
if (colour_get_value(comm_col_a) < 50) {
	comm_col_a = merge_color(comm_col_a, 16777215, 0.2);
}
slog_roster("Create obj_contr. A", 0);
team_roster[0] = s_sort_players(team_roster[0], 3);
s_tag_backups_internal(team_roster[0]);
team_roster[0] = s_sort_players(team_roster[0], 4);
slog_roster("Create obj_contr. A", 1);
team_roster[1] = s_sort_players(team_roster[1], 3);
s_tag_backups_internal(team_roster[1]);
team_roster[1] = s_sort_players(team_roster[1], 4);
s_tag_backups();
with (obj_master) {
	roster = s_sort_players(roster, 4);
}
touchdowns = 0;
starqb = false;
starplayer = false;
if (obj_master.roster != -4) {
	for (var i = 0; i < ds_list_size(obj_master.roster); i++) {
		var pmap = ds_list_find_value(obj_master.roster, i);
		if (pmap && !s_player_benched(pmap) && !ds_map_find_value(pmap, "backup") && ds_map_find_value(pmap, "condition") >= 0) {
			starplayer = true;
			if (ds_map_find_value(pmap, "position") == 1) {
				starqb = true;
			}
		}
	}
}
slog("starqb: [" + string(starqb) + "]");
slog("starplayer: [" + string(starplayer) + "]");
control_alpha = 1;
var cheer1 = spr_cheerleaders1_noout;
var cheer2 = spr_cheerleaders2_noout;
var cheer3 = spr_cheerleaders3_noout;
cheer_frame = 0;
spr_cl1 = choose(cheer1, cheer2);
spr_cl2 = choose(cheer2, cheer3);
spr_cl3 = choose(cheer1, cheer3);
spr_cl4 = choose(cheer1, cheer2);
spr_cl5 = choose(cheer2, cheer3);
spr_cl6 = choose(cheer1, cheer3);
mobbrow_start_x = 0;
mobbrow_start_y = 0;
mobbrow_start_time = 0;
college_overtime = false;
college_overtime_round = 0;
college_overtime_possession = 0;
s_set_up_button_kickoff();
s_pause_btn_init();
