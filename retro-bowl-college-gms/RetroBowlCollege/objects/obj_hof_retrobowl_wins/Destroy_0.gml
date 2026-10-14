for (var i = 0; i < ds_list_size(retrobowlhof); i++) {
	ds_map_destroy(ds_list_find_value(retrobowlhof, i));
	ds_list_set(retrobowlhof, i, -1);
}
ds_list_destroy(retrobowlhof);
retrobowlhof = -1;
