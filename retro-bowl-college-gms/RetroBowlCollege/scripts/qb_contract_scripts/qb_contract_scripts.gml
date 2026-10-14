function s_qb_mode_set_up_contract_screen() {
	slog("s_qb_mode_set_up_contract_screen");
	with (obj_master) {
		var pmap = s_get_qb_pmap();
		inst_100725.text = s_get_string_year(true);
		inst_100716.text = ds_map_find_value(myteam, "name");
		inst_100718.text = string(qb_salary) + " cc / " + s_str("ui_Game");
		inst_100720.text = string(qb_tdbonus) + " cc";
		var expiry = year - 1 + ds_map_find_value(pmap, "contract");
		inst_100722.text = string_replace(s_str("ui_contract_expires"), "$year", expiry);
		inst_100741.visible = false;
		if (!qb_new_offer && newteam) {
			qb_new_offer = s_qb_mode_new_contract(newteam);
		}
		if (!qb_new_offer) {
			inst_100740.text = s_str("ui_Request");
			inst_100726.text = "-";
			inst_100728.text = "-";
			inst_100730.text = "-";
			inst_100732.text = "-";
			inst_100734.active = false;
			inst_100735.active = false;
			inst_100737.active = false;
			inst_100736.active = false;
			inst_100739.active = false;
			inst_100738.active = false;
		} else {
			inst_100714.visible = false;
			if (ds_map_find_value(pmap, "contract") > 0) {
				inst_100741.visible = true;
			}
			var tmap = s_get_team_by_id(qb_new_offer._teamid);
			inst_100726.text = ds_map_find_value(tmap, "name");
			var inc = ceil(qb_new_offer._salary / 10) * qb_new_offer._salary_neg;
			inst_100728.text = string(qb_new_offer._salary + inc) + " cc / " + s_str("ui_Game");
			inst_100730.text = string(qb_new_offer._tdbonus + qb_new_offer._tdbonus_neg) + " cc";
			inst_100732.text = string_replace(s_str("ui_contract_expires"), "$year", year - 1 + qb_new_offer._length + qb_new_offer._length_neg);
			inst_100728.tcolour = global.c_primary;
			inst_100730.tcolour = global.c_primary;
			inst_100732.tcolour = global.c_primary;
			if (qb_new_offer._salary + inc > qb_salary) {
				inst_100728.tcolour = 65535;
			}
			if (qb_new_offer._tdbonus + qb_new_offer._tdbonus_neg > qb_tdbonus) {
				inst_100730.tcolour = 65535;
			}
			if (qb_new_offer._length > ds_map_find_value(pmap, "contract")) {
				inst_100732.tcolour = 65535;
			}
			if (qb_new_offer._locked) {
				inst_100734.active = false;
				inst_100735.active = false;
				inst_100737.active = false;
				inst_100736.active = false;
				inst_100739.active = false;
				inst_100738.active = false;
				inst_100740.text = s_str("ui_Accept");
			} else {
				inst_100734.active = true;
				inst_100735.active = true;
				if (qb_new_offer._salary_neg < 1) {
					inst_100734.active = false;
				}
				if (qb_new_offer._salary_neg > 4) {
					inst_100735.active = false;
				}
				inst_100737.active = true;
				inst_100736.active = true;
				if (qb_new_offer._tdbonus_neg < 1) {
					inst_100737.active = false;
				}
				if (qb_new_offer._tdbonus_neg > 2) {
					inst_100736.active = false;
				}
				inst_100739.active = true;
				inst_100738.active = true;
				if (qb_new_offer._length_neg < 1) {
					inst_100739.active = false;
				}
				if (qb_new_offer._length + qb_new_offer._length_neg > 2) {
					inst_100738.active = false;
				}
				if (qb_new_offer._salary_neg + qb_new_offer._tdbonus_neg + qb_new_offer._length_neg == 0) {
					inst_100740.text = s_str("ui_Accept");
				} else {
					inst_100740.text = s_str("ui_Negotiate");
				}
			}
		}
	}
}

function s_qb_mode_new_contract(_arg0) {
	var pmap = s_get_qb_pmap();
	var prating = s_get_player_rating(pmap);
	var offer = {
		_teamid: ds_map_find_value(_arg0, "uid"),
		_salary: prating * 10,
		_tdbonus: s_get_player_rating(pmap),
		_length: max(ds_map_find_value(pmap, "contract") + 1, irandom_range(2, 3)),
		_salary_neg: 0,
		_tdbonus_neg: 0,
		_length_neg: 0,
		_locked: 0
	};
	if (ds_map_find_value(pmap, "contract") < 1) {
		offer._length = 1;
	}
	var trating = (s_get_team_offense_with_reputation_boost(_arg0) + s_get_team_defense_with_reputation_boost(_arg0)) / 2;
	slog("Team rating = " + string(trating));
	slog("Player rating = " + string(prating));
	if (trating > prating) {
		while (trating > prating) {
			trating -= 1;
			switch (irandom(2)) {
				case 0:
					offer._salary -= 1;
					break;
				case 1:
					offer._tdbonus -= 1;
					break;
				case 2:
					break;
			}
			slog("-");
		}
	} else {
		while (trating < prating) {
			prating -= 1;
			switch (irandom(2)) {
				case 0:
					offer._salary += 1;
					break;
				case 1:
					offer._tdbonus += 1;
					break;
				case 2:
					break;
			}
			slog("+");
		}
	}
	offer._salary = max(1, offer._salary);
	offer._tdbonus = max(0, offer._tdbonus);
	return offer;
}

function btn_contract_negotiate() {
	var sz = 0;
	with (obj_master) {
		if (!qb_new_offer) {
			if (ds_map_find_value(s_get_qb_pmap(), "contract") > 2) {
				s_do_message(s_str("msg_NegotiateNo_TooLong"));
				return;
			} else if (week < 9) {
				s_do_message(s_str("msg_NegotiateNo_TooEarly"));
				return;
			}
			qb_new_offer = s_qb_mode_new_contract(myteam);
			s_qb_mode_set_up_contract_screen();
			return;
		} else {
			sz = qb_new_offer._salary_neg + qb_new_offer._tdbonus_neg + qb_new_offer._length_neg;
		}
	}
	if (sz > 0) {
		room_goto(rm_qb_negotiate);
	} else {
		s_accept_contract();
	}
}

function btn_contract_salary_minus() {
	with (obj_master) {
		qb_new_offer._salary_neg -= 1;
	}
	s_qb_mode_set_up_contract_screen();
}

function btn_contract_salary_plus() {
	with (obj_master) {
		qb_new_offer._salary_neg += 1;
	}
	s_qb_mode_set_up_contract_screen();
}

function btn_contract_tdbonus_minus() {
	with (obj_master) {
		qb_new_offer._tdbonus_neg -= 1;
	}
	s_qb_mode_set_up_contract_screen();
}

function btn_contract_tdbonus_plus() {
	with (obj_master) {
		qb_new_offer._tdbonus_neg += 1;
	}
	s_qb_mode_set_up_contract_screen();
}

function btn_contract_length_minus() {
	with (obj_master) {
		qb_new_offer._length_neg -= 1;
	}
	s_qb_mode_set_up_contract_screen();
}

function btn_contract_length_plus() {
	with (obj_master) {
		qb_new_offer._length_neg += 1;
	}
	s_qb_mode_set_up_contract_screen();
}

function btn_negotiate_higher() {
	s_check_negotiate(true);
}

function btn_negotiate_lower() {
	s_check_negotiate(false);
}

function s_check_negotiate(_arg0) {
	var current_num = -1;
	var next_num = -1;
	with (obj_negotiate_num) {
		if (position == -1) {
			current_num = number;
		}
		if (position == 0) {
			next_num = number;
		}
	}
	var correct = false;
	switch (_arg0) {
		case true:
			if (next_num > current_num) {
				correct = true;
			}
			break;
		case false:
			if (next_num < current_num) {
				correct = true;
			}
			break;
	}
	if (correct) {
		var complete = true;
		with (obj_negotiate_num) {
			if (position == 0) {
				shirt[0] = colour_get_blue(65280) / 256;
				shirt[1] = colour_get_green(65280) / 256;
				shirt[2] = colour_get_red(65280) / 256;
			}
			position -= 1;
			if (position >= 0) {
				complete = false;
			}
		}
		if (complete) {
			inst_100743.visible = true;
			inst_100744.active = false;
			inst_100745.active = false;
			inst_100747.text = s_str("ui_Success") + "!";
			inst_100747.visible = true;
			s_sound(snd_starrating);
			with (obj_negotiate_num) {
				position += 1;
				revealed = true;
			}
			with (obj_master) {
				qb_new_offer._salary += qb_new_offer._salary_neg;
				qb_new_offer._tdbonus += qb_new_offer._tdbonus_neg;
				qb_new_offer._length += qb_new_offer._length_neg;
				qb_new_offer._salary_neg = 0;
				qb_new_offer._tdbonus_neg = 0;
				qb_new_offer._length_neg = 0;
				qb_new_offer._locked = true;
			}
		} else {
			s_sound(snd_success);
			s_check_hilo_buttons();
		}
	} else {
		inst_100743.visible = true;
		inst_100744.active = false;
		inst_100745.active = false;
		inst_100747.text = s_str("ui_Failed") + "!";
		inst_100747.tcolour = 255;
		inst_100747.visible = true;
		s_sound(snd_error);
		with (obj_negotiate_num) {
			revealed = true;
			if (position == 0) {
				shirt[0] = colour_get_blue(255) / 256;
				shirt[1] = colour_get_green(255) / 256;
				shirt[2] = colour_get_red(255) / 256;
			}
		}
		with (obj_master) {
			qb_new_offer._salary_neg = 0;
			qb_new_offer._tdbonus_neg = 0;
			qb_new_offer._length_neg = 0;
			qb_new_offer._locked = true;
		}
	}
}

function s_check_hilo_buttons() {
	inst_100744.active = true;
	inst_100745.active = true;
	with (obj_negotiate_num) {
		if (position == -1) {
			if (number == 1) {
				inst_100745.active = false;
			} else if (number == 11) {
				inst_100744.active = false;
			}
		}
	}
}

function s_accept_contract() {
	slog("s_accept_contract");
	var pmap = s_get_qb_pmap();
	with (obj_master) {
		qb_salary = qb_new_offer._salary;
		qb_tdbonus = qb_new_offer._tdbonus;
		ds_map_set(pmap, "contract", qb_new_offer._length);
		if (qb_new_offer._teamid != ds_map_find_value(myteam, "uid")) {
			ds_map_set(pmap, "teamid", qb_new_offer._teamid);
			myteam = s_get_team_by_id(qb_new_offer._teamid);
			myteam_id = qb_new_offer._teamid;
			myconference = ds_map_find_value(myteam, "conference");
			mydivision = ds_map_find_value(myteam, "division");
			newteam = -1;
			if (favourite_team_id == qb_new_offer._teamid) {
				s_add_news(s_parse_player_message(s_str("news_ContractNewTeamFavorite"), pmap));
			} else {
				s_add_news(s_parse_player_message(s_str("news_ContractNewTeam"), pmap));
			}
		} else {
			s_add_news(s_parse_player_message(s_str("news_ContractExtended"), pmap));
		}
		qb_new_offer = -1;
	}
	room_goto(rm_home);
}

function s_reject_contract() {
	slog("s_reject_contract");
	with (obj_master) {
		if (qb_new_offer._teamid == ds_map_find_value(myteam, "uid")) {
			s_meter_change(9, relationship_boss, rm_qb_life, "");
			relationship_boss = clamp(relationship_boss - 10, 1, 100);
		} else {
			ds_list_add(list_teams_rejected, qb_new_offer._teamid);
			room_goto(rm_choose_team);
		}
		qb_new_offer = -1;
		s_savegame();
	}
}

