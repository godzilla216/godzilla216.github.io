function s_update_commentary() {
	s_stop_brass_loop();
	slog("s_update_commentary: " + s_get_string_commstage(comm_stage) + " possesion: " + s_co_poss_str(possession) + " scrimmage:" + string(scrimmage));
	comm_proceed = false;
	tap_msg = "";
	last_stage = comm_stage;
	if (skip_half) {
		alarm[1] = 1;
	} else {
		alarm[1] = 100;
	}
	instance_destroy(obj_match_msg);
	slog("drives=" + string(drives));
	if (s_simming_action()) {
		s_check_skip_time_button();
	}
	if (global.debug_co_overtime) {
		if (quarter < 4) {
			quarter = 4;
		}
	}
	switch (comm_stage) {
		case 0:
			comm_stage = 1;
			alarm[1] = 1;
			break;
		case 1:
			if (s_is_quarter_over()) {
				s_update_commentary();
				break;
			}
			var deficit = abs(team_score[human_team] - team_score[!human_team ? 1 : 0]);
			var secs_remaining = s_seconds_remaining();
			var lsecs = 100;
			if (deficit > 8) {
				lsecs = 160;
			}
			if (possession == human_team && s_simming_action()) {
				s_kick_off();
			} else if ((possession == human_team || global.exhibition && obj_master.playerteamindex == -1) && quarter == 4 && team_score[possession] <= team_score[!possession ? 1 : 0] && s_last_secs_of_half(lsecs)) {
				var chance = 9;
				var kk = s_get_player_by_position_from_roster(10, 1, obj_controller.team_roster[possession]);
				if (kk) {
					chance += s_get_attribute(kk, "skill");
				}
				var msg = string_replace(s_str("msg_OnSideKick"), "$num", string(chance));
				s_create_message("", msg, s_str("ui_No"), s_str("ui_Yes"), btn_response_onsidekick_no, btn_response_onsidekick_yes, 16777215, 0.7);
				comm_stage = 25;
				scrimmage = -15;
			} else if (possession != human_team && quarter == 4 && team_score[human_team] > team_score[!human_team ? 1 : 0] && (deficit <= 8 && secs_remaining <= 60 || deficit > 8 && deficit <= 16 && secs_remaining > 60)) {
				comm_stage = 27;
				scrimmage = -15;
				s_update_commentary();
			} else {
				s_kick_off();
			}
			break;
		case 25:
			break;
		case 26:
			s_kick_off();
			s_sound_kick();
			break;
		case 27:
			s_sound_kick();
			var chance = 9;
			var kk = -1;
			if (possession == human_team) {
				kk = s_get_player_by_position_from_roster(10, 1, obj_controller.team_roster[possession]);
				if (kk) {
					chance += s_get_attribute(kk, "skill");
				}
			}
			comm_stage = 1;
			if (kk) {
				comm_txt = string_replace(s_str("match_OnsideKickingPlayer"), "$playername", ds_map_find_value(kk, "lname"));
			} else {
				comm_txt = string_replace(s_str("match_OnsideKicking"), "$teamname", team_name[possession]);
			}
			if (irandom(99) < chance) {
				comm_stage = 28;
			} else {
				comm_stage = 29;
			}
			break;
		case 28:
			s_sound_audience_fg();
			down = 1;
			yards = 10;
			scrimmage += irandom_range(10, 15);
			s_subtract_time(3, 4, "COMM_STAGE_ONSIDEKICK_SUCCESS");
			comm_txt = string_replace(s_str("match_OnsideKickingSuccess"), "$teamname", team_name[possession]);
			s_change_possession();
			s_change_possession();
			last_play = 1;
			break;
		case 29:
			s_sound_audience_dis();
			down = 1;
			yards = 10;
			scrimmage += irandom_range(10, 15);
			s_subtract_time(3, 4, "COMM_STAGE_ONSIDEKICK_FAIL");
			s_change_possession();
			comm_txt = string_replace(s_str("match_OnsideKickingFail"), "$teamname", team_name[possession]);
			last_play = 1;
			break;
		case 2:
			goforit = false;
			hailmary = false;
			scored_by = -1;
			if (quarter == 5) {
				had_ot_possession[possession] = 1;
				slog("had_ot_possession[" + string(possession) + "] = 1");
			}
			if (s_is_quarter_over()) {
				s_update_commentary();
				break;
			}
			var scr = round(scrimmage);
			if (scr > 40) {
				comm_txt = s_str("comm_stage_Possession_RedZone");
			} else if (scr < -40) {
				comm_txt = s_str("comm_stage_Possession_BackedUp");
			} else if (scr >= -10 && scr <= 20) {
				comm_txt = s_str("comm_stage_Possession_Halfway");
			} else if (scr < -10) {
				comm_txt = s_str("comm_stage_Possession_OwnHalf" + string(1 + poss_txt++ mod 3));
			} else {
				comm_txt = s_str("comm_stage_Possession_OppHalf" + string(1 + poss_txt++ mod 3));
			}
			var yrd = 50 - abs(scr);
			comm_txt = string_replace(comm_txt, "$num", string(yrd));
			comm_txt = string_replace(comm_txt, "$teamname", team_name[possession]);
			comm_stage = 3;
			break;
		case 3:
			phase += 1;
			if (!s_simming_action() && (possession == obj_master.playerteamindex || obj_master.playerteamindex == -1)) {
				if ((last_play == 5 || last_play == 1) && scrimmage < -10 && phase == 1) {
					comm_gain = irandom_range(7, 15) + irandom(obj_controller.difficulty);
					comm_gain = clamp(comm_gain, 7, 30);
					scrimmage += comm_gain;
					if (comm_gain > 10) {
						comm_txt = s_str("comm_stage_PuntReturnGood");
						comm_txt = string_replace(comm_txt, "$num", comm_gain);
					} else {
						comm_txt = s_str("comm_stage_PuntReturnShort");
					}
					comm_stage = 2;
				} else {
					state = 2;
				}
			} else {
				comm_stage = 4;
				if (possession != human_team) {
					with (obj_master) {
						var def_roster = obj_controller.team_roster[!obj_controller.possession ? 1 : 0];
						if (def_roster != -4) {
							for (var i = 0; i < ds_list_size(def_roster); i++) {
								var pmap = ds_list_find_value(def_roster, i);
								if (ds_map_exists(pmap, "backup") && ds_map_find_value(pmap, "backup") == true) {
									continue;
								}
								if (ds_map_find_value(pmap, "condition") > 0 && !s_player_benched(pmap)) {
									switch (ds_map_find_value(pmap, "position")) {
										case 6:
										case 7:
											if (random(4) < random(s_get_attribute(pmap, "skill"))) {
												ds_map_set_post(pmap, "stat_tackles", ds_map_find_value(pmap, "stat_tackles") + 1);
											}
											break;
										case 9:
										case 8:
											if (random(6) < random(s_get_attribute(pmap, "skill"))) {
												ds_map_set_post(pmap, "stat_tackles", ds_map_find_value(pmap, "stat_tackles") + 1);
											}
											break;
									}
								}
							}
						}
					}
				}
				s_update_commentary();
			}
			break;
		case 24:
			goforit = true;
			comm_txt = s_str("comm_stage_GoForIt");
			comm_txt = string_replace(comm_txt, "$teamname", team_name[possession]);
			comm_stage = 4;
			break;
		case 4:
			scored_by = -1;
			switch (irandom(2)) {
				case 0:
					runorpass = 1;
					break;
				case 1:
				case 2:
					runorpass = 2;
					break;
			}
			if (team_score[possession] >= team_score[possession]) {
				if (s_last_secs_of_half(45) && !irandom(4)) {
					runorpass = 1;
				}
			} else if (s_last_secs_of_half(60) && !irandom(4) && scrimmage > 25) {
				runorpass = 2;
			}
			comm_gain = irandom_range(20, 35);
			if (s_last_secs_of_half(30)) {
				runorpass = 2;
				comm_txt = string_replace(s_str("comm_stage_DrivePass" + string(irandom(4))), "$teamname", team_name[possession]);
				if (scrimmage < 10 && (quarter == 4 && team_score[!possession ? 1 : 0] >= team_score[possession] - 6 || quarter == 2 && team_score[!possession ? 1 : 0] >= team_score[possession] - 14)) {
					comm_txt = string_replace(s_str("comm_stage_DriveHailMary" + string(irandom(2))), "$teamname", team_name[possession]);
					comm_gain += 5 + irandom(30);
					hailmary = true;
					s_subtract_time(21, 22, "comm_stage_DriveHailMary");
				} else if (scrimmage > 5 && team_score[possession] >= team_score[!possession ? 1 : 0] - 3) {
					comm_stage = 6;
					s_update_commentary();
					break;
				}
			} else {
				switch (runorpass) {
					case 1:
						comm_txt = string_replace(s_str("comm_stage_DriveRun" + string(irandom(4))), "$teamname", team_name[possession]);
						break;
					case 2:
						comm_txt = string_replace(s_str("comm_stage_DrivePass" + string(irandom(4))), "$teamname", team_name[possession]);
						break;
				}
			}
			if (scrimmage < -40) {
				if (runorpass == 1) {
					s_subtract_time(15, 20, "Get out of red-zone RUN");
				} else {
					s_subtract_time(10, 15, "Get out of red-zone PASS");
				}
				scrimmage += comm_gain;
				comm_stage = 2;
				break;
			}
			comm_defender = -4;
			var def_roster = obj_controller.team_roster[!possession ? 1 : 0];
			if (def_roster != -4 && irandom(1 + s_count_defenders(def_roster))) {
				if (hailmary) {
					comm_defender = s_get_random_player_by_position_from_roster(false, 8, def_roster);
				} else {
					comm_defender = s_get_random_player_by_position_from_roster(false, choose(6, 7, choose(8, 9)), def_roster);
				}
				if (comm_defender == -4) {
					comm_defender = s_get_random_player_by_position_from_roster(false, choose(6, 7, choose(8, 9)), def_roster);
				}
			}
			var rat_defense = 0;
			var rat_offense = 0;
			var boost_defense = 0;
			var boost_offense = 0;
			if (possession == human_team) {
				if (!global.exhibition) {
					comm_defender = -1;
				}
				rat_defense = team_defense[!human_team ? 1 : 0];
				rat_offense = team_offense[human_team] + 5;
				if (obj_master.op_difficulty == 4) {
					rat_defense = 10;
				}
			} else {
				rat_defense = team_defense[human_team];
				rat_offense = team_offense[!human_team ? 1 : 0];
				if (obj_master.op_difficulty == 4) {
					rat_offense = 10;
				}
				boost_defense = round(clamp(obj_controller.difficulty, 0, 10) * 0.3);
				boost_offense = 1;
				if (team_score[!human_team ? 1 : 0] > team_score[human_team] + 7 || obj_controller.difficulty > 7) {
					boost_offense = 0;
				}
				if (obj_controller.difficulty < 1) {
					boost_offense++;
				}
				if (obj_master.op_difficulty == 4) {
					boost_offense += 0.6;
				} else if (obj_controller.difficulty == -5) {
					boost_offense += random_range(0.1, 0.5);
				}
			}
			if (goforit) {
				boost_offense = 0;
				rat_offense *= 0.7;
			}
			var result_offense = boost_offense + random(rat_offense);
			var result_defense = boost_defense + random(max(2, rat_defense));
			if (comm_defender) {
				slog(">>>>>>>>>>>>>>>>>>>>>>> comm_defender = " + ds_map_find_value(comm_defender, "lname"));
				s_subtract_time(7, 12, "COMM_STAGE_DRIVE_1");
				var tmax = 1.5;
				if (obj_master.op_difficulty > 3) {
					tmax = 1;
				}
				var teamskl = min(s_get_defense_attribute("skill", def_roster) * 0.05, tmax);
				var teamspd = min(s_get_defense_attribute("speed", def_roster) * 0.05, tmax);
				var teamstr = min(s_get_defense_attribute("strength", def_roster) * 0.05, tmax);
				var def_skill = random(teamskl + s_get_attribute(comm_defender, "skill"));
				var def_speed = random(teamspd + s_get_attribute(comm_defender, "speed"));
				var def_strength = random(teamstr + s_get_attribute(comm_defender, "strength"));
				if (random(s_get_attribute(comm_defender, "stamina")) < random(9)) {
					switch (irandom(2)) {
						case 0:
							def_skill = max(def_skill - 1, 1);
							break;
						case 1:
							def_speed = max(def_speed - 1, 1);
							break;
						case 2:
							def_strength = max(def_strength - 1, 1);
							break;
					}
				}
				switch (irandom(2)) {
					case 0:
						slog("Skill of " + string(s_get_attribute(comm_defender, "skill")) + " = r" + string(def_skill));
						if (result_offense < def_skill) {
							if (irandom(2)) {
								comm_stage = 23;
							} else {
								comm_stage = 8;
							}
						} else {
							comm_stage = 19;
						}
						break;
					case 1:
						slog("Strength of " + string(s_get_attribute(comm_defender, "strength")) + " = r" + string(def_strength));
						if (result_offense < def_strength) {
							if (irandom(3)) {
								comm_stage = 23;
							} else {
								comm_stage = 8;
							}
						} else {
							comm_stage = 20;
						}
						break;
					case 2:
						slog("Speed of " + string(s_get_attribute(comm_defender, "speed")) + " = r" + string(def_speed));
						if (result_offense < def_speed) {
							if (irandom(3)) {
								comm_stage = 23;
							} else {
								comm_stage = 8;
							}
						} else {
							comm_stage = 21;
						}
						break;
				}
			} else if (result_offense > result_defense) {
				slog(">>>>>>>>>>>>>>>>>>>>>>> OFFENSE WIN: " + string(result_offense) + " > " + string(result_defense));
				if (scrimmage + comm_gain >= 50) {
					s_subtract_time(10, 15, "COMM_STAGE_DRIVE_2");
					comm_stage = 9;
				} else {
					s_subtract_time(10, 15, "COMM_STAGE_DRIVE_3");
					scrimmage += comm_gain;
					comm_stage = 2;
					if (s_simming_action() && possession == human_team) {
						switch (runorpass) {
							case 2:
								s_sim_stat_pass(comm_gain);
								break;
							case 1:
								s_sim_stat_run(comm_gain);
								break;
						}
					}
				}
			} else if (irandom(3)) {
				slog(">>>>>>>>>>>>>>>>>>>>>>> DEFENSE WIN - COMM_STAGE_INCOMPLETE: " + string(result_defense) + " > " + string(result_offense));
				s_subtract_time(5, 10, "COMM_STAGE_DRIVE_4");
				comm_stage = 23;
			} else {
				slog(">>>>>>>>>>>>>>>>>>>>>>> DEFENSE WIN - COMM_STAGE_TURNOVER: " + string(result_defense) + " > " + string(result_offense));
				s_subtract_time(5, 10, "COMM_STAGE_DRIVE_5");
				comm_stage = 8;
			}
			break;
		case 23:
			switch (runorpass) {
				case 1:
					comm_txt = s_str("comm_stage_incomplete_Run");
					if (s_simming_action() && possession == human_team) {
						s_sim_stat_run(round(comm_gain * 0.5));
					}
					break;
				case 2:
					comm_txt = s_str("comm_stage_incomplete_Pass");
					break;
			}
			if (comm_defender && ds_map_find_value(comm_defender, "position") < 8) {
				ds_map_set_post(comm_defender, "stat_tackles", ds_map_find_value(comm_defender, "stat_tackles") + 1);
			}
			if (s_is_quarter_over()) {
				s_update_commentary();
				break;
			} else if (goforit) {
				comm_stage = 8;
				s_update_commentary();
			} else {
				s_go_for_it_or_not();
			}
			break;
		case 5:
			if (s_is_quarter_over()) {
				s_update_commentary();
				break;
			}
			s_punt();
			break;
		case 6:
			scrimmage -= 4;
			var fg_dist = clamp(round(s_convert_scrimmage_to_goal_distance() + 10), 17, 63);
			comm_txt = string_replace(s_str("comm_stage_FieldGoal1"), "$num", fg_dist);
			comm_txt = string_replace(comm_txt, "$teamname", team_name[possession]);
			comm_stage = 7;
			if (s_simming_action() && possession == human_team) {
				s_sim_stat_increment(s_get_player_by_position_from_roster(10, 1, obj_controller.team_roster[possession]), "stat_attempts", 1);
			}
			s_sound_kick();
			break;
		case 7:
			s_subtract_time(4, 5, "COMM_STAGE_FIELDGOAL2");
			var fg_dist = clamp(round(s_convert_scrimmage_to_goal_distance() + 10), 17, 63);
			if (irandom(75) < irandom(fg_dist)) {
				slog("field goal missed!");
				comm_txt = s_str("comm_stage_FieldGoal2_Missed");
				s_sound_audience_dis();
				if (scrimmage > 30) {
					scrimmage = 30;
				}
				if (college_overtime) {
					s_college_overtime_handle_play_end();
					break;
				}
				s_change_possession();
				if (quarter == 5 && team_score[0] != team_score[1] && s_both_teams_had_possession()) {
					slog("Overtime win 3");
					comm_stage = 17;
					break;
				}
			} else {
				slog("field goal in! scrimmage[" + string(scrimmage) + "] fg_dist[" + string(fg_dist) + "]");
				comm_txt = s_str("comm_stage_FieldGoal2_Scored");
				s_sound_audience_fg();
				if (s_simming_action() && possession == human_team) {
					var pmap = s_get_player_by_position_from_roster(10, 1, obj_controller.team_roster[possession]);
					if (pmap) {
						s_sim_stat_increment(pmap, "stat_complete", 1);
						s_sim_stat_increment(pmap, "stat_yards", fg_dist);
						if (fg_dist > ds_map_find_value(pmap, "stat_longest")) {
							s_sim_stat_update(pmap, "stat_longest", fg_dist);
						}
					}
				}
				team_score[possession] += 3;
				if (college_overtime) {
					s_college_overtime_handle_play_end();
					break;
				}
				if (quarter == 5 && team_score[0] != team_score[1] && s_both_teams_had_possession()) {
					if (obj_master.week <= obj_master.last_week_regular) {
						if (drives > 1) {
							comm_stage = 17;
						} else {
							comm_stage = 1;
						}
					} else {
						slog("Overtime win 2");
						comm_stage = 17;
					}
					break;
				}
				comm_stage = 1;
			}
			break;
		case 8:
			if (scrimmage > 49) {
				scrimmage = 40 + irandom(9);
			}
			if (!comm_defender) {
				var simstat = s_simming_action() && possession == human_team;
				switch (runorpass) {
					case 1:
						comm_txt = string_replace(s_str("comm_stage_Turnover_Fumble"), "$teamname", team_name[possession]);
						if (simstat) {
							s_sim_stat_fumble();
						}
						break;
					case 2:
						switch (irandom(1)) {
							case 0:
								comm_txt = string_replace(s_str("comm_stage_Turnover_Interception"), "$teamname", team_name[possession]);
								if (simstat) {
									s_sim_stat_interception();
								}
								break;
							case 1:
								comm_txt = string_replace(s_str("comm_stage_Turnover_Sack"), "$teamname", team_name[possession]);
								if (simstat) {
									s_sim_stat_sack();
								}
								break;
						}
						break;
				}
				s_change_possession();
				s_check_win_after_turnover();
			} else {
				switch (runorpass) {
					case 1:
						var fumble = irandom(1);
						if (!fumble) {
							comm_txt = s_str("comm_stage_Turnover_Tackle" + string(1 + irandom(1)));
							comm_txt = string_replace(comm_txt, "$playername", ds_map_find_value(comm_defender, "lname"));
							comm_txt = string_replace(comm_txt, "$pos", s_get_string_position(ds_map_find_value(comm_defender, "position")));
							ds_map_set_post(comm_defender, "stat_tackles", ds_map_find_value(comm_defender, "stat_tackles") + 1);
							if (goforit || quarter == 5) {
								s_change_possession();
								s_check_win_after_turnover();
							} else {
								comm_stage = 5;
								if (scrimmage > 0) {
									comm_stage = 6;
								}
							}
						} else {
							var punch = irandom(1);
							comm_txt = s_str("comm_stage_Turnover_Fumble" + string(1 + punch));
							comm_txt = string_replace(comm_txt, "$playername", ds_map_find_value(comm_defender, "lname"));
							comm_txt = string_replace(comm_txt, "$pos", s_get_string_position(ds_map_find_value(comm_defender, "position")));
							ds_map_set_post(comm_defender, "stat_tackles", ds_map_find_value(comm_defender, "stat_tackles") + 1);
							ds_map_set_post(comm_defender, "stat_fumbles", ds_map_find_value(comm_defender, "stat_fumbles") + 1);
							s_change_possession();
							s_check_win_after_turnover();
						}
						break;
					case 2:
						var sack = false;
						if (ds_map_find_value(comm_defender, "position") == 6) {
							sack = true;
						}
						if (irandom(1) && ds_map_find_value(comm_defender, "position") == 7) {
							sack = true;
						}
						if (sack) {
							comm_txt = s_str("comm_stage_Turnover_Sack" + string(1 + irandom(1)));
							comm_txt = string_replace(comm_txt, "$playername", ds_map_find_value(comm_defender, "lname"));
							comm_txt = string_replace(comm_txt, "$pos", s_get_string_position(ds_map_find_value(comm_defender, "position")));
							ds_map_set_post(comm_defender, "stat_tackles", ds_map_find_value(comm_defender, "stat_tackles") + 1);
							ds_map_set_post(comm_defender, "stat_sacks", ds_map_find_value(comm_defender, "stat_sacks") + 1);
							if (goforit || quarter == 5) {
								s_change_possession();
								s_check_win_after_turnover();
							} else {
								comm_stage = 5;
								if (scrimmage > 0) {
									comm_stage = 6;
								}
							}
						} else {
							comm_txt = s_str("comm_stage_Turnover_Interception" + string(1 + irandom(1)));
							comm_txt = string_replace(comm_txt, "$playername", ds_map_find_value(comm_defender, "lname"));
							comm_txt = string_replace(comm_txt, "$pos", s_get_string_position(ds_map_find_value(comm_defender, "position")));
							ds_map_set_post(comm_defender, "stat_int", ds_map_find_value(comm_defender, "stat_int") + 1);
							s_change_possession();
							s_check_win_after_turnover();
						}
				}
			}
			comm_defender = -4;
			break;
		case 9:
			scrimmage += comm_gain;
			slog("COMM_STAGE_TOUCHDOWN scrimmage[" + string(scrimmage) + "] after com_gain[" + string(comm_gain) + "]");
			comm_txt = "";
			comm_stage = 10;
			team_score[possession] += 6;
			scored_by = possession;
			s_create_match_message(6);
			s_sound_audience_fg();
			if (s_simming_action() && possession == human_team) {
				s_sim_stat_touchdown(runorpass, comm_gain);
			}
			if (college_overtime) {
			} else if (quarter == 5 && team_score[possession] > team_score[!possession ? 1 : 0] && s_both_teams_had_possession()) {
				slog("overtime win TOUCHDOWN");
				comm_stage = 17;
			}
			break;
		case 10:
			var pt2 = false;
			var margin = team_score[possession] - team_score[!possession ? 1 : 0];
			if (abs(margin) mod 8 == 0) {
				pt2 = true;
			}
			if (margin == 1 || margin == 5 || margin == 12 || margin == -2 || margin == -4 || margin == -5 || margin == -8 || margin == -10 || margin == -13 || margin == -15) {
				pt2 = true;
			}
			if (quarter > 2 && (margin == 7 || margin == 14 || margin == -9 || margin == -12) && !irandom(2)) {
				pt2 = true;
			}
			if (margin == 0) {
				pt2 = false;
			}
			switch (margin) {
				case -1:
					pt2 = false;
					break;
				case -2:
					pt2 = true;
					break;
				case -3:
					pt2 = false;
					break;
				case -4:
					pt2 = false;
					break;
				case -5:
					pt2 = true;
					break;
				case -6:
					pt2 = false;
					break;
				case -7:
					pt2 = false;
					break;
				case -8:
					pt2 = false;
					break;
				case -9:
					pt2 = true;
					break;
				case -10:
					pt2 = true;
					break;
				case -11:
					pt2 = false;
					break;
				case -12:
					pt2 = true;
					break;
				case -13:
					pt2 = false;
					break;
				case -14:
					pt2 = false;
					break;
				case -15:
					pt2 = false;
					break;
				case -16:
					pt2 = true;
					break;
				case -17:
					pt2 = false;
					break;
				case -18:
					pt2 = false;
					break;
				case -19:
					pt2 = true;
					break;
				case -20:
					pt2 = false;
					break;
				case 1:
					pt2 = true;
					break;
				case 2:
					pt2 = false;
					break;
				case 3:
					pt2 = false;
					break;
				case 4:
					pt2 = true;
					break;
				case 5:
					pt2 = true;
					break;
				case 6:
					pt2 = false;
					break;
				case 7:
					pt2 = false;
					break;
				case 8:
					pt2 = false;
					break;
				case 9:
					pt2 = false;
					break;
				case 10:
					pt2 = false;
					break;
				case 11:
					pt2 = false;
					break;
				case 12:
					pt2 = true;
					break;
				case 13:
					pt2 = false;
					break;
				case 14:
					pt2 = false;
					break;
				case 15:
					pt2 = true;
					break;
				case 16:
					pt2 = false;
					break;
				case 17:
					pt2 = false;
					break;
				case 18:
					pt2 = false;
					break;
				case 19:
					pt2 = true;
					break;
				case 20:
					pt2 = false;
					break;
			}
			if (college_overtime && college_overtime_round >= 2) {
				slog("college_overtime force PAT to be pt2, since it's round[" + string(college_overtime_round) + "]");
				pt2 = true;
			}
			if (pt2) {
				comm_stage = 15;
				s_update_commentary();
				break;
			}
			if (s_simming_action() && possession == human_team) {
				s_sim_stat_increment(s_get_player_by_position_from_roster(10, 1, obj_controller.team_roster[possession]), "stat_attempts_XP", 1);
			}
			comm_txt = string_replace(s_str("comm_stage_PAT1"), "$teamname", team_name[possession]);
			comm_stage = 11;
			s_sound_kick();
			break;
		case 11:
			if (!irandom(8)) {
				slog("1pt kick missed! scrimmage[" + string(scrimmage) + "]");
				comm_txt = s_str("comm_stage_PAT2_Missed");
				s_sound_audience_dis();
				scored_by = -1;
			} else {
				slog("1pt kick in! scrimmage[" + string(scrimmage) + "]!");
				if (s_simming_action() && possession == human_team) {
					s_sim_stat_increment(s_get_player_by_position_from_roster(10, 1, obj_controller.team_roster[possession]), "stat_complete_XP", 1);
				}
				comm_txt = s_str("comm_stage_PAT2_Scored");
				s_sound_audience_fg();
				team_score[possession] += 1;
				scored_by = possession;
			}
			if (college_overtime) {
				s_college_overtime_handle_play_end();
				break;
			}
			if (quarter == 5 && team_score[0] != team_score[0] && s_both_teams_had_possession()) {
				slog("Overtime win 2");
				comm_stage = 17;
				break;
			}
			comm_stage = 1;
			break;
		case 12:
			s_set_up_button_kickoff();
			comm_txt = s_str("comm_stage_end_quarter" + string(min(quarter, 4)));
			if (!college_overtime) {
				s_college_overtime_score_hack();
			}
			if (quarter == 4 || quarter >= 4 && s_no_ties_allowed()) {
				if (quarter > 4) {
					comm_txt = s_str("comm_stage_overtime_over");
				}
				if (team_score[0] == team_score[1]) {
					comm_txt = s_str("comm_stage_overtime");
				}
			}
			comm_stage = 13;
			alarm[1] = 0;
			s_sound_brass_loop(0.5);
			switch (quarter) {
				case 1:
					obj_master.qtr_scores0[quarter - 1] = team_score[0];
					obj_master.qtr_scores1[quarter - 1] = team_score[1];
					break;
				case 2:
					obj_master.qtr_scores0[quarter - 1] = team_score[0] - obj_master.qtr_scores0[0];
					obj_master.qtr_scores1[quarter - 1] = team_score[1] - obj_master.qtr_scores1[0];
					break;
				case 3:
					obj_master.qtr_scores0[quarter - 1] = team_score[0] - obj_master.qtr_scores0[0] - obj_master.qtr_scores0[1];
					obj_master.qtr_scores1[quarter - 1] = team_score[1] - obj_master.qtr_scores1[0] - obj_master.qtr_scores1[1];
					break;
				case 4:
					obj_master.qtr_scores0[quarter - 1] = team_score[0] - obj_master.qtr_scores0[0] - obj_master.qtr_scores0[1] - obj_master.qtr_scores0[2];
					obj_master.qtr_scores1[quarter - 1] = team_score[1] - obj_master.qtr_scores1[0] - obj_master.qtr_scores1[1] - obj_master.qtr_scores1[2];
					if (team_score[human_team] != team_score[!human_team ? 1 : 0]) {
						_poki_gameplay_stop();
					}
					break;
			}
			quarter++;
			if (quarter == 3 || quarter == 5) {
				s_set_audibles(-1);
			}
			var tos = clamp(2 + obj_master.op_matchlength, 2, 3);
			if (quarter == 3) {
				s_set_timeouts(tos);
			}
			if (quarter == 5) {
				s_set_timeouts(2);
			}
			if (obj_master.year == 1 && !global.exhibition) {
				s_set_timeouts(0);
			}
			if (quarter != 3) {
				s_switch_drivedirection();
				if (global.poki && !_poki_is_mobile() && quarter < 5) {
					poki_pause();
					poki_commercial_break(poki_resume, "poki_commercial_break");
				}
			}
			break;
		case 13:
			with (obj_controller) {
				skip_half = false;
				minutes = 2 + obj_master.op_matchlength;
				seconds = 0;
				time_subtract = 0;
			}
			switch (quarter) {
				case 2:
					comm_stage = comm_next_stage;
					s_update_commentary();
					break;
				case 3:
					comm_stage = 1;
					possession = !kickoffteam;
					s_update_commentary();
					break;
				case 4:
					comm_stage = comm_next_stage;
					s_update_commentary();
					break;
				case 5:
					comm_txt = "";
					if (team_score[human_team] > team_score[!human_team ? 1 : 0]) {
						s_end_match(1);
						return;
					}
					if (team_score[human_team] < team_score[!human_team ? 1 : 0]) {
						s_end_match(-1);
						return;
					}
					comm_stage = 1;
					possession = !human_team;
					switch (obj_master.op_difficulty) {
						case 1:
							break;
						case 0:
							if (obj_master.suppress_difficulty > 0) {
								break;
							}
						case 2:
						case 3:
							if (!irandom(2)) {
								possession = human_team;
							}
							break;
						case 4:
							if (!irandom(1)) {
								possession = human_team;
							}
							break;
					}
					if (s_is_co_mode() && !college_overtime) {
						s_college_overtime_start();
					}
					drives = 0;
					s_update_commentary();
					break;
				case 6:
					slog("End of OT: quarter == 6");
					if (obj_master.week <= obj_master.last_week_regular && !global.exhibition && !college_overtime) {
						if (team_score[human_team] > team_score[!human_team ? 1 : 0]) {
							s_end_match(1);
							return;
						} else if (team_score[human_team] < team_score[!human_team ? 1 : 0]) {
							s_end_match(-1);
							return;
						} else {
							s_end_match(0);
							return;
						}
					}
					quarter = 5;
					ot_count++;
					comm_stage = comm_next_stage;
					s_update_commentary();
					break;
			}
			break;
		case 14:
			state = 2;
			alarm[1] = 1;
			break;
		case 15:
			comm_txt = string_replace(s_str("comm_stage_2pt_attempt" + (obj_master.qb_mode ? "QB" : "")), "$teamname", team_name[possession]);
			comm_stage = 16;
			break;
		case 16:
			if (!s_simming_action() && possession == human_team) {
				state = 2;
				down = 6;
				break;
			}
			if (irandom(99) > 60) {
				slog("2pt touchdown failed! scrimmage[" + string(scrimmage) + "]");
				comm_txt = s_str("comm_stage_2pt_missed");
				scored_by = -1;
			} else {
				slog("2pt touchdown success! scrimmage[" + string(scrimmage) + "]");
				comm_txt = s_str("comm_stage_2pt_scored");
				team_score[possession] += 2;
				scored_by = possession;
			}
			if (college_overtime) {
				obj_controller.had_ot_possession[possession] = 1;
				s_college_overtime_handle_play_end();
				break;
			}
			if (quarter == 5 && team_score[0] != team_score[0] && s_both_teams_had_possession()) {
				slog("Overtime win 2pt fail");
				comm_stage = 17;
				break;
			}
			comm_stage = 1;
			break;
		case 17:
			s_set_up_button_kickoff();
			comm_txt = s_str("comm_stage_overtime_over");
			comm_stage = 18;
			alarm[1] = 0;
			s_sound_brass_loop(0.5);
			break;
		case 18:
			comm_txt = "";
			if (team_score[human_team] > team_score[!human_team ? 1 : 0]) {
				s_end_match(1);
				return;
			}
			if (team_score[human_team] < team_score[!human_team ? 1 : 0]) {
				s_end_match(-1);
				return;
			}
			if (s_no_ties_allowed()) {
				quarter = 5;
				comm_stage = comm_next_stage;
				s_update_commentary();
			} else {
				s_end_match(0);
				return;
			}
			break;
		case 19:
			scrimmage += comm_gain;
			s_tackle_failure();
			comm_txt = s_str("comm_stage_failed_skill");
			comm_txt = string_replace(comm_txt, "$playername", ds_map_find_value(comm_defender, "lname"));
			comm_txt = string_replace(comm_txt, "$pos", s_get_string_position(ds_map_find_value(comm_defender, "position")));
			comm_defender = -4;
			if (scrimmage >= 50) {
				comm_stage = 9;
			} else {
				comm_stage = 2;
			}
			break;
		case 20:
			scrimmage += comm_gain;
			s_tackle_failure();
			comm_txt = s_str("comm_stage_failed_strength");
			comm_txt = string_replace(comm_txt, "$playername", ds_map_find_value(comm_defender, "lname"));
			comm_txt = string_replace(comm_txt, "$pos", s_get_string_position(ds_map_find_value(comm_defender, "position")));
			comm_defender = -4;
			if (scrimmage >= 50) {
				comm_stage = 9;
			} else {
				comm_stage = 2;
			}
			break;
		case 21:
			scrimmage += comm_gain;
			s_tackle_failure();
			comm_txt = s_str("comm_stage_failed_speed");
			comm_txt = string_replace(comm_txt, "$playername", ds_map_find_value(comm_defender, "lname"));
			comm_txt = string_replace(comm_txt, "$pos", s_get_string_position(ds_map_find_value(comm_defender, "position")));
			comm_defender = -4;
			if (scrimmage >= 50) {
				comm_stage = 9;
			} else {
				comm_stage = 2;
			}
			break;
		case 22:
			if (down == 5) {
				comm_txt = string_replace(s_str("comm_stage_TurnoverHuman4th"), "$teamname", team_name[possession]);
			} else {
				comm_txt = string_replace(s_str("comm_stage_TurnoverHuman"), "$teamname", team_name[possession]);
			}
			s_change_possession();
			break;
		case 30:
			break;
	}
}

function s_go_for_it_or_not() {
	if (scrimmage > 0) {
		comm_stage = 6;
	} else {
		comm_stage = 5;
	}
	var downby = team_score[!possession ? 1 : 0] - team_score[possession];
	if (quarter == 5) {
		if (scrimmage > 10 && downby < 4) {
			comm_stage = 6;
		} else {
			comm_stage = 24;
		}
		return;
	}
	if (downby > 16 && scrimmage < 0) {
		return;
	}
	if (quarter == 4 && downby > 7) {
		if (scrimmage > 10 && downby > 8 && downby < 12) {
			comm_stage = 6;
		} else {
			comm_stage = 24;
		}
		return;
	}
	if (s_last_secs_of_half(60) && downby > 0 && downby < 9) {
		comm_stage = 24;
	}
}

function s_check_skip_time_button() {
	if (obj_controller.skip_half) {
		return;
	}
	with (obj_btn_skiptime) {
		return;
	}
	var bx = display_get_gui_width() - 16 - sprite_get_width(spr_fieldgoalbtn);
	var by = display_get_gui_height() - 16 - sprite_get_height(spr_fieldgoalbtn);
	var btn_skiptime = instance_create_layer(bx, by, "Text", obj_btn_skiptime);
	btn_skiptime.gp_mapped_button = global.gp_timeout;
}

function btn_skip_time() {
	obj_controller.skip_half = true;
	obj_controller.comm_proceed = true;
	with (obj_btn_skiptime) {
		instance_destroy();
	}
}

function s_no_ties_allowed() {
	return obj_master.week > obj_master.last_week_regular || global.exhibition || s_is_co_mode();
}

function roster_short_desc(_arg0) {
	if (_arg0 == -4) {
		return "No Roster";
	}
	if (ds_list_size(_arg0) == 0) {
		return "Empty Roster";
	}
	return "Roster of [" + string(ds_list_size(_arg0)) + "] players";
}

function roster_short_desc_tag(_arg0, _arg1) {
	if (_arg0 == -4) {
		return _arg1 + ": No Roster";
	}
	if (ds_list_size(_arg0) == 0) {
		return _arg1 + ": Empty Roster";
	}
	return _arg1 + ": Roster of [" + string(ds_list_size(_arg0)) + "] players";
}

function slog_roster(_arg0, _arg1) {
	if (obj_controller.team_roster[_arg1] == -4) {
		slog("ROSTER[" + string(_arg1) + "] " + _arg0 + ": No roster");
		return;
	}
	var cur_roster = obj_controller.team_roster[_arg1];
	var size = ds_list_size(cur_roster);
	if (size == 0) {
		slog("ROSTER[" + string(_arg1) + "] " + _arg0 + ": Valid, but empty");
		return;
	}
	var dispCount = min(size, 3);
	var playersStr = "";
	for (i = 1; i < dispCount; i += 1) {
		var pmap = ds_list_find_value(cur_roster, i);
		playersStr += ds_map_find_value(pmap, "lname") + ",";
	}
	playersStr += "...";
	slog("ROSTER[" + string(_arg1) + "] " + _arg0 + ": Valid, [" + string(size) + "] entries: " + playersStr);
}

function slog_master_roster(_arg0) {
	if (obj_master.roster == -4) {
		slog("ROSTER[MASTER] " + _arg0 + ": No roster");
		return;
	}
	var size = ds_list_size(obj_master.roster);
	if (size == 0) {
		slog("ROSTER[MASTER] " + _arg0 + ": Valid, but empty");
		return;
	}
	var dispCount = min(size, 3);
	var playersStr = "";
	for (i = 1; i < dispCount; i += 1) {
		var pmap = ds_list_find_value(obj_master.roster, i);
		playersStr += ds_map_find_value(pmap, "lname") + ",";
	}
	playersStr += "...";
	slog("ROSTER[MASTER] " + _arg0 + ": Valid, [" + string(size) + "] entries: " + playersStr);
}

