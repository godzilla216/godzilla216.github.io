function s_set_skills_and_skin() {
	var skin = irandom(2);
	if (irandom(9) > 1) {
		skin = 0;
	}
	var team_offense = 1;
	var oc = s_get_staff(102);
	if (oc) {
		team_offense = clamp(real(ds_map_find_value(oc, "rating") * 0.5), 1, 5);
	}
	var team_defense = obj_controller.team_defense[!obj_controller.human_team ? 1 : 0] - obj_controller.difficulty;
	if (obj_master.op_difficulty == 4) {
		team_defense = 15;
	}
	team_defense = clamp(team_defense, 2, 15);
	var specialteams = 1;
	var dc = s_get_staff(101);
	if (dc) {
		specialteams = clamp(real(ds_map_find_value(oc, "rating") * 0.5), 1, 5);
	}
	var te_blockers = 0;
	with (obj_player) {
		if (te_blocking) {
			te_blockers++;
		} else if (pmap && ds_map_find_value(pmap, "position") == 5) {
			te_blockers++;
		}
	}
	pmap = -4;
	var attack_roster = obj_controller.team_roster[obj_controller.possession];
	var defense_roster = obj_controller.team_roster[!obj_controller.possession ? 1 : 0];
	if (!s_is_kickoff(false)) {
		if (offense) {
			switch (inum) {
				case 1:
					if (obj_controller.kicking) {
						pmap = s_get_player_by_position_from_roster(10, 1, attack_roster);
					} else {
						pmap = s_get_player_by_position_from_roster(1, 1, attack_roster);
					}
					break;
				case 2:
					pmap = s_get_player_by_position_from_roster(position, 1, attack_roster);
					break;
				case 9:
					if (obj_controller.quarter == 1 || obj_controller.quarter == 4) {
						pmap = s_get_player_by_position_from_roster(position, 1, attack_roster);
					} else {
						pmap = s_get_player_by_position_from_roster(position, 2, attack_roster);
					}
					break;
				case 11:
					if (obj_controller.quarter == 1 || obj_controller.quarter == 4) {
						pmap = s_get_player_by_position_from_roster(position, 2, attack_roster);
					} else {
						pmap = s_get_player_by_position_from_roster(position, 1, attack_roster);
					}
					break;
				case 10:
					if (s_count_players_onfield_by_position(3, attack_roster) == 1) {
						if (!te_blocking) {
							pmap = s_get_player_by_position_from_roster(position, 1, attack_roster);
						}
					} else if (obj_controller.quarter == 1 || obj_controller.quarter == 4) {
						pmap = s_get_player_by_position_from_roster(position, 1, attack_roster);
					} else {
						pmap = s_get_player_by_position_from_roster(position, 2, attack_roster);
					}
					break;
				case 8:
					if (s_count_players_onfield_by_position(3, attack_roster) == 1) {
						pmap = s_get_player_by_position_from_roster(position, 1, attack_roster);
						with (obj_player) {
							if (inum == 10 && pmap) {
								other.pmap = -4;
							}
						}
					} else if (obj_controller.quarter == 1 || obj_controller.quarter == 4) {
						pmap = s_get_player_by_position_from_roster(position, 2, attack_roster);
					} else {
						pmap = s_get_player_by_position_from_roster(position, 1, attack_roster);
					}
					break;
				case 3:
					pmap = s_get_player_by_position_from_roster(position, 3, attack_roster);
					break;
				case 4:
					pmap = s_get_player_by_position_from_roster(position, 1, attack_roster);
					break;
				case 5:
					pmap = s_get_player_by_position_from_roster(position, 2, attack_roster);
					break;
				case 6:
					pmap = s_get_player_by_position_from_roster(position, 4, attack_roster);
					break;
				case 7:
					pmap = s_get_player_by_position_from_roster(position, 5, attack_roster);
					break;
			}
		}
	} else if (position == 14) {
		slog("POS RETURNER :");
		if (offense) {
			pmap = s_get_player_kick_returner(defense_roster);
		} else {
			pmap = s_get_player_kick_returner(attack_roster);
		}
	}
	if (body_type == -1) {
		var body_pmap = pmap;
		if (offense && s_is_kickoff(false) && body_pmap == -4) {
			switch (inum) {
				case 1:
					body_pmap = s_get_player_by_position_from_roster(1, 1, attack_roster);
					break;
				case 2:
					body_pmap = s_get_player_by_position_from_roster(2, 1, attack_roster);
					break;
				case 9:
					body_pmap = s_get_player_by_position_from_roster(4, 1, attack_roster);
					break;
				case 11:
					body_pmap = s_get_player_by_position_from_roster(4, 2, attack_roster);
					break;
				case 10:
					body_pmap = s_get_player_by_position_from_roster(3, 1, attack_roster);
					break;
				case 8:
					body_pmap = s_get_player_by_position_from_roster(3, 2, attack_roster);
					break;
				case 3:
					body_pmap = s_get_player_by_position_from_roster(5, 3, attack_roster);
					break;
				case 4:
					body_pmap = s_get_player_by_position_from_roster(5, 1, attack_roster);
					break;
				case 5:
					body_pmap = s_get_player_by_position_from_roster(5, 2, attack_roster);
					break;
				case 6:
					body_pmap = s_get_player_by_position_from_roster(5, 4, attack_roster);
					break;
				case 7:
					body_pmap = s_get_player_by_position_from_roster(5, 5, attack_roster);
					break;
			}
		}
		body_type = s_get_player_body_type(offense, body_pmap, team_defense);
	}
	if (pmap) {
		name = true;
	} else {
	}
	if (global.exhibition) {
		team_offense = obj_controller.team_offense[obj_controller.possession];
		team_defense = obj_controller.team_defense[!obj_controller.possession ? 1 : 0];
	}
	s_set_anim(0);
	switch (position) {
		case 12:
			team_defense = min(team_defense, 10);
			collsize = 10;
			strength = random_range(2.1, 2.5) + 0.1 * random(team_defense);
			my_tackle_limit = (21 + team_defense) * irandom_range(3, 5);
			my_accel = 0.065 + random_range(0.03, 0.04) + 0.002 * team_defense;
			stamina = clamp(team_defense - irandom(2), 1, 8);
			s_set_anim(1);
			break;
		case 13:
			collsize = 10;
			strength = 2.5 + 0.1 * random(specialteams);
			my_tackle_limit = (21 + team_defense) * irandom_range(3, 5);
			my_accel = 0.065 + random_range(0.03, 0.04) + 0.002 * specialteams;
			stamina = clamp(specialteams - irandom(2), 1, 8);
			break;
		case 14:
			collsize = 10;
			strength = 2.5 + 0.1 * team_defense;
			my_tackle_limit = 20 + specialteams;
			my_accel = 0.10500000000000001 + 0.002 * specialteams;
			stamina = clamp(specialteams - irandom(2), 1, 8);
			stiff_arm = 0;
			jumps = 0;
			if (pmap) {
				strength = 1 + 0.2 * s_get_attribute(pmap, "strength");
				my_accel = 0.10500000000000001 + 0.002 * s_get_attribute(pmap, "speed");
				if (irandom(15) < s_get_attribute(pmap, "strenth")) {
					stiff_arm++;
				}
				if (irandom(15) < s_get_attribute(pmap, "speed")) {
					jumps++;
				}
			} else {
				switch (irandom(1)) {
					case 0:
						stiff_arm = irandom(1);
						break;
					case 1:
						jumps = irandom(1);
						break;
				}
			}
			break;
		case 1:
			collsize = 5;
			if (pmap != -4) {
				strength = 1 + 0.1 * s_get_attribute(pmap, "strength");
				my_accel = 0.095 + 0.002 * s_get_attribute(pmap, "speed");
				skill = s_get_attribute(pmap, "skill");
				obj_controller.route_alpha = 1 + s_get_attribute(pmap, "strength");
				if (!obj_controller.kicking && s_count_audibles() < 0) {
					obj_controller.audibles = s_get_num_audibles(pmap);
				}
			} else {
				strength = 1 + 0.1 * team_offense;
				my_accel = 0.065 + 0.002 * team_offense;
				skill = 1;
				if (!obj_controller.kicking && s_count_audibles() < 0) {
					if (global.exhibition) {
						s_set_audibles(3);
					} else if (obj_master.year > 1) {
						s_set_audibles(1);
					}
				}
			}
			s_set_anim(0);
			break;
		case 11:
			s_set_anim(13);
		case 10:
			collsize = 5;
			if (pmap != -4) {
				strength = 1 + 0.1 * s_get_attribute(pmap, "strength");
				my_accel = 0.045 + 0.002 * s_get_attribute(pmap, "speed");
				skill = s_get_attribute(pmap, "skill");
			} else {
				skill = 1;
				strength = 1 + 0.1 * team_defense;
				my_accel = 0.045 + 0.002 * team_defense;
			}
			break;
		case 5:
			collsize = 10;
			var str = 4.75 + te_blockers * 0.85;
			var tacklimit = 20 + obj_controller.difficulty + 5.5 * te_blockers;
			if (pmap) {
				strength = str + 0.4 * s_get_attribute(pmap, "strength");
				my_accel = 0.055 + 0.002 * s_get_attribute(pmap, "speed");
				my_tackle_limit = (tacklimit + s_get_attribute(pmap, "skill")) * 5;
			} else {
				strength = str + 0.1 * obj_controller.team_offense[obj_controller.human_team];
				my_accel = 0.035 + 0.002 * obj_controller.team_offense[obj_controller.human_team];
				my_tackle_limit = tacklimit * irandom_range(3, 4);
			}
			s_set_anim(1);
			break;
		case 3:
			if (pmap) {
				my_tackle_limit = (20 + obj_controller.difficulty + s_get_attribute(pmap, "skill")) * 4;
				my_accel = 0.095 + 0.002 * s_get_attribute(pmap, "speed");
			} else {
				my_tackle_limit = (20 + obj_controller.difficulty) * irandom_range(2, 3);
			}
		case 2:
			collsize = 5;
			if (pmap != -4) {
				strength = 2 + 0.1 * s_get_attribute(pmap, "strength");
				if (position == 2) {
					my_accel = 0.10500000000000001 + 0.002 * s_get_attribute(pmap, "speed");
				}
				skill = s_get_attribute(pmap, "skill");
				stiff_arm = irandom(1);
				if (stiff_arm == 0 && s_get_attribute(pmap, "strength") >= 6) {
					stiff_arm = 1;
				}
				if (irandom(10) < s_get_attribute(pmap, "strength")) {
					stiff_arm++;
				}
				jumps = irandom(1);
				if (irandom(10) < s_get_attribute(pmap, "speed")) {
					jumps++;
				}
				if (jumps == 0 && s_get_attribute(pmap, "speed") >= 10) {
					jumps++;
				}
				if (position == 2 && obj_controller.defensive_cover == 0) {
					stiff_arm -= irandom(1);
					jumps -= irandom(1);
				} else if (ds_map_find_value(pmap, "age") - s_rookie_age_internal() < irandom(10)) {
					switch (irandom(1)) {
						case 0:
							stiff_arm--;
							break;
						case 1:
							jumps--;
							break;
					}
				}
			} else {
				strength = 2 + 0.1 * team_offense;
				my_accel = 0.09 + 0.002 * team_offense;
				skill = 1;
				stiff_arm = irandom(1);
				jumps = irandom(1);
				if (global.exhibition) {
					my_accel = 0.1 + 0.002 * team_offense;
					skill = team_offense;
					stiff_arm += irandom(1);
					jumps += irandom(1);
				} else if (obj_master.op_difficulty == 4) {
					stiff_arm = 0;
					jumps = 0;
				}
			}
			var max_stiff = 2;
			if (obj_controller.difficulty < 0 && !global.exhibition) {
				max_stiff = 1;
			}
			stiff_arm = clamp(stiff_arm - irandom(1), 0, max_stiff);
			jumps = clamp(jumps - irandom(1), 0, max_stiff);
			if (irandom(9)) {
				skin = 0;
			}
			break;
		case 4:
			collsize = 2.5;
			if (pmap) {
				strength = 1 + 0.2 * s_get_attribute(pmap, "strength");
				my_accel = 0.115 + 0.002 * s_get_attribute(pmap, "speed");
				skill = s_get_attribute(pmap, "skill");
				stiff_arm = irandom(1);
				if (irandom(11) < s_get_attribute(pmap, "strength")) {
					stiff_arm++;
				}
				if (stiff_arm == 0 && s_get_attribute(pmap, "strength") >= 10) {
					stiff_arm++;
				}
				jumps = irandom(1);
				if (irandom(11) < s_get_attribute(pmap, "speed")) {
					jumps++;
				}
				if (jumps == 0 && s_get_attribute(pmap, "speed") >= 10) {
					jumps++;
				}
				if (ds_map_find_value(pmap, "age") - s_rookie_age_internal() < irandom(10)) {
					switch (irandom(1)) {
						case 0:
							stiff_arm--;
							break;
						case 1:
							jumps--;
							break;
					}
				}
			} else {
				strength = 1 + 0.2 * team_offense;
				my_accel = 0.10500000000000001 + 0.002 * team_offense;
				skill = 1;
				stiff_arm = irandom(1);
				jumps = irandom(1);
				if (global.exhibition) {
					my_accel = 0.115 + 0.002 * team_offense;
					skill = team_offense;
					stiff_arm += irandom(1);
					jumps += irandom(1);
				} else if (obj_master.op_difficulty == 4) {
					stiff_arm = 0;
					jumps = 0;
				}
			}
			if (!global.exhibition) {
				if (obj_controller.difficulty < 2) {
					stiff_arm -= 1;
					jumps -= 1;
				} else if (obj_controller.difficulty < 5) {
					stiff_arm -= irandom(1);
					jumps -= irandom(1);
				}
			}
			if (stiff_arm < 0) {
				stiff_arm = 0;
			}
			if (jumps < 0) {
				jumps = 0;
			}
			if (irandom(9)) {
				skin = 0;
			}
			break;
		case 6:
			if (obj_controller.defensive_cover == 0) {
				team_defense = clamp(team_defense + 3, 1, 10);
			}
			if (obj_controller.down == 6) {
				team_defense += 3;
			}
			collsize = 10;
			strength = 3.5 + 0.2 * team_defense;
			if (obj_master.op_difficulty >= 3) {
				strength = 4 + 0.2 * team_defense;
			}
			my_tackle_limit = (20 + team_defense) * irandom_range(3, 5);
			my_accel = 0.035 + 0.002 * team_defense;
			s_set_anim(1);
			break;
		case 7:
			if (obj_controller.defensive_cover == 0) {
				team_defense = clamp(team_defense + 3, 1, 10);
			}
			collsize = 5;
			strength = 2 + 0.1 * team_defense;
			my_tackle_limit = 20 + team_defense;
			my_accel = 0.065 + random(0.005) + 0.002 * team_defense;
			if (obj_master.op_difficulty == 4) {
				my_accel = 0.07 + 0.003 * team_defense;
			}
			break;
		case 9:
		case 8:
			collsize = 5;
			strength = 1 + 0.2 * team_defense;
			my_tackle_limit = 20 + team_defense;
			my_accel = 0.065 + random_range(0.04, 0.055) + 0.002 * team_defense;
			if (obj_master.op_difficulty == 3) {
				my_accel = 0.065 + random_range(0.05, 0.06) + 0.002 * team_defense;
			} else if (obj_master.op_difficulty == 4) {
				my_accel = 0.135 + 0.003 * team_defense;
			}
			if (s_is_kickoff(false) && obj_controller.possession != obj_controller.human_team) {
				strength = 1 + 0.2 * specialteams;
				my_tackle_limit = 20 + specialteams;
				my_accel = 0.065 + random_range(0.04, 0.055) + 0.002 * specialteams;
			}
			if (irandom(9)) {
				skin = 0;
			}
			break;
	}
	if (pmap) {
		var str = s_get_attribute(pmap, "strength");
		stamina = s_get_attribute(pmap, "stamina");
		var stam = (10 - stamina) * 0.05;
		var dep = ds_map_find_value(pmap, "stat_attempts") * stam;
		str = clamp(str - dep, 1, 10);
		my_throw_power = 0.08 + 0.004 * str;
		str = s_get_attribute(pmap, "strength");
		stam = (11 - stamina) * 0.2;
		dep = ds_map_find_value(pmap, "stat_attempts") * stam;
		str = clamp(str - dep, 1, 10);
		my_kick_power = 0.065 + 0.001235 * str;
		my_kick_skill = s_get_attribute(pmap, "skill");
		var stam = (10 - stamina) * 0.05;
		var dep = ds_map_find_value(pmap, "stat_attempts") * stam;
		var yds = clamp(ds_map_find_value(pmap, "stat_yards") + ds_map_find_value(pmap, "stat_rush_yards"), 0, 275) / 275;
		yds = lerp(yds * 0.99, yds * 0.5, stamina * 0.1);
		my_accel = lerp(my_accel, my_accel * 0.8, yds);
		skin = ds_map_find_value(pmap, "skin");
	} else if (!s_is_kickoff(true)) {
		if (position == 1) {
			skin = (real(obj_master.myteam_id) + real(obj_master.year)) mod 3;
		}
		if (global.exhibition) {
			skill = team_offense;
			my_throw_power = 0.08 + 0.004 * team_offense;
			my_kick_power = 0.065 + 0.001235 * team_offense;
			my_kick_skill = team_offense;
		}
		if (offense) {
			var qtr = clamp(obj_controller.quarter, 1, 5) / 5;
			my_accel = lerp(my_accel, my_accel * 0.7, qtr);
			stamina = team_offense;
		} else {
			var qtr = clamp(obj_controller.quarter, 1, 5) / 5;
			my_accel = lerp(my_accel, my_accel * 0.85, qtr);
			stamina = clamp(team_defense - irandom(2), 1, 8);
		}
	}
	if (position == 1 || position == 10) {
		slog("My kick skill = " + string(my_kick_skill));
	}
	if (!te_blocking) {
		my_route_alpha = obj_controller.route_alpha;
	}
	var colSkin = s_get_skin_colour_by_index(skin);
	col_skin_r = color_get_red(colSkin) / 255;
	col_skin_g = color_get_green(colSkin) / 255;
	col_skin_b = color_get_blue(colSkin) / 255;
	if (te_blocking) {
		position = 5;
	}
	if (pmap) {
		pos_name = string_copy(ds_map_find_value(pmap, "fname"), 1, 1) + "." + ds_map_find_value(pmap, "lname") + " [" + s_get_string_position(ds_map_find_value(pmap, "position")) + "]";
		pos_name2 = string_copy(ds_map_find_value(pmap, "fname"), 1, 1) + "." + ds_map_find_value(pmap, "lname");
		if (position == 4) {
			pos_name3 = string_copy(ds_map_find_value(pmap, "fname"), 1, 1) + "." + string_copy(ds_map_find_value(pmap, "lname"), 1, 1);
		}
		if (position == 3) {
			pos_name3 = string_copy(ds_map_find_value(pmap, "fname"), 1, 1) + "." + string_copy(ds_map_find_value(pmap, "lname"), 1, 1);
		}
		if (!ds_map_exists(pmap, "randnum")) {
			ds_map_set(pmap, "randnum", irandom(999));
		}
		switch (ds_map_find_value(pmap, "randnum") mod 3) {
			case 0:
				cleats = shirt;
				break;
			case 1:
				cleats = pants;
				break;
			case 2:
				cleats = stripe;
				break;
		}
		if (cleats[0] + cleats[1] + cleats[2] == 0) {
			cleats[0] = 255;
			cleats[1] = 255;
			cleats[2] = 255;
		}
	}
	slog("Setup player[" + (offense ? "OF" : "DF") + "] [" + (pmap == -4 ? "Anon" : ds_map_find_value(pmap, "lname")) + "] with roster: " + roster_short_desc(player_roster));
}

