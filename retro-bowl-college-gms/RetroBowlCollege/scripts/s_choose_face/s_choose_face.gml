function s_choose_face(_arg0, _arg1) {
	var gw = ds_grid_width(_arg1);
	var gh = ds_grid_height(_arg1);
	var sx = irandom(gw - 1);
	var sy = irandom(gh - 1);
	if (ds_grid_get_min(_arg1, 0, 0, gw, gh) == 1) {
		ds_grid_clear(_arg1, 0);
		with (obj_master) {
			if (_arg1 == face_grid_C && myface_x >= 0 && myface_y >= 0) {
				ds_grid_set(_arg1, myface_x, myface_y, 1);
			}
		}
	}
	for (var fx = sx; fx < ds_grid_width(_arg1); fx++) {
		for (var fy = sy; fy < ds_grid_height(_arg1); fy++) {
			if (ds_grid_get(_arg1, fx, fy) == 0) {
				ds_grid_set(_arg1, fx, fy, 1);
				ds_map_set(_arg0, "face_x", fx);
				ds_map_set(_arg0, "face_y", fy);
				return _arg0;
			}
		}
	}
	for (var fx = 0; fx < gw; fx++) {
		for (var fy = 0; fy < gh; fy++) {
			if (ds_grid_get(_arg1, fx, fy) == 0) {
				ds_grid_set(_arg1, fx, fy, 1);
				ds_map_set(_arg0, "face_x", fx);
				ds_map_set(_arg0, "face_y", fy);
				return _arg0;
			}
		}
	}
	slog(ds_map_find_value(_arg0, "lname") + " no face!");
}

function s_face_from_set(_arg0, _arg1) {
	if (_arg1 == -4) {
		return _arg0;
	}
	if (!ds_map_exists(_arg1, "face_set")) {
		return _arg0;
	}
	var fs = ds_map_find_value(_arg1, "face_set");
	switch (_arg0) {
		case spr_light_001:
			return fs == 0 ? spr_light_001 : (fs == 1 ? spr_light_001_co : spr_light_001_co_s);
		case spr_light_002:
			return fs == 0 ? spr_light_002 : (fs == 1 ? spr_light_002_co : spr_light_002_co_s);
		case spr_light_003:
			return fs == 0 ? spr_light_003 : (fs == 1 ? spr_light_003_co : spr_light_003_co_s);
		case spr_mix_001:
			return fs == 0 ? spr_mix_001 : (fs == 1 ? spr_mix_001_co : spr_mix_001_co_s);
		case spr_dark_001:
			return fs == 0 ? spr_dark_001 : (fs == 1 ? spr_dark_001_co : spr_dark_001_co_s);
		case spr_dark_002:
			return fs == 0 ? spr_dark_002 : (fs == 1 ? spr_dark_002_co : spr_dark_002_co_s);
		case spr_dark_003:
			return fs == 0 ? spr_dark_003 : (fs == 1 ? spr_dark_003_co : spr_dark_003_co_s);
		case spr_dark_004:
			return fs == 0 ? spr_dark_004 : (fs == 1 ? spr_dark_004_co : spr_dark_004_co_s);
		case spr_dark_005:
			return fs == 0 ? spr_dark_005 : (fs == 1 ? spr_dark_005_co : spr_dark_005_co_s);
		case spr_dark_006:
			return fs == 0 ? spr_dark_006 : (fs == 1 ? spr_dark_006_co : spr_dark_006_co_s);
		case spr_dark_007:
			return fs == 0 ? spr_dark_007 : (fs == 1 ? spr_dark_007_co : spr_dark_007_co_s);
		case spr_dark_008:
			return fs == 0 ? spr_dark_008 : (fs == 1 ? spr_dark_008_co : spr_dark_008_co_s);
	}
	return _arg0;
}

function s_face_from_set_direct(_arg0, _arg1) {
	switch (_arg0) {
		case spr_light_001:
			return _arg1 == 0 ? spr_light_001 : (_arg1 == 1 ? spr_light_001_co : spr_light_001_co_s);
		case spr_light_002:
			return _arg1 == 0 ? spr_light_002 : (_arg1 == 1 ? spr_light_002_co : spr_light_002_co_s);
		case spr_light_003:
			return _arg1 == 0 ? spr_light_003 : (_arg1 == 1 ? spr_light_003_co : spr_light_003_co_s);
		case spr_mix_001:
			return _arg1 == 0 ? spr_mix_001 : (_arg1 == 1 ? spr_mix_001_co : spr_mix_001_co_s);
		case spr_dark_001:
			return _arg1 == 0 ? spr_dark_001 : (_arg1 == 1 ? spr_dark_001_co : spr_dark_001_co_s);
		case spr_dark_002:
			return _arg1 == 0 ? spr_dark_002 : (_arg1 == 1 ? spr_dark_002_co : spr_dark_002_co_s);
		case spr_dark_003:
			return _arg1 == 0 ? spr_dark_003 : (_arg1 == 1 ? spr_dark_003_co : spr_dark_003_co_s);
		case spr_dark_004:
			return _arg1 == 0 ? spr_dark_004 : (_arg1 == 1 ? spr_dark_004_co : spr_dark_004_co_s);
		case spr_dark_005:
			return _arg1 == 0 ? spr_dark_005 : (_arg1 == 1 ? spr_dark_005_co : spr_dark_005_co_s);
		case spr_dark_006:
			return _arg1 == 0 ? spr_dark_006 : (_arg1 == 1 ? spr_dark_006_co : spr_dark_006_co_s);
		case spr_dark_007:
			return _arg1 == 0 ? spr_dark_007 : (_arg1 == 1 ? spr_dark_007_co : spr_dark_007_co_s);
		case spr_dark_008:
			return _arg1 == 0 ? spr_dark_008 : (_arg1 == 1 ? spr_dark_008_co : spr_dark_008_co_s);
	}
	return _arg0;
}

