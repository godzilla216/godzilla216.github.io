function s_kick_off() {
	slog("s_kick_off");
	with (obj_controller) {
		comm_txt = string_replace(s_str("comm_stage_KickOff"), "$teamname", team_name[possession]);
		down = 1;
		yards = 10;
		scrimmage = -15;
		var ko = ds_map_find_value(obj_master.map_options, "op_kickoffs");
		if (global.exhibition) {
			ko = ds_map_find_value(obj_master.map_options, "exh_op_kickoffs");
		}
		if (ko && !obj_master.qb_mode && !s_simming_action() && (possession != obj_master.playerteamindex || obj_master.playerteamindex == -1)) {
			down = 99;
			state = 2;
			last_play = 1;
			drives += 1;
			return;
		}
		if (possession == human_team) {
			var kk = s_get_player_by_position_from_roster(10, 1, team_roster[possession]);
			if (kk) {
				comm_txt = string_replace(s_str("comm_stage_KickOffPlayer"), "$teamname", team_name[possession]);
				comm_txt = string_replace(comm_txt, "$playername", ds_map_find_value(kk, "lname"));
				scrimmage = 25 + s_get_attribute(kk, "strength") + s_get_attribute(kk, "skill");
			} else {
				scrimmage = irandom_range(20, 25);
			}
		} else {
			scrimmage += irandom_range(45, 70);
			if (scrimmage > 40) {
				scrimmage = 25;
			}
		}
		s_subtract_time(3, 5, "COMM_STAGE_KICKOFF");
		s_change_possession();
		last_play = 1;
	}
}

