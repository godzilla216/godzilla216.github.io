function s_get_condition_squad() {
	var con = 0;
	with (obj_master) {
		var size = 0;
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "condition") > 0 && !s_player_benched(pmap)) {
				con += ds_map_find_value(pmap, "condition");
				size++;
			}
		}
		if (size > 0) {
			con /= size;
		}
		return round(con);
	}
}

function s_get_condition_squad_from_roster(_arg0) {
	var con = 0;
	var size = 0;
	for (var i = 0; i < ds_list_size(_arg0); i++) {
		var pmap = ds_list_find_value(_arg0, i);
		if (ds_map_find_value(pmap, "condition") > 0 && !s_player_benched(pmap)) {
			con += ds_map_find_value(pmap, "condition");
			size++;
		}
	}
	if (size > 0) {
		con /= size;
	}
	return round(con);
}

