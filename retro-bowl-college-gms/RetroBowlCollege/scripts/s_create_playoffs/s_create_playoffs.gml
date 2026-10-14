function s_create_playoffs() {
	s_clear_playoff_fixtures();
	var afc_seed4 = s_get_division_winner_by_seed(0, 4);
	var afc_seed5 = s_get_team_by_seed(0, 5);
	s_create_fixdata(obj_master.playoffs, obj_master.first_week_playoffs, ds_map_find_value(afc_seed5, "uid"), ds_map_find_value(afc_seed4, "uid"));
	var afc_seed3 = s_get_division_winner_by_seed(0, 3);
	var afc_seed6 = s_get_team_by_seed(0, 6);
	s_create_fixdata(obj_master.playoffs, obj_master.first_week_playoffs + 1, ds_map_find_value(afc_seed6, "uid"), ds_map_find_value(afc_seed3, "uid"));
	var nfc_seed4 = s_get_division_winner_by_seed(1, 4);
	var nfc_seed5 = s_get_team_by_seed(1, 5);
	s_create_fixdata(obj_master.playoffs, obj_master.first_week_playoffs + 2, ds_map_find_value(nfc_seed5, "uid"), ds_map_find_value(nfc_seed4, "uid"));
	var nfc_seed3 = s_get_division_winner_by_seed(1, 3);
	var nfc_seed6 = s_get_team_by_seed(1, 6);
	s_create_fixdata(obj_master.playoffs, obj_master.first_week_playoffs + 3, ds_map_find_value(nfc_seed6, "uid"), ds_map_find_value(nfc_seed3, "uid"));
	var afc_seed1 = s_get_division_winner_by_seed(0, 1);
	var afc_seed2 = s_get_division_winner_by_seed(0, 2);
	s_create_fixdata(obj_master.playoffs, obj_master.first_week_playoffs + 4, -1, ds_map_find_value(afc_seed1, "uid"));
	s_create_fixdata(obj_master.playoffs, obj_master.first_week_playoffs + 5, -1, ds_map_find_value(afc_seed2, "uid"));
	var nfc_seed1 = s_get_division_winner_by_seed(1, 1);
	var nfc_seed2 = s_get_division_winner_by_seed(1, 2);
	s_create_fixdata(obj_master.playoffs, obj_master.first_week_playoffs + 6, -1, ds_map_find_value(nfc_seed1, "uid"));
	s_create_fixdata(obj_master.playoffs, obj_master.first_week_playoffs + 7, -1, ds_map_find_value(nfc_seed2, "uid"));
	s_create_fixdata(obj_master.playoffs, obj_master.first_week_playoffs + 8, -1, -1);
	s_create_fixdata(obj_master.playoffs, obj_master.first_week_playoffs + 9, -1, -1);
	s_create_fixdata(obj_master.playoffs, obj_master.first_week_playoffs + 10, -1, -1);
}

