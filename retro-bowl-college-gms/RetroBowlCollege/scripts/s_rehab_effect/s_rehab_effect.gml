function s_rehab_effect(_arg0, _arg1) {
	var amt = _arg0;
	var update_injuries = _arg1;
	with (obj_master) {
		var oc = s_get_staff(102);
		var dc = s_get_staff(101);
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			var con = ds_map_find_value(pmap, "condition");
			if (con < 0) {
				if (update_injuries && ds_map_find_value(pmap, "injury_week") != week) {
					con += 1;
					if (con == 0) {
						ds_map_set(pmap, "injury_week", 0);
						con = irandom_range(85, 100);
						var msg = s_str("news_PlayerRecovered");
						msg = s_parse_player_message(msg, pmap);
						s_add_news(msg);
					}
					ds_map_set(pmap, "condition", round(con));
				}
			} else {
				if (s_player_benched(pmap)) {
					con += amt * 2;
				} else {
					con += amt;
					var trainingreg = obj_master.training_reg_df;
					if (s_is_offensive_player(pmap)) {
						trainingreg = obj_master.training_reg_of;
					}
					if (amt > 10) {
						if (trainingreg == 1) {
							con += 10;
						} else if (trainingreg == 3) {
							con -= 10;
						}
					}
				}
				if (ds_map_find_value(oc, "trait") == 6 && s_is_offensive_player(pmap)) {
					con += 5;
				} else if (ds_map_find_value(dc, "trait") == 6 && !s_is_offensive_player(pmap)) {
					con += 5;
				}
				ds_map_set(pmap, "condition", round(clamp(con, 1, 100)));
			}
		}
	}
}

