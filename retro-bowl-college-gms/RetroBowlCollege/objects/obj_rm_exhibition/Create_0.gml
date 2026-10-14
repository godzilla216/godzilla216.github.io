slog("RM_EXH_CREATE A: ROSTER P0: " + roster_short_desc(global.exh_roster_p0));
slog("RM_EXH_CREATE A: ROSTER P1: " + roster_short_desc(global.exh_roster_p1));
s_set_up_uniforms_exhibition();
obj_master.sim_action = false;
team0 = obj_master.team[0];
team1 = obj_master.team[1];
team0_filename = get_ex_uniform_file(global.exh_teamset_p0);
team1_filename = get_ex_uniform_file(global.exh_teamset_p1);
switch (obj_master.force_uniform_sel1) {
	case 0:
		s_load_uniform_file2(ds_map_find_value(team0, "uid"), 100786, 1, team0_filename, true);
		break;
	case 1:
		s_load_uniform_file2(ds_map_find_value(team0, "uid"), 100786, 0, team0_filename, true);
		break;
	case 2:
		s_load_uniform_file2(ds_map_find_value(team0, "uid"), 100786, 2, team0_filename, true);
		break;
	case 3:
		s_load_uniform_file2(ds_map_find_value(team0, "uid"), 100786, 3, team0_filename, true);
		break;
}
switch (obj_master.force_uniform_sel2) {
	case 0:
		s_load_uniform_file2(ds_map_find_value(team1, "uid"), 100787, 0, team1_filename, true);
		break;
	case 1:
		s_load_uniform_file2(ds_map_find_value(team1, "uid"), 100787, 1, team1_filename, true);
		break;
	case 2:
		s_load_uniform_file2(ds_map_find_value(team1, "uid"), 100787, 2, team1_filename, true);
		break;
	case 3:
		s_load_uniform_file2(ds_map_find_value(team1, "uid"), 100787, 3, team1_filename, true);
		break;
}
switch (obj_master.force_uniform_sel1) {
	case 0:
		inst_100791.text = s_str("ui_Away");
		break;
	case 1:
		inst_100791.text = s_str("ui_Home");
		break;
	case 2:
		inst_100791.text = s_str("ui_Alternate");
		break;
	case 3:
		inst_100791.text = s_str("ui_Rush");
		break;
}
switch (obj_master.force_uniform_sel2) {
	case 0:
		inst_100792.text = s_str("ui_Home");
		break;
	case 1:
		inst_100792.text = s_str("ui_Away");
		break;
	case 2:
		inst_100792.text = s_str("ui_Alternate");
		break;
	case 3:
		inst_100792.text = s_str("ui_Rush");
		break;
}
defense[0] = s_get_team_defense_exh(team0, global.exh_roster_p0);
offense[0] = s_get_team_offense_exh(team0, global.exh_roster_p0);
defense[1] = s_get_team_defense_exh(team1, global.exh_roster_p1);
offense[1] = s_get_team_offense_exh(team1, global.exh_roster_p1);
slog("T0 Defense/Offense [" + string(defense[0]) + "," + string(offense[0]) + "]");
slog("T1 Defense/Offense [" + string(defense[1]) + "," + string(offense[1]) + "]");
with (obj_master) {
	col_helmet_home = inst_100787.helmet;
	col_logo_home = inst_100787.logo;
	col_shirt_home = inst_100787.shirt;
	col_sleeve_home = inst_100787.sleeve;
	col_pants_home = inst_100787.pants;
	col_pants_home_b = inst_100787.pants_b;
	col_stripe_home = inst_100787.stripe;
	col_socks1_home = inst_100787.socks1;
	col_socks2_home = inst_100787.socks2;
	col_endzone_home = inst_100787.endzone;
	col_helmet_away = inst_100786.helmet;
	col_logo_away = inst_100786.logo;
	col_shirt_away = inst_100786.shirt;
	col_sleeve_away = inst_100786.sleeve;
	col_pants_away = inst_100786.pants;
	col_pants_away_b = inst_100786.pants_b;
	col_stripe_away = inst_100786.stripe;
	col_socks1_away = inst_100786.socks1;
	col_socks2_away = inst_100786.socks2;
	col_endzone_away = inst_100786.endzone;
}
inst_100788.title = s_str("ui_Ball") + " " + string(obj_master.op_ball + 1);
inst_100790.image_num = obj_master.op_ball;
if (s_is_multicon()) {
	obj_master.playerteamindex = -1;
	inst_100797.active = 0;
	inst_100798.active = 0;
}
refresh_exh_roster_buttons();
s_set_exhibition_buttons(obj_master.btn_continue_state);
s_update_exhibition_controllers();
s_save_options();
slog("RM_EXH_CREATE B: ROSTER P0: " + roster_short_desc(global.exh_roster_p0));
slog("RM_EXH_CREATE B: ROSTER P1: " + roster_short_desc(global.exh_roster_p1));
