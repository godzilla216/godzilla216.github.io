wind_force = 0;
wind = irandom(9);
wind_dir = irandom(7);
rain_rate = 1;
rain_speed = 3;
if (obj_controller.difficulty < 1) {
	wind = clamp(irandom(15), 0, 9);
}
if (obj_controller.difficulty > 5) {
	wind = irandom(5);
}
var hometeam = obj_controller.team[1];
type = 0;
if (obj_master.year == 1 || obj_master.week == s_get_week_superbowl() || s_is_co_bowl_week(obj_master.week)) {
} else if (obj_master.week < 12) {
	if (irandom(200) < real(ds_map_find_value(hometeam, "rainfall"))) {
		type = 1;
	}
} else if (obj_master.week <= obj_master.first_week_playoffs) {
	if (irandom(200) < real(ds_map_find_value(hometeam, "rainfall"))) {
		type = 1;
	} else if (1 + irandom(150) < real(ds_map_find_value(hometeam, "snowfall"))) {
		type = 2;
		wind = 0;
	}
} else if (1 + irandom(100) < ds_map_find_value(hometeam, "snowfall")) {
	type = 2;
	wind = 0;
} else if (irandom(200) < ds_map_find_value(hometeam, "rainfall")) {
	type = 1;
}
if (global.exhibition) {
	switch (ds_map_find_value(obj_master.map_options, "exh_op_weather")) {
		case 0:
			type = choose(0, 1, 2);
			wind = clamp(irandom_range(-4, 9), 0, 9);
			break;
		case 1:
			type = 0;
			wind = irandom(5);
			break;
		case 2:
			type = 1;
			wind = irandom(9);
			break;
		case 3:
			type = 2;
			wind = 0;
			break;
	}
	exit;
}
if (!ds_map_find_value(obj_master.map_options, "op_weather") || type == 0 || obj_master.gamepractice) {
	instance_destroy();
	exit;
}
switch (real(ds_map_find_value(hometeam, "roof"))) {
	case 0:
		break;
	case 1:
		if (type != 0 || wind > 5) {
			instance_destroy();
			exit;
		}
		break;
	case 2:
		instance_destroy();
		exit;
		break;
}
