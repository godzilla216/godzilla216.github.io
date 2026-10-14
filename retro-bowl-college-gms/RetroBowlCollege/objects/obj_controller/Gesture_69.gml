if (os_type == 21 && !global.gamepad) {
	with (global.master_ball) {
		if (state == 2) {
			exit;
		}
	}
	global.flickVelX += ds_map_find_value(event_data, "diffX");
	global.flickVelY += ds_map_find_value(event_data, "diffY");
}
