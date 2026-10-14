inst_100322.title = obj_master.name_conf1;
inst_100323.title = obj_master.name_conf2;
var lay_id1 = layer_get_id("Instances1");
var lay_id2 = layer_get_id("Instances2");
layer_set_visible(lay_id1, false);
layer_set_visible(lay_id2, false);
inst_100347.visible = true;
inst_100349.visible = false;
inst_100350.visible = false;
if (obj_master.playoff_proceed) {
	inst_100347.visible = false;
	inst_100349.visible = true;
	inst_100350.visible = true;
	inst_100350.flash = true;
}
if (obj_master.week > obj_master.last_week_regular) {
	layer_set_visible(lay_id1, true);
	inst_100348.text = s_str("ui_PlayOffs");
	inst_100346.text = s_str("ui_Super#Bowl");
	var fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs);
	if (!fix) {
		slog("NO PLAY OFFS! Trying to recreate playoffs");
		s_create_playoffs();
		fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs);
	}
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100325.text = ds_map_find_value(team_away, "tla");
		inst_100324.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.first_week_playoffs) {
			inst_100325.flashtext = true;
			inst_100324.flashtext = true;
		} else if (obj_master.week > obj_master.first_week_playoffs) {
			inst_100325.alpha = 0.5;
			inst_100324.alpha = 0.5;
		}
	}
	fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 1);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100326.text = ds_map_find_value(team_away, "tla");
		inst_100327.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.first_week_playoffs + 1) {
			inst_100326.flashtext = true;
			inst_100327.flashtext = true;
		} else if (obj_master.week > obj_master.first_week_playoffs + 1) {
			inst_100326.alpha = 0.5;
			inst_100327.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 2);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100336.text = ds_map_find_value(team_away, "tla");
		inst_100335.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.first_week_playoffs + 2) {
			inst_100336.flashtext = true;
			inst_100335.flashtext = true;
		} else if (obj_master.week > obj_master.first_week_playoffs + 2) {
			inst_100336.alpha = 0.5;
			inst_100335.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 3);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100337.text = ds_map_find_value(team_away, "tla");
		inst_100338.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.first_week_playoffs + 3) {
			inst_100337.flashtext = true;
			inst_100338.flashtext = true;
		} else if (obj_master.week > obj_master.first_week_playoffs + 3) {
			inst_100337.alpha = 0.5;
			inst_100338.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 4);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100328.text = ds_map_find_value(team_away, "tla");
		inst_100329.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.first_week_playoffs + 4) {
			inst_100328.flashtext = true;
			inst_100329.flashtext = true;
		} else if (obj_master.week > obj_master.first_week_playoffs + 4) {
			inst_100328.alpha = 0.5;
			inst_100329.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 5);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100331.text = ds_map_find_value(team_away, "tla");
		inst_100330.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.first_week_playoffs + 5) {
			inst_100331.flashtext = true;
			inst_100330.flashtext = true;
		} else if (obj_master.week > obj_master.first_week_playoffs + 5) {
			inst_100331.alpha = 0.5;
			inst_100330.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 6);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100339.text = ds_map_find_value(team_away, "tla");
		inst_100340.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.first_week_playoffs + 6) {
			inst_100339.flashtext = true;
			inst_100340.flashtext = true;
		} else if (obj_master.week > obj_master.first_week_playoffs + 6) {
			inst_100339.alpha = 0.5;
			inst_100340.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 7);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100342.text = ds_map_find_value(team_away, "tla");
		inst_100341.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.first_week_playoffs + 7) {
			inst_100342.flashtext = true;
			inst_100341.flashtext = true;
		} else if (obj_master.week > obj_master.first_week_playoffs + 7) {
			inst_100342.alpha = 0.5;
			inst_100341.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 8);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100332.text = ds_map_find_value(team_away, "tla");
		inst_100333.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.first_week_playoffs + 8) {
			inst_100332.flashtext = true;
			inst_100333.flashtext = true;
		} else if (obj_master.week > obj_master.first_week_playoffs + 8) {
			inst_100332.alpha = 0.5;
			inst_100333.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 9);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100343.text = ds_map_find_value(team_away, "tla");
		inst_100344.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.first_week_playoffs + 9) {
			inst_100343.flashtext = true;
			inst_100344.flashtext = true;
		} else if (obj_master.week > obj_master.first_week_playoffs + 9) {
			inst_100343.alpha = 0.5;
			inst_100344.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.first_week_playoffs + 10);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100334.text = ds_map_find_value(team_away, "tla");
		inst_100345.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.first_week_playoffs + 10) {
			inst_100334.flashtext = true;
			inst_100345.flashtext = true;
		} else if (obj_master.week > obj_master.first_week_playoffs + 10) {
			inst_100334.alpha = 0.5;
			inst_100345.alpha = 0.5;
		}
	}
} else {
	layer_set_visible(lay_id2, true);
	inst_100348.text = s_str("ui_PlayOffPicture");
}
with (obj_text) {
	slog(text);
	if (text == ds_map_find_value(obj_master.myteam, "tla")) {
		colour = global.c_primary;
		tcolour = global.c_primary;
	}
}
