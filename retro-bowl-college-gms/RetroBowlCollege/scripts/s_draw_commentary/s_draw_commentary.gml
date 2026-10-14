function s_draw_commentary() {
	var buf = 8;
	if (state == 2) {
		comm_txt = "";
		if (instance_exists(obj_ball) && global.master_ball.state == 0 && current_time < playstart_time + 2000) {
			if (kicking) {
				switch (kicking) {
					case 1:
						comm_txt = s_str("match_FieldGoal");
						break;
					case 2:
						comm_txt = s_str("match_PAT");
						break;
					case 3:
						comm_txt = s_str("match_KickOff");
						break;
				}
			} else if (down > 0) {
				comm_txt = s_get_string_downand();
			}
		}
		with (obj_messagebox) {
			return;
		}
	}
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(1);
	draw_set_valign(1);
	draw_set_alpha(1);
	var tx = display_get_gui_width() * 0.5;
	var ty = display_get_gui_height() * 0.5;
	if (state == 2) {
		ty = display_get_gui_height() * 0.75;
	}
	if (comm_txt != "") {
		var tw = string_hd_width(comm_txt) * 0.5 + buf;
		var comm_col = comm_col_a;
		if (possession == 1) {
			comm_col = comm_col_h;
		}
		switch (last_stage) {
			case 0:
			case 12:
			case 13:
			case 14:
			case 17:
			case 18:
			case 22:
			case 25:
			case 30:
			case 31:
				comm_col = 0;
				break;
			case 19:
			case 20:
			case 21:
				comm_col = comm_col_h;
				if (possession == 1) {
					comm_col = comm_col_a;
				}
				break;
			case 1:
				if (last_stage != 7 && last_stage != 16) {
					comm_col = comm_col_a;
					if (possession == 0) {
						comm_col = comm_col_h;
					}
				}
				break;
			case 5:
				comm_col = comm_col_a;
				if (possession == 0) {
					comm_col = comm_col_h;
				}
				break;
			case 7:
			case 16:
			case 11:
				break;
		}
		if (comm_stage == 2 && last_stage == 7) {
			comm_col = comm_col_a;
			if (possession == 0) {
				comm_col = comm_col_h;
			}
		}
		if (state == 2 || skip_half) {
			comm_col = 0;
		}
		draw_sprite_ext(spr_commentary_bg, 0, tx - tw, ty - buf, tw / 16 * 2, 1.1, 0, comm_col, 1);
		if (global.debug) {
			draw_hd_text(tx, ty + 22, "  " + s_get_string_commstage(comm_stage));
			draw_hd_text(tx, ty + 32, "  " + s_get_string_commstage(last_stage));
		}
		draw_hd_text_ext_color(tx - 1, ty + 1, comm_txt, -1, -1, 0, 0, 0, 0, 1);
		draw_hd_text(tx, ty, comm_txt);
	}
	if (!global.gamepad && tap_msg != "" && !instance_exists(obj_button)) {
		ty = display_get_gui_height() * 0.75;
		var tw = string_hd_width(tap_msg) * 0.5 + buf;
		draw_sprite_ext(spr_commentary_bg, 0, tx - tw, ty - buf, tw / 16 * 2, 1.1, 0, 0, 1);
		draw_hd_text(tx, ty, tap_msg);
	}
}

