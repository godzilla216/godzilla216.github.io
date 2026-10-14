function s_count_simmed_games(_arg0) {
	var wins = 0;
	var losses = 0;
	var ties = 0;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(fixturelist); i++) {
			var map = ds_list_find_value(fixturelist, i);
			if (ds_map_find_value(map, "human_win") != "unplayed") {
				if (ds_map_exists(map, "difficulty")) {
					var dif = ds_map_find_value(map, "difficulty");
					if (string_count(s_str("ui_Sim"), dif) > 0) {
						switch (ds_map_find_value(map, "human_win")) {
							case "win":
								wins++;
								break;
							case "loss":
								losses++;
								break;
							case "tie":
								ties++;
								break;
						}
					}
				}
			}
		}
	}
	switch (_arg0) {
		case -1:
			return losses;
			break;
		case 0:
			return ties;
			break;
		case 1:
			return wins;
			break;
	}
	return 0;
}

