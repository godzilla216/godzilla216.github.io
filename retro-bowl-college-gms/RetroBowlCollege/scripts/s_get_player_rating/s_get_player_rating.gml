function s_get_player_rating(_arg0) {
	var max_rating = 0;
	var rating = 0;
	switch (ds_map_find_value(_arg0, "position")) {
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
	var stm = 0;
	var spd = 0;
	var str = 0;
	var skl = 0;
	if (ds_map_exists(_arg0, "stamina")) {
		stm = real(ds_map_find_value(_arg0, "stamina"));
	}
	if (ds_map_exists(_arg0, "speed")) {
		spd = real(ds_map_find_value(_arg0, "speed"));
	}
	if (ds_map_exists(_arg0, "strength")) {
		str = real(ds_map_find_value(_arg0, "strength"));
	}
	if (ds_map_exists(_arg0, "skill")) {
		skl = real(ds_map_find_value(_arg0, "skill"));
	}
	rating = stm + spd + str + skl;
	rating = round(rating / max_rating * 10);
	return clamp(rating, 1, 10);
}

