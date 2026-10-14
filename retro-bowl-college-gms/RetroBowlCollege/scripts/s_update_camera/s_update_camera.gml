function s_update_camera() {
	var des_zoom = 0.6;
	with (global.master_ball) {
		if (holder && s_aiming()) {
			var dist = s_get_distance_to_furthest_teammate(holder);
			des_zoom = clamp(dist * 0.003, 0.7, 1);
		}
	}
	switch (state) {
		case 1:
			if (comm_stage != 14) {
				bzoom = lerp(bzoom, 1, 0.05);
				break;
			}
		default:
			bzoom = lerp(bzoom, des_zoom, 0.025);
			if (kicking) {
				bzoom = 1;
			}
			break;
	}
	switch (ds_map_find_value(obj_master.map_options, "op_zoom")) {
		case false:
		case "false":
			bzoom = 1;
			break;
	}
	camera_set_view_size(g_pBuiltIn.view_camera[0], 960 * bzoom, 540 * bzoom);
	var cam_w = camera_get_view_width(g_pBuiltIn.view_camera[0]);
	var cam_h = camera_get_view_height(g_pBuiltIn.view_camera[0]);
	var cam_trackx = cam_w * 0.5;
	var cam_tracky = cam_h * 0.5;
	var cx = 1300;
	var cy = 300;
	var lrp = 0.05;
	var ball = global.master_ball;
	if (instance_exists(ball)) {
		cx = ball.x;
		cy = 300 + (ball.y - 300) * 0.5;
		if (s_aiming()) {
			cy = 300;
		}
		if (instance_exists(ball.holder)) {
			cx = ball.holder.x;
		}
		cam_trackx = cam_w * (0.5 - 0.15 * drivedir);
		if (kicking) {
			cam_trackx = cam_w * (0.5 - 0.25 * drivedir);
		}
	} else {
		cy = 0;
		lrp = 0.025;
		switch (drivedir) {
			case -1:
				if (possession == human_team) {
					cx -= scrimmage * 20;
				} else {
					cx += scrimmage * 20;
				}
				break;
			case 1:
				if (possession == human_team) {
					cx += scrimmage * 20;
				} else {
					cx -= scrimmage * 20;
				}
				break;
		}
		switch (comm_stage) {
			case 12:
			case 13:
				if (quarter != 3 && quarter != 5) {
					break;
				}
			case 0:
			case 1:
			case 17:
				lrp = 0.25;
				cx = 1300;
				break;
			default:
				break;
		}
	}
	cy -= 10;
	var newpos_x = lerp(camera_get_view_x(g_pBuiltIn.view_camera[0]), cx - cam_trackx, lrp * 0.5);
	var newpos_y = lerp(camera_get_view_y(g_pBuiltIn.view_camera[0]), cy - cam_tracky, lrp * 0.5);
	newpos_x = clamp(newpos_x, 0, g_pBuiltIn.room_width - cam_w);
	newpos_y = clamp(newpos_y, 0, g_pBuiltIn.room_height - cam_h);
	camera_set_view_pos(g_pBuiltIn.view_camera[0], newpos_x, newpos_y);
}

