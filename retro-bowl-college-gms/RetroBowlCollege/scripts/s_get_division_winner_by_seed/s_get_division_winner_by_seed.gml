function s_get_division_winner_by_seed(_arg0, _arg1) {
	var div_winners = ds_list_create();
	ds_list_add(div_winners, s_get_division_winner(_arg0, 0));
	ds_list_add(div_winners, s_get_division_winner(_arg0, 1));
	ds_list_add(div_winners, s_get_division_winner(_arg0, 2));
	ds_list_add(div_winners, s_get_division_winner(_arg0, 3));
	div_winners = s_sort_teams(div_winners, 0, false);
	var team = ds_list_find_value(div_winners, _arg1 - 1);
	ds_list_destroy(div_winners);
	div_winners = -1;
	return team;
}

