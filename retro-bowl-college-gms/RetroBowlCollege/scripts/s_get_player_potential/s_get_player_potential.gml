function s_get_player_potential(_arg0) {
	var pmap = _arg0;
	var max_rating = 0;
	var rating = 0;
	switch (ds_map_find_value(pmap, "position")) {
		case 1:
			max_rating = 37;
			break;
		case 2:
			max_rating = 34;
			break;
		case 3:
			max_rating = 33;
			break;
		case 4:
			max_rating = 34;
			break;
		case 5:
			max_rating = 35;
			break;
		case 6:
			max_rating = 35;
			break;
		case 7:
			max_rating = 33;
			break;
		case 8:
			max_rating = 33;
			break;
		case 9:
			max_rating = 33;
			break;
		case 10:
			max_rating = 37;
			break;
	}
	var mstm = 0;
	var mspd = 0;
	var mstr = 0;
	var mskl = 0;
	if (ds_map_exists(pmap, "max_stamina")) {
		mstm = real(ds_map_find_value(pmap, "max_stamina"));
	}
	if (ds_map_exists(pmap, "max_speed")) {
		mspd = real(ds_map_find_value(pmap, "max_speed"));
	}
	if (ds_map_exists(pmap, "max_strength")) {
		mstr = real(ds_map_find_value(pmap, "max_strength"));
	}
	if (ds_map_exists(pmap, "max_skill")) {
		mskl = real(ds_map_find_value(pmap, "max_skill"));
	}
	rating = mstm + mspd + mstr + mskl;
	return clamp(round(rating / max_rating * 10), 1, 10);
}

