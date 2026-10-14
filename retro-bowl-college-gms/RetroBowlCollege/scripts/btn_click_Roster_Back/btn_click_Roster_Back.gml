function btn_click_Roster_Back() {
	with (obj_master) {
		if (roster_from_store) {
			room_goto(rm_freeagents2);
		} else if (ds_list_size(draftlist) > 0 && obj_master.draft_entered) {
			btn_click_Profile_Back_To_Draft();
		} else if (ds_list_size(freeagentlist) > 0) {
			room_goto(rm_freeagents);
		} else if (ds_list_size(tradelist) > 0) {
			room_goto(rm_freeagents);
		} else {
			room_goto(rm_home);
		}
	}
}

function btn_click_Profile_Back_To_Draft() {
	slog("btn_click_Profile_Back_To_Draft");
	if (!s_is_co_mode()) {
		room_goto(rm_draft);
		return;
	}
	if (obj_master.college_admissions_warn_once && obj_master.college_admissions_doing_player_draft_sign) {
		slog("btn_click_Profile_Back_To_Draft - Warn");
		obj_master.college_admissions_warn_once = 0;
		s_create_message("", s_str("ui_Admissions_Warn_Once"), "", s_str("ui_Continue"), "", btn_click_Profile_Back_To_Draft_Continue, global.c_background, 1);
	} else {
		slog("btn_click_Profile_Back_To_Draft - No Warn");
		obj_master.college_admissions_doing_player_draft_sign = false;
		room_goto(rm_draft);
	}
}

function btn_click_Profile_Back_To_Draft_Continue() {
	s_msg_clear();
	obj_master.college_admissions_doing_player_draft_sign = false;
	room_goto(rm_draft);
}

