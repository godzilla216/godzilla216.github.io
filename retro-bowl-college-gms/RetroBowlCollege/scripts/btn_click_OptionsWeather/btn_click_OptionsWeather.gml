function btn_click_OptionsWeather() {
	with (obj_master) {
		if (ds_map_find_value(map_options, "fullversion") == 1) {
			ds_map_set(map_options, "op_weather", !ds_map_find_value(map_options, "op_weather"));
			s_update_options();
		} else {
			s_create_message("", s_str("msg_NeedUnlimited"), s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, s_open_store, global.c_background, 1);
		}
	}
}

function btn_click_OptionsWeather_Exh() {
	with (obj_master) {
		ds_map_set(map_options, "exh_op_weather", real(ds_map_find_value(map_options, "exh_op_weather")) + 1);
		if (ds_map_find_value(map_options, "exh_op_weather") > 3) {
			ds_map_set(map_options, "exh_op_weather", 0);
		}
		s_update_options_exh();
	}
}

