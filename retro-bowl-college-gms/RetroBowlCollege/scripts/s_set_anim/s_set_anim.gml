function s_set_anim(_arg0) {
	anim = _arg0;
	image_speed = 1;
	var ball = global.master_ball;
	switch (anim) {
		case 0:
			sprite_index = s_spr_from_bt(spr_stand, body_type);
			with (ball) {
				if (holder == other.id) {
					other.sprite_index = s_spr_from_bt(spr_stand_ball, other.body_type);
				}
			}
			if (position == 1 && instance_number(obj_ball) == 0) {
				image_index = 2;
			} else {
				image_index = 0;
			}
			image_speed = 0;
			tackling = -4;
			break;
		case 1:
			sprite_index = s_spr_from_bt(spr_stand, body_type);
			image_index = 1;
			image_speed = 0;
			tackling = -4;
			break;
		case 2:
			if (ball.holder == id) {
				sprite_index = s_spr_from_bt(spr_run_ball, body_type);
			} else {
				sprite_index = s_spr_from_bt(spr_run, body_type);
			}
			image_index = 0;
			image_speed = min(speed, 1);
			tackling = -4;
			break;
		case 3:
			sprite_index = s_spr_from_bt(spr_wrestle, body_type);
			image_index = 0;
			break;
		case 4:
			s_sound_oof();
			if (sprite_index == spr_falling || sprite_index == spr_falling_ball || sprite_index == spr_falling_ball2) {
				return;
			}
			if (sprite_index == spr_falling_thin || sprite_index == spr_falling_ball_thin || sprite_index == spr_falling_ball2_thin) {
				return;
			}
			if (sprite_index == spr_falling_bulky || sprite_index == spr_falling_ball_bulky || sprite_index == spr_falling_ball2_bulky) {
				return;
			}
			sprite_index = s_spr_from_bt(spr_falling, body_type);
			if (ball.holder == id && !ball.is_dead) {
				var fumble_chance = 10;
				if (obj_master.op_difficulty > 2) {
					fumble_chance -= 1;
				}
				if (obj_master.op_difficulty > 3) {
					fumble_chance -= 1;
				}
				with (obj_weather) {
					if (type != 0) {
						fumble_chance -= 2;
					}
				}
				slog(">>>>>>>>>>>>>>>>>>>>>>>>>");
				slog("fumble_c = " + string(fumble_chance));
				fumble_chance = irandom(fumble_chance);
				if (x < 400 || x > 2200) {
					fumble_chance = 1;
				}
				if (!fumble_chance && offense && position != 1 && !s_is_kickoff(true) && player_roster != -4) {
					slog(">>>>>>>>>>>>>>>>>>>>>>>>> FUMBLE CHANCE!");
					var catching = (s_get_morale_from_roster(player_roster) + s_get_condition_squad_from_roster(player_roster)) * 0.5;
					if (ball.holder && ball.holder.pmap) {
						var skl = s_get_attribute(ball.holder.pmap, "skill") * 10;
						var att = real(ds_map_find_value(ball.holder.pmap, "attitude"));
						var fmb = real(ds_map_find_value(ball.holder.pmap, "stat_fumbles"));
						slog("player_skill = " + string(skl));
						slog("player_attit = " + string(att));
						slog("stat_fumbles = " + string(fmb));
						catching = (skl + att) * 0.5;
						if (max(s_rookie_age_internal(), real(ds_map_find_value(ball.holder.pmap, "age"))) > s_rookie_age_internal()) {
							catching += fmb * 50;
						}
						slog("player catching = " + string(catching));
					} else {
						slog("catching squad = " + string(catching));
					}
					catching += obj_controller.difficulty * 2;
					catching = clamp(catching, 1, 100);
					slog("final catching = " + string(catching));
					var catch_dice = irandom_range(-100, 85);
					slog("catch_dice = " + string(catch_dice));
					if (catch_dice > catching || !irandom(49)) {
						s_drop_ball(true);
					} else {
						sprite_index = s_spr_from_bt(spr_falling_ball, body_type);
					}
				} else {
					sprite_index = s_spr_from_bt(spr_falling_ball, body_type);
				}
			}
			image_index = 0;
			tackling = -4;
			tacklecount = 0;
			break;
		case 5:
			image_index = 0;
			sprite_index = s_spr_from_bt(spr_dive_ball, body_type);
			if (ball.holder == id) {
				if (s_do_touchback()) {
					return;
				}
				if (!obj_master.gamepractice && (ball.holder.position == 1 || ball.holder.qb_rushing)) {
					if (ball.holder.goaldist > 100) {
						if (obj_controller.drivedir == -1 && ball.holder.x > obj_controller.x_scrim + 30 || obj_controller.drivedir == 1 && ball.holder.x < obj_controller.x_scrim - 30) {
							s_set_anim(19);
							return;
						} else if (ball.holder.remaining_dist < 0 || ball.holder.remaining_dist > 60) {
							sprite_index = s_spr_from_bt(spr_qb_slide, body_type);
						}
					}
				}
			}
			hspeed *= 1.9;
			vspeed *= 1.7;
			tackling = -4;
			s_sound_dive();
			break;
		case 6:
			if (ball.holder == id) {
				if (sprite_index == spr_kneel || sprite_index == spr_kneel_thin || sprite_index == spr_kneel_bulky) {
					sprite_index = s_spr_from_bt(spr_stand_ball, body_type);
				} else {
					sprite_index = s_spr_from_bt(spr_getup_ball, body_type);
				}
			} else {
				sprite_index = s_spr_from_bt(spr_getup, body_type);
			}
			image_index = 0;
			tackling = -4;
			break;
		case 7:
			if (s_do_touchback()) {
				return;
			} else if (goaldist < 40 && intheclear) {
				sprite_index = s_spr_from_bt(spr_taunt, body_type);
			} else {
				sprite_index = s_spr_from_bt(spr_jockey, body_type);
			}
			image_index = 0;
			hspeed *= 0.1;
			tackling = -4;
			break;
		case 8:
			s_sound_dive();
			s_sound_audience_catch();
			sprite_index = s_spr_from_bt(spr_jump, body_type);
			jumps--;
			image_index = 0;
			tackling = -4;
			break;
		case 9:
			sprite_index = s_spr_from_bt(spr_stiffarm, body_type);
			stiff_arm--;
			tackling = -4;
			global.flickVelX = 0;
			global.flickVelY = 0;
			break;
		case 10:
			s_sound_dive();
			sprite_index = s_spr_from_bt(spr_jump_catch, body_type);
			image_index = 0;
			tackling = -4;
			break;
		case 11:
			sprite_index = s_spr_from_bt(spr_qb_walk, body_type);
			with (global.master_ball) {
				if (dragdist > 85) {
					other.sprite_index = s_spr_from_bt(spr_qb_aim, other.body_type);
				}
			}
			image_index = 0;
			break;
		case 12:
			if (ball.state == 19) {
				sprite_index = s_spr_from_bt(spr_handoff, body_type);
			} else {
				sprite_index = s_spr_from_bt(spr_qb_throw, body_type);
			}
			image_index = 0;
			s_sound_throw();
			break;
		case 13:
			sprite_index = s_spr_from_bt(spr_place, body_type);
			image_index = 0;
			image_speed = 0;
			break;
		case 14:
			hspeed = image_xscale * 0.85;
			sprite_index = s_spr_from_bt(spr_kick1, body_type);
			image_index = 0;
			break;
		case 15:
			sprite_index = s_spr_from_bt(spr_kick2, body_type);
			image_index = 0;
			break;
		case 16:
			sprite_index = s_spr_from_bt(spr_spike, body_type);
			image_index = 0;
			break;
		case 17:
			sprite_index = s_spr_from_bt(spr_celebrate, body_type);
			image_index = irandom(1);
			break;
		case 18:
			sprite_index = s_spr_from_bt(irandom(1) ? spr_firstdown : spr_firstdown_kneel, body_type);
			image_index = 0;
			break;
		case 19:
			sprite_index = s_spr_from_bt(spr_kneel, body_type);
			image_index = 0;
			hspeed *= 0.1;
			vspeed *= 0.1;
			break;
	}
}

