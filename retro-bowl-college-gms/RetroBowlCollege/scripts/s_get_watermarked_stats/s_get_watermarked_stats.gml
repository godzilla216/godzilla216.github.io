function s_get_watermarked_stats(_arg0) {
	var pmap = _arg0;
	var pos = ds_map_find_value(pmap, "position");
	var gms = string(ds_map_find_value(pmap, "season_games"));
	var cgms = string(ds_map_find_value(pmap, "career_games"));
	var att = string(ds_map_find_value(pmap, "season_attempts"));
	var cmp = string(ds_map_find_value(pmap, "season_complete"));
	var yds = string(round(ds_map_find_value(pmap, "season_yards")));
	var avg = s_get_string_float(s_get_average_yards(pmap, 1, false), 1);
	var lng = string(round(ds_map_find_value(pmap, "season_longest")));
	var tds = string(ds_map_find_value(pmap, "season_touchdowns"));
	var fum = string(ds_map_find_value(pmap, "season_fumbles"));
	var tck = string(ds_map_find_value(pmap, "season_tackles"));
	var int = string(ds_map_find_value(pmap, "season_int"));
	var sck = string(ds_map_find_value(pmap, "season_sacks"));
	var r_att = string(ds_map_find_value(pmap, "season_rush_attempts"));
	var r_yds = string(round(ds_map_find_value(pmap, "season_rush_yards")));
	var r_avg = s_get_string_float(s_get_average_yards(pmap, 1, true), 1);
	var r_lng = string(round(ds_map_find_value(pmap, "season_rush_longest")));
	var r_tds = string(ds_map_find_value(pmap, "season_rush_touchdowns"));
	var str = s_get_string_position(ds_map_find_value(pmap, "position")) + " ";
	if (pos == 10) {
		str = "KK ";
	}
	str += "G" + gms + "/" + cgms;
	switch (pos) {
		case 1:
			str += "  AC:" + att + "/" + cmp;
			str += "  Y:" + yds + "/" + r_yds;
			str += "  TD:" + tds + "/" + r_tds;
			str += "  TO:" + int + "/" + fum;
			str += "  SK:" + sck;
			break;
		case 2:
			str += "  TC:" + att + "/" + r_att;
			str += "  Y:" + yds + "/" + r_yds;
			str += "  TD:" + tds + "/" + r_tds;
			str += "  FM:" + fum;
			break;
		case 3:
		case 4:
			str += "  R:" + att;
			str += "  Y:" + yds;
			str += "  TD:" + tds;
			str += "  AV:" + avg;
			str += "  FM:" + fum;
			break;
		case 10:
			str += "  AC:" + att + "/" + cmp;
			str += "  YD:" + yds;
			break;
		case 5:
			str += "  BL:" + tck;
			break;
		default:
			str += "  TK:" + tck;
			str += "  SK:" + sck;
			str += "  IN:" + int;
			str += "  FF:" + fum;
			break;
	}
	return str;
}

