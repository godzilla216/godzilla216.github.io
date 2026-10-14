function s_get_match_rating(_arg0) {
	var mrating = 0;
	var pos = ds_map_find_value(_arg0, "position");
	switch (pos) {
		case 1:
			mrating += ds_map_find_value(_arg0, "stat_touchdowns");
			mrating += ds_map_find_value(_arg0, "stat_rush_touchdowns");
			mrating -= ds_map_find_value(_arg0, "stat_int") * 0.5;
			mrating -= ds_map_find_value(_arg0, "stat_sacks") * 0.5;
			mrating += ds_map_find_value(_arg0, "stat_yards") / 50;
			mrating += ds_map_find_value(_arg0, "stat_rush_yards") / 25;
			mrating -= ds_map_find_value(_arg0, "stat_fumbles");
			break;
		case 5:
			mrating += ds_map_find_value(_arg0, "stat_tackles");
			mrating += ds_map_find_value(_arg0, "stat_complete") * 0.25;
			mrating -= ds_map_find_value(_arg0, "stat_sacks");
			break;
		case 4:
			mrating += ds_map_find_value(_arg0, "stat_tackles");
			mrating += ds_map_find_value(_arg0, "stat_touchdowns");
			mrating += ds_map_find_value(_arg0, "stat_yards") / 20;
			mrating -= ds_map_find_value(_arg0, "stat_fumbles");
			if (ds_map_find_value(_arg0, "stat_return_attempts")) {
				mrating += ds_map_find_value(_arg0, "stat_return_yards") / ds_map_find_value(_arg0, "stat_return_attempts") / 10;
				mrating += ds_map_find_value(_arg0, "stat_return_tds");
			}
			if (mrating < 5 && ds_map_find_value(_arg0, "stat_touchdowns") > 0) {
				mrating = 5;
			}
			break;
		case 3:
			mrating += ds_map_find_value(_arg0, "stat_tackles") * 2;
			mrating += ds_map_find_value(_arg0, "stat_touchdowns") * 2;
			mrating += ds_map_find_value(_arg0, "stat_yards") / 7.5;
			mrating -= ds_map_find_value(_arg0, "stat_fumbles");
			if (mrating < 5 && ds_map_find_value(_arg0, "stat_touchdowns") > 0) {
				mrating = 5.5;
			}
			break;
		case 2:
			mrating += ds_map_find_value(_arg0, "stat_tackles");
			mrating += ds_map_find_value(_arg0, "stat_touchdowns") * 3;
			mrating += ds_map_find_value(_arg0, "stat_yards") / 15;
			mrating += ds_map_find_value(_arg0, "stat_rush_touchdowns") * 2;
			mrating += ds_map_find_value(_arg0, "stat_rush_yards") / 15;
			mrating -= ds_map_find_value(_arg0, "stat_fumbles");
			if (ds_map_find_value(_arg0, "stat_return_attempts")) {
				mrating += ds_map_find_value(_arg0, "stat_return_yards") / ds_map_find_value(_arg0, "stat_return_attempts") / 10;
				mrating += ds_map_find_value(_arg0, "stat_return_tds");
			}
			if (mrating < 5 && ds_map_find_value(_arg0, "stat_touchdowns") > 0) {
				mrating = 5;
			}
			break;
		case 10:
			mrating = 5;
			if (ds_map_find_value(_arg0, "stat_attempts")) {
				mrating = 4;
				mrating += ds_map_find_value(_arg0, "stat_complete");
				mrating -= ds_map_find_value(_arg0, "stat_attempts") - ds_map_find_value(_arg0, "stat_complete");
				if (ds_map_find_value(_arg0, "stat_longest") > 40) {
					mrating += 2;
				} else if (ds_map_find_value(_arg0, "stat_longest") > 30) {
					mrating += 1;
				}
			}
			if (ds_map_exists(_arg0, "stat_attempts_XP") && ds_map_find_value(_arg0, "stat_attempts_XP") > 0) {
				mrating += ds_map_find_value(_arg0, "stat_complete_XP");
				mrating -= ds_map_find_value(_arg0, "stat_attempts_XP") - ds_map_find_value(_arg0, "stat_complete_XP");
			}
			break;
		case 6:
		case 7:
		case 8:
		case 9:
			mrating += ds_map_find_value(_arg0, "stat_tackles") * 1.5;
			mrating += ds_map_find_value(_arg0, "stat_int") * 2;
			mrating += ds_map_find_value(_arg0, "stat_sacks") * 2;
			mrating += ds_map_find_value(_arg0, "stat_fumbles") * 2;
			if (ds_map_find_value(_arg0, "stat_return_attempts")) {
				mrating += ds_map_find_value(_arg0, "stat_return_yards") / ds_map_find_value(_arg0, "stat_return_attempts") / 10;
				mrating += ds_map_find_value(_arg0, "stat_return_tds");
			}
			break;
	}
	if (ds_map_exists(_arg0, "kr") && ds_map_find_value(_arg0, "kr")) {
		if (ds_map_exists(_arg0, "backup") && ds_map_find_value(_arg0, "backup")) {
			mrating += 1;
		}
	}
	switch (obj_master.op_matchlength) {
		case -1:
			mrating *= 1.33;
			break;
		case 0:
			break;
		case 1:
			mrating *= 0.66;
			break;
	}
	if (mrating >= 10) {
		if (s_is_offensive_player(_arg0) && ds_map_find_value(_arg0, "stat_fumbles") > 0) {
			mrating = 9;
		}
		if (pos == 1) {
			if (ds_map_find_value(_arg0, "stat_int") > 0) {
				mrating = 9;
			}
			if (ds_map_find_value(_arg0, "stat_sacks") > 0) {
				mrating = 9;
			}
		} else if (pos == 10) {
			if (ds_map_find_value(_arg0, "stat_attempts") > ds_map_find_value(_arg0, "stat_complete")) {
				mrating = 9;
			}
		}
	}
	return clamp(round(mrating), 1, 10);
}

