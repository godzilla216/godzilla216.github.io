var ball = global.master_ball;
var cont = obj_controller;
if (cont.state != 2) {
	exit;
}
s_check_ball_collision();
if (y < 117) {
	y = 117;
}
var gl = goalline_attack;
if (!offense) {
	gl = goalline_defend;
}
if (y < 152) {
	my_route_end_dir = point_direction(x, y, gl, 152);
}
if (y > 448) {
	my_route_end_dir = point_direction(x, y, gl, 448);
}
if (y < 132) {
	jdir = point_direction(x, y, x, 300);
}
if (y > 468) {
	jdir = point_direction(x, y, x, 300);
}
if (offense && ball.state == 6 && ball.holder == id) {
	jdir = point_direction(x, y, obj_controller.drivedir == 1 ? 2510 : 90, y);
}
if ((!s_is_kickoff(true) || ball.state == 6) && (ball.state != 3 || bouncedist > 400)) {
	if (x < 195 || x > 2405) {
		var celebrate = false;
		if (current_time > obj_controller.td_time + 750 && ball.holder == id && ball.state == 6 && anim != 16 && anim != 17) {
			celebrate = true;
			with (obj_controller) {
				if (down == 6) {
					celebrate = false;
					if (s_last_secs_of_half(20) && team_score[human_team] < team_score[!human_team ? 1 : 0] && team_score[human_team] + 2 >= team_score[!human_team ? 1 : 0]) {
						celebrate = true;
					}
				}
			}
		}
		if (celebrate) {
			s_set_anim(16);
			jforce = 0;
		} else if (!path_exists(my_route) && ball.state != 5) {
			jforce = 0.1;
		}
	}
	if (x < 142.5 || x > 2457.5) {
		if (ball.state != 5) {
			jforce = 0;
		}
	}
}
switch (anim) {
	case 4:
		jforce = 0;
		break;
	case 5:
		jforce = 0;
		break;
	case 6:
		jforce = 0;
		break;
	case 7:
		jforce = 0;
		break;
	case 10:
		jforce = 0;
		break;
	case 11:
		jforce = 0;
		break;
	case 12:
		jforce = 0;
		break;
	case 19:
		jforce = 0;
		break;
}
if (dead) {
	jforce = 0;
}
if (position == 2 && ball.state == 19 && jforce == 1) {
	jforce = 0.5;
}
if (ball.is_dead) {
	if (!(ball.holder == id && ball.state == 6)) {
		jforce = 0;
	}
}
if (anim != 3) {
	var veffect = 0.75;
	hspeed += dcos(jdir) * jforce * my_accel;
	vspeed += dsin(-jdir) * jforce * my_accel * veffect;
}
if (ball.holder == id && (ball.state == 5 || ball.state == 9 || ball.state == 10)) {
	var bx = ball.x;
	if (min_x == -1) {
		min_x = bx;
	} else if (hspeed < 0 && bx < min_x) {
		min_x = bx;
	}
	if (max_x == -1) {
		max_x = bx;
	} else if (hspeed > 0 && bx > max_x) {
		max_x = bx;
	}
}
if (!obj_master.gamepractice) {
	if (ball.holder == id && anim == 2 && my_accel > 0.060125000000000005) {
		var decel = 0.9999;
		var stam = 11 - stamina;
		decel -= stam * 0.00005;
		my_accel *= decel;
	}
}
hspeed *= 0.94;
vspeed *= 0.94;
if (dead) {
	var getup = 2500;
	if (!offense) {
		getup = 2500 - cont.team_defense[!cont.human_team ? 1 : 0] * 100;
	} else if (obj_controller.difficulty > 5) {
		getup = 1000;
	} else if (pmap) {
		getup -= s_get_attribute(pmap, "stamina") * 100;
	} else {
		getup -= cont.team_offense[cont.human_team] * 100;
	}
	if (current_time > dead + getup) {
		dead = 0;
		tacklecount = 0;
		var doanim = true;
		if (!pmap || ball.holder != id) {
			doanim = false;
		}
		if (anim != 5 && anim != 4) {
			doanim = false;
		}
		if (obj_controller.drivedir == 1 && (ball.xdead < obj_controller.x_yards || ball.xdead > 2000)) {
			doanim = false;
		}
		if (obj_controller.drivedir == -1 && (ball.xdead > obj_controller.x_yards || ball.xdead < 600)) {
			doanim = false;
		}
		if (abs(ball.xdead) / 20 > 600) {
			doanim = false;
		}
		if (!irandom(1)) {
			doanim = false;
		}
		if (doanim) {
			s_set_anim(18);
		} else {
			s_set_anim(6);
		}
	}
} else {
	if (hspeed > 0.1) {
		image_xscale = 2;
	} else if (hspeed < -0.1) {
		image_xscale = -2;
	} else if (anim != 5 && anim != 4) {
		image_xscale = facing * 2;
	}
	if (position == 1 && path_exists(my_route) && ball.state != 19 && ball.holder == id) {
		image_xscale = facing * 2;
	}
	switch (anim) {
		case 0:
		case 1:
			if (speed >= 0.1) {
				s_set_anim(2);
			}
			break;
		case 2:
			image_speed = min(speed, 1);
			if (speed < 0.1) {
				s_set_anim(0);
			}
			break;
		case 3:
			if (tackling) {
				image_xscale = 2;
				if (tackling.x < x) {
					image_xscale = -2;
				}
			}
			break;
		case 4:
		case 5:
		case 6:
		case 7:
		case 8:
		case 9:
		case 18:
		case 19:
			break;
		case 11:
		case 12:
			image_xscale = 2;
			if (obj_metaball.bounce_x < x) {
				image_xscale = -2;
			}
			break;
	}
}
depth = -y * 10 + randyards * 0.1;
if (ball.holder == id) {
	if (position == 1 && ball.state == 2) {
		if (path_exists(my_route)) {
			sprite_index = s_spr_from_bt(spr_qb_walk, body_type);
			image_xscale = 2;
			if (facing == -1) {
				image_xscale = -2;
			}
		}
	} else if (balldist < 10) {
		switch (sprite_index) {
			case spr_run:
				sprite_index = spr_run_ball;
				break;
			case spr_jump_catch:
				sprite_index = spr_jump_catch_ball;
				break;
			case spr_dive:
				sprite_index = spr_dive_ball;
				break;
			case spr_run_thin:
				sprite_index = spr_run_ball_thin;
				break;
			case spr_jump_catch_thin:
				sprite_index = spr_jump_catch_ball_thin;
				break;
			case spr_dive_thin:
				sprite_index = spr_dive_ball_thin;
				break;
			case spr_run_bulky:
				sprite_index = spr_run_ball_bulky;
				break;
			case spr_jump_catch_bulky:
				sprite_index = spr_jump_catch_ball_bulky;
				break;
			case spr_dive_bulky:
				sprite_index = spr_dive_ball_thin;
				break;
		}
	}
} else {
	switch (sprite_index) {
		case spr_run_ball:
			sprite_index = spr_run;
			break;
		case spr_run_ball2:
			sprite_index = spr_run;
			break;
		case spr_jump_catch_ball:
			sprite_index = spr_jump_catch;
			break;
		case spr_jump_catch_ball2:
			sprite_index = spr_jump_catch;
			break;
		case spr_dive_ball:
			sprite_index = spr_dive;
			break;
		case spr_dive_ball2:
			sprite_index = spr_dive;
			break;
		case spr_falling_ball:
			sprite_index = spr_falling;
			break;
		case spr_falling_ball2:
			sprite_index = spr_falling;
			break;
		case spr_run_ball_thin:
			sprite_index = spr_run_thin;
			break;
		case spr_run_ball2_thin:
			sprite_index = spr_run_thin;
			break;
		case spr_jump_catch_ball_thin:
			sprite_index = spr_jump_catch_thin;
			break;
		case spr_jump_catch_ball2_thin:
			sprite_index = spr_jump_catch_thin;
			break;
		case spr_dive_ball_thin:
			sprite_index = spr_dive_thin;
			break;
		case spr_dive_ball2_thin:
			sprite_index = spr_dive_thin;
			break;
		case spr_falling_ball_thin:
			sprite_index = spr_falling_thin;
			break;
		case spr_falling_ball2_thin:
			sprite_index = spr_falling_thin;
			break;
		case spr_run_ball_bulky:
			sprite_index = spr_run_bulky;
			break;
		case spr_run_ball2_bulky:
			sprite_index = spr_run_bulky;
			break;
		case spr_jump_catch_ball_bulky:
			sprite_index = spr_jump_catch_bulky;
			break;
		case spr_jump_catch_ball2_bulky:
			sprite_index = spr_jump_catch_bulky;
			break;
		case spr_dive_ball_bulky:
			sprite_index = spr_dive_bulky;
			break;
		case spr_dive_ball2_bulky:
			sprite_index = spr_dive_bulky;
			break;
		case spr_falling_ball_bulky:
			sprite_index = spr_falling_bulky;
			break;
		case spr_falling_ball2_bulky:
			sprite_index = spr_falling_bulky;
			break;
	}
}
switch (obj_master.op_ball) {
	case 2:
	case 5:
		switch (sprite_index) {
			case spr_stand_ball:
				sprite_index = spr_stand_ball2;
				break;
			case spr_run_ball:
				sprite_index = spr_run_ball2;
				break;
			case spr_getup_ball:
				sprite_index = spr_getup_ball2;
				break;
			case spr_jump:
				sprite_index = spr_jump2;
				break;
			case spr_jump_catch_ball:
				sprite_index = spr_jump_catch_ball2;
				break;
			case spr_dive_ball:
				sprite_index = spr_dive_ball2;
				break;
			case spr_stiffarm:
				sprite_index = spr_stiffarm2;
				break;
			case spr_spike:
				sprite_index = spr_spike2;
				break;
			case spr_falling_ball:
				sprite_index = spr_falling_ball2;
				break;
			case spr_stand_ball_thin:
				sprite_index = spr_stand_ball2_thin;
				break;
			case spr_run_ball_thin:
				sprite_index = spr_run_ball2_thin;
				break;
			case spr_getup_ball_thin:
				sprite_index = spr_getup_ball2_thin;
				break;
			case spr_jump_thin:
				sprite_index = spr_jump2_thin;
				break;
			case spr_jump_catch_ball_thin:
				sprite_index = spr_jump_catch_ball2_thin;
				break;
			case spr_dive_ball_thin:
				sprite_index = spr_dive_ball2_thin;
				break;
			case spr_stiffarm_thin:
				sprite_index = spr_stiffarm2_thin;
				break;
			case spr_spike_thin:
				sprite_index = spr_spike2_thin;
				break;
			case spr_falling_ball_thin:
				sprite_index = spr_falling_ball2_thin;
				break;
			case spr_stand_ball_bulky:
				sprite_index = spr_stand_ball2_bulky;
				break;
			case spr_run_ball_bulky:
				sprite_index = spr_run_ball2_bulky;
				break;
			case spr_getup_ball_bulky:
				sprite_index = spr_getup_ball2_bulky;
				break;
			case spr_jump_bulky:
				sprite_index = spr_jump2_bulky;
				break;
			case spr_jump_catch_ball_bulky:
				sprite_index = spr_jump_catch_ball2_bulky;
				break;
			case spr_dive_ball_bulky:
				sprite_index = spr_dive_ball2_bulky;
				break;
			case spr_stiffarm_bulky:
				sprite_index = spr_stiffarm2_bulky;
				break;
			case spr_spike_bulky:
				sprite_index = spr_spike2_bulky;
				break;
			case spr_falling_ball_bulky:
				sprite_index = spr_falling_ball2_bulky;
				break;
		}
		break;
	default:
		break;
}
if (sprite_index == spr_qb_aim || sprite_index == spr_qb_aim_thin || sprite_index == spr_qb_aim_bulky) {
	image_index = obj_master.op_ball;
}
s_update_my_shadow();
if (obj_controller.state == 2 && global.master_ball.state != 0 && global.replay_tick mod 4 == 0) {
	s_record_frame();
}
