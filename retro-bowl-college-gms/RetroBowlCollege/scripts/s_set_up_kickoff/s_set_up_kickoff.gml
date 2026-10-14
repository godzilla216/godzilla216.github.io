function s_set_up_kickoff() {
	show_debug_message("s_set_up_kickoff");
	playstart_time = current_time;
	down = 99;
	global.replay_do = false;
	with (obj_controller) {
		alarm[0] = 0;
		s_reset_wind();
		kicking = 3;
		scored_by = -1;
		scrimmage = -15;
		x_scrim = 1300 + scrimmage * 20 * -drivedir;
		x_yards = x_scrim + yards * 20 * drivedir;
		y_scrim = 300;
		kick_dist = 0;
		s_destroy_match_objects();
		for (var o = 1; o < 12; o++) {
			instance_create_layer(0, 0, "Players", obj_playerOF);
		}
		for (var d = 1; d < 12; d++) {
			instance_create_layer(0, 0, "Players", obj_playerDF);
		}
		with (obj_player) {
			s_set_skills_and_skin();
		}
		global.master_ball = instance_create_layer(0, 0, "Ball", obj_ball);
		instance_create_layer(0, 0, "Ball", obj_metaball);
	}
}

