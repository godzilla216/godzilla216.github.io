function s_check_contracts_expiring() {
	with (obj_master) {
		var pmap = s_get_staff(101);
		for (var i = 0; i < ds_list_size(roster); i++) {
			pmap = ds_list_find_value(roster, i);
			if (pmap && ds_map_find_value(pmap, "age") >= s_get_max_age(pmap)) {
				var msg = s_str("news_PlayerRetiringNoTag");
				if (ds_map_exists(pmap, "hof") && ds_map_find_value(pmap, "hof")) {
					msg = s_str("news_PlayerRetiringTag");
				}
				msg = string_replace(msg, "$teamname", s_get_team_name_by_id(myteam_id));
				msg = s_parse_player_message(msg, pmap);
				s_add_news(msg);
			}
		}
		pmap = s_get_staff(102);
		if (pmap && ds_map_find_value(pmap, "age") >= s_get_max_age(pmap)) {
			s_add_news(s_parse_player_message(s_str("msg_StaffRetiring"), pmap));
		} else if (pmap && ds_map_find_value(pmap, "contract") < 2) {
			s_add_news(s_parse_player_message(s_str("msg_StaffExpiringTip"), pmap));
		}
		pmap = s_get_staff(101);
		if (pmap && ds_map_find_value(pmap, "age") >= s_get_max_age(pmap)) {
			s_add_news(s_parse_player_message(s_str("msg_StaffRetiring"), pmap));
		} else if (pmap && ds_map_find_value(pmap, "contract") < 2) {
			s_add_news(s_parse_player_message(s_str("msg_StaffExpiringTip"), pmap));
		}
	}
}

