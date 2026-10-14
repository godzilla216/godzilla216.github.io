function s_practice_running() {
	show_debug_message("s_practice_running");
	playstart_time = current_time;
	kicking = 0;
	x_scrim = 1300 - scrimmage * 20 * drivedir;
	x_scrim += 500 * drivedir;
	x_yards = x_scrim + yards * 20 * drivedir;
	y_scrim = 300;
	s_destroy_match_objects();
	var qb = instance_create_layer(0, 0, "Players", obj_playerOF);
	var ol1 = instance_create_layer(0, 0, "Players", obj_playerOF);
	instance_create_layer(0, 0, "Players", obj_playerOF);
	var sx = qb.x + 60 * drivedir;
	var sy = qb.y;
	for (var d = 1; d < 4; d++) {
		sx += 120 * drivedir;
		s_create_dummy(sx, sy, random_range(1.5, 1.5), 0, 40);
	}
	s_create_boundary(2, 300, 250, 2000);
	s_create_boundary(3, 300, 350, 2000);
	global.master_ball = instance_create_layer(0, 0, "Ball", obj_ball);
	instance_create_layer(0, 0, "Ball", obj_metaball);
	with (obj_player) {
		s_set_skills_and_skin();
	}
	with (obj_controller) {
		state = 1;
		comm_stage = 14;
		comm_txt = "";
		comm_proceed = false;
		tap_msg = s_str("training_Running1");
		if (os_type == 0 || os_type == 1) {
			tap_msg = s_str("training_Running1b");
		}
		if (global.gamepad) {
			comm_proceed = true;
		}
	}
}

