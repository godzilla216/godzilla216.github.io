inst_100354.title = obj_master.name_conf1;
inst_100370.title = obj_master.name_conf2;
var lay_id1 = layer_get_id("Instances1");
var lay_id2 = layer_get_id("Instances2");
layer_set_visible(lay_id1, false);
layer_set_visible(lay_id2, false);
inst_100383.visible = true;
inst_100385.visible = false;
inst_100386.visible = false;
if (obj_master.playoff_proceed) {
	inst_100383.visible = false;
	inst_100385.visible = true;
	inst_100386.visible = true;
	if (!global.gamepad) {
		inst_100386.flash = true;
	}
}
if (obj_master.week > obj_master.last_week_regular) {
	layer_set_visible(lay_id1, true);
	inst_100384.text = s_str("ui_PlayOffs");
	inst_100367.text = s_str("ui_Super#Bowl");
	var fix = s_get_playoff_fixture_by_week(obj_master.last_week_regular + 1);
	if (!fix) {
		slog("NO PLAY OFFS! Trying to recreate playoffs");
		s_create_playoffs2();
		fix = s_get_playoff_fixture_by_week(obj_master.last_week_regular + 1);
	}
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100356.text = ds_map_find_value(team_away, "tla");
		inst_100355.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.last_week_regular + 1) {
			inst_100356.flashtext = true;
			inst_100355.flashtext = true;
		} else if (obj_master.week > obj_master.last_week_regular + 1) {
			inst_100356.alpha = 0.5;
			inst_100355.alpha = 0.5;
		}
	}
	fix = s_get_playoff_fixture_by_week(obj_master.last_week_regular + 2);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100357.text = ds_map_find_value(team_away, "tla");
		inst_100358.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.last_week_regular + 2) {
			inst_100357.flashtext = true;
			inst_100358.flashtext = true;
		} else if (obj_master.week > obj_master.last_week_regular + 2) {
			inst_100357.alpha = 0.5;
			inst_100358.alpha = 0.5;
		}
	}
	fix = s_get_playoff_fixture_by_week(obj_master.last_week_regular + 3);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100369.text = ds_map_find_value(team_away, "tla");
		inst_100362.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.last_week_regular + 3) {
			inst_100369.flashtext = true;
			inst_100362.flashtext = true;
		} else if (obj_master.week > obj_master.last_week_regular + 3) {
			inst_100369.alpha = 0.5;
			inst_100362.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.last_week_regular + 4);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100372.text = ds_map_find_value(team_away, "tla");
		inst_100379.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.last_week_regular + 4) {
			inst_100372.flashtext = true;
			inst_100379.flashtext = true;
		} else if (obj_master.week > obj_master.last_week_regular + 4) {
			inst_100372.alpha = 0.5;
			inst_100379.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.last_week_regular + 5);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100373.text = ds_map_find_value(team_away, "tla");
		inst_100374.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.last_week_regular + 5) {
			inst_100373.flashtext = true;
			inst_100374.flashtext = true;
		} else if (obj_master.week > obj_master.last_week_regular + 5) {
			inst_100373.alpha = 0.5;
			inst_100374.alpha = 0.5;
		}
	}
	fix = s_get_playoff_fixture_by_week(obj_master.last_week_regular + 6);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100382.text = ds_map_find_value(team_away, "tla");
		inst_100378.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.last_week_regular + 6) {
			inst_100382.flashtext = true;
			inst_100378.flashtext = true;
		} else if (obj_master.week > obj_master.last_week_regular + 6) {
			inst_100382.alpha = 0.5;
			inst_100378.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.last_week_regular + 7);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100360.text = ds_map_find_value(team_away, "tla");
		inst_100359.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.last_week_regular + 7) {
			inst_100360.flashtext = true;
			inst_100359.flashtext = true;
		} else if (obj_master.week > obj_master.last_week_regular + 7) {
			inst_100360.alpha = 0.5;
			inst_100359.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.last_week_regular + 8);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100361.text = ds_map_find_value(team_away, "tla");
		inst_100368.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.last_week_regular + 8) {
			inst_100361.flashtext = true;
			inst_100368.flashtext = true;
		} else if (obj_master.week > obj_master.last_week_regular + 8) {
			inst_100361.alpha = 0.5;
			inst_100368.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.last_week_regular + 9);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100376.text = ds_map_find_value(team_away, "tla");
		inst_100375.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.last_week_regular + 9) {
			inst_100376.flashtext = true;
			inst_100375.flashtext = true;
		} else if (obj_master.week > obj_master.last_week_regular + 9) {
			inst_100376.alpha = 0.5;
			inst_100375.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.last_week_regular + 10);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100377.text = ds_map_find_value(team_away, "tla");
		inst_100381.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.last_week_regular + 10) {
			inst_100377.flashtext = true;
			inst_100381.flashtext = true;
		} else if (obj_master.week > obj_master.last_week_regular + 10) {
			inst_100377.alpha = 0.5;
			inst_100381.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.last_week_regular + 11);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100363.text = ds_map_find_value(team_away, "tla");
		inst_100364.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.last_week_regular + 11) {
			inst_100363.flashtext = true;
			inst_100364.flashtext = true;
		} else if (obj_master.week > obj_master.last_week_regular + 11) {
			inst_100363.alpha = 0.5;
			inst_100364.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.last_week_regular + 12);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100371.text = ds_map_find_value(team_away, "tla");
		inst_100380.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.last_week_regular + 12) {
			inst_100371.flashtext = true;
			inst_100380.flashtext = true;
		} else if (obj_master.week > obj_master.last_week_regular + 12) {
			inst_100371.alpha = 0.5;
			inst_100380.alpha = 0.5;
		}
	}
	var fix = s_get_playoff_fixture_by_week(obj_master.last_week_regular + 13);
	if (fix) {
		var team_away = s_get_team_by_id(ds_map_find_value(fix, "away_team"));
		var team_home = s_get_team_by_id(ds_map_find_value(fix, "home_team"));
		inst_100365.text = ds_map_find_value(team_away, "tla");
		inst_100366.text = ds_map_find_value(team_home, "tla");
		if (obj_master.week == obj_master.last_week_regular + 13) {
			inst_100365.flashtext = true;
			inst_100366.flashtext = true;
		} else if (obj_master.week > obj_master.last_week_regular + 13) {
			inst_100365.alpha = 0.5;
			inst_100366.alpha = 0.5;
		}
	}
} else {
	layer_set_visible(lay_id2, true);
	inst_100384.text = s_str("ui_PlayOffPicture");
}
with (obj_text) {
	if (text == ds_map_find_value(obj_master.myteam, "tla")) {
		colour = global.c_primary;
		tcolour = global.c_primary;
	}
}
