function s_check_expired_contract_message() {
	with (obj_master) {
		if (!expiredcontract_msg_done) {
			if (s_is_co_mode()) {
				expiredcontract_msg_done = true;
				return;
			}
			for (var i = 0; i < ds_list_size(freeagentlist); i++) {
				var pmap = ds_list_find_value(freeagentlist, i);
				if (ds_map_find_value(pmap, "signed_year") != 0) {
					var msg = s_str("msg_OutOfContractPlayers");
					if (ds_list_size(freeagentlist) == 1) {
						msg = s_str("msg_OutOfContractPlayer");
						msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(pmap, "position")));
						msg = string_replace(msg, "$playername", ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname"));
					}
					s_create_message("", msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
					expiredcontract_msg_done = true;
					return;
				}
			}
		}
	}
}

