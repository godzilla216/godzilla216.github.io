function s_count_full_seasons() {
	with (obj_master) {
		var season_count = 0;
		for (var i = 0; i < ds_list_size(history); i++) {
			var map = ds_list_find_value(history, i);
			if (map && ds_exists(map, 1)) {
				if (ds_map_exists(map, "year") && (real(ds_map_find_value(map, "year")) == 1 || real(ds_map_find_value(map, "year")) == year)) {
					continue;
				}
				if (ds_map_exists(map, "wins_sim") && real(ds_map_find_value(map, "wins_sim")) > 0) {
					continue;
				}
				if (ds_map_exists(map, "losses_sim") && real(ds_map_find_value(map, "losses_sim")) > 0) {
					continue;
				}
				if (ds_map_exists(map, "ties_sim") && real(ds_map_find_value(map, "ties_sim")) > 0) {
					continue;
				}
				season_count++;
			}
		}
		return season_count;
	}
}

function s_count_games_coached() {
	var count = 0;
	var last_map_year = 0;
	for (var i = 0; i < ds_list_size(obj_master.history); i++) {
		var map = ds_list_find_value(obj_master.history, i);
		if (ds_exists(map, 1)) {
			if (ds_map_exists(map, "wins")) {
				count += real(ds_map_find_value(map, "wins"));
			}
			if (ds_map_exists(map, "losses")) {
				count += real(ds_map_find_value(map, "losses"));
			}
			if (ds_map_exists(map, "ties")) {
				count += real(ds_map_find_value(map, "ties"));
			}
			if (ds_map_exists(map, "wins_po")) {
				count += real(ds_map_find_value(map, "wins_po"));
			}
			if (ds_map_exists(map, "losses_po")) {
				count += real(ds_map_find_value(map, "losses_po"));
			}
			if (ds_map_exists(map, "year") && real(ds_map_find_value(map, "year")) > last_map_year) {
				last_map_year = ds_map_find_value(map, "year");
			}
		}
	}
	if (last_map_year < obj_master.year) {
		count += s_count_fixtures_played();
	}
	if (s_is_co_mode() && last_map_year == 0) {
		count = 0;
	}
	return count;
}

function s_count_games_simmed() {
	var count = 0;
	var last_map_year = 0;
	for (var i = 0; i < ds_list_size(obj_master.history); i++) {
		var map = ds_list_find_value(obj_master.history, i);
		if (ds_exists(map, 1)) {
			if (ds_map_exists(map, "wins_sim")) {
				count += real(ds_map_find_value(map, "wins_sim"));
			}
			if (ds_map_exists(map, "losses_sim")) {
				count += real(ds_map_find_value(map, "losses_sim"));
			}
			if (ds_map_exists(map, "ties_sim")) {
				count += real(ds_map_find_value(map, "ties_sim"));
			}
			if (ds_map_exists(map, "year") && real(ds_map_find_value(map, "year")) > last_map_year) {
				last_map_year = ds_map_find_value(map, "year");
			}
		}
	}
	if (last_map_year < obj_master.year) {
		count += s_count_simmed_games(-1);
		count += s_count_simmed_games(0);
		count += s_count_simmed_games(1);
	}
	return count;
}

function s_count_fixtures_played() {
	var count = 0;
	with (obj_master) {
		count += real(ds_map_find_value(myteam, "wins"));
		count += real(ds_map_find_value(myteam, "losses"));
		count += real(ds_map_find_value(myteam, "ties"));
	}
	return count;
}

