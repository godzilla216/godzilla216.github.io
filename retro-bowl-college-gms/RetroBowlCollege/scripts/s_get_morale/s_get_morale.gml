function s_get_morale() {
	var mor = 0;
	with (obj_master) {
		var size = 0;
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (is_undefined(ds_map_find_value(pmap, "attitude"))) {
				ds_map_set(pmap, "attitude", 50);
			}
			mor += ds_map_find_value(pmap, "attitude");
			size++;
		}
		if (!qb_mode) {
			for (var i = 0; i < ds_list_size(stafflist); i++) {
				var pmap = ds_list_find_value(stafflist, i);
				if (is_undefined(ds_map_find_value(pmap, "attitude"))) {
					ds_map_set(pmap, "attitude", 50);
				}
				mor += ds_map_find_value(pmap, "attitude");
				size++;
			}
		}
		mor /= size;
		mor = round(1 + mor);
		return clamp(mor, 1, 100);
	}
}

function s_get_morale_from_roster(_arg0) {
	var mor = 0;
	var size = 0;
	for (var i = 0; i < ds_list_size(_arg0); i++) {
		var pmap = ds_list_find_value(_arg0, i);
		if (is_undefined(ds_map_find_value(pmap, "attitude"))) {
			ds_map_set(pmap, "attitude", 50);
		}
		mor += ds_map_find_value(pmap, "attitude");
		size++;
	}
	with (obj_master) {
		if (!qb_mode && !global.exhibition) {
			for (var i = 0; i < ds_list_size(stafflist); i++) {
				var pmap = ds_list_find_value(stafflist, i);
				if (is_undefined(ds_map_find_value(pmap, "attitude"))) {
					ds_map_set(pmap, "attitude", 50);
				}
				mor += ds_map_find_value(pmap, "attitude");
				size++;
			}
		}
	}
	mor /= size;
	mor = round(1 + mor);
	return clamp(mor, 1, 100);
}

