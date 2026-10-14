function s_play(_arg0) {
	if (_arg0) {
		obj_master.stage += 1;
	}
	if (obj_master.stage > 8) {
		obj_master.stage = 1;
	}
	show_debug_message("s_play(" + string(_arg0) + ") STAGE = " + string(obj_master.stage));
	switch (obj_master.stage) {
		case 1:
			room_goto(rm_home);
			break;
		case 2:
			obj_master.draft_entered = true;
			s_check_draft();
			break;
		case 3:
			obj_master.nag++;
			slog("fullversion = " + string(ds_map_find_value(obj_master.map_options, "fullversion")));
			slog("nag = " + string(obj_master.nag));
			var allowNag = true;
			if (s_is_co_mode() && obj_master.year < 2) {
				allowNag = false;
			}
			if (!obj_master.qb_mode && ds_map_find_value(obj_master.map_options, "fullversion") && !obj_master.tag_kr_message_done && obj_master.year > 1) {
				obj_master.stage = 1;
				obj_master.tag_kr_message_done = 1;
				s_create_message("", s_str("msg_KickReturns"), "", s_str("ui_Continue"), "", s_msg_clear, global.c_background, 1);
				return;
			} else if (!ds_map_find_value(obj_master.map_options, "done_ad_retrogoal") && global.mobile_device && obj_master.year > 1 && obj_master.week > 2 && 1 && allowNag) {
				s_do_ad_retrogoal();
				return;
			} else if (!ds_map_find_value(obj_master.map_options, "fullversion") && obj_master.nag > 4 && allowNag) {
				s_do_nag_message();
				return;
			}
			if (s_is_co_mode()) {
				s_co_pre_match();
			} else {
				s_pre_match();
			}
			break;
		case 4:
			if (!s_get_human_fixture_by_week(obj_master.week)) {
				obj_master.stage = 1;
				return;
			}
			obj_master.stage = 0;
			obj_master.gamestarts += 1;
			s_savegame();
			obj_master.stage = 4;
			room_goto(rm_match);
			break;
		case 5:
			s_do_schedule(false);
			room_goto(rm_post_match);
			break;
		case 6:
			if (!obj_master.qb_mode) {
				obj_master.stage++;
				room_goto(rm_xp);
			} else {
				room_goto(rm_qb_post_match);
			}
			break;
		case 7:
			room_goto(rm_xp);
			break;
		case 8:
			s_loading_start(s_play_endweek);
			break;
		case -10:
			s_start_college_draft();
			break;
	}
}

function s_play_endweek() {
	s_do_next_week();
	s_play(1);
}

