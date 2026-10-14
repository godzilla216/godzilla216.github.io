if (obj_controller.state != 2) {
	exit;
}
if (obj_controller.kicking && draw_arc && !s_is_kickoff(0)) {
	with (global.master_ball) {
		var dir = direc;
		var len = 180;
		var sx = x;
		var sy = y;
		if (holder) {
			len = 180 + 5 * holder.my_kick_skill;
			sx = holder.x;
			sy = holder.y;
		} else {
			slog("No holder!");
		}
		with (obj_playerOF) {
			if (position == 11) {
				sx = x;
				sy = y;
			}
		}
		var kx = sx + dcos(dir) * len;
		var ky = sy + dsin(dir) * len;
		draw_set_colour(16777215);
		draw_set_alpha(0.75);
		draw_line_width(sx, sy, kx, ky, 3);
		if (obj_controller.drivedir == 1) {
			draw_sprite_ext(spr_route_pointR, 0, kx, ky, 0.75, 0.75, -dir, 16777215, 0.75);
		} else {
			draw_sprite_ext(spr_route_pointR, 0, kx + 1, ky + 1.5, 0.75, 0.75, -dir, 16777215, 0.75);
		}
	}
} else if (draw_arc) {
	draw_set_colour(0);
	for (b = 0; b < plot_len; b++) {
		draw_set_alpha(0.5);
		draw_rectangle(plot_x[b], plot_y[b], plot_x[b] + 2, plot_y[b] + 2, false);
	}
}
if (draw_bounce) {
	draw_sprite_ext(spr_bouncespot, 0, bounce_x, bounce_y, 2, 2, 0, 65535, bounce_alf);
}
draw_set_colour(16777215);
draw_set_alpha(1);
