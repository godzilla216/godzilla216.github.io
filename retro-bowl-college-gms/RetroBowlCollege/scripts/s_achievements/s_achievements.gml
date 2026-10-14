function s_complete_achievement(_arg0) {
	if (global.exhibition) {
		return;
	}
	var ach = s_get_achievement(_arg0);
	if (!ds_exists(ach, 1)) {
		return;
	}
	with (obj_controller) {
		if (comm_stage != 31 && s_simming_action()) {
			return;
		}
	}
	if (s_achievement_is_valid(ach) == false) {
		return;
	}
	if (!is_undefined(ds_map_find_value(ach, "achieved"))) {
		var count = real(ds_map_find_value(ach, "achieved"));
		if (count == 0) {
			s_notification(s_str("ui_Achievement") + "!", ds_map_find_value(ach, "description"));
		}
		ds_map_set(ach, "achieved", count + 1);
	}
}

function s_achievement_is_valid(_arg0) {
	if (!is_undefined(ds_map_find_value(_arg0, "valid_in"))) {
		var valid_in = ds_map_find_value(_arg0, "valid_in");
		if (string_length(valid_in) != 0) {
			var valid_list = string_split(valid_in, ",");
			if (s_is_co_mode() && !s_exists_in_list(valid_list, "co")) {
				return false;
			}
			if ((obj_master.fr_mode == 1 || obj_master.qb_mode == 1) && !s_exists_in_list(valid_list, "fr")) {
				return false;
			}
		}
	}
	return true;
}

function s_exists_in_list(_arg0, _arg1) {
	for (var i = 0; i < array_length_1d(_arg0); i++) {
		if (_arg1 == _arg0[i]) {
			return true;
		}
	}
	return false;
}

function s_count_achievement(_arg0) {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(achievements); i++) {
			var ach = ds_list_find_value(achievements, i);
			if (ds_map_find_value(ach, "tag") == _arg0) {
				return real(ds_map_find_value(ach, "achieved"));
			}
		}
	}
	return 0;
}

function s_get_achievement(_arg0) {
	var tag = _arg0;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(achievements); i++) {
			var ach = ds_list_find_value(achievements, i);
			if (ds_map_find_value(ach, "tag") == tag) {
				return ach;
			}
		}
	}
	return -4;
}

function s_get_achievement_percentage() {
	with (obj_master) {
		var sz = ds_list_size(achievements);
		var count = 0;
		for (var i = 0; i < sz; i++) {
			var ach = ds_list_find_value(achievements, i);
			if (!is_undefined(ds_map_find_value(ach, "achieved"))) {
				if (real(ds_map_find_value(ach, "achieved")) > 0) {
					count++;
				}
			}
		}
	}
	return round(count / sz * 100);
}

