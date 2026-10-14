function btn_click_OptionsDriveLeft() {
	with (obj_master) {
		switch (ds_map_find_value(map_options, "op_drivedir")) {
			case 0:
				ds_map_set(map_options, "op_drivedir", -1);
				break;
			case -1:
				ds_map_set(map_options, "op_drivedir", 1);
				break;
			case 1:
				ds_map_set(map_options, "op_drivedir", 0);
				break;
		}
		s_update_options();
	}
}

function btn_click_OptionsDriveLeft_Exh() {
	with (obj_master) {
		switch (ds_map_find_value(map_options, "exh_op_drivedir")) {
			case 0:
				ds_map_set(map_options, "exh_op_drivedir", -1);
				break;
			case -1:
				ds_map_set(map_options, "exh_op_drivedir", 1);
				break;
			case 1:
				ds_map_set(map_options, "exh_op_drivedir", 0);
				break;
		}
		s_update_options_exh();
	}
}

