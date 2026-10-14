function s_parse_dilemma(_arg0, _arg1, _arg2) {
	var msg_key = _arg0;
	var msg = s_str(_arg0);
	var pmap = _arg1;
	var map_dilemma = ds_map_create();
	slog(msg);
	ds_map_set(map_dilemma, "title", s_str(_arg2));
	ds_map_set(map_dilemma, "effect_on1", "");
	ds_map_set(map_dilemma, "effect_on2", "");
	ds_map_set(map_dilemma, "msg_key", msg_key);
	ds_map_set(map_dilemma, "cost_amt1", 0);
	ds_map_set(map_dilemma, "cost_amt2", 0);
	var btn = "1";
	if (string_count("-choice_DefendPlayer", msg)) {
		var cc_cost = -1;
		if (obj_master.qb_mode) {
			cc_cost = -3;
		}
		if (s_is_co_mode()) {
			cc_cost = s_dilemma_defend_player_cost(msg_key, pmap);
		}
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_DefendPlayer"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_DefendPlayer");
		ds_map_set(map_dilemma, "cost_amt" + btn, cc_cost);
		ds_map_set(map_dilemma, "cost_img" + btn, obj_master.qb_mode ? "spr_fans" : "spr_credit");
		ds_map_set(map_dilemma, "effect_on" + btn, "player");
		msg = string_replace_all(msg, "-choice_DefendPlayer", "");
		btn = "2";
	}
	if (string_count("-choice_PraisePlayer", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_PraisePlayer"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_PraisePlayer");
		ds_map_set(map_dilemma, "cost_amt" + btn, 15);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_attitude");
		ds_map_set(map_dilemma, "effect_on" + btn, "player");
		msg = string_replace_all(msg, "-choice_PraisePlayer", "");
		btn = "2";
	}
	if (string_count("-choice_CriticisePlayer", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_CriticisePlayer"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_CriticisePlayer");
		ds_map_set(map_dilemma, "cost_amt" + btn, -15);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_attitude");
		ds_map_set(map_dilemma, "effect_on" + btn, "player");
		msg = string_replace_all(msg, "-choice_CriticisePlayer", "");
		btn = "2";
	}
	if (string_count("-choice_SideWithPlayer", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_SideWithPlayer"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_SideWithPlayer");
		ds_map_set(map_dilemma, "cost_amt" + btn, 10);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_attitude");
		ds_map_set(map_dilemma, "effect_on" + btn, "player");
		msg = string_replace_all(msg, "-choice_SideWithPlayer", "");
		btn = "2";
	}
	if (string_count("-choice_RestYes", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_RestYes"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_RestYes");
		ds_map_set(map_dilemma, "cost_amt" + btn, 15);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_attitude");
		ds_map_set(map_dilemma, "effect_on" + btn, "player");
		msg = string_replace_all(msg, "-choice_RestYes", "");
		btn = "2";
	}
	if (string_count("-choice_RestNo", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_RestNo"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_RestNo");
		ds_map_set(map_dilemma, "cost_amt" + btn, -5);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_attitude");
		ds_map_set(map_dilemma, "effect_on" + btn, "player");
		msg = string_replace_all(msg, "-choice_RestNo", "");
		btn = "2";
	}
	if (string_count("-choice_FinePlayer", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_FinePlayer"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_FinePlayer");
		ds_map_set(map_dilemma, "cost_amt" + btn, -10);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_attitude");
		ds_map_set(map_dilemma, "effect_on" + btn, "player");
		msg = string_replace_all(msg, "-choice_FinePlayer", "");
		btn = "2";
	}
	if (string_count("-choice_IgnoreFine", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_IgnoreFine"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_IgnoreFine");
		ds_map_set(map_dilemma, "cost_amt" + btn, -5);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_attitude");
		ds_map_set(map_dilemma, "effect_on" + btn, "team");
		msg = string_replace_all(msg, "-choice_IgnoreFine", "");
		btn = "2";
	}
	if (string_count("-choice_PraiseTeam", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_PraiseTeam"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_PraiseTeam");
		ds_map_set(map_dilemma, "cost_amt" + btn, 3);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_attitude");
		ds_map_set(map_dilemma, "effect_on" + btn, "team");
		msg = string_replace_all(msg, "-choice_PraiseTeam", "");
		btn = "2";
	}
	if (string_count("-choice_CriticiseTeam", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_CriticiseTeam"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_CriticiseTeam");
		ds_map_set(map_dilemma, "cost_amt" + btn, -10);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_attitude");
		ds_map_set(map_dilemma, "effect_on" + btn, "team");
		msg = string_replace_all(msg, "-choice_CriticiseTeam", "");
		btn = "2";
	}
	if (string_count("-choice_FocusTeam", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_FocusTeam"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_FocusTeam");
		ds_map_set(map_dilemma, "cost_amt" + btn, 300);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_xp");
		ds_map_set(map_dilemma, "effect_on" + btn, "team");
		msg = string_replace_all(msg, "-choice_FocusTeam", "");
		btn = "2";
	}
	if (string_count("-choice_MeetTeam", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_MeetTeam"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_MeetTeam");
		ds_map_set(map_dilemma, "cost_amt" + btn, 10);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_attitude");
		ds_map_set(map_dilemma, "effect_on" + btn, "team");
		msg = string_replace_all(msg, "-choice_MeetTeam", "");
		btn = "2";
	}
	if (string_count("-choice_PraiseFans", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_PraiseFans"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_PraiseFans");
		ds_map_set(map_dilemma, "cost_amt" + btn, 3);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_fans");
		msg = string_replace_all(msg, "-choice_PraiseFans", "");
		btn = "2";
	}
	if (string_count("-choice_CriticiseFans", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_CriticiseFans"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_CriticiseFans");
		ds_map_set(map_dilemma, "cost_amt" + btn, -10);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_fans");
		msg = string_replace_all(msg, "-choice_CriticiseFans", "");
		btn = "2";
	}
	if (string_count("-choice_FocusMedia", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_FocusMedia"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_FocusMedia");
		ds_map_set(map_dilemma, "cost_amt" + btn, 5);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_fans");
		msg = string_replace_all(msg, "-choice_FocusMedia", "");
		btn = "2";
	}
	if (string_count("-choice_MeetMedia", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_MeetMedia"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_MeetMedia");
		ds_map_set(map_dilemma, "cost_amt" + btn, 5);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_fans");
		msg = string_replace_all(msg, "-choice_MeetMedia", "");
		btn = "2";
	}
	if (string_count("-choice_PraiseCoaches", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_PraiseCoaches"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_PraiseCoaches");
		ds_map_set(map_dilemma, "cost_amt" + btn, 15);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_attitude");
		ds_map_set(map_dilemma, "effect_on" + btn, "coaches");
		msg = string_replace_all(msg, "-choice_PraiseCoaches", "");
		btn = "2";
	}
	if (string_count("-choice_CriticiseCoaches", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_CriticiseCoaches"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_CriticiseCoaches");
		ds_map_set(map_dilemma, "cost_amt" + btn, -15);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_attitude");
		ds_map_set(map_dilemma, "effect_on" + btn, "coaches");
		msg = string_replace_all(msg, "-choice_CriticiseCoaches", "");
		btn = "2";
	}
	if (string_count("-choice_FocusCoaches", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_FocusCoaches"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_FocusCoaches");
		ds_map_set(map_dilemma, "cost_amt" + btn, 100);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_xp");
		ds_map_set(map_dilemma, "effect_on" + btn, "coaches");
		if (obj_master.qb_mode) {
			ds_map_set(map_dilemma, "effect_on" + btn, "qb_self");
		}
		msg = string_replace_all(msg, "-choice_FocusCoaches", "");
		btn = "2";
	}
	if (string_count("-choice_MeetCoaches", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_MeetCoaches"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_MeetCoaches");
		ds_map_set(map_dilemma, "cost_amt" + btn, 15);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_attitude");
		ds_map_set(map_dilemma, "effect_on" + btn, "coaches");
		msg = string_replace_all(msg, "-choice_MeetCoaches", "");
		btn = "2";
	}
	if (string_count("-choice_SideWithCoach", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_SideWithCoach"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_SideWithCoach");
		ds_map_set(map_dilemma, "cost_amt" + btn, 10);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_attitude");
		ds_map_set(map_dilemma, "effect_on" + btn, "coaches");
		msg = string_replace_all(msg, "-choice_SideWithCoach", "");
		btn = "2";
	}
	if (string_count("-choice_CriticiseSelf", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_CriticiseSelf"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_CriticiseSelf");
		ds_map_set(map_dilemma, "cost_amt" + btn, obj_master.qb_mode ? -3 : -1);
		ds_map_set(map_dilemma, "cost_img" + btn, obj_master.qb_mode ? "spr_fans" : "spr_credit");
		ds_map_set(map_dilemma, "effect_on" + btn, "self");
		msg = string_replace_all(msg, "-choice_CriticiseSelf", "");
		btn = "2";
	}
	if (string_count("-choice_PraiseOwner", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_PraiseOwner"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_PraiseOwner");
		ds_map_set(map_dilemma, "cost_amt" + btn, 1);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_credit");
		msg = string_replace_all(msg, "-choice_PraiseOwner", "");
		btn = "2";
	}
	if (string_count("-choice_FocusOwner", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_FocusOwner"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_FocusOwner");
		ds_map_set(map_dilemma, "cost_amt" + btn, 2);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_credit");
		msg = string_replace_all(msg, "-choice_FocusOwner", "");
		btn = "2";
	}
	if (string_count("-choice_MeetOwner", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_MeetOwner"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_MeetOwner");
		ds_map_set(map_dilemma, "cost_amt" + btn, global.console_build ? 2 : 1);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_credit");
		msg = string_replace_all(msg, "-choice_MeetOwner", "");
		btn = "2";
	}
	if (string_count("-choice_CriticiseOfficials", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_CriticiseOfficials"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_CriticiseOfficials");
		ds_map_set(map_dilemma, "cost_amt" + btn, obj_master.qb_mode ? -3 : -1);
		ds_map_set(map_dilemma, "cost_img" + btn, obj_master.qb_mode ? "spr_fans" : "spr_credit");
		msg = string_replace_all(msg, "-choice_CriticiseOfficials", "");
		btn = "2";
	}
	if (irandom(1)) {
		if (string_count("-choice_qpos_correct", msg)) {
			ds_map_set(map_dilemma, "btn_txt" + btn, s_get_string_position(ds_map_find_value(pmap, "position")));
			ds_map_set(map_dilemma, "cost_typ" + btn, "choice_PraiseFans");
			ds_map_set(map_dilemma, "cost_amt" + btn, 3);
			ds_map_set(map_dilemma, "cost_img" + btn, "-1");
			ds_map_set(map_dilemma, "effect_on" + btn, "fans");
			msg = string_replace_all(msg, "-choice_qpos_correct", "");
			btn = "2";
		}
	}
	if (string_count("-choice_qpos_wrong", msg)) {
		var pos = irandom_range(1, 10);
		if (ds_map_find_value(pmap, "position") == 101) {
			pos = 102;
		} else if (ds_map_find_value(pmap, "position") == 102) {
			pos = 101;
		} else {
			while (pos == real(ds_map_find_value(pmap, "position")) || pos == 8 || pos == 9) {
				pos = irandom_range(1, 10);
			}
		}
		ds_map_set(map_dilemma, "btn_txt" + btn, s_get_string_position(pos));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_CriticiseFans");
		ds_map_set(map_dilemma, "cost_amt" + btn, -5);
		ds_map_set(map_dilemma, "cost_img" + btn, "-1");
		ds_map_set(map_dilemma, "effect_on" + btn, "fans");
		msg = string_replace_all(msg, "-choice_qpos_wrong", "");
		btn = "2";
	}
	if (string_count("-choice_qpos_correct", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_get_string_position(ds_map_find_value(pmap, "position")));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_PraiseFans");
		ds_map_set(map_dilemma, "cost_amt" + btn, 3);
		ds_map_set(map_dilemma, "cost_img" + btn, "-1");
		ds_map_set(map_dilemma, "effect_on" + btn, "fans");
		msg = string_replace_all(msg, "-choice_qpos_correct", "");
		btn = "2";
	}
	var replaceCCWithTeam = obj_master.coach_credit <= 0;
	if (s_is_co_mode() && string_pos("leaverescue", msg_key)) {
		replaceCCWithTeam = false;
	}
	if (replaceCCWithTeam) {
		if (ds_map_find_value(map_dilemma, "cost_img1") == "spr_credit" && ds_map_find_value(map_dilemma, "cost_amt1") < 0) {
			ds_map_set(map_dilemma, "cost_typ1", "choice_CriticiseTeam");
			ds_map_set(map_dilemma, "cost_amt1", -10);
			ds_map_set(map_dilemma, "cost_img1", "spr_attitude");
			ds_map_set(map_dilemma, "effect_on1", "team");
		}
		if (ds_map_find_value(map_dilemma, "cost_img2") == "spr_credit" && ds_map_find_value(map_dilemma, "cost_amt2") < 0) {
			ds_map_set(map_dilemma, "cost_typ2", "choice_CriticiseTeam");
			ds_map_set(map_dilemma, "cost_amt2", -10);
			ds_map_set(map_dilemma, "cost_img2", "spr_attitude");
			ds_map_set(map_dilemma, "effect_on2", "team");
		}
	}
	if (string_count("-choice_FocusNRG", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_FocusNRG"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_FocusNRG");
		ds_map_set(map_dilemma, "cost_amt" + btn, 1);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_nrg");
		ds_map_set(map_dilemma, "effect_on" + btn, "nrg");
		msg = string_replace_all(msg, "-choice_FocusNRG", "");
		btn = "2";
	}
	if (string_count("-choice_GPAUp", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_GPAUp"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_GPAUp");
		ds_map_set(map_dilemma, "cost_amt" + btn, 7);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_gpa");
		ds_map_set(map_dilemma, "effect_on" + btn, "player");
		msg = string_replace_all(msg, "-choice_GPAUp", "");
		btn = "2";
	}
	if (string_count("-choice_GPADrop", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_GPADrop"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_GPADrop");
		ds_map_set(map_dilemma, "cost_amt" + btn, -9);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_gpa");
		ds_map_set(map_dilemma, "effect_on" + btn, "player");
		msg = string_replace_all(msg, "-choice_GPADrop", "");
		btn = "2";
	}
	if (string_count("-choice_CutPlayer", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_CutPlayer"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_CutPlayer");
		ds_map_set(map_dilemma, "cost_amt" + btn, 0);
		ds_map_set(map_dilemma, "cost_img" + btn, "-1");
		ds_map_set(map_dilemma, "effect_on" + btn, "player");
		msg = string_replace_all(msg, "-choice_CutPlayer", "");
		btn = "2";
	}
	if (string_count("-choice_FocusGPA", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_FocusGPA"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_FocusGPA");
		ds_map_set(map_dilemma, "cost_amt" + btn, 7);
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_gpa");
		ds_map_set(map_dilemma, "effect_on" + btn, "team");
		msg = string_replace_all(msg, "-choice_FocusGPA", "");
		btn = "2";
	}
	if (string_count("-choice_FocusRC", msg)) {
		ds_map_set(map_dilemma, "btn_txt" + btn, s_str("choice_FocusRC"));
		ds_map_set(map_dilemma, "cost_typ" + btn, "choice_FocusRC");
		ds_map_set(map_dilemma, "cost_amt" + btn, s_str_real("choice_FocusRC_bonus"));
		ds_map_set(map_dilemma, "cost_img" + btn, "spr_credit_rec");
		msg = string_replace_all(msg, "-choice_FocusRC", "");
		btn = "2";
	}
	if (pmap) {
		msg = s_parse_player_message(msg, pmap);
		slog("Dilemma about: " + ds_map_find_value(pmap, "lname"));
		if (s_is_co_mode()) {
			if (string_count("toxic", msg_key)) {
				ds_map_set(pmap, "toxic_dilemmas", ds_map_find_value(pmap, "toxic_dilemmas") + 1);
			}
			if (string_count("party", msg_key)) {
				ds_map_set(pmap, "party_dilemmas", ds_map_find_value(pmap, "party_dilemmas") + 1);
			}
		}
	}
	ds_map_set(map_dilemma, "msg", msg);
	slog("Dilemma: " + msg);
	return map_dilemma;
}

