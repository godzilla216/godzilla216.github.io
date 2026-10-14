var ball = global.master_ball;
x = ball.x;
y = ball.y;
draw_arc = false;
draw_bounce = false;
dragdist = ball.dragdist;
bounce_alf = 1;
with (ball) {
	if (instance_exists(holder) && holder.position == 1) {
		other.x = holder.x;
		other.y = holder.y;
		var fadestart = 1;
		var accuracy = 0;
		if (holder.pmap) {
			accuracy = s_get_attribute(holder.pmap, "skill");
		}
		fadestart += clamp(accuracy, 0, 10) * 0.05;
		if (obj_master.op_difficulty == 1) {
			other.bounce_alf = 1;
		} else if (obj_master.op_difficulty == 4) {
			other.bounce_alf = 0;
		} else {
			switch (obj_master.op_difficulty) {
				case 0:
					accuracy += clamp(obj_master.suppress_difficulty, 0, 10);
					break;
				case 2:
					accuracy += 6;
					break;
				case 3:
					break;
			}
			other.bounce_alf = fadestart - dragdist / 75;
		}
		if (state == 2) {
			if (dragdist >= 20 || obj_controller.kicking) {
				other.draw_arc = true;
			}
			if (global.gamepad && obj_master.op_difficulty < 4) {
				other.draw_bounce = true;
			}
		}
	} else if (state == 3 && !obj_controller.kicking) {
		other.draw_bounce = true;
	}
	if (obj_controller.kicking && obj_controller.possession != obj_controller.human_team && !obj_master.gamepractice && obj_master.playerteamindex > -1) {
		other.draw_arc = false;
	}
}
height = ball.height;
direc = ball.direc;
velocity = ball.velocity;
zvel = ball.zvel;
var beat = 0;
var p = 0;
bounce_x = 0;
bounce_y = 0;
jump_x = 0;
jump_y = 0;
while (height > 0) {
	s_update_ball_movement(true);
	beat++;
	if (beat > gap && p < plot_len && zvel > zvel_limit) {
		beat = 0;
		plot_x[p] = x;
		plot_y[p] = y;
		plot_z[p] = height;
		p++;
	}
	if (zvel < 0 && jump_x == 0 && height > 54 && height < 60) {
		jump_x = x;
		jump_y = y;
	}
	if (zvel < 0 && bounce_x == 0 && height < 12) {
		bounce_x = x;
		bounce_y = y;
	}
}
for (q = p; q < plot_len; q++) {
	plot_x[q] = 0;
	plot_y[q] = 0;
	plot_z[q] = 0;
}
