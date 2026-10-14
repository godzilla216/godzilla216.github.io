function s_savegame() {
	slog("<<< s_savegame >>>");
	if (instance_exists(obj_controller)) {
		return;
	}
	if (obj_master.stage == 4) {
		return;
	}
	if (obj_master.first_load) {
		obj_master.first_load = false;
		return;
	}
	if (global.exhibition) {
		return;
	}
	s_save_options();
	with (obj_master) {
		if (!s_is_debug_desktop()) {
			slog("Verify team data...");
		}
		if (myteam_id < min_team_id || myteam_id > max_team_id) {
			slogf("team %3 ot of bounds (%1,%2), not saving", min_team_id, max_team_id, myteam_id);
			return;
		}
		var tmap, uid, team_name, tla, verify;
		for (var i = 0; i < ds_list_size(teamlist); i++) {
			tmap = ds_list_find_value(teamlist, i);
			uid = string(ds_map_find_value(tmap, "uid"));
			team_name = string(ds_map_find_value(tmap, "name"));
			tla = string(ds_map_find_value(tmap, "tla"));
			verify = uid + ". " + tla + " - " + team_name + "... Ok";
			slog(verify);
		}
		var pmap, name, pos, skin;
		for (var i = 0; i < ds_list_size(roster); i++) {
			pmap = ds_list_find_value(roster, i);
			name = ds_map_find_value(pmap, "lname");
			pos = ds_map_find_value(pmap, "position");
			skin = ds_map_find_value(pmap, "skin");
			verify = name + " - " + s_get_string_position(pos) + " Skin:" + string(skin) + "... Ok";
			if (!s_is_debug_desktop()) {
				slog(verify);
			}
		}
		tmap = ds_list_find_value(teamlist, myteam_id);
		team_name = ds_map_find_value(tmap, "name");
		if (os_is_paused()) {
			return;
		}
		slog("My team ID(" + string(myteam_id) + ") My team=" + team_name);
		ini_open(s_get_savename());
		if (s_is_co_mode()) {
			ini_write_real("savegame", "data_version", data_version);
			ini_write_real("savegame", "year_offset", year_offset);
		}
		ini_write_real("savegame", "start_year", start_year);
		ini_write_real("savegame", "year_stagger", year_stagger);
		ini_write_real("savegame", "last_week_regular", last_week_regular);
		ini_write_real("savegame", "first_week_playoffs", first_week_playoffs);
		ini_write_real("savegame", "year", year);
		ini_write_real("savegame", "week", week);
		ini_write_real("savegame", "stage", stage);
		ini_write_real("savegame", "intro", intro);
		ini_write_string("savegame", "fname", fname);
		ini_write_string("savegame", "lname", lname);
		ini_write_real("savegame", "qb_mode", qb_mode);
		ini_write_real("savegame", "co_mode", co_mode);
		ini_write_real("savegame", "fr_mode", fr_mode);
		ini_write_string("savegame", "fname_coach", fname_coach);
		ini_write_string("savegame", "lname_coach", lname_coach);
		ini_write_string("savegame", "starrating", starrating);
		ini_write_string("savegame", "relationship_boss", relationship_boss);
		ini_write_string("savegame", "qb_salary", qb_salary);
		ini_write_string("savegame", "qb_tdbonus", qb_tdbonus);
		ini_write_string("savegame", "qb_training_hiscore", qb_training_hiscore);
		ini_write_string("savegame", "qb_nrg", qb_nrg);
		ini_write_real("savegame", "myteam_id", myteam_id);
		ini_write_real("savegame", "myface_x", myface_x);
		ini_write_real("savegame", "myface_y", myface_y);
		ini_write_real("savegame", "favourite_team_id", favourite_team_id);
		ini_write_real("savegame", "suppress_difficulty", suppress_difficulty);
		ini_write_real("savegame", "salary_cap", salary_cap);
		ini_write_real("savegame", "boost_salary_cap", boost_salary_cap);
		ini_write_real("savegame", "prematch_dilemma_done", prematch_dilemma_done);
		ini_write_real("savegame", "tip_count", tip_count);
		ini_write_real("savegame", "matchcount", matchcount);
		ini_write_real("savegame", "gamestarts", gamestarts);
		ini_write_real("savegame", "timeout_message_done", timeout_message_done);
		ini_write_real("savegame", "bullet_throw_message_done", bullet_throw_message_done);
		ini_write_real("savegame", "tag_hof_message_done", tag_hof_message_done);
		ini_write_real("savegame", "tag_kr_message_done", tag_kr_message_done);
		ini_write_real("savegame", "season_credits_purchased", season_credits_purchased);
		ini_write_real("savegame", "op_ball", op_ball);
		ini_write_real("savegame", "coach_credit", coach_credit);
		ini_write_real("savegame", "purchased_credit", purchased_credit);
		ini_write_real("savegame", "coach_rating", coach_rating);
		ini_write_real("savegame", "fans", fans);
		ini_write_real("savegame", "facility_stadium", facility_stadium);
		ini_write_real("savegame", "facility_training", facility_training);
		ini_write_real("savegame", "facility_rehab", facility_rehab);
		ini_write_real("savegame", "facility_upgraded_stadium", facility_upgraded_stadium);
		ini_write_real("savegame", "facility_upgraded_training", facility_upgraded_training);
		ini_write_real("savegame", "facility_upgraded_rehab", facility_upgraded_rehab);
		ini_write_real("savegame", "training_reg_df", training_reg_df);
		ini_write_real("savegame", "training_reg_of", training_reg_of);
		ini_write_real("savegame", "draft_round", draft_round);
		ini_write_real("savegame", "draft_picks_0", draft_picks[0]);
		ini_write_real("savegame", "draft_picks_1", draft_picks[1]);
		ini_write_real("savegame", "draft_picks_2", draft_picks[2]);
		ini_write_real("savegame", "draft_info_done", draft_info_done);
		ini_write_real("savegame", "expiredcontract_msg_done", expiredcontract_msg_done);
		ini_write_real("savegame", "offers_done", offers_done);
		ini_write_real("savegame", "op_difficulty", op_difficulty);
		ini_write_real("savegame", "op_matchlength", op_matchlength);
		ini_write_real("savegame", "op_autorun", op_autorun);
		ini_write_real("savegame", "op_autorun_p2", op_autorun_p2);
		if (!s_is_debug_desktop()) {
			slog(">>>>>>>>>>>>>>>>>>>>>>> " + name_conf1);
		}
		ini_write_string("savegame", "name_conf1", name_conf1);
		ini_write_string("savegame", "name_conf2", name_conf2);
		ini_write_string("savegame", "name_div1", name_div1);
		ini_write_string("savegame", "name_div2", name_div2);
		ini_write_string("savegame", "name_div3", name_div3);
		ini_write_string("savegame", "name_div4", name_div4);
		ini_write_string("savegame", "name_div1b", name_div1b);
		ini_write_string("savegame", "name_div2b", name_div2b);
		ini_write_string("savegame", "name_div3b", name_div3b);
		ini_write_string("savegame", "name_div4b", name_div4b);
		ini_write_string("savegame", "news", ds_list_write(newslist));
		ini_write_string("savegame", "dilemma_tags", ds_list_write(dilemma_tags));
		ini_write_string("savegame", "news_tags", ds_list_write(news_tags));
		var size, val, str;
		size = ds_list_size(list_news_dyn);
		ini_write_real("savegame", "news_dyn", size);
		for (var r = 0; r < size; r++) {
			str = ds_map_write(ds_list_find_value(list_news_dyn, r));
			ini_write_string("savegame", "news_dyn_" + string(r), str);
		}
		size = ds_list_size(teamlist);
		ini_write_real("savegame", "teamlist", size);
		for (var m = 0; m < size; m++) {
			tmap = ds_list_find_value(teamlist, m);
			ini_write_string("savegame", "teamlist_" + string(m), ds_map_write(tmap));
		}
		size = ds_list_size(achievements);
		ini_write_real("savegame", "achievements", size);
		for (var m = 0; m < size; m++) {
			val = ds_list_find_value(achievements, m);
			ini_write_string("savegame", "achievements_" + string(m), ds_map_write(val));
		}
		size = ds_list_size(records);
		ini_write_real("savegame", "records", size);
		for (var m = 0; m < size; m++) {
			val = ds_list_find_value(records, m);
			ini_write_string("savegame", "records_" + string(m), ds_map_write(val));
		}
		size = ds_list_size(history);
		ini_write_real("savegame", "history", size);
		for (var m = 0; m < size; m++) {
			str = ds_map_write(ds_list_find_value(history, m));
			ini_write_string("savegame", "history_" + string(m), str);
		}
		size = ds_list_size(schedule);
		ini_write_real("savegame", "schedule", size);
		slogf("schedule size: %1", ds_list_size(schedule));
		for (var m = 0; m < size; m++) {
			str = ds_map_write(ds_list_find_value(schedule, m));
			ini_write_string("savegame", "schedule_" + string(m), str);
		}
		size = ds_list_size(fixturelist);
		ini_write_real("savegame", "fixturelist", size);
		for (var m = 0; m < size; m++) {
			str = ds_map_write(ds_list_find_value(fixturelist, m));
			ini_write_string("savegame", "fixture_" + string(m), str);
		}
		size = ds_list_size(playoffs);
		ini_write_real("savegame", "playoffs", size);
		for (var m = 0; m < size; m++) {
			str = ds_map_write(ds_list_find_value(playoffs, m));
			ini_write_string("savegame", "playoff_" + string(m), str);
		}
		size = ds_list_size(draftlist);
		ini_write_real("savegame", "draftlist", size);
		for (var r = 0; r < size; r++) {
			str = ds_map_write(ds_list_find_value(draftlist, r));
			ini_write_string("savegame", "draftlist_" + string(r), str);
		}
		for (var i = size; i < 50; i++) {
			ini_key_delete("savegame", "draftlist_" + string(i));
		}
		size = ds_list_size(hirelist);
		ini_write_real("savegame", "hirelist", size);
		for (var r = 0; r < size; r++) {
			str = ds_map_write(ds_list_find_value(hirelist, r));
			ini_write_string("savegame", "hirelist_" + string(r), str);
		}
		size = ds_list_size(storelist);
		ini_write_real("savegame", "storelist", size);
		for (var r = 0; r < size; r++) {
			str = ds_map_write(ds_list_find_value(storelist, r));
			ini_write_string("savegame", "storelist_" + string(r), str);
		}
		size = ds_list_size(tradelist);
		ini_write_real("savegame", "tradelist", size);
		for (var r = 0; r < size; r++) {
			str = ds_map_write(ds_list_find_value(tradelist, r));
			ini_write_string("savegame", "tradelist_" + string(r), str);
		}
		for (var i = size; i < 12; i++) {
			ini_key_delete("savegame", "tradelist_" + string(i));
		}
		size = ds_list_size(freeagentlist);
		ini_write_real("savegame", "freeagentlist", size);
		for (var r = 0; r < size; r++) {
			str = ds_map_write(ds_list_find_value(freeagentlist, r));
			ini_write_string("savegame", "freeagentlist_" + string(r), str);
		}
		for (var i = size; i < 12; i++) {
			ini_key_delete("savegame", "freeagentlist_" + string(i));
		}
		size = ds_list_size(roster);
		ini_write_real("savegame", "roster", size);
		for (var r = 0; r < size; r++) {
			pmap = ds_list_find_value(roster, r);
			str = ds_map_write(pmap);
			slog(ds_map_find_value(pmap, "lname"));
			ini_write_string("savegame", "roster_" + string(r), str);
		}
		for (var i = size; i < 12; i++) {
			ini_key_delete("savegame", "roster_" + string(i));
		}
		size = ds_list_size(stafflist);
		ini_write_real("savegame", "stafflist", size);
		for (var r = 0; r < size; r++) {
			str = ds_map_write(ds_list_find_value(stafflist, r));
			ini_write_string("savegame", "stafflist_" + string(r), str);
		}
		size = ds_list_size(hoflist);
		ini_write_real("savegame", "hoflist", size);
		for (var r = 0; r < size; r++) {
			str = ds_map_write(ds_list_find_value(hoflist, r));
			ini_write_string("savegame", "hoflist_" + string(r), str);
		}
		for (var i = size; i < 50; i++) {
			ini_key_delete("savegame", "hoflist_" + string(i));
		}
		size = ds_list_size(rbhistorylist);
		ini_write_real("savegame", "rbhistorylist", size);
		for (var r = 0; r < size; r++) {
			var str = ds_map_write(ds_list_find_value(rbhistorylist, r));
			slog(str);
			ini_write_string("savegame", "rbhistorylist_" + string(r), str);
		}
		ini_write_string("savegame", "face_grid_L", ds_grid_write(face_grid_L));
		ini_write_string("savegame", "face_grid_M", ds_grid_write(face_grid_M));
		ini_write_string("savegame", "face_grid_D", ds_grid_write(face_grid_D));
		ini_write_string("savegame", "face_grid_C", ds_grid_write(face_grid_C));
		size = ds_list_size(shoppinglist);
		ini_write_real("savegame", "shoppinglist", size);
		for (var m = 0; m < size; m++) {
			val = ds_list_find_value(shoppinglist, m);
			ini_write_string("savegame", "shoppinglist_" + string(m), ds_map_write(val));
		}
		size = ds_list_size(list_teams_rejected);
		ini_write_real("savegame", "list_teams_rejected", size);
		for (var m = 0; m < size; m++) {
			val = ds_list_find_value(list_teams_rejected, m);
			ini_write_real("savegame", "list_teams_rejected_" + string(m), val);
		}
		if (s_is_co_mode()) {
			ini_write_real("savegame", "recruitment_credits", recruitment_credits);
			ini_write_real("savegame", "recruitment_credits_cap", recruitment_credits_cap);
			ini_write_real("savegame", "rc_season_earned", rc_season_earned);
			ini_write_real("savegame", "rc_lifetime_earned", rc_lifetime_earned);
			ini_write_real("savegame", "rc_lifetime_spent", rc_lifetime_spent);
			ini_write_real("savegame", "recruitment_credits", recruitment_credits);
			ini_write_real("savegame", "boost_recruitment_credits_cap", boost_recruitment_credits_cap);
			ini_write_real("savegame", "college_admissions_draft_round", college_admissions_draft_round);
			ini_write_real("savegame", "college_admissions_warn_once", college_admissions_warn_once);
			ini_write_real("savegame", "college_awards_done", college_awards_done);
			ini_write_real("savegame", "pro_drafted_players", pro_drafted_players);
			ini_write_real("savegame", "rec_conf_champ_wins", rec_conf_champ_wins);
			ini_write_real("savegame", "rec_bowl_wins", rec_bowl_wins);
			ini_write_real("savegame", "rec_champ_wins", rec_champ_wins);
			ini_write_real("savegame", "rec_highest_rank_major", rec_highest_rank_major);
			ini_write_real("savegame", "rec_highest_rank_minor", rec_highest_rank_minor);
			ini_write_real("savegame", "non_champ_conferences_resolved", non_champ_conferences_resolved);
		}
		ini_write_real("savegame", "cap_breach_flag", cap_breach_flag);
		ini_close();
	}
	s_nx_commit();
}

