function s_training_regime_effect_on_morale() {
	with (obj_master) {
		slog("s_training_regime_effect_on_morale");
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			var trainingreg = obj_master.training_reg_df;
			if (s_is_offensive_player(pmap)) {
				trainingreg = obj_master.training_reg_of;
			}
			if (ds_map_find_value(pmap, "condition") > 0 && !s_player_benched(pmap)) {
				slog(ds_map_find_value(pmap, "lname") + "Attitude was = " + string(ds_map_find_value(pmap, "attitude")));
				var amt = 0;
				switch (trainingreg) {
					case 1:
						amt = irandom(2);
					case 2:
						break;
					case 3:
						amt = irandom_range(-1, -3);
				}
				slog("Amt = " + string(amt));
				ds_map_set(pmap, "attitude", clamp(ds_map_find_value(pmap, "attitude") + amt, 1, 100));
				slog("Attitude now = " + string(ds_map_find_value(pmap, "attitude")));
			}
		}
	}
}

