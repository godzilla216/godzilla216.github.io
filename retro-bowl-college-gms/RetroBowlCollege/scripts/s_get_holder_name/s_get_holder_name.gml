function s_get_holder_name() {
	with (global.master_ball) {
		if (holder && holder.pmap) {
			return s_get_string_position(ds_map_find_value(holder.pmap, "position")) + " " + string_copy(ds_map_find_value(holder.pmap, "fname"), 1, 1) + "." + ds_map_find_value(holder.pmap, "lname");
		}
	}
	return "0";
}

