function s_point_to_path() {
	px = my_route_startx + path_get_point_x(my_route, my_route_point);
	py = my_route_starty + path_get_point_y(my_route, my_route_point);
	if (my_route_starty > 300) {
		py = my_route_starty - path_get_point_y(my_route, my_route_point);
	}
	if (point_distance(x, y, px, py) < 20) {
		my_route_point += 1;
	}
	if (my_route_point >= path_get_number(my_route)) {
		path_delete(my_route);
	}
	return point_direction(x, y, px, py);
}

