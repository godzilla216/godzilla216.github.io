pmap = obj_master.player_profile;
if (pmap == -4) {
	exit;
}
draw_set_font(global.fnt_small_flex);
draw_set_halign(0);
draw_set_valign(1);
inst_100771.pmap = obj_master.player_profile;
inst_100771.active = false;
inst_100767.title = s_get_string_position_full(ds_map_find_value(pmap, "position"));
inst_100768.text = ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname");
inst_100769.text = s_str("ui_Age") + ": " + string(ds_map_find_value(pmap, "age"));
inst_100770.text = s_str("ui_Attitude") + ": " + s_get_string_attitude(ds_map_find_value(pmap, "attitude"));
attitude_img = s_get_attitude_icon(ds_map_find_value(pmap, "attitude"));
inst_100780.visible = false;
var game_count = s_count_games_coached();
var sim_count = s_count_games_simmed();
var sim_prc = round(sim_count / game_count * 100);
inst_100781.text = s_str("ui_TotalGames") + ": " + string(game_count);
inst_100782.text = s_str("ui_SimGames") + ": " + string(sim_count) + " (" + string(sim_prc) + "%)";
if (global.debug) {
	inst_100774.text = "Rating:" + string(obj_master.coach_rating);
} else {
	inst_100774.visible = false;
}
inst_100780.visible = true;
if (obj_master.myface_x < 0) {
	obj_master.face_type_coach = true;
	room_goto(rm_choose_face);
	exit;
}
s_load_profile_uni(100771);
if (s_is_co_mode()) {
	inst_100782.visible = false;
}
s_check_intro();
s_check_intro_rm_profile_boss();
