function s_is_offensive_player(_arg0) {
	switch (ds_map_find_value(_arg0, "position")) {
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 102:
			return true;
		case 6:
		case 7:
		case 8:
		case 9:
		case 10:
		case 101:
			return false;
	}
	return false;
}

function s_get_training_reg(_arg0) {
	var trainingreg = obj_master.training_reg_df;
	if (s_is_offensive_player(_arg0)) {
		trainingreg = obj_master.training_reg_of;
	}
	return trainingreg;
}

