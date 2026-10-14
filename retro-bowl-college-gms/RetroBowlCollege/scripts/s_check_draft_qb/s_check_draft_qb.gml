function s_check_draft_QB() {
	if (intro > 0 || year == 1) {
	} else if (ds_map_find_value(s_get_qb_pmap(), "contract") < 1) {
		s_create_message("", s_str("news_QB_contract_expired"), s_str("ui_Continue"), "", s_goto_room_contract, -1, global.c_background, 1);
		stage = 1;
		return;
	} else if (week == 1 && draft_round == 1) {
		s_do_qb_draft_round();
		s_end_draft_round(false);
		s_do_qb_draft_round();
		s_end_draft_round(false);
		s_do_qb_draft_round();
		s_end_draft_round(false);
		return;
	}
	if (!obj_master.prematch_dilemma_done && !s_is_bye_week(obj_master.week) && obj_master.week < obj_master.last_week_regular && (obj_master.year > 1 || obj_master.qb_mode)) {
		if (s_do_prematch_dilemma_qb()) {
			return;
		}
	}
	obj_master.prematch_dilemma_done = true;
	s_savegame();
	s_play(1);
}

function s_do_qb_draft_round() {
	if (ds_list_size(obj_master.draftlist) < 50) {
		s_create_draftlist();
	}
	var new_pmap = -4;
	var remove_pmap = -4;
	var max_roster = s_get_roster_cap();
	if (ds_list_size(obj_master.roster) < max_roster) {
		if (s_count_players_by_position(4) < 1) {
			new_pmap = s_find_draft_player_by_position(4, 0);
		} else if (s_count_players_by_position(2) < 1) {
			new_pmap = s_find_draft_player_by_position(2, 0);
		} else if (s_count_players_by_position(4) < 2) {
			new_pmap = s_find_draft_player_by_position(4, 7);
		}
		if (new_pmap == -4) {
			var current_rb = s_get_player_by_position_for_qb_draft(2, 1);
			if (current_rb) {
				var rating = s_get_player_rating(current_rb);
				new_pmap = s_find_draft_player_by_position(2, rating + 1);
				if (new_pmap) {
					remove_pmap = current_rb;
				}
			}
		}
		if (new_pmap == -4 && s_count_players_by_position(4) < 2) {
			new_pmap = s_find_draft_player_by_position(4, 5);
		}
		if (new_pmap == -4 && s_count_players_by_position(3) < 1) {
			new_pmap = s_find_draft_player_by_position(3, 5);
		}
		if (new_pmap == -4 && s_count_players_by_position(4) < 2) {
			new_pmap = s_find_draft_player_by_position(4, 0);
		}
		if (new_pmap == -4 && s_count_players_by_position(3) < 1) {
			new_pmap = s_find_draft_player_by_position(3, 0);
		}
		if (new_pmap == -4) {
			var weakest_p = s_get_weakest_player_by_position(4);
			if (weakest_p) {
				new_pmap = s_find_draft_player_by_position(4, s_get_player_rating(weakest_p) + 1);
				if (new_pmap) {
					remove_pmap = weakest_p;
				}
			}
		}
		if (new_pmap == -4 && max_roster > 10 && s_count_players_by_position(3) < 2) {
			new_pmap = s_find_draft_player_by_position(3, 5);
		}
		if (new_pmap == -4) {
			var weakest_p = s_get_weakest_player_by_position(3);
			if (weakest_p) {
				new_pmap = s_find_draft_player_by_position(3, s_get_player_rating(weakest_p) + 1);
				if (new_pmap) {
					remove_pmap = weakest_p;
				}
			}
		}
		if (new_pmap == -4) {
			with (obj_master) {
				for (var i = 0; i < ds_list_size(draftlist); i++) {
					var pmap = ds_list_find_value(draftlist, i);
					var pos = ds_map_find_value(pmap, "position");
					if (s_count_players_by_position(pos) < 1) {
						new_pmap = pmap;
						break;
					}
				}
			}
		}
		if (new_pmap == -4) {
			with (obj_master) {
				for (var i = 0; i < ds_list_size(draftlist); i++) {
					var pmap = ds_list_find_value(draftlist, i);
					var pos = ds_map_find_value(pmap, "position");
					switch (pos) {
						case 6:
						case 7:
						case 5:
							if (s_count_players_by_position(pos) < 2) {
								new_pmap = pmap;
							}
							break;
						default:
							if (s_count_players_by_position(pos) < 1) {
								new_pmap = pmap;
							}
							break;
					}
					if (new_pmap) {
						break;
					}
				}
			}
		}
	} else {
		var plist = ds_list_create();
		ds_list_add(plist, 2);
		ds_list_add(plist, 4);
		ds_list_add(plist, 3);
		ds_list_add(plist, 5);
		ds_list_add(plist, 6);
		ds_list_add(plist, 7);
		ds_list_add(plist, choose(8, 9));
		ds_list_add(plist, 10);
		while (ds_list_size(plist) > 0) {
			ds_list_shuffle(plist);
			var pos = ds_list_find_value(plist, 0);
			var weakest_p = s_get_weakest_player_by_position(pos);
			if (weakest_p) {
				new_pmap = s_find_draft_player_by_position(pos, s_get_player_rating(weakest_p) + 1);
				if (new_pmap) {
					remove_pmap = weakest_p;
				}
			}
			ds_list_delete(plist, 0);
			if (new_pmap) {
				break;
			}
		}
		ds_list_clear(plist);
	}
	with (obj_master) {
		if (new_pmap) {
			ds_map_set(new_pmap, "signed_year", year);
			ds_map_set(new_pmap, "teamid", myteam_id);
			ds_map_set(new_pmap, "flash_time", current_time);
			ds_list_add(roster, new_pmap);
			s_do_contract_news(s_str("news_QB_draft_playerjoins"), new_pmap);
			ds_list_delete(draftlist, ds_list_find_index(draftlist, new_pmap));
		}
		if (remove_pmap) {
			s_do_contract_news(s_str("news_QB_draft_playerleaves"), remove_pmap);
			ds_list_delete(roster, ds_list_find_index(roster, remove_pmap));
		}
	}
}

function s_get_weakest_player_by_position(_arg0) {
	var current_p1 = s_get_player_by_position_for_qb_draft(_arg0, 1);
	var current_p2 = s_get_player_by_position_for_qb_draft(_arg0, 2);
	var current_p3 = s_get_player_by_position_for_qb_draft(_arg0, 3);
	var current_p4 = s_get_player_by_position_for_qb_draft(_arg0, 4);
	var weakest_p = current_p1;
	if (weakest_p && current_p2 && s_get_player_rating(weakest_p) > s_get_player_rating(current_p2)) {
		weakest_p = current_p2;
	}
	if (weakest_p && current_p3 && s_get_player_rating(weakest_p) > s_get_player_rating(current_p3)) {
		weakest_p = current_p3;
	}
	if (weakest_p && current_p4 && s_get_player_rating(weakest_p) > s_get_player_rating(current_p4)) {
		weakest_p = current_p4;
	}
	return weakest_p;
}

function s_find_draft_player_by_position(_arg0, _arg1) {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(draftlist); i++) {
			var pmap = ds_list_find_value(draftlist, i);
			if (ds_map_find_value(pmap, "position") == _arg0 && s_get_player_rating(pmap) >= _arg1) {
				return pmap;
			}
		}
	}
	return -4;
}

function s_get_player_by_position_for_qb_draft(_arg0, _arg1) {
	with (obj_master) {
		var count = 0;
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "age") == s_rookie_age_internal()) {
				continue;
			}
			if (ds_map_find_value(pmap, "age") == s_rookie_age_internal() + 1 && s_get_player_potential(pmap) > 7 && ds_map_find_value(pmap, "attitude") > 30) {
				continue;
			}
			if (ds_map_find_value(pmap, "position") == _arg0) {
				count++;
				if (count == _arg1) {
					return pmap;
				}
			}
		}
	}
	return -4;
}

function s_do_contract_news(_arg0, _arg1) {
	_arg0 = string_replace(_arg0, "$myteam", ds_map_find_value(myteam, "name"));
	_arg0 = string_replace(_arg0, "$position", s_get_string_position(ds_map_find_value(_arg1, "position")));
	_arg0 = string_replace(_arg0, "$playername", ds_map_find_value(_arg1, "fname") + " " + ds_map_find_value(_arg1, "lname"));
	_arg0 = string_replace(_arg0, "$randomteamname", s_get_random_teamname(false));
	_arg0 = string_replace(_arg0, "$draftround", draft_round);
	s_add_news(_arg0);
}

function s_goto_room_contract() {
	s_msg_clear();
	room_goto(rm_qb_contract);
}

function btn_qb_mode_interested_teams() {
	room_goto(rm_choose_team);
}

