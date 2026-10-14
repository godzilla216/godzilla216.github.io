if (dead) {
	exit;
}
if (obj_controller.state != 2) {
	exit;
}
var ball = global.master_ball;
balldist = point_distance(x, y, ball.x, ball.y);
if (ball.is_dead) {
	s_stop_tackling();
	exit;
}
intheclear = s_is_in_the_clear();
bouncedist = point_distance(x, y, obj_metaball.bounce_x, obj_metaball.bounce_y);
balldir = point_direction(x, y, ball.x, ball.y);
goaldist = abs(goalline_attack - x);
if (obj_controller.drivedir == 1) {
	remaining_dist = obj_controller.x_yards - x;
} else {
	remaining_dist = x - obj_controller.x_yards;
}
step_tick++;
if (step_tick == 2) {
	nearest_opp = s_get_nearest_opponent(id);
	nearest_opp_dist = 1000;
	if (nearest_opp) {
		nearest_opp_dist = point_distance(x, y, nearest_opp.x, nearest_opp.y);
	}
	step_tick = 0;
}
jdir = 0;
if (facing == -1) {
	jdir = 180;
}
if (ball.state != 0 && ball.state != 1) {
	my_route_alpha = 0;
}
if (offense) {
	s_check_human_control();
}
s_get_destination();
s_check_tackling();
s_check_dive();
