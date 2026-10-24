function s_check_dive() {
	var ball = global.master_ball;
	var cont = obj_controller;
	if (ball.holder == -4) {
		if (offense && (!pmap || s_get_attribute(pmap, "skill") < 4)) {
			return;
		}
		if (!offense && obj_master.op_difficulty < 4) {
			return;
		}
		var jump_max = 12;
		if (!offense) {
			jump_max = 6;
		}
		if (anim == 2 && balldist < 60 && point_distance(x, y, obj_metaball.jump_x, obj_metaball.jump_y) < jump_max) {
			method(other, s_set_anim)(10);
		} else if (facing == 1 && x > cont.x_scrim || facing == -1 && x < cont.x_scrim) {
			if (anim == 2 && ball.zvel < 0 && ball.height < 30 && bouncedist > balldist && balldist > 20 && bouncedist < 40) {
				other.jdir = point_direction(other.x, other.y, obj_metaball.bounce_x, obj_metaball.bounce_y);
				method(other, s_set_anim)(5);
			}
		}
	} else if (ball.holder.offense != offense && !ball.holder.dead) {
		if (anim == 2 && abs(hspeed) > 0.05) {
			var hardmode = false;
			if (!obj_controller.running_play && ball.holder.position == 2) {
				hardmode = true;
			}
			if (obj_controller.down == 6 || obj_controller.defensive_cover == 0 || obj_controller.scrimmage > 40 || obj_controller.yards < 3) {
				hardmode = true;
			}
			if (obj_master.op_difficulty == 4) {
				switch (obj_controller.drivedir) {
					case -1:
						if (ball.holder.x < obj_controller.x_scrim - 60) {
							slog("scrim_L");
						}
						break;
					case 1:
						if (ball.holder.x > obj_controller.x_scrim + 60) {
							slog("scrim_R");
						}
						break;
				}
			}
			if (ball.holder.intheclear || !ball.holder.offense || hardmode || ball.holder.position == 1 || s_ball_holder_goalside()) {
				var oppdist = distance_to_point(ball.holder.x, ball.holder.y);
				var ydist = abs(y - ball.holder.y);
				if (oppdist < 20 && ydist < 5) {
					s_set_anim(5);
				}
			}
		}
	}
}

