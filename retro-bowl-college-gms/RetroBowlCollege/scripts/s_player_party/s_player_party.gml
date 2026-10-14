function s_update_party_meter(_arg0) {
	if (!s_is_co_mode()) {
		return;
	}
	var inc = 5;
	switch (s_get_training_reg(_arg0)) {
		case 1:
			break;
		case 2:
			break;
		case 3:
			inc += -3;
			break;
	}
	if (ds_map_find_value(_arg0, "attitude") <= 45 || s_player_benched(_arg0)) {
		inc += 3;
	}
	if (s_is_player_hobby_fraternity(_arg0)) {
		inc += 6;
	}
	s_add_to_party_meter(_arg0, inc);
}

function s_get_party_info(_arg0) {
	if (!s_is_co_mode()) {
		return;
	}
	var partyExt = " Meter: " + string(ds_map_find_value(_arg0, "party_meter")) + " Tick[";
	var inc = 5;
	partyExt += " base(" + string(5) + ")";
	switch (s_get_training_reg(_arg0)) {
		case 1:
			break;
		case 2:
			break;
		case 3:
			partyExt += " T.Hard(" + string(-3) + ")";
			inc += -3;
			break;
	}
	if (ds_map_find_value(_arg0, "attitude") <= 45 || s_player_benched(_arg0)) {
		var reason = "";
		if (s_player_benched(_arg0)) {
			reason += "|Bench";
		}
		if (ds_map_find_value(_arg0, "attitude") <= 45) {
			reason += "|BadAtti";
		}
		partyExt += " " + reason + "(" + string(3) + ")";
		inc += 3;
	}
	if (s_is_player_hobby_fraternity(_arg0)) {
		partyExt += " Frat(" + string(6) + ")";
		inc += 6;
	}
	partyExt += "]: " + string(inc);
	return partyExt;
}

function s_add_to_party_meter(_arg0, _arg1) {
	if (!s_is_co_mode()) {
		return;
	}
	var new_val = clamp(ds_map_find_value(_arg0, "party_meter") + _arg1, 0, 100);
	ds_map_set(_arg0, "party_meter", new_val);
}

function s_clear_party_meter(_arg0) {
	if (!s_is_co_mode()) {
		return;
	}
	slog("s_clear_party_meter");
	ds_map_set(_arg0, "party_meter", 0);
}

function s_team_halve_all_party_meters() {
	if (!s_is_co_mode()) {
		return;
	}
	slog("s_team_halve_all_party_meters");
	for (var i = 0; i < ds_list_size(roster); i++) {
		var pmap = ds_list_find_value(roster, i);
		var oldVal = ds_map_find_value(pmap, "party_meter");
		ds_map_set(pmap, "party_meter", int64(oldVal / 2));
		slog("... PartyMeter adjust for " + string(ds_map_find_value(pmap, "lname")) + ":[" + string(oldVal) + "]->[" + string(ds_map_find_value(pmap, "party_meter")) + "]");
	}
}

