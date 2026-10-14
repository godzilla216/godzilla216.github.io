function s_get_new_salary(_arg0) {
	var pmap = _arg0;
	var rating = s_get_player_rating(pmap);
	var salary = 0;
	switch (ds_map_find_value(pmap, "position")) {
		case 1:
			salary = rating * 1.66;
			break;
		case 2:
			salary = rating * 1;
			break;
		case 3:
			salary = rating * 0.9;
			break;
		case 4:
			salary = rating * 1.1;
			break;
		case 5:
			salary = rating * 0.8;
			break;
		case 6:
			salary = rating * 1;
			break;
		case 7:
			salary = rating * 0.9;
			break;
		case 8:
			salary = rating * 0.8;
			break;
		case 9:
			salary = rating * 0.75;
			break;
		case 10:
			salary = rating * 0.55;
			break;
	}
	salary *= 3;
	var age = ds_map_find_value(pmap, "age");
	var max_age = s_get_max_age(pmap);
	if (age == s_rookie_age_internal()) {
		salary *= 0.6;
	} else if (age > max_age - 2) {
		salary *= 0.55;
	} else if (age > max_age - 3) {
		salary *= 0.65;
	} else if (age > max_age - 4) {
		salary *= 0.75;
	} else if (age > max_age - 5) {
		salary *= 0.85;
	}
	return round(salary);
}

