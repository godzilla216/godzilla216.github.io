function s_set_up_button_kickoff() {
	slog("s_set_up_button_kickoff");
	btn_kickoff = -1;
	if (obj_master.gamepractice) {
		return;
	}
	with (obj_controller) {
		var bx = display_get_gui_width() / 2 - sprite_get_width(spr_fieldgoalbtn) / 2;
		var by = 180;
		btn_kickoff = instance_create_layer(bx, by, "Text", obj_btn_kickoff);
		btn_kickoff.gp_mapped_button = global.gp_select;
		with (obj_btn_skiptime) {
			instance_destroy();
		}
		slog(s_get_string_commstage(comm_stage));
		slog("Quarter = " + string(quarter));
		var kickingoff = -1;
		switch (comm_stage) {
			case 0:
				if (kickoffteam == human_team || obj_master.playerteamindex == -1) {
					kickingoff = 1;
				} else {
					kickingoff = 0;
				}
				break;
			case 12:
			case 13:
				if (quarter == 2) {
					if (kickoffteam != human_team || obj_master.playerteamindex == -1) {
						kickingoff = 1;
					} else {
						kickingoff = 0;
					}
				}
				break;
		}
		switch (kickingoff) {
			case -1:
				btn_kickoff.txt = s_str("ui_Continue");
				break;
			case 0:
				btn_kickoff.txt = s_str("match_Receive");
				break;
			case 1:
				btn_kickoff.txt = s_str("match_KickOff");
				break;
		}
	}
}

function btn_kick_off() {
	slog("btn_kick_off");
	instance_destroy();
	with (obj_controller) {
		comm_proceed = true;
	}
	if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
		audio_play_sound(snd_click, 1, false);
	}
}

function s_btn_kickoff_recenter() {
	x = display_get_gui_width() / 2 - sprite_get_width(spr_fieldgoalbtn) / 2;
}

