function s_create_player_storelist(_arg0, _arg1) {
	slog("s_create_player_storelist");
	var max_rating = 10;
	if (_arg1) {
		max_rating = 8 - floor(obj_master.week / 3);
		if (max_rating < 4) {
			max_rating = 4;
		}
	}
	var pmap = s_create_player(_arg0, s_rookie_age_internal() + 2 + irandom(5), max_rating - 2, max_rating);
	ds_map_set(pmap, "attitude", irandom_range(50, 100));
	ds_map_set(pmap, "salary", round(ds_map_find_value(pmap, "salary") * 0.8));
	switch (obj_master.op_difficulty) {
		case 0:
			ds_map_set(pmap, "salary", round(ds_map_find_value(pmap, "salary") * 1));
			break;
		case 1:
			break;
		case 2:
			ds_map_set(pmap, "salary", round(ds_map_find_value(pmap, "salary") * 0.9));
			break;
		case 3:
			ds_map_set(pmap, "salary", round(ds_map_find_value(pmap, "salary") * 1));
			break;
		case 4:
			ds_map_set(pmap, "salary", round(ds_map_find_value(pmap, "salary") * 1.1));
			break;
	}
	ds_map_set(pmap, "creditcost", round(s_get_player_rating(pmap) + ds_map_find_value(pmap, "salary") * 0.5));
	ds_map_set(pmap, "contract", 3);
	if (_arg1) {
		ds_map_set(pmap, "attitude", irandom_range(20, 90));
	}
	return pmap;
}

