function s_tag_backups() {
	slog("s_tag_backups");
	with (obj_master) {
		roster = s_sort_players(roster, 3);
		s_tag_backups_internal(roster);
	}
}

function s_tag_backups_internal(_arg0) {
	if (_arg0 == -4) {
		slog("s_tag_backups_internal. no cur_roster");
		return;
	}
	with (obj_master) {
		var count = array_create(11, 0);
		for (var i = 0; i < ds_list_size(_arg0); i++) {
			var pmap = ds_list_find_value(_arg0, i);
			var pos = clamp(real(ds_map_find_value(pmap, "position")), 1, 10);
			ds_map_set(pmap, "backup", false);
			if (s_player_benched(pmap)) {
				continue;
			}
			if (ds_map_find_value(pmap, "condition") < 0) {
				continue;
			}
			count[pos]++;
			var maxpos = 1;
			switch (pos) {
				case 1:
					maxpos = 2;
					break;
				case 2:
					maxpos = 2;
					break;
				case 3:
					maxpos = 3;
					break;
				case 4:
					maxpos = 3;
					break;
				case 5:
					maxpos = 6;
					break;
				case 6:
					maxpos = 5;
					break;
				case 7:
					maxpos = 4;
					break;
				case 9:
				case 8:
					maxpos = 5;
					break;
				case 10:
					maxpos = 2;
					break;
			}
			if (count[pos] >= maxpos) {
				ds_map_set(pmap, "backup", true);
			}
		}
	}
}

