function s_is_bye_week(_arg0) {
	with (obj_master) {
		var fix = s_get_human_fixture_by_week(_arg0);
		if (!fix && _arg0 < obj_master.first_week_playoffs) {
			return true;
		}
	}
	return false;
}

function s_get_bye_week() {
	with (obj_master) {
		var wk = 1;
		for (var f = 0; f < ds_list_size(fixturelist); f++) {
			var fix = ds_list_find_value(fixturelist, f);
			if (fix && !is_undefined(ds_map_find_value(fix, "week")) && real(ds_map_find_value(fix, "week")) == wk) {
				wk++;
			} else {
				return wk;
			}
			if (wk > obj_master.first_week_playoffs) {
				return obj_master.first_week_playoffs;
			}
		}
	}
}

