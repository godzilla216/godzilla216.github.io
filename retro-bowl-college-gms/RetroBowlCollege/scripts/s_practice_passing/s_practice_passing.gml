function s_practice_passing() {
	show_debug_message("s_practice_passing");
	playstart_time = current_time;
	kicking = 0;
	x_scrim = 1300 + scrimmage * 20 * drivedir;
	x_yards = x_scrim + yards * 20 * drivedir;
	y_scrim = 300;
	s_destroy_match_objects();
	var qb = instance_create_layer(0, 0, "Players", obj_playerOF);
	var rb = instance_create_layer(0, 0, "Players", obj_playerOF);
	var ol1 = instance_create_layer(0, 0, "Players", obj_playerOF);
	var ol2 = instance_create_layer(0, 0, "Players", obj_playerOF);
	var ol3 = instance_create_layer(0, 0, "Players", obj_playerOF);
	var ol4 = instance_create_layer(0, 0, "Players", obj_playerOF);
	var ol5 = instance_create_layer(0, 0, "Players", obj_playerOF);
	var te = instance_create_layer(0, 0, "Players", obj_playerOF);
	var wr = instance_create_layer(0, 0, "Players", obj_playerOF);
	instance_destroy(rb);
	instance_destroy(ol2);
	instance_destroy(ol3);
	instance_destroy(ol4);
	instance_destroy(ol5);
	instance_destroy(te);
	with (obj_player) {
		s_set_skills_and_skin();
	}
	global.master_ball = instance_create_layer(0, 0, "Ball", obj_ball);
	instance_create_layer(0, 0, "Ball", obj_metaball);
	with (obj_controller) {
		state = 1;
		comm_stage = 14;
		comm_txt = "";
		comm_proceed = false;
		tap_msg = s_str("training_Throw1");
		if (global.gamepad) {
			comm_proceed = true;
		}
	}
}

