switch (type) {
	case 1:
		obj_master.coach_credit += value;
		break;
	case 2:
		if (!is_undefined(pmap)) {
			ds_map_set(pmap, "rating", ds_map_find_value(pmap, "rating") + 1);
		}
		break;
}
