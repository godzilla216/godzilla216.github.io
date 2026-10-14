function s_switch_drivedirection() {
	with (obj_controller) {
		drivedir = -drivedir;
		var dd = ds_map_find_value(obj_master.map_options, "op_drivedir");
		if (global.exhibition) {
			dd = ds_map_find_value(obj_master.map_options, "exh_op_drivedir");
		}
		if (dd != 0) {
			drivedir = dd;
		}
	}
	with (obj_player) {
		facing = -facing;
		goalline_attack = 2300;
		if (facing == -1) {
			goalline_attack = 300;
		}
	}
}

