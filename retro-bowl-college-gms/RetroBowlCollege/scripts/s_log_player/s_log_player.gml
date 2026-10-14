function s_log_player(_arg0) {
	var map = _arg0;
	var k = ds_map_find_first(map);
	var maptext = "";
	while (!is_undefined(k)) {
		maptext += k + ": " + string(ds_map_find_value(map, k)) + "\n";
		k = ds_map_find_next(map, k);
	}
	slog(maptext);
}

