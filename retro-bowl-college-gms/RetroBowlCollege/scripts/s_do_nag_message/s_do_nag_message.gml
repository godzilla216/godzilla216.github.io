function s_do_nag_message() {
	obj_master.nag = 0;
	if (obj_master.ad_tick++ mod 3 == 0) {
		s_do_ad_retrogoal();
		return;
	}
	s_msg_clear();
	obj_master.stage = 1;
	s_create_message("", s_str("msg_UnlimitedFeatures"), s_str("ui_Cancel"), s_str("ui_Upgrade"), s_msg_clear, s_open_store_nag, global.c_background, 1);
}

function s_do_ad_retrogoal() {
	s_msg_clear();
	obj_master.stage = 1;
	ds_map_set(obj_master.map_options, "done_ad_retrogoal", real(ds_map_find_value(obj_master.map_options, "done_ad_retrogoal")) + 1);
	s_save_options();
	room_goto(rm_ad_retrogoal);
}

