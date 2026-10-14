function s_get_random_scoredata() {
	var map = ds_map_create();
	ds_map_set(map, "points", 0);
	ds_map_set(map, "yards", 0);
	ds_map_set(map, "tds", 0);
	ds_map_set(map, "sacks", 0);
	ds_map_set(map, "ints", 0);
	var chances = irandom_range(6, 12);
	for (var s = 0; s < chances; s++) {
		switch (irandom(2)) {
			case 0:
				if (irandom(1)) {
					ds_map_set(map, "tds", ds_map_find_value(map, "tds") + 1);
					ds_map_set(map, "yards", ds_map_find_value(map, "yards") + (40 + irandom(40)));
				}
				ds_map_set(map, "points", ds_map_find_value(map, "points") + 7);
				if (irandom(99) > 93) {
					ds_map_set(map, "points", ds_map_find_value(map, "points") - 1);
				}
				break;
			case 1:
				ds_map_set(map, "yards", ds_map_find_value(map, "yards") + irandom(20));
				ds_map_set(map, "points", ds_map_find_value(map, "points") + 3);
				if (irandom(5) == 0) {
					ds_map_set(map, "points", ds_map_find_value(map, "points") - 3);
				}
				break;
			default:
				ds_map_set(map, "yards", ds_map_find_value(map, "yards") + irandom(10));
				switch (irandom(2)) {
					case 0:
						ds_map_set(map, "sacks", ds_map_find_value(map, "sacks") + 1);
						break;
					case 1:
						ds_map_set(map, "ints", ds_map_find_value(map, "ints") + 1);
						break;
					case 2:
						break;
				}
				break;
		}
	}
	return map;
}

function s_co_get_random_scoredata(_arg0) {
	var map = ds_map_create();
	ds_map_set(map, "points", 0);
	ds_map_set(map, "yards", 0);
	ds_map_set(map, "tds", 0);
	ds_map_set(map, "sacks", 0);
	ds_map_set(map, "ints", 0);
	if (_arg0 == 0) {
		_arg0 = irandom_range(6, 12);
	}
	for (var s = 0; s < _arg0; s++) {
		switch (irandom(2)) {
			case 0:
				if (irandom(1)) {
					ds_map_set(map, "tds", ds_map_find_value(map, "tds") + 1);
					ds_map_set(map, "yards", ds_map_find_value(map, "yards") + (40 + irandom(40)));
				}
				ds_map_set(map, "points", ds_map_find_value(map, "points") + 6);
				if (irandom(99) > 93) {
					ds_map_set(map, "points", ds_map_find_value(map, "points") + 1);
				}
				break;
			case 1:
				ds_map_set(map, "yards", ds_map_find_value(map, "yards") + irandom(20));
				ds_map_set(map, "points", ds_map_find_value(map, "points") + 3);
				if (irandom(5) == 0) {
					ds_map_set(map, "points", ds_map_find_value(map, "points") - 3);
				}
				break;
			default:
				ds_map_set(map, "yards", ds_map_find_value(map, "yards") + irandom(10));
				switch (irandom(2)) {
					case 0:
						ds_map_set(map, "sacks", ds_map_find_value(map, "sacks") + 1);
						break;
					case 1:
						ds_map_set(map, "ints", ds_map_find_value(map, "ints") + 1);
						break;
					case 2:
						break;
				}
				break;
		}
	}
	return map;
}

