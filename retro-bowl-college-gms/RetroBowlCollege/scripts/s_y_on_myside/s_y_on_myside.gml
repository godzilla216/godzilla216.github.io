function s_y_on_myside(_arg0) {
	if (y < 300) {
		with (obj_metaball) {
			if (_arg0 < 276) {
				return true;
			}
		}
	} else {
		with (obj_metaball) {
			if (_arg0 > 332) {
				return true;
			}
		}
	}
	return false;
}

