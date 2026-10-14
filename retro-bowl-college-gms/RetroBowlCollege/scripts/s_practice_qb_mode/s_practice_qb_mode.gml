function s_practice_qb_mode() {
	show_debug_message("s_practice_qb_mode");
	playstart_time = current_time;
	kicking = 0;
	x_scrim = 1300 + scrimmage * 20 * drivedir;
	x_yards = x_scrim + yards * 20 * drivedir;
	y_scrim = 300;
	s_destroy_match_objects();
	var qb = instance_create_layer(0, 0, "Players", obj_playerOF);
	var rb = instance_create_layer(0, 0, "Players", obj_playerOF);
	var ol1 = instance_create_layer(0, 0, "Players", obj_playerOF);
	instance_destroy(rb);
	with (obj_player) {
		s_set_skills_and_skin();
	}
	var dist = 200 + 30 * practice_success;
	var d = random_range(-30, 30);
	var sx = qb.x + dcos(d) * dist * drivedir;
	var sy = qb.y + dsin(d) * dist * drivedir;
	if (sy < 132 || sy > 468) {
		sy = irandom_range(132, 468);
	}
	s_create_dummy(sx, sy, 0, 0, 0);
	global.master_ball = instance_create_layer(0, 0, "Ball", obj_ball);
	instance_create_layer(0, 0, "Ball", obj_metaball);
	with (obj_controller) {
		state = 2;
		comm_stage = 14;
		comm_txt = "";
		comm_proceed = false;
		tap_msg = "";
		if (global.gamepad) {
			comm_proceed = true;
		}
	}
}

function s_end_qb_mode_practice() {
	slog("s_end_qb_mode_practice");
	with (obj_controller) {
		state = 1;
		comm_stage = 30;
		comm_txt = "";
		var xp = round(practice_score_qb_mode * 0.6);
		var msg = s_str("msg_TrainingResult");
		if (practice_score_qb_mode > obj_master.qb_training_hiscore) {
			obj_master.qb_training_hiscore = practice_score_qb_mode;
			msg = s_str("msg_TrainingResultBest");
		}
		msg = string_replace(msg, "$num", string(practice_score_qb_mode));
		msg = string_replace(msg, "$xp", string(xp));
		s_create_message("", msg, "", s_str("ui_Continue"), "", s_quit_qb_mode_practice, global.c_background, 0.7);
		var qb = s_get_qb_pmap();
		ds_map_set(qb, "xp_gain", ds_map_find_value(qb, "xp_gain") + xp);
	}
}

function s_quit_qb_mode_practice() {
	s_msg_clear();
	s_savegame();
	room_goto(rm_profile_player);
}

