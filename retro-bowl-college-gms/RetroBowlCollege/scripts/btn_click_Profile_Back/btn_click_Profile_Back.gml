function btn_click_Profile_Back() {
	slog("btn_click_Profile_Back");
	with (obj_master) {
		college_profile_page_num = 1;
		if (profile_back_to == 1) {
			profile_back_to = -1;
			with (obj_master) {
				s_create_dilemma(map_dilemma);
			}
		} else if (profile_back_to == 2) {
			profile_back_to = -1;
			with (obj_master) {
				s_create_dilemma_news();
			}
		} else if (profile_back_to == 3) {
			profile_back_to = -1;
			with (obj_master) {
				s_college_draft_earyly_info_return();
			}
		} else if (s_doing_college_draft()) {
			room_goto(rm_draft_college);
		} else if (ds_list_find_index(storelist, player_profile) >= 0) {
			room_goto(rm_freeagents2);
		} else if (ds_list_find_index(roster, player_profile) >= 0) {
			room_goto(rm_roster);
		} else if (ds_list_find_index(draftlist, player_profile) >= 0) {
			room_goto(rm_draft);
		} else if (ds_list_find_index(freeagentlist, player_profile) >= 0) {
			room_goto(rm_freeagents);
		} else if (ds_list_find_index(tradelist, player_profile) >= 0) {
			room_goto(rm_freeagents);
		} else {
			room_goto(rm_home);
		}
	}
}

