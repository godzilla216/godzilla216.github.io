function s_set_position_offense() {
	x = obj_controller.x_scrim - 20 * facing;
	var QB_X = 100;
	switch (inum) {
		case 1:
			position = 1;
			x = obj_controller.x_scrim - QB_X * facing;
			y = obj_controller.y_scrim;
			break;
		case 2:
			if (irandom(1) || obj_master.gamepractice == 2) {
				position = 2;
				x = obj_controller.x_scrim - QB_X * facing;
				y = obj_controller.y_scrim - 35;
				if (irandom(1)) {
					y = obj_controller.y_scrim + 35;
				}
			} else {
				position = 2;
				x = obj_controller.x_scrim - (QB_X + 35) * facing;
				switch (irandom(2)) {
					case 0:
						y = obj_controller.y_scrim - 17;
						break;
					case 1:
						y = obj_controller.y_scrim + 17;
						break;
					case 2:
						y = 300;
						break;
				}
			}
			break;
		case 3:
			position = 5;
			x = obj_controller.x_scrim - 10 * facing;
			y = obj_controller.y_scrim;
			break;
		case 4:
			position = 5;
			y = obj_controller.y_scrim - 15;
			break;
		case 5:
			position = 5;
			y = obj_controller.y_scrim + 15;
			break;
		case 6:
			position = 5;
			y = obj_controller.y_scrim - 30;
			break;
		case 7:
			position = 5;
			y = obj_controller.y_scrim + 30;
			break;
		case 8:
			position = 3;
			x = obj_controller.x_scrim - 12 * facing;
			y = obj_controller.y_scrim + 60;
			var rb = false;
			with (obj_playerOF) {
				if (position == 2 && y >= 300) {
					rb = true;
				}
			}
			if (rb && 1) {
				y = obj_controller.y_scrim + 45;
				te_blocking = true;
			}
			break;
		case 9:
			position = 4;
			x = obj_controller.x_scrim - 20 * irandom_range(1, 2) * facing;
			y = obj_controller.y_scrim - random_range(100, 120);
			if (y > 300 && obj_controller.y_scrim < 300 || y < 300 && obj_controller.y_scrim > 300) {
				y = obj_controller.y_scrim - random_range(120, 160);
			}
			break;
		case 10:
			position = 3;
			x = obj_controller.x_scrim - 12 * facing;
			y = obj_controller.y_scrim - 60;
			var rb = false;
			with (obj_playerOF) {
				if (position == 2 && y <= 300) {
					rb = true;
				}
			}
			if (rb) {
				y = obj_controller.y_scrim - 45;
				te_blocking = true;
			}
			break;
		case 11:
			position = 4;
			x = obj_controller.x_scrim - 20 * irandom_range(1, 2) * facing;
			y = obj_controller.y_scrim + random_range(100, 120);
			if (y > 300 && obj_controller.y_scrim < 300 || y < 300 && obj_controller.y_scrim > 300) {
				y = obj_controller.y_scrim + random_range(120, 160);
			}
			break;
	}
	my_route_name = "";
	switch (position) {
		case 1:
			if (obj_master.gamepractice) {
				if (obj_controller.practice_success > 0 && obj_master.gamepractice == 3) {
					x = obj_controller.x_scrim - 40 * facing;
					my_route = path_duplicate(route_qb);
				}
			} else if (irandom(1)) {
				x = obj_controller.x_scrim - 40 * facing;
				my_route = path_duplicate(route_qb);
			}
			break;
		case 4:
			if (obj_master.gamepractice == 3) {
				if (obj_controller.practice_success == 0) {
					my_route = path_duplicate(route_dig2);
				} else {
					my_route = path_duplicate(route_post);
				}
			} else if (s_last_secs_of_half(15) && obj_controller.scrimmage < 40 || obj_controller.yards > 10) {
				my_route_name = choose("route_slant", "route_post", "route_streak");
			} else if (y < 200 || y > 400) {
				if (obj_controller.scrimmage > 40) {
					my_route_name = choose("route_hitch", "route_slant", "route_slant2", "route_curl", "route_dig1", "route_dig2", "route_dig3");
				} else {
					my_route_name = choose("route_hitch", "route_slant", "route_slant2", "route_curl", "route_dig1", "route_dig2", "route_dig3", "route_post", "route_streak");
				}
			} else if (obj_controller.scrimmage > 40) {
				my_route_name = choose("route_hitch", "route_slant", "route_slant2", "route_out1", "route_out2", "route_out3", "route_curl", "route_comeback", "route_dig1", "route_dig2", "route_dig3");
			} else {
				my_route_name = choose("route_hitch", "route_slant", "route_slant2", "route_out1", "route_out2", "route_out3", "route_curl", "route_comeback", "route_dig1", "route_dig2", "route_dig3", "route_post", "route_corner", "route_streak");
			}
			break;
		case 3:
			if (te_blocking) {
				my_route = path_duplicate(route_te_block);
			} else if (s_last_secs_of_half(15) && obj_controller.scrimmage < 40) {
				my_route_name = choose("route_slant", "route_post", "route_streak");
			} else if (irandom(1)) {
				my_route_name = choose("route_fb_1", "route_fb_2", "route_fb_4", "route_fb_flat");
			} else {
				my_route_name = choose("route_flat", "route_slant", "route_slant2", "route_out1", "route_out2", "route_out3", "route_curl", "route_comeback", "route_dig1", "route_dig2", "route_dig3", "route_post", "route_corner", "route_streak");
			}
			break;
		case 2:
			var shotgun = true;
			var qby = 0;
			with (obj_playerOF) {
				if (position == 1 && path_exists(my_route)) {
					qby = y;
					shotgun = false;
				}
			}
			if (obj_master.gamepractice == 2) {
				my_route = path_duplicate(route_fb_2);
			} else if (shotgun) {
				my_route_name = choose("route_fb_1", "route_fb_2", "route_fb_3", "route_fb_4", "route_fb_flat", "route_fb_flat2");
			} else {
				my_route_name = choose("route_fb_1", "route_fb_2", "route_fb_3", "route_fb_4");
			}
			break;
	}
	if (my_route_name != "" && position == 4) {
		var dupe = false;
		with (obj_playerOF) {
			if (other.id != id) {
				if ((my_route_name == "route_slant" || my_route_name == "route_slant2") && (other.my_route_name == "route_slant" || other.my_route_name == "route_slant2")) {
					dupe = true;
				} else if ((my_route_name == "route_dig1" || my_route_name == "route_dig2" || my_route_name == "route_dig3") && (other.my_route_name == "route_dig1" || other.my_route_name == "route_dig2" || other.my_route_name == "route_dig3")) {
					dupe = true;
				} else if (my_route_name == "route_hitch" && other.my_route_name == "route_hitch") {
					dupe = true;
				}
			}
		}
		if (dupe) {
			switch (my_route_name) {
				case "route_slant":
				case "route_slant2":
					my_route_name = choose("route_curl", "route_dig1", "route_dig2", "route_dig3", "route_post", "route_streak");
					break;
				case "route_dig1":
				case "route_dig2":
				case "route_dig3":
					my_route_name = choose("route_curl", "route_slant", "route_slant2", "route_post", "route_streak");
					break;
				case "route_hitch":
					my_route_name = choose("route_curl", "route_slant", "route_slant2", "route_post", "route_streak");
					break;
			}
		}
	}
	switch (my_route_name) {
		case "route_flat":
			my_route = path_duplicate(route_flat);
			break;
		case "route_slant":
			my_route = path_duplicate(route_slant);
			break;
		case "route_slant_fake":
			my_route = path_duplicate(route_slant_fake);
			break;
		case "route_slant2":
			my_route = path_duplicate(route_slant2);
			break;
		case "route_out1":
			my_route = path_duplicate(route_out1);
			break;
		case "route_out2":
			my_route = path_duplicate(route_out2);
			break;
		case "route_out3":
			my_route = path_duplicate(route_out3);
			break;
		case "route_curl":
			my_route = path_duplicate(route_curl);
			break;
		case "route_comeback":
			my_route = path_duplicate(route_comeback);
			break;
		case "route_dig1":
			my_route = path_duplicate(route_dig1);
			break;
		case "route_dig2":
			my_route = path_duplicate(route_dig2);
			break;
		case "route_dig3":
			my_route = path_duplicate(route_dig3);
			break;
		case "route_post":
			my_route = path_duplicate(route_post);
			break;
		case "route_corner":
			my_route = path_duplicate(route_corner);
			break;
		case "route_streak":
			my_route = path_duplicate(route_streak);
			break;
		case "route_fb_1":
			my_route = path_duplicate(route_fb_1);
			break;
		case "route_fb_2":
			my_route = path_duplicate(route_fb_2);
			break;
		case "route_fb_3":
			my_route = path_duplicate(route_fb_3);
			break;
		case "route_fb_4":
			my_route = path_duplicate(route_fb_4);
			break;
		case "route_fb_flat":
			my_route = path_duplicate(route_fb_flat);
			break;
		case "route_fb_flat2":
			my_route = path_duplicate(route_fb_flat2);
			break;
		case "route_hitch":
			my_route = path_duplicate(route_hitch);
			break;
		default:
			break;
	}
	if (facing == -1 && path_exists(my_route)) {
		path_mirror(my_route);
		path_shift(my_route, -path_get_x(my_route, 0), 0);
	}
	my_route_startx = x;
	my_route_starty = y;
}

