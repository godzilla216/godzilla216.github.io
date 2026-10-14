function s_check_ingame_control_change() {
	if (global.console_build && gamepad_button_check_pressed(global.gp.slot, 32779) && global.master_ball && global.master_ball.state == 0) {
		with (obj_master) {
			ds_map_set(map_options, "op_invert_throw", ds_map_find_value(map_options, "op_invert_throw") + 1);
			if (ds_map_find_value(map_options, "op_invert_throw") > 3) {
				ds_map_set(map_options, "op_invert_throw", 0);
			}
			switch (ds_map_find_value(map_options, "op_invert_throw")) {
				case 0:
					with (obj_ball) {
						s_fieldtxt(s_str("ui_Normal"));
					}
					break;
				case 1:
					with (obj_ball) {
						s_fieldtxt(s_str("ui_Inverted"));
					}
					break;
				case 2:
					with (obj_ball) {
						s_fieldtxt(s_str("ui_AnalogueL"));
					}
					break;
				case 3:
					with (obj_ball) {
						s_fieldtxt(s_str("ui_AnalogueR"));
					}
					break;
			}
		}
	}
}

