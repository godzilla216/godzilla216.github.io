function s_do_prematch_dilemma_qb() {
	with (obj_master) {
		obj_master.prematch_dilemma_done = true;
		if (!s_get_human_fixture_next()) {
			return false;
		}
		if (year == 1 && week == 1) {
			s_add_news_dyn("web", s_str("news_qb_pregame1"), s_get_qb_pmap(), true);
			return true;
		}
		var msg = "";
		var pmap = s_get_random_player(true);
		var smap = s_get_staff(101);
		var dilemmas = ds_list_create();
		if (irandom(2) && year > 1) {
			ds_list_add(dilemmas, "dilemma_Owner");
			if (pmap) {
				if (s_is_offensive_player(pmap)) {
					smap = s_get_staff(102);
				}
				if (!s_player_benched(pmap) && ds_map_find_value(pmap, "condition") > 0 && ds_map_find_value(pmap, "condition") < 20 && week < obj_master.last_week_regular) {
					ds_list_add(dilemmas, "dilemma_RestPlayer");
				}
				if (ds_map_find_value(pmap, "attitude") <= 30) {
					ds_list_add(dilemmas, "dilemma_toxic");
				}
				if (smap && (ds_map_find_value(pmap, "attitude") <= 30 || ds_map_find_value(smap, "attitude") <= 30)) {
					ds_list_add(dilemmas, "dilemma_Coach_BustUp");
				}
				if (ds_map_find_value(pmap, "attitude") <= 60) {
					ds_list_add(dilemmas, "dilemma_late");
				}
				if (ds_map_find_value(pmap, "age") == s_rookie_age_internal()) {
					ds_list_add(dilemmas, "dilemma_rookie");
				}
				if (ds_map_find_value(pmap, "attitude") > 90 && obj_master.fans < 98) {
					ds_list_add(dilemmas, "news_CharityWork");
				} else {
					ds_list_add(dilemmas, "dilemma_random");
				}
			}
			for (var i = 0; i < ds_list_size(dilemmas); i++) {
				slog("List: " + ds_list_find_value(dilemmas, i));
			}
			ds_list_shuffle(dilemmas);
			msg = s_choose_dilemma(ds_list_find_value(dilemmas, 0));
			slog("s_do_prematch_dilemma: " + msg);
		}
		if (string_count("dilemma_", msg)) {
			ds_map_destroy(map_dilemma);
			map_dilemma = -1;
			map_dilemma = s_parse_dilemma(msg, pmap, "ui_Dilemma");
			obj_master.player_profile = pmap;
			s_create_dilemma(map_dilemma);
			ds_list_destroy(dilemmas);
			dilemmas = -1;
			return true;
		} else if (string_count("news_", msg)) {
			if (string_count("news_CharityWork", msg)) {
				msg = s_parse_player_message(s_str(msg), pmap);
				s_meter_change(1, obj_master.fans, current_room, msg);
				obj_master.fans += 2;
			} else {
				msg = s_parse_player_message(s_str(msg), pmap);
				s_create_message(s_str("ui_News"), msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			}
			ds_list_destroy(dilemmas);
			dilemmas = -1;
			return true;
		}
		ds_list_destroy(dilemmas);
		dilemmas = -1;
		return false;
	}
}

