function s_get_player_body_type(_arg0, _arg1, _arg2) {
	if (_arg0) {
		if (_arg1 == -4) {
			return 1;
		} else {
			var stats = 0;
			switch (ds_map_find_value(_arg1, "position")) {
				case 1:
					stats += ds_map_find_value(_arg1, "speed") / 7;
					stats += ds_map_find_value(_arg1, "strength") / 10;
					stats += ds_map_find_value(_arg1, "skill") / 10;
					stats += ds_map_find_value(_arg1, "stamina") / 10;
					break;
				case 2:
					stats += ds_map_find_value(_arg1, "speed") / 10;
					stats += ds_map_find_value(_arg1, "strength") / 9;
					stats += ds_map_find_value(_arg1, "skill") / 6;
					stats += ds_map_find_value(_arg1, "stamina") / 9;
					break;
				case 3:
					stats += ds_map_find_value(_arg1, "speed") / 7;
					stats += ds_map_find_value(_arg1, "strength") / 8;
					stats += ds_map_find_value(_arg1, "skill") / 8;
					stats += ds_map_find_value(_arg1, "stamina") / 10;
					break;
				case 4:
					stats += ds_map_find_value(_arg1, "speed") / 10;
					stats += ds_map_find_value(_arg1, "strength") / 6;
					stats += ds_map_find_value(_arg1, "skill") / 10;
					stats += ds_map_find_value(_arg1, "stamina") / 8;
					break;
				case 5:
				case 6:
					stats += ds_map_find_value(_arg1, "speed") / 5;
					stats += ds_map_find_value(_arg1, "strength") / 10;
					stats += ds_map_find_value(_arg1, "skill") / 10;
					stats += ds_map_find_value(_arg1, "stamina") / 10;
					break;
				case 7:
					stats += ds_map_find_value(_arg1, "speed") / 7;
					stats += ds_map_find_value(_arg1, "strength") / 8;
					stats += ds_map_find_value(_arg1, "skill") / 8;
					stats += ds_map_find_value(_arg1, "stamina") / 10;
					break;
				case 8:
				case 9:
					stats += ds_map_find_value(_arg1, "speed") / 9;
					stats += ds_map_find_value(_arg1, "strength") / 6;
					stats += ds_map_find_value(_arg1, "skill") / 8;
					stats += ds_map_find_value(_arg1, "stamina") / 10;
					break;
				case 10:
					stats += ds_map_find_value(_arg1, "speed") / 7;
					stats += ds_map_find_value(_arg1, "strength") / 10;
					stats += ds_map_find_value(_arg1, "skill") / 10;
					stats += ds_map_find_value(_arg1, "stamina") / 10;
					break;
			}
			stats /= 4;
			if (stats >= 0.7) {
				return 2;
			}
			return 1;
		}
	} else {
		var r = 0;
		if (_arg2 < 2) {
			r = 0;
		} else if (_arg2 < 4) {
			r = 0.1;
		} else if (_arg2 < 5) {
			r = 0.2;
		} else if (_arg2 < 6) {
			r = 0.3;
		} else if (_arg2 < 7) {
			r = 0.4;
		} else if (_arg2 < 8) {
			r = 0.5;
		} else if (_arg2 < 9) {
			r = 0.6;
		} else if (_arg2 < 14) {
			r = 0.8;
		} else {
			r = 0.9;
		}
		var pick = random_range(0, 1);
		if (pick < r) {
			return 2;
		}
		return 1;
	}
	slog("BODTYP: BODY_THIN(Fallback)");
	return 1;
}

function s_spr_from_bt(_arg0, _arg1) {
	switch (_arg0) {
		case spr_celebrate:
			return _arg1 == 2 ? spr_celebrate_bulky : (_arg1 == 1 ? spr_celebrate_thin : spr_celebrate);
		case spr_dive:
			return _arg1 == 2 ? spr_dive_bulky : (_arg1 == 1 ? spr_dive_thin : spr_dive);
		case spr_dive_ball:
			return _arg1 == 2 ? spr_dive_ball_bulky : (_arg1 == 1 ? spr_dive_ball_thin : spr_dive_ball);
		case spr_dive_ball2:
			return _arg1 == 2 ? spr_dive_ball2_bulky : (_arg1 == 1 ? spr_dive_ball2_thin : spr_dive_ball2);
		case spr_falling:
			return _arg1 == 2 ? spr_falling_bulky : (_arg1 == 1 ? spr_falling_thin : spr_falling);
		case spr_falling_ball:
			return _arg1 == 2 ? spr_falling_ball_bulky : (_arg1 == 1 ? spr_falling_ball_thin : spr_falling_ball);
		case spr_falling_ball2:
			return _arg1 == 2 ? spr_falling_ball2_bulky : (_arg1 == 1 ? spr_falling_ball2_thin : spr_falling_ball2);
		case spr_firstdown:
			return _arg1 == 2 ? spr_firstdown_bulky : (_arg1 == 1 ? spr_firstdown_thin : spr_firstdown);
		case spr_firstdown_kneel:
			return _arg1 == 2 ? spr_firstdown_kneel_bulky : (_arg1 == 1 ? spr_firstdown_kneel_thin : spr_firstdown_kneel);
		case spr_getup:
			return _arg1 == 2 ? spr_getup_bulky : (_arg1 == 1 ? spr_getup_thin : spr_getup);
		case spr_getup_ball:
			return _arg1 == 2 ? spr_getup_ball_bulky : (_arg1 == 1 ? spr_getup_ball_thin : spr_getup_ball);
		case spr_getup_ball2:
			return _arg1 == 2 ? spr_getup_ball2_bulky : (_arg1 == 1 ? spr_getup_ball2_thin : spr_getup_ball2);
		case spr_handoff:
			return _arg1 == 2 ? spr_handoff_bulky : (_arg1 == 1 ? spr_handoff_thin : spr_handoff);
		case spr_jockey:
			return _arg1 == 2 ? spr_jockey_bulky : (_arg1 == 1 ? spr_jockey_thin : spr_jockey);
		case spr_jump:
			return _arg1 == 2 ? spr_jump_bulky : (_arg1 == 1 ? spr_jump_thin : spr_jump);
		case spr_jump_catch:
			return _arg1 == 2 ? spr_jump_catch_bulky : (_arg1 == 1 ? spr_jump_catch_thin : spr_jump_catch);
		case spr_jump_catch_ball:
			return _arg1 == 2 ? spr_jump_catch_ball_bulky : (_arg1 == 1 ? spr_jump_catch_ball_thin : spr_jump_catch_ball);
		case spr_jump_catch_ball2:
			return _arg1 == 2 ? spr_jump_catch_ball2_bulky : (_arg1 == 1 ? spr_jump_catch_ball2_thin : spr_jump_catch_ball2);
		case spr_jump2:
			return _arg1 == 2 ? spr_jump2_bulky : (_arg1 == 1 ? spr_jump2_thin : spr_jump2);
		case spr_kick1:
			return _arg1 == 2 ? spr_kick1_bulky : (_arg1 == 1 ? spr_kick1_thin : spr_kick1);
		case spr_kick2:
			return _arg1 == 2 ? spr_kick2_bulky : (_arg1 == 1 ? spr_kick2_thin : spr_kick2);
		case spr_kneel:
			return _arg1 == 2 ? spr_kneel_bulky : (_arg1 == 1 ? spr_kneel_thin : spr_kneel);
		case spr_place:
			return _arg1 == 2 ? spr_place_bulky : (_arg1 == 1 ? spr_place_thin : spr_place);
		case spr_qb_aim:
			return _arg1 == 2 ? spr_qb_aim_bulky : (_arg1 == 1 ? spr_qb_aim_thin : spr_qb_aim);
		case spr_qb_aim_old:
			return _arg1 == 2 ? spr_qb_aim_old_bulky : (_arg1 == 1 ? spr_qb_aim_old_thin : spr_qb_aim_old);
		case spr_qb_slide:
			return _arg1 == 2 ? spr_qb_slide_bulky : (_arg1 == 1 ? spr_qb_slide_thin : spr_qb_slide);
		case spr_qb_throw:
			return _arg1 == 2 ? spr_qb_throw_bulky : (_arg1 == 1 ? spr_qb_throw_thin : spr_qb_throw);
		case spr_qb_walk:
			return _arg1 == 2 ? spr_qb_walk_bulky : (_arg1 == 1 ? spr_qb_walk_thin : spr_qb_walk);
		case spr_run:
			return _arg1 == 2 ? spr_run_bulky : (_arg1 == 1 ? spr_run_thin : spr_run);
		case spr_run_ball:
			return _arg1 == 2 ? spr_run_ball_bulky : (_arg1 == 1 ? spr_run_ball_thin : spr_run_ball);
		case spr_run_ball2:
			return _arg1 == 2 ? spr_run_ball2_bulky : (_arg1 == 1 ? spr_run_ball2_thin : spr_run_ball2);
		case spr_spike:
			return _arg1 == 2 ? spr_spike_bulky : (_arg1 == 1 ? spr_spike_thin : spr_spike);
		case spr_spike2:
			return _arg1 == 2 ? spr_spike2_bulky : (_arg1 == 1 ? spr_spike2_thin : spr_spike2);
		case spr_stand:
			return _arg1 == 2 ? spr_stand_bulky : (_arg1 == 1 ? spr_stand_thin : spr_stand);
		case spr_stand_ball:
			return _arg1 == 2 ? spr_stand_ball_bulky : (_arg1 == 1 ? spr_stand_ball_thin : spr_stand_ball);
		case spr_stand_ball2:
			return _arg1 == 2 ? spr_stand_ball2_bulky : (_arg1 == 1 ? spr_stand_ball2_thin : spr_stand_ball2);
		case spr_stand_highlight:
			return _arg1 == 2 ? spr_stand_highlight_bulky : (_arg1 == 1 ? spr_stand_highlight_thin : spr_stand_highlight);
		case spr_stiffarm:
			return _arg1 == 2 ? spr_stiffarm_bulky : (_arg1 == 1 ? spr_stiffarm_thin : spr_stiffarm);
		case spr_stiffarm2:
			return _arg1 == 2 ? spr_stiffarm2_bulky : (_arg1 == 1 ? spr_stiffarm2_thin : spr_stiffarm2);
		case spr_taunt:
			return _arg1 == 2 ? spr_taunt_bulky : (_arg1 == 1 ? spr_taunt_thin : spr_taunt);
		case spr_wrestle:
			return _arg1 == 2 ? spr_wrestle_bulky : (_arg1 == 1 ? spr_wrestle_thin : spr_wrestle);
	}
	return _arg0;
}

function s_is_spr_bodytype(_arg0, _arg1) {
	if (_arg1 == 2) {
		switch (_arg0) {
			case spr_celebrate_bulky:
				return true;
			case spr_dive_bulky:
				return true;
			case spr_dive_ball_bulky:
				return true;
			case spr_dive_ball2_bulky:
				return true;
			case spr_falling_bulky:
				return true;
			case spr_falling_ball_bulky:
				return true;
			case spr_falling_ball2_bulky:
				return true;
			case spr_firstdown_bulky:
				return true;
			case spr_firstdown_kneel_bulky:
				return true;
			case spr_getup_bulky:
				return true;
			case spr_getup_ball_bulky:
				return true;
			case spr_getup_ball2_bulky:
				return true;
			case spr_handoff_bulky:
				return true;
			case spr_jockey_bulky:
				return true;
			case spr_jump_bulky:
				return true;
			case spr_jump_catch_bulky:
				return true;
			case spr_jump_catch_ball_bulky:
				return true;
			case spr_jump_catch_ball2_bulky:
				return true;
			case spr_jump2_bulky:
				return true;
			case spr_kick1_bulky:
				return true;
			case spr_kick2_bulky:
				return true;
			case spr_kneel_bulky:
				return true;
			case spr_place_bulky:
				return true;
			case spr_qb_aim_bulky:
				return true;
			case spr_qb_aim_old_bulky:
				return true;
			case spr_qb_slide_bulky:
				return true;
			case spr_qb_throw_bulky:
				return true;
			case spr_qb_walk_bulky:
				return true;
			case spr_run_bulky:
				return true;
			case spr_run_ball_bulky:
				return true;
			case spr_run_ball2_bulky:
				return true;
			case spr_spike_bulky:
				return true;
			case spr_spike2_bulky:
				return true;
			case spr_stand_bulky:
				return true;
			case spr_stand_ball_bulky:
				return true;
			case spr_stand_ball2_bulky:
				return true;
			case spr_stand_highlight_bulky:
				return true;
			case spr_stiffarm_bulky:
				return true;
			case spr_stiffarm2_bulky:
				return true;
			case spr_taunt_bulky:
				return true;
			case spr_wrestle_bulky:
				return true;
		}
		return false;
	}
	if (_arg1 == 1) {
		switch (_arg0) {
			case spr_celebrate_thin:
				return true;
			case spr_dive_thin:
				return true;
			case spr_dive_ball_thin:
				return true;
			case spr_dive_ball2_thin:
				return true;
			case spr_falling_thin:
				return true;
			case spr_falling_ball_thin:
				return true;
			case spr_falling_ball2_thin:
				return true;
			case spr_firstdown_thin:
				return true;
			case spr_firstdown_kneel_thin:
				return true;
			case spr_getup_thin:
				return true;
			case spr_getup_ball_thin:
				return true;
			case spr_getup_ball2_thin:
				return true;
			case spr_handoff_thin:
				return true;
			case spr_jockey_thin:
				return true;
			case spr_jump_thin:
				return true;
			case spr_jump_catch_thin:
				return true;
			case spr_jump_catch_ball_thin:
				return true;
			case spr_jump_catch_ball2_thin:
				return true;
			case spr_jump2_thin:
				return true;
			case spr_kick1_thin:
				return true;
			case spr_kick2_thin:
				return true;
			case spr_kneel_thin:
				return true;
			case spr_place_thin:
				return true;
			case spr_qb_aim_thin:
				return true;
			case spr_qb_aim_old_thin:
				return true;
			case spr_qb_slide_thin:
				return true;
			case spr_qb_throw_thin:
				return true;
			case spr_qb_walk_thin:
				return true;
			case spr_run_thin:
				return true;
			case spr_run_ball_thin:
				return true;
			case spr_run_ball2_thin:
				return true;
			case spr_spike_thin:
				return true;
			case spr_spike2_thin:
				return true;
			case spr_stand_thin:
				return true;
			case spr_stand_ball_thin:
				return true;
			case spr_stand_ball2_thin:
				return true;
			case spr_stand_highlight_thin:
				return true;
			case spr_stiffarm_thin:
				return true;
			case spr_stiffarm2_thin:
				return true;
			case spr_taunt_thin:
				return true;
			case spr_wrestle_thin:
				return true;
		}
		return false;
	}
	if (_arg1 == 0) {
		switch (_arg0) {
			case spr_celebrate:
				return true;
			case spr_dive:
				return true;
			case spr_dive_ball:
				return true;
			case spr_dive_ball2:
				return true;
			case spr_falling:
				return true;
			case spr_falling_ball:
				return true;
			case spr_falling_ball2:
				return true;
			case spr_firstdown:
				return true;
			case spr_firstdown_kneel:
				return true;
			case spr_getup:
				return true;
			case spr_getup_ball:
				return true;
			case spr_getup_ball2:
				return true;
			case spr_handoff:
				return true;
			case spr_jockey:
				return true;
			case spr_jump:
				return true;
			case spr_jump_catch:
				return true;
			case spr_jump_catch_ball:
				return true;
			case spr_jump_catch_ball2:
				return true;
			case spr_jump2:
				return true;
			case spr_kick1:
				return true;
			case spr_kick2:
				return true;
			case spr_kneel:
				return true;
			case spr_place:
				return true;
			case spr_qb_aim:
				return true;
			case spr_qb_aim_old:
				return true;
			case spr_qb_slide:
				return true;
			case spr_qb_throw:
				return true;
			case spr_qb_walk:
				return true;
			case spr_run:
				return true;
			case spr_run_ball:
				return true;
			case spr_run_ball2:
				return true;
			case spr_spike:
				return true;
			case spr_spike2:
				return true;
			case spr_stand:
				return true;
			case spr_stand_ball:
				return true;
			case spr_stand_ball2:
				return true;
			case spr_stand_highlight:
				return true;
			case spr_stiffarm:
				return true;
			case spr_stiffarm2:
				return true;
			case spr_taunt:
				return true;
			case spr_wrestle:
				return true;
		}
		return false;
	}
	return false;
}

function s_get_team_body_type(_arg0, _arg1, _arg2) {
	var PLAYER_TEAM_MIN_BULKY = 8;
	var AI_TEAM_MIN_RATING = 15;
	with (obj_master) {
		if (ds_map_find_value(_arg0, "uid") == myteam_id && !global.exhibition) {
			var bulkyCount = 0;
			for (var i = 0; i < ds_list_size(roster); i++) {
				var pmap = ds_list_find_value(roster, i);
				bulkyCount = s_get_player_body_type(true, pmap, -1);
			}
			if (bulkyCount >= PLAYER_TEAM_MIN_BULKY) {
				slog("tbt:BODY_BULKY - bulkyCount:" + string(bulkyCount));
				return 2;
			} else {
				slog("tbt:BODY_THIN - bulkyCount:" + string(bulkyCount));
				return 1;
			}
		} else if (_arg1 + _arg2 > AI_TEAM_MIN_RATING) {
			slog("tbt:BODY_BULKY - def+off:" + string(_arg1 + _arg2));
			return 2;
		} else {
			slog("tbt:BODY_THIN - def+off:" + string(_arg1 + _arg2));
			return 1;
		}
	}
	slog("tbt:BODY_BULKY - ??");
	return 2;
}

