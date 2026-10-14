function s_clear_trade_offers() {
	for (var i = 0; i < ds_list_size(obj_master.roster); i++) {
		var pmap = ds_list_find_value(obj_master.roster, i);
		ds_map_set(pmap, "outtrade_pick", 0);
		ds_map_set(pmap, "intrade_pick", 0);
	}
	s_savegame();
}

