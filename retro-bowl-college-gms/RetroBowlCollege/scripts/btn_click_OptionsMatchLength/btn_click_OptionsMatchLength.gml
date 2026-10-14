function btn_click_OptionsMatchLength() {
	with (obj_master) {
		op_matchlength += 1;
		if (op_matchlength > 1) {
			op_matchlength = -1;
		}
		s_update_options();
	}
}

function btn_click_OptionsMatchLength_Exh() {
	with (obj_master) {
		ds_map_set(map_options, "exh_op_matchlength", real(ds_map_find_value(map_options, "exh_op_matchlength")) + 1);
		if (ds_map_find_value(map_options, "exh_op_matchlength") > 1) {
			ds_map_set(map_options, "exh_op_matchlength", -1);
		}
		s_update_options_exh();
	}
}

