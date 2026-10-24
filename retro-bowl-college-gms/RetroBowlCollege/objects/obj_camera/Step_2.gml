if (is_undefined(zoom)) {
	s_create_camera();
	exit;
}
if (global.browser || os_type == 21) {
	if (display_width != display_get_width() || display_height != display_get_height()) {
		s_create_camera();
	}
}
var _cur_x = camera_get_view_x(view_camera[0]);
var _cur_y = camera_get_view_y(view_camera[0]);
var _x = _cur_x;
var _y = _cur_y;
var des_zoom = 1.2;
var _spd = 0.03;
var _pan = view_width * zoom;
with (obj_controller) {
	switch (state) {
		case 1:
			if (comm_stage != 14) {
				des_zoom = 2;
			}
			_x = 1300;
			if (global.exhibition && obj_master.playerteamindex == -1) {
				s_force_kick_direction();
				switch (drivedir) {
					case -1:
						_x -= scrimmage * 20;
						break;
					case 1:
						_x += scrimmage * 20;
						break;
				}
			} else {
				switch (drivedir) {
					case -1:
						if (possession == human_team) {
							_x -= scrimmage * 20;
						} else {
							_x += scrimmage * 20;
						}
						break;
					case 1:
						if (possession == human_team) {
							_x += scrimmage * 20;
						} else {
							_x -= scrimmage * 20;
						}
						break;
				}
			}
			switch (comm_stage) {
				case 12:
				case 13:
					if (quarter != 3 && quarter != 5) {
						break;
					}
				case 0:
				case 1:
				case 17:
					_spd = 0.15;
					_x = 1300;
					break;
				default:
					break;
			}
			_x -= _pan * 0.5;
			break;
		default:
			break;
	}
}
with (global.master_ball) {
	var by = self.y;
	if (s_aiming()) {
		by = 280;
	}
	_x = self.x - _pan * 0.5;
	_y = by - other.view_height * other.zoom * 0.5;
	if (holder && s_aiming()) {
		var dist = s_get_distance_to_furthest_teammate(holder);
		des_zoom = lerp(600 / dist, 2, 1.6);
		des_zoom = clamp(des_zoom, 1.6, 2);
		if (obj_controller.drivedir == -1) {
			_x = self.x - _pan * 0.6;
		} else {
			_x = self.x - _pan * 0.4;
		}
	}
	if (obj_controller.kicking || s_is_kickoff(false)) {
		_x = self.x - _pan * 0.5;
		des_zoom = 1.9;
	}
}
if (!ds_map_find_value(obj_master.map_options, "op_zoom")) {
	zoom = 2;
} else {
	zoom = lerp(zoom, des_zoom, 0.02);
}
camera_set_view_size(view_camera[0], view_width * zoom, view_height * zoom);
var cam_w = camera_get_view_width(view_camera[0]);
var cam_h = camera_get_view_height(view_camera[0]);
_x = clamp(lerp(_cur_x, _x, _spd), 0, room_width - cam_w);
_y = clamp(lerp(_cur_y, _y, _spd), 0, room_height - cam_h);
camera_set_view_pos(view_camera[0], _x, _y);
