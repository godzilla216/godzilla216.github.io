slog(">>> obj_details");
s_update_details_screen();
if (global.browser && obj_master.do_welcome_msg) {
	s_create_new_save();
}
inst_100034.text = s_get_team_name_by_id(ds_map_find_value(obj_master.myteam, "uid"));
if (global.mobile_device && global.browser) {
	inst_100025.active = false;
	inst_100026.active = false;
}
inst_100025.text = obj_master.fname;
inst_100026.text = obj_master.lname;
if (obj_master.do_welcome_msg) {
	obj_master.do_welcome_msg = false;
	s_create_message("", s_str("msg_Welcome_CO"), s_str("ui_Continue"), "", s_choose_mode_CO_loading, "", global.c_background, 1);
}
inst_100037.state = obj_master.fave_team_check;
inst_100036.skin = obj_master.my_skin;
inst_100036.face_x = obj_master.myface_x;
inst_100036.face_y = obj_master.myface_y;
slog("prof_head.skin = " + string(inst_100036.skin));
slog("prof_head.face_x = " + string(inst_100036.face_x));
slog("prof_head.face_y = " + string(inst_100036.face_y));
slog("obj_master.skin = " + string(obj_master.my_skin));
slog("obj_master.face_x = " + string(obj_master.myface_x));
slog("obj_master.face_y = " + string(obj_master.myface_y));
s_refresh_gamepads();
if (s_is_co_mode()) {
	s_college_details_init();
}
