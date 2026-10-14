function s_create_storelist(_arg0) {
	slog("s_create_storelist");
	with (obj_master) {
		var size = ds_list_size(storelist);
		if (_arg0 > 0) {
			repeat (_arg0) {
				if (size > 0) {
					var i = irandom(size - 1);
					ds_map_destroy(ds_list_find_value(storelist, i));
					ds_list_set(storelist, i, -1);
					ds_list_delete(storelist, i);
					size -= 1;
				}
			}
		}
		for (var l = 0; l < 2; l++) {
			for (var i = 1; i <= 10; i++) {
				if (s_count_players_by_position_store(i) < 2) {
					if (i == 9) {
						continue;
					}
					var lower_rating = false;
					if (_arg0 || l == 1) {
						lower_rating = true;
					}
					ds_list_add(storelist, s_create_player_storelist(i, lower_rating));
				}
			}
		}
		slog("Storelist size = " + string(ds_list_size(storelist)));
		storelist = s_sort_hirelist(storelist);
	}
}

