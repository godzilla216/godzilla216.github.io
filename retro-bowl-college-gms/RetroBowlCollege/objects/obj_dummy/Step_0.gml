if (current_time < pause_time) {
	exit;
}
if (abs(range_x)) {
	x += move_speed;
	if (x > start_x + range_x || x < start_x - range_x) {
		move_speed = -move_speed;
		pause_time = current_time + edge_pause;
	}
}
if (abs(range_y)) {
	y += move_speed;
	if (y > start_y + range_y || y < start_y - range_y) {
		if (dead) {
			move_speed = 0;
		}
		move_speed = -move_speed;
		pause_time = current_time + edge_pause;
	}
}
depth = -y * 10;
