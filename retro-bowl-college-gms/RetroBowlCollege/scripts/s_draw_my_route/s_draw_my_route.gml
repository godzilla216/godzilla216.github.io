function s_draw_my_route() {
	draw_set_colour(0);
	draw_set_alpha(my_route_alpha * 0.5);
	var lastx = my_route_startx;
	var lasty = my_route_starty;
	var num = path_get_number(my_route);
	for (var pt = 0; pt < num; pt += 1) {
		var nextx = round(my_route_startx + path_get_point_x(my_route, pt));
		var nexty = round(my_route_starty + path_get_point_y(my_route, pt));
		if (my_route_starty > 300) {
			nexty = my_route_starty - path_get_point_y(my_route, pt);
		}
		draw_line_width(lastx, lasty + 1, nextx, nexty + 1, 5);
		draw_circle(nextx, nexty + 1, 2.5, 0);
		my_route_end_dir = 999;
		switch (obj_controller.drivedir) {
			case -1:
				if (nextx <= lastx) {
					my_route_end_dir = point_direction(lastx, lasty, nextx, nexty);
				}
				break;
			case 1:
				if (nextx >= lastx) {
					my_route_end_dir = point_direction(lastx, lasty, nextx, nexty);
				}
				break;
		}
		lastx = nextx;
		lasty = nexty;
	}
	if (te_blocking) {
		draw_set_colour(0);
		draw_set_alpha(my_route_alpha * 0.5);
		draw_line_width(lastx, lasty - 5, nextx, nexty + 7, 5);
	} else if (my_route_end_dir == 999) {
		draw_set_colour(0);
		draw_set_alpha(my_route_alpha * 0.5);
		draw_circle(lastx, lasty + 1, 5, 0);
	} else {
		if (my_route_end_dir >= 270) {
			lastx += 1.5;
			lasty += 1;
		} else if (my_route_end_dir > 90) {
			lastx += 1.5;
			lasty += 2;
		}
		draw_sprite_ext(spr_route_pointR, 0, lastx, lasty + 1, 0.75, 0.75, my_route_end_dir, 0, my_route_alpha * 0.5);
	}
	var col = global.c_routes;
	if (te_blocking || position == 1) {
		col = 16777215;
	} else if (position == 2) {
		col = global.c_routes_rb;
	}
	if (obj_master.qb_mode && rewarded_route) {
		col = 255;
	}
	draw_set_colour(col);
	draw_set_alpha(my_route_alpha);
	lastx = round(my_route_startx);
	lasty = round(my_route_starty);
	for (var pt = 0; pt < num; pt += 1) {
		var nextx = round(my_route_startx + path_get_point_x(my_route, pt));
		var nexty = round(my_route_starty + path_get_point_y(my_route, pt));
		if (my_route_starty > 300) {
			nexty = my_route_starty - path_get_point_y(my_route, pt);
		}
		draw_line_width(lastx, lasty, nextx, nexty, 5);
		draw_circle(nextx, nexty, 2.5, 0);
		lastx = nextx;
		lasty = nexty;
	}
	if (te_blocking) {
		my_route_end_dir = 999;
		draw_set_colour(16777215);
		draw_set_alpha(my_route_alpha);
		draw_line_width(lastx, lasty - 6, nextx, nexty + 6, 5);
	} else if (my_route_end_dir == 999) {
		draw_set_colour(col);
		draw_set_alpha(my_route_alpha);
		draw_circle(lastx, lasty, 5, 0);
	} else {
		if (my_route_end_dir >= 270) {
			lastx += 1.5;
			lasty += 1;
		} else if (my_route_end_dir > 90) {
			lastx += 1.5;
			lasty += 2;
		}
		draw_sprite_ext(spr_route_pointR, 0, lastx, lasty, 0.75, 0.75, my_route_end_dir, col, my_route_alpha);
	}
	draw_set_colour(16777215);
	draw_set_alpha(1);
}

