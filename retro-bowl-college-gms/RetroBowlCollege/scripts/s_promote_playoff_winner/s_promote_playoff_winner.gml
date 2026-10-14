function s_promote_playoff_winner(_arg0, _arg1) {
	slog("s_promote_playoff_winner" + string(_arg1));
	var nextround_fix;
	var week_afc_champ = 26;
	var week_nfc_champ = 27;
	if (s_playoffs_12()) {
		if (_arg0 == obj_master.first_week_playoffs) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 4);
		} else if (_arg0 == obj_master.first_week_playoffs + 1) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 5);
		} else if (_arg0 == obj_master.first_week_playoffs + 2) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 6);
		} else if (_arg0 == obj_master.first_week_playoffs + 3) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 7);
		} else if (_arg0 == obj_master.first_week_playoffs + 4) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 8);
		} else if (_arg0 == obj_master.first_week_playoffs + 5) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 8);
		} else if (_arg0 == obj_master.first_week_playoffs + 6) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 9);
		} else if (_arg0 == obj_master.first_week_playoffs + 7) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 9);
		} else if (_arg0 == obj_master.first_week_playoffs + 8) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 10);
		} else if (_arg0 == obj_master.first_week_playoffs + 9) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 10);
		} else {
			return;
		}
	} else {
		week_afc_champ = 28;
		week_nfc_champ = 29;
		if (obj_master.first_week_playoffs == 19) {
			week_afc_champ += 1;
			week_nfc_champ += 1;
		}
		if (_arg0 == obj_master.first_week_playoffs) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 6);
		} else if (_arg0 == obj_master.first_week_playoffs + 1) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 7);
		} else if (_arg0 == obj_master.first_week_playoffs + 2) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 7);
		} else if (_arg0 == obj_master.first_week_playoffs + 3) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 8);
		} else if (_arg0 == obj_master.first_week_playoffs + 4) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 9);
		} else if (_arg0 == obj_master.first_week_playoffs + 5) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 9);
		} else if (_arg0 == obj_master.first_week_playoffs + 6) {
			nextround_fix = s_get_playoff_fixture_by_week(week_afc_champ);
		} else if (_arg0 == obj_master.first_week_playoffs + 7) {
			nextround_fix = s_get_playoff_fixture_by_week(week_afc_champ);
		} else if (_arg0 == obj_master.first_week_playoffs + 8) {
			nextround_fix = s_get_playoff_fixture_by_week(week_nfc_champ);
		} else if (_arg0 == obj_master.first_week_playoffs + 9) {
			nextround_fix = s_get_playoff_fixture_by_week(week_nfc_champ);
		} else if (_arg0 == obj_master.first_week_playoffs + 10) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 12);
		} else if (_arg0 == obj_master.first_week_playoffs + 11) {
			nextround_fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 12);
		} else {
			return;
		}
	}
	if (nextround_fix) {
		slog("Got next round fix: " + string(ds_map_find_value(nextround_fix, "week")));
		if (ds_map_find_value(nextround_fix, "away_team") == -1) {
			ds_map_set(nextround_fix, "away_team", _arg1);
		} else if (ds_map_find_value(nextround_fix, "home_team") == -1) {
			ds_map_set(nextround_fix, "home_team", _arg1);
		}
		if (real(ds_map_find_value(nextround_fix, "week")) == obj_master.first_week_playoffs + 7 && ds_map_find_value(nextround_fix, "away_team") > -1 && ds_map_find_value(nextround_fix, "home_team") > -1) {
			s_seed_divisional_round(0);
		} else if (real(ds_map_find_value(nextround_fix, "week")) == obj_master.first_week_playoffs + 9 && ds_map_find_value(nextround_fix, "away_team") > -1 && ds_map_find_value(nextround_fix, "home_team") > -1) {
			s_seed_divisional_round(1);
		}
		if (real(ds_map_find_value(nextround_fix, "week")) == week_afc_champ || real(ds_map_find_value(nextround_fix, "week")) == week_nfc_champ) {
			if (ds_map_find_value(nextround_fix, "away_team") > -1 && ds_map_find_value(nextround_fix, "home_team") > -1) {
				var tmap1 = s_get_team_by_id(ds_map_find_value(nextround_fix, "away_team"));
				var tmap2 = s_get_team_by_id(ds_map_find_value(nextround_fix, "home_team"));
				if (s_get_team_winpct(tmap1) > s_get_team_winpct(tmap2)) {
					ds_map_set(nextround_fix, "away_team", real(ds_map_find_value(tmap2, "uid")));
					ds_map_set(nextround_fix, "home_team", real(ds_map_find_value(tmap1, "uid")));
				}
			}
		}
		if (irandom(1) && real(ds_map_find_value(nextround_fix, "week")) == week_nfc_champ + 1) {
			var tmp = ds_map_find_value(nextround_fix, "away_team");
			ds_map_set(nextround_fix, "away_team", ds_map_find_value(nextround_fix, "home_team"));
			ds_map_set(nextround_fix, "home_team", tmp);
		}
	}
	s_update_human_playoff_fixtures();
}

function s_seed_divisional_round(_arg0) {
	var fix1 = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 6);
	var fix2 = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 7);
	if (_arg0 == 1) {
		fix1 = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 8);
		fix2 = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 9);
	}
	var tmap2 = s_get_team_by_id(ds_map_find_value(fix1, "away_team"));
	var tmap3 = s_get_team_by_id(ds_map_find_value(fix2, "home_team"));
	var tmap4 = s_get_team_by_id(ds_map_find_value(fix2, "away_team"));
	var pct2 = -s_get_team_seeding(tmap2);
	var pct3 = -s_get_team_seeding(tmap3);
	var pct4 = -s_get_team_seeding(tmap4);
	var tgrid = ds_grid_create(2, 3);
	ds_grid_set(tgrid, 0, 0, pct2);
	ds_grid_set(tgrid, 1, 0, ds_map_find_value(tmap2, "uid"));
	ds_grid_set(tgrid, 0, 1, pct3);
	ds_grid_set(tgrid, 1, 1, ds_map_find_value(tmap3, "uid"));
	ds_grid_set(tgrid, 0, 2, pct4);
	ds_grid_set(tgrid, 1, 2, ds_map_find_value(tmap4, "uid"));
	ds_grid_sort(tgrid, 0, true);
	ds_map_set(fix1, "away_team", real(ds_grid_get(tgrid, 1, 0)));
	ds_map_set(fix2, "away_team", real(ds_grid_get(tgrid, 1, 1)));
	ds_map_set(fix2, "home_team", real(ds_grid_get(tgrid, 1, 2)));
	ds_grid_destroy(tgrid);
}

