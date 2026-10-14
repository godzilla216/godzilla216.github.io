function s_dilemma_choice(_arg0) {
	var btn = string(_arg0);
	with (obj_master) {
		slog("s_dilemma_choice [" + string(btn) + "]::[" + string(ds_map_find_value(map_dilemma, "cost_img" + btn)) + "]");
		if (string_count("party", ds_map_find_value(map_dilemma, "msg_key"))) {
			s_clear_party_meter(player_profile);
		}
		switch (ds_map_find_value(map_dilemma, "cost_img" + btn)) {
			case "spr_xp":
				switch (ds_map_find_value(map_dilemma, "effect_on" + btn)) {
					case "team":
						var amt = real(ds_map_find_value(map_dilemma, "cost_amt" + btn)) / clamp(ds_list_size(roster), 1, 10);
						amt = round(amt);
						slog("XP gain per player = " + string(amt));
						for (var i = 0; i < ds_list_size(roster); i++) {
							var pmap = ds_list_find_value(roster, i);
							ds_map_set(pmap, "xp_gain", round(ds_map_find_value(pmap, "xp_gain") + amt));
						}
						break;
					case "coaches":
						var amt = real(ds_map_find_value(map_dilemma, "cost_amt" + btn)) / ds_list_size(stafflist);
						slog("XP gain per coach = " + string(amt));
						for (var i = 0; i < ds_list_size(stafflist); i++) {
							var pmap = ds_list_find_value(stafflist, i);
							ds_map_set(pmap, "xp_gain", round(ds_map_find_value(pmap, "xp_gain") + amt));
						}
						break;
					case "qb_self":
						var pmap = s_get_qb_pmap();
						ds_map_set(pmap, "xp_gain", round(ds_map_find_value(pmap, "xp_gain") + ds_map_find_value(pmap, "xp_level") * 50));
						break;
				}
				s_dilemma_end();
				break;
			case "spr_credit":
				if (coach_credit + real(ds_map_find_value(map_dilemma, "cost_amt" + btn)) < 0) {
					var useMoraleInsteadOfCC = true;
					if (s_is_co_mode() && string_pos("leaverescue", ds_map_find_value(map_dilemma, "msg_key"))) {
						useMoraleInsteadOfCC = false;
					}
					if (useMoraleInsteadOfCC) {
						coach_credit = 0;
						var old_morale = s_get_morale();
						s_adjust_team_morale(-5, -10);
						s_meter_change(4, old_morale, -4, "");
					} else {
						switch (os_type) {
							case 4:
							case 3:
								s_create_message(s_str("ui_News"), s_str("msg_NotEnoughCCStore"), s_str("ui_Yes"), s_str("ui_No"), s_dilemma_morecc_store, s_dilemma_morecc_back, global.c_background, 1);
								break;
							default:
								s_create_message(s_str("ui_News"), s_str("msg_NotEnoughCC"), "", s_str("ui_Continue"), "", s_dilemma_morecc_back, global.c_background, 1);
								break;
						}
					}
					return;
				}
				if (ds_map_find_value(map_dilemma, "cost_typ" + btn) == "choice_DefendPlayer") {
					coach_credit += real(ds_map_find_value(map_dilemma, "cost_amt" + btn));
					pmap = player_profile;
					var old_att = ds_map_find_value(pmap, "attitude");
					ds_map_set(pmap, "attitude", clamp(ds_map_find_value(pmap, "attitude") + 5, 1, 100));
					s_meter_change(5, old_att, -4, "");
					return;
				} else {
					s_meter_change(8, coach_credit, -4, "");
					coach_credit += real(ds_map_find_value(map_dilemma, "cost_amt" + btn));
					return;
				}
				s_dilemma_end();
				break;
			case "spr_attitude":
				var pmap = -4;
				switch (ds_map_find_value(map_dilemma, "effect_on" + btn)) {
					case "team":
						s_meter_change(4, s_get_morale(), -4, "");
						var amt = real(ds_map_find_value(map_dilemma, "cost_amt" + btn));
						s_adjust_team_morale(amt, amt);
						break;
					case "coaches":
						if (obj_master.player_profile) {
							if (ds_map_find_value(map_dilemma, "cost_typ" + btn) == "choice_SideWithCoach") {
								ds_map_set(obj_master.player_profile, "attitude", clamp(ds_map_find_value(obj_master.player_profile, "attitude") + real(-ds_map_find_value(map_dilemma, "cost_amt" + btn)), 1, 100));
							}
							switch (s_is_offensive_player(obj_master.player_profile)) {
								case true:
									pmap = s_get_staff(102);
									break;
								case false:
									pmap = s_get_staff(101);
									break;
							}
						}
						if (pmap == -4) {
							pmap = s_get_random_coach();
						}
						obj_master.player_profile = pmap;
						var old_amount = ds_map_find_value(pmap, "attitude");
						ds_map_set(pmap, "attitude", clamp(ds_map_find_value(pmap, "attitude") + real(ds_map_find_value(map_dilemma, "cost_amt" + btn)), 1, 100));
						s_meter_change(5, old_amount, -4, "");
						break;
					case "player":
						if (ds_map_find_value(map_dilemma, "cost_typ" + btn) == "choice_SideWithPlayer") {
							var smap = s_get_staff(101);
							if (s_is_offensive_player(player_profile)) {
								smap = s_get_staff(102);
							}
							ds_map_set(smap, "attitude", clamp(ds_map_find_value(smap, "attitude") + real(-ds_map_find_value(map_dilemma, "cost_amt" + btn)), 1, 100));
						} else if (ds_map_find_value(map_dilemma, "cost_typ" + btn) == "choice_RestYes") {
							ds_map_set(player_profile, "resting", 1);
						}
						pmap = player_profile;
						var old_amount = ds_map_find_value(pmap, "attitude");
						ds_map_set(pmap, "attitude", clamp(ds_map_find_value(pmap, "attitude") + real(ds_map_find_value(map_dilemma, "cost_amt" + btn)), 1, 100));
						s_meter_change(5, old_amount, -4, "");
						break;
				}
				break;
			case "spr_fans":
				s_meter_change(1, fans, -4, "");
				fans = clamp(fans + real(ds_map_find_value(map_dilemma, "cost_amt" + btn)), 1, 100);
				break;
			case "-1":
				if (ds_map_find_value(map_dilemma, "cost_typ" + btn) == "choice_CutPlayer") {
					if (string_count("gpa", ds_map_find_value(map_dilemma, "msg_key"))) {
						msg = s_parse_player_message(s_str("news_playerleaves_gpa_norescue"), player_profile);
						s_create_message(s_str("ui_News"), msg, s_str("ui_Continue"), "", s_cut_player_end_gpa, "", global.c_background, 1);
					} else if (string_count("toxic", ds_map_find_value(map_dilemma, "msg_key"))) {
						msg = s_parse_player_message(s_str("news_playerleaves_toxic_norescue"), player_profile);
						s_create_message(s_str("ui_News"), msg, s_str("ui_Continue"), "", s_cut_player_end_toxic, "", global.c_background, 1);
					} else if (string_count("party", ds_map_find_value(map_dilemma, "msg_key"))) {
						msg = s_parse_player_message(s_str("news_playerleaves_party_norescue"), player_profile);
						s_create_message(s_str("ui_News"), msg, s_str("ui_Continue"), "", s_cut_player_end_party, "", global.c_background, 1);
					} else {
						msg = s_parse_player_message(s_str("news_playerleaves_gpa_norescue"), player_profile);
						s_create_message(s_str("ui_News"), msg, s_str("ui_Continue"), "", s_cut_player_end, "", global.c_background, 1);
					}
					return;
				} else {
					var amt = real(ds_map_find_value(map_dilemma, "cost_amt" + btn));
					var result = s_str("ui_Correct");
					if (amt < 0) {
						result = s_str("ui_Wrong");
					}
					s_meter_change(1, fans, -4, result + "!");
					fans = clamp(fans + amt, 1, 100);
				}
				break;
			case "spr_nrg":
				obj_master.qb_nrg += real(ds_map_find_value(map_dilemma, "cost_amt" + btn));
				s_sound(snd_success);
				s_dilemma_end();
				break;
			case "spr_gpa":
				var grade_boost = real(ds_map_find_value(map_dilemma, "cost_amt" + btn));
				switch (ds_map_find_value(map_dilemma, "effect_on" + btn)) {
					case "team":
						obj_master.byeweek_gpaup = true;
						for (var i = 0; i < ds_list_size(roster); i++) {
							var pmap = ds_list_find_value(roster, i);
							ds_map_set(pmap, "saved_percent_grade", ds_map_find_value(pmap, "percent_grade"));
							s_add_percent_grade(pmap, grade_boost);
							slog(ds_map_find_value(pmap, "lname") + " percent grade increased from " + string(ds_map_find_value(pmap, "saved_percent_grade")) + " to " + string(ds_map_find_value(pmap, "percent_grade")) + " or in GPA: " + s_gpa_string_direct(ds_map_find_value(pmap, "percent_grade")));
						}
						s_dilemma_end();
						break;
					case "player":
						pmap = player_profile;
						if (grade_boost > 0) {
							s_add_percent_grade(pmap, grade_boost);
							var old_morale = s_get_morale();
							s_adjust_team_morale(-5, -10);
							s_meter_change(4, old_morale, -4, s_str("choice_GPAUpResultMsg"));
							return;
						} else {
							s_add_percent_grade(pmap, grade_boost);
							s_dilemma_end();
							return;
						}
						break;
				}
				break;
			case "spr_credit_rec":
				var old_rc = obj_master.recruitment_credits;
				s_meter_change(10, old_rc, -4, "");
				recruitment_credits_add(real(ds_map_find_value(map_dilemma, "cost_amt" + btn)));
				break;
		}
	}
}

function s_cut_player_end() {
	s_msg_clear();
	s_remove_player(obj_master.player_profile, "cut", s_pick_epilogue_story("epi_cut"));
	s_dilemma_end();
}

function s_cut_player_end_gpa() {
	s_msg_clear();
	s_remove_player(obj_master.player_profile, "cut", s_pick_epilogue_story("epi_dil_lowGPANoRescue"));
	s_dilemma_end();
}

function s_cut_player_end_toxic() {
	s_msg_clear();
	s_remove_player(obj_master.player_profile, "cut", s_pick_epilogue_story("epi_dil_toxicNoRescue"));
	s_dilemma_end();
}

function s_cut_player_end_party() {
	s_msg_clear();
	s_remove_player(obj_master.player_profile, "cut", s_pick_epilogue_story("epi_dil_partyNoRescue"));
	s_dilemma_end();
}

function s_cut_player_end_toxic_max() {
	s_msg_clear();
	s_remove_player(obj_master.player_profile, "cut", s_pick_epilogue_story("epi_dil_maxToxic"));
	s_dilemma_end();
}

function s_cut_player_end_party_max() {
	s_msg_clear();
	s_remove_player(obj_master.player_profile, "cut", s_pick_epilogue_story("epi_dil_maxParty"));
	s_dilemma_end();
}

function s_dilemma_morecc_store() {
	s_msg_clear();
	with (obj_master) {
		store_to_dilemma = true;
		s_open_store();
	}
}

function s_dilemma_morecc_back() {
	s_msg_clear();
	with (obj_master) {
		s_create_dilemma(map_dilemma);
	}
}

function s_dilemma_end() {
	obj_master.profile_back_to = -1;
	slog("s_dilemma_end");
	if (s_dilemma_college_check_chained()) {
		return;
	}
	s_play(1);
}

function s_dilemma_college_check_chained() {
	obj_master.profile_back_to = -1;
	if (s_is_co_mode() && (obj_master.stage == 2 || obj_master.stage == 1)) {
		obj_master.prematch_dilemma_shown_count += 1;
		var r = random_range(0, 1);
		slog("s_dilemma_college_check_chained - Checking for chained dilemma. count:" + string(obj_master.prematch_dilemma_shown_count));
		var teamSize = ds_list_size(obj_master.roster);
		if (obj_master.prematch_dilemma_shown_count == 1 && irandom(20) < teamSize - 2) {
			s_msg_clear();
			s_do_prematch_dilemma(true);
			return true;
		}
		if (obj_master.prematch_dilemma_shown_count == 2 && random_range(0, 1) < 0.05) {
			s_msg_clear();
			s_do_prematch_dilemma(true);
			return true;
		}
	} else {
		slog("s_dilemma_college_check_chained ignored");
	}
	return false;
}

