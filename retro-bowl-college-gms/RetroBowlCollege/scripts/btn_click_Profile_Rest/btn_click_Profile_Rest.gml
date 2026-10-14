function btn_click_Profile_Rest() {
	slog("btn_profile_rest");
	with (obj_master) {
		if (s_is_co_mode()) {
			if (ds_map_find_value(player_profile, "suspended")) {
				var msg = s_parse_player_message(s_str("msg_suspended"), player_profile);
				s_create_message(s_str("ui_PlayerSuspended"), msg, s_str("ui_Ok"), "", s_msg_clear, -4, global.c_background, 1);
				return;
			}
		}
		if (global.exhibition) {
			switch (ds_map_find_value(player_profile, "resting")) {
				case 0:
					ds_map_set(player_profile, "resting", true);
					break;
				case 1:
					ds_map_set(player_profile, "resting", false);
					break;
			}
			room_goto(rm_profile_player);
			return;
		}
		switch (ds_map_find_value(player_profile, "resting")) {
			case 0:
				var msg = s_parse_player_message(s_str("msg_Bench"), player_profile);
				s_create_message(s_str("ui_BenchPlayer"), msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_rest_player_yes, global.c_background, 1);
				break;
			case 1:
				if (ds_map_find_value(player_profile, "condition") < 40) {
					ds_map_set(player_profile, "attitude", clamp(ds_map_find_value(player_profile, "attitude") - 15, 1, 100));
				}
				ds_map_set(player_profile, "resting", false);
				room_goto(rm_profile_player);
				break;
		}
	}
}

