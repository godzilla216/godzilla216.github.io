for (var i = 0; i < ds_list_size(retrobowlhof); i++) {
	var map = ds_list_find_value(retrobowlhof, i);
	if (ds_map_find_value(map, "year") <= obj_master.start_year) {
		ds_map_destroy(map);
		map = -1;
	}
}
ds_list_clear(retrobowlhof);
ds_list_destroy(retrobowlhof);
retrobowlhof = -1;
