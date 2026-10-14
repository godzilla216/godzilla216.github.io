function s_create_match_message(_arg0) {
	with (obj_match_msg) {
		instance_destroy();
	}
	var txt = "";
	var sub_txt = "";
	var flash = false;
	var col = 16777215;
	switch (_arg0) {
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 13:
		case 18:
		case 19:
			return;
			break;
		case 6:
			txt = s_str("match_Touchdown") + "!!!";
			flash = true;
			col = 65535;
			if (obj_controller.down == 6) {
				txt = s_str("match_Scored") + "!!!";
			}
			if (global.poki) {
				with (obj_controller) {
					if (possession == human_team) {
						poki_happy_time(0.75);
					}
				}
			}
			sub_txt = obj_controller.scorer;
			if (obj_controller.dist_td >= 1) {
				sub_txt += " " + string(obj_controller.dist_td) + " " + s_str("tla_yards");
			}
			break;
		case 7:
			txt = s_str("match_Incomplete");
			flash = false;
			col = 16777215;
			break;
		case 8:
			txt = s_str("match_OutOfBounds");
			flash = false;
			col = 16777215;
			break;
		case 9:
			txt = s_str("match_Interception") + "!";
			flash = true;
			col = 255;
			break;
		case 10:
			txt = s_str("match_Turnover") + "!";
			flash = true;
			col = 255;
			break;
		case 11:
			txt = s_str("match_Sacked") + "!";
			flash = true;
			col = 255;
			break;
		case 12:
			txt = s_str("match_Safety") + "!";
			flash = true;
			col = 255;
			break;
		case 14:
			if (global.poki) {
				with (obj_controller) {
					if (possession == human_team) {
						poki_happy_time(0.5);
					}
				}
			}
			txt = s_str("match_FG_Good") + "!";
			flash = true;
			col = 65535;
			with (obj_controller) {
				if (kicking) {
					sub_txt = string(kick_dist) + " " + s_str("tla_yards");
					var kk = s_get_kicker();
					if (kk) {
						sub_txt = kk.pos_name2 + "   " + sub_txt;
					}
				}
			}
			break;
		case 15:
			txt = s_str("match_FG_Bad") + "!";
			flash = true;
			col = 255;
			break;
		case 16:
			txt = s_str("match_Success") + "!";
			flash = true;
			col = 65535;
			if (obj_master.gamepractice == 4) {
				txt = s_str("match_Hit") + "!";
				obj_controller.practice_success += 1;
			} else if (obj_controller.practice_success > 0) {
				obj_controller.practice_success = -1;
			} else {
				obj_controller.practice_success = obj_controller.practice_count;
			}
			if (global.poki) {
				with (obj_controller) {
					if (possession == human_team) {
						poki_happy_time(0.5);
					}
				}
			}
			break;
		case 17:
			txt = s_str("match_Fail") + "!";
			if (obj_master.gamepractice == 4) {
				obj_controller.practice_success = max(0, obj_controller.practice_success - 1);
				txt = s_str("match_Miss") + "!";
			}
			flash = true;
			col = 255;
			break;
		case 20:
			txt = s_str("match_TouchBack");
			flash = false;
			col = 16777215;
			break;
		case 21:
			txt = s_str("match_Interception") + "!";
			flash = true;
			col = 255;
			sub_txt = s_str("match_TouchBack");
			break;
	}
	var msg = instance_create_layer(0, 0, "Text", obj_match_msg);
	msg.text = string_upper(txt);
	msg.sub_text = string_upper(sub_txt);
	msg.flash = flash;
	msg.col = col;
	msg.alarm[0] = 100;
	obj_controller.tap_msg = "";
	slog(txt);
}

function s_create_head2head_message() {
	slog("s_create_head2head_message");
	if (!global.exhibition || obj_master.playerteamindex != -1) {
		return;
	}
	with (obj_messagebox) {
		return;
	}
	var ps = 0;
	with (obj_controller) {
		ps = possession;
		if (s_is_kickoff(0)) {
			ps = !ps;
		}
		if (ps == last_h2h_possession) {
			return;
		}
		last_h2h_possession = ps;
	}
	s_set_multicon_turn(ps + 1);
	var msg = instance_create_layer(0, 0, "Text", obj_match_msg);
	s_sound_training_success(1);
	msg.text = string_upper(s_str("head2head_Player") + " " + string(ps + 1));
	msg.sub_text = team_name[ps];
	msg.flash = false;
	msg.col = 65535;
	msg.alarm[0] = 200;
	msg.ty = msg.h * 0.5;
	obj_controller.tap_msg = "";
	slog(msg.text);
	slog(msg.sub_text);
}

