if (instance_exists(obj_msgbg)) {
	exit;
}
if (obj_controller.state != 2) {
	exit;
}
var old_ballstate = state;
var lastx = x;
switch (obj_controller.kicking) {
	case 0:
		s_update_ball();
		break;
	default:
		s_update_ball_fieldgoal();
		break;
}
depth = -y * 10;
image_speed = 1;
if (obj_controller.drivedir == 1) {
	image_speed = -1;
}
s_check_ball_position();
if (state != old_ballstate) {
	s_create_match_message(state);
}
if (abs(lastx - x) > 1) {
	for (var i = 20; i > 0; i--) {
		l_blur[i][0] = l_blur[i - 1][0];
		l_blur[i][1] = l_blur[i - 1][1];
	}
	l_blur[0][0] = x;
	l_blur[0][1] = y - (height + 1);
}
if (holder || velocity < 1) {
	image_index = 0;
}
hidden = false;
with (holder) {
	if (s_sprite_holding_ball(sprite_index)) {
		other.hidden = true;
	}
}
s_update_my_shadow();
if (hidden) {
	layer_sprite_y(my_shadow, -99999);
}
