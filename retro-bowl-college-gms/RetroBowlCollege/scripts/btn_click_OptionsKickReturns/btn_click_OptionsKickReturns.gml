function btn_click_OptionsKickReturns() {
	with (obj_master) {
		if (ds_map_find_value(map_options, "fullversion") == 1) {
			ds_map_set(map_options, "op_kickoffs", !ds_map_find_value(map_options, "op_kickoffs"));
			s_update_options();
			if (!ds_map_find_value(map_options, "op_kickoffs")) {
				for (var i = 0; i < ds_list_size(roster); i++) {
					ds_map_set(ds_list_find_value(roster, i), "kr", 0);
				}
			}
		} else {
			ds_map_set(map_options, "op_kickoffs", 0);
			s_create_message("", s_str("msg_NeedUnlimited"), s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, s_open_store, global.c_background, 1);
		}
	}
}

function btn_click_OptionsKickReturns_Exh() {
	with (obj_master) {
		ds_map_set(map_options, "exh_op_kickoffs", !ds_map_find_value(map_options, "exh_op_kickoffs"));
		s_update_options_exh();
	}
}

