function s_end_match(_arg0) {
	slog("s_end_match:" + string(_arg0));
	_poki_gameplay_start();
	audio_sound_gain(snd_audience_idle, 0, 3000);
	obj_controller.comm_stage = 31;
	with (obj_master) {
		tscore[0] = obj_controller.team_score[0];
		tscore[1] = obj_controller.team_score[1];
		if (global.exhibition) {
			s_set_multicon_turn();
			exhibition_handle_exit_match();
			room_goto(rm_exhibition_postmatch);
			return;
		}
		roster = obj_controller.team_roster[obj_controller.human_team];
		slog_master_roster("s_end_match");
		s_update_stats();
		s_match_rating_effect_on_morale();
		s_training_regime_effect_on_morale();
		if (_arg0 == 1 && !s_simming_action()) {
			if (!obj_controller.starqb) {
				s_complete_achievement("ACH_WIN_NOSTARQB");
			}
			if (!obj_controller.starplayer) {
				s_complete_achievement("ACH_WIN_NOSTAR");
			}
		}
		var tmap1 = obj_controller.team[0];
		var tmap2 = obj_controller.team[1];
		var str = ds_map_find_value(tmap1, "tla") + " " + string(tscore[0]) + "-" + string(tscore[1]) + " " + ds_map_find_value(tmap2, "tla");
		s_check_record_text("ui_MostPointsGame", tscore[0] + tscore[1], str);
		var dif = abs(tscore[0] - tscore[1]);
		switch (_arg0) {
			case -1:
				s_check_record_text("ui_BiggestLoss", dif, str);
				break;
			case 1:
				s_check_record_text("ui_BiggestWin", dif, str);
				if (tscore[0] == 0 || tscore[1] == 0) {
					s_complete_achievement("ACH_SHUTOUT");
				}
				break;
		}
		if (tscore[obj_controller.human_team] >= 50 && !s_simming_action()) {
			s_complete_achievement("ACH_SCORE50");
		}
		var tds = obj_controller.touchdowns;
		s_check_record_text("ui_MostTDsGame", tds, str + " (" + string(tds) + ")");
		var fixture = s_get_human_fixture_by_week(week);
		if (s_simming_action()) {
			switch (op_difficulty) {
				case 0:
					ds_map_set(fixture, "difficulty", s_str("ui_Sim") + " " + string(16 - (5 + suppress_difficulty)));
					break;
				case 1:
					ds_map_set(fixture, "difficulty", s_str("ui_Sim") + " E");
					break;
				case 2:
					ds_map_set(fixture, "difficulty", s_str("ui_Sim") + " M");
					break;
				case 3:
					ds_map_set(fixture, "difficulty", s_str("ui_Sim") + " H");
					break;
				case 4:
					ds_map_set(fixture, "difficulty", s_str("ui_Sim") + " X");
					break;
			}
		} else {
			switch (op_difficulty) {
				case 0:
					ds_map_set(fixture, "difficulty", s_str("ui_Dynamic") + " " + string(16 - (5 + suppress_difficulty)));
					break;
				case 1:
					ds_map_set(fixture, "difficulty", s_str("ui_Easy"));
					break;
				case 2:
					ds_map_set(fixture, "difficulty", s_str("ui_Medium"));
					break;
				case 3:
					ds_map_set(fixture, "difficulty", s_str("ui_Hard"));
					break;
				case 4:
					ds_map_set(fixture, "difficulty", s_str("ui_Extreme"));
					break;
			}
		}
		ds_map_set(fixture, "op_matchlength", obj_master.op_matchlength);
		ds_map_set(fixture, "away_score", tscore[0]);
		ds_map_set(fixture, "home_score", tscore[1]);
		if (week == obj_master.last_week_regular) {
			slog("End of regular season. My rating was " + string(coach_rating));
			if (s_get_division_winner(myconference, mydivision) == myteam) {
				slog("Divisional winner!");
				s_complete_achievement("ACH_WIN_DIVISION");
			}
			if (s_get_team_id_by_seed(myconference, 1) == myteam_id) {
				coach_rating += 4;
				slog("1st seed. My rating is now " + string(coach_rating));
			} else if (s_get_team_id_by_seed(myconference, 2) == myteam_id) {
				coach_rating += 3;
				slog("2nd seed. My rating is now " + string(coach_rating));
			} else if (s_get_team_id_by_seed(myconference, 3) == myteam_id) {
				coach_rating += 2;
				slog("3rd seed. My rating is now " + string(coach_rating));
			} else if (s_get_team_id_by_seed(myconference, 4) == myteam_id) {
				slog("4th seed. My rating is now " + string(coach_rating));
			} else {
				coach_rating = round(coach_rating * 0.5);
				slog("Unseeded. My rating is now " + string(coach_rating));
			}
		}
		s_complete_achievement("ACH_PLAYGAME1");
		matchcount++;
		switch (_arg0) {
			case -1:
				ds_map_set(fixture, "human_win", "loss");
				suppress_difficulty += 1;
				if (week >= obj_master.first_week_playoffs) {
					s_update_history_playoffs(0);
				}
				if (s_playoffs_12()) {
					if (week >= first_week_playoffs && week <= first_week_playoffs + 3) {
						coach_rating += 3;
						slog("Out in wild card round. My rating is now " + string(coach_rating));
						s_update_history_finish(1);
					} else if (week >= first_week_playoffs + 4 && week <= first_week_playoffs + 7) {
						coach_rating += 4;
						slog("Out in divisional round. My rating is now " + string(coach_rating));
					} else if (week >= first_week_playoffs + 8 && week <= first_week_playoffs + 9) {
						coach_rating += 5;
						slog("Out in wild championship round. My rating is now " + string(coach_rating));
					} else if (week == first_week_playoffs + 10) {
						coach_rating += 6;
						slog("Lost the superbowl. My rating is now " + string(coach_rating));
					}
				} else if (week >= first_week_playoffs && week <= first_week_playoffs + 5) {
					coach_rating += 3;
					slog("Out in wild card round. My rating is now " + string(coach_rating));
					s_update_history_finish(1);
				} else if (week >= first_week_playoffs + 6 && week <= first_week_playoffs + 9) {
					coach_rating += 4;
					slog("Out in divisional round. My rating is now " + string(coach_rating));
				} else if (week >= first_week_playoffs + 10 && week <= first_week_playoffs + 11) {
					coach_rating += 5;
					slog("Out in wild championship round. My rating is now " + string(coach_rating));
				} else if (week == first_week_playoffs + 12) {
					coach_rating += 6;
					slog("Lost the superbowl. My rating is now " + string(coach_rating));
				}
				break;
			case 0:
				ds_map_set(fixture, "human_win", "tie");
				break;
			case 1:
				if (global.poki) {
					poki_happy_time(1);
				}
				ds_map_set(fixture, "human_win", "win");
				suppress_difficulty -= 1;
				if (obj_controller.team_score[obj_controller.human_team] > obj_controller.team_score[!obj_controller.human_team ? 1 : 0] + 14) {
					suppress_difficulty -= 1;
				}
				s_complete_achievement("ACH_WIN1");
				var count = s_count_achievement("ACH_WIN1");
				if (count >= 5) {
					s_complete_achievement("ACH_WIN5");
				}
				if (count >= 10) {
					s_complete_achievement("ACH_WIN10");
				}
				if (count >= 25) {
					s_complete_achievement("ACH_WIN25");
				}
				if (count >= 50) {
					s_complete_achievement("ACH_WIN50");
				}
				if (count >= 100) {
					s_complete_achievement("ACH_WIN100");
				}
				if (week >= obj_master.first_week_playoffs) {
					s_update_history_playoffs(1);
				}
				if (s_playoffs_12()) {
					if (week >= first_week_playoffs && week <= first_week_playoffs + 3) {
						s_complete_achievement("ACH_WIN_PLAYOFF");
						s_update_history_finish(2);
					} else if (week >= first_week_playoffs + 4 && week <= first_week_playoffs + 7) {
						s_complete_achievement("ACH_WIN_PLAYOFF");
						s_update_history_finish(3);
					} else if (week >= first_week_playoffs + 8 && week <= first_week_playoffs + 9) {
						switch (obj_master.myconference) {
							case 0:
								s_complete_achievement("ACH_WIN_AFC");
								break;
							case 1:
								s_complete_achievement("ACH_WIN_NFC");
								break;
						}
						s_update_history_finish(4);
					} else if (week == first_week_playoffs + 10) {
						coach_rating += 8;
						slog("Won the superbowl! My rating is now " + string(coach_rating));
						s_update_history_finish(5);
						s_complete_achievement("ACH_WIN_RETROBOWL1");
						var count = s_count_achievement("ACH_WIN_RETROBOWL1");
						if (count == 3) {
							s_complete_achievement("ACH_WIN_RETROBOWL3");
						}
						if (count == 5) {
							s_complete_achievement("ACH_WIN_RETROBOWL5");
						}
						if (count == 10) {
							s_complete_achievement("ACH_WIN_RETROBOWL10");
						}
						if (!s_simming_action()) {
							if (!obj_controller.starqb) {
								s_complete_achievement("ACH_RETROBOWL_NOSTARQB");
							}
							if (!obj_controller.starplayer) {
								s_complete_achievement("ACH_RETROBOWL_NOSTAR");
							}
						}
						s_check_repeat_retrobowls();
						s_award_sb_rings();
					}
				} else if (week >= first_week_playoffs && week <= first_week_playoffs + 5) {
					s_complete_achievement("ACH_WIN_PLAYOFF");
					s_update_history_finish(2);
				} else if (week >= first_week_playoffs + 6 && week <= first_week_playoffs + 9) {
					s_complete_achievement("ACH_WIN_PLAYOFF");
					s_update_history_finish(3);
				} else if (week >= first_week_playoffs + 10 && week <= first_week_playoffs + 11) {
					switch (obj_master.myconference) {
						case 0:
							s_complete_achievement("ACH_WIN_AFC");
							break;
						case 1:
							s_complete_achievement("ACH_WIN_NFC");
							break;
					}
					s_update_history_finish(4);
				} else if (week == first_week_playoffs + 12) {
					coach_rating += 8;
					slog("Won the superbowl! My rating is now " + string(coach_rating));
					s_update_history_finish(5);
					s_complete_achievement("ACH_WIN_RETROBOWL1");
					var count = s_count_achievement("ACH_WIN_RETROBOWL1");
					if (count == 3) {
						s_complete_achievement("ACH_WIN_RETROBOWL3");
					}
					if (count == 5) {
						s_complete_achievement("ACH_WIN_RETROBOWL5");
					}
					if (count == 10) {
						s_complete_achievement("ACH_WIN_RETROBOWL10");
					}
					if (!s_simming_action()) {
						if (!obj_controller.starqb) {
							s_complete_achievement("ACH_RETROBOWL_NOSTARQB");
						}
						if (!obj_controller.starplayer) {
							s_complete_achievement("ACH_RETROBOWL_NOSTAR");
						}
					}
					s_check_repeat_retrobowls();
					s_award_sb_rings();
				}
				break;
		}
		var show_comp_win_screen = "none";
		var cid = -1;
		if (s_is_co_mode()) {
			var schedule_fix = s_get_player_schedule_fixture_by_week(week);
			slog_map("FIXTURE:: ", schedule_fix);
			if (schedule_fix != -4) {
				cid = ds_map_find_value(schedule_fix, "cid");
				if (ds_map_exists(schedule_fix, "notify")) {
					slog("Fixture has notification request [" + string(ds_map_find_value(schedule_fix, "notify")) + "]");
					s_handle_fixture_notification(schedule_fix, ds_map_find_value(fixture, "human_win"));
				} else {
					slog("Fixture has no notification request");
				}
				if (ds_map_exists(schedule_fix, "history_rec")) {
					slog("Fixture has history record request [" + string(ds_map_find_value(schedule_fix, "history_rec")) + "]");
					s_handle_fixture_history_record(schedule_fix, ds_map_find_value(fixture, "human_win"));
				} else {
					slog("Fixture has no history record request");
				}
				if (ds_map_exists(schedule_fix, "reward")) {
					s_handle_fixture_reward(schedule_fix, ds_map_find_value(fixture, "human_win"));
				}
				show_comp_win_screen = s_fixture_victory_screen(schedule_fix, ds_map_find_value(fixture, "human_win"));
			}
		}
		ds_map_set(fixture, "weather", 0);
		with (obj_weather) {
			ds_map_set(fixture, "weather", type);
		}
		coach_rating = clamp(coach_rating, 1, 20);
		if (s_count_achievement("ACH_WIN_RETROBOWL1") > 0) {
			suppress_difficulty = clamp(suppress_difficulty, -5, 10);
		} else {
			suppress_difficulty = clamp(suppress_difficulty, -1, 10);
		}
	}
	s_save_backup();
	s_update_music();
	s_log_this_year_history();
	if (show_comp_win_screen != "none") {
		s_show_rm_winners(0, cid, show_comp_win_screen, "", btn_click_Play1, true);
	} else {
		s_play(1);
	}
}

