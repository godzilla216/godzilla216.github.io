function btn_click_Profile_Cut() {
	var name = ds_map_find_value(obj_master.player_profile, "fname") + " " + ds_map_find_value(obj_master.player_profile, "lname");
	var msg = string_replace(s_str("msg_CutPlayer"), "$playername", name);
	msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(obj_master.player_profile, "position")));
	s_create_message(s_str("ui_CutPlayer"), msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_cut_player_yes, global.c_background, 1);
}

function btn_click_Profile_JefeBoost() {
	var pmap = obj_master.player_profile;
	if (ds_map_find_value(pmap, "skill") + ds_map_find_value(pmap, "speed") + ds_map_find_value(pmap, "strength") + ds_map_find_value(pmap, "stamina") == 40) {
		return;
	}
	s_create_message("Boost player", "Do you want to give this player maximum stats?", s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, s_JefeBoost, global.c_background, 1);
}

function s_JefeBoost() {
	var pmap = obj_master.player_profile;
	if (ds_map_find_value(pmap, "skill") + ds_map_find_value(pmap, "speed") + ds_map_find_value(pmap, "strength") + ds_map_find_value(pmap, "stamina") == 40) {
		audio_play_sound(snd_oof1, 1, false);
		return;
	}
	ds_map_set(pmap, "skill", 10);
	ds_map_set(pmap, "speed", 10);
	ds_map_set(pmap, "strength", 10);
	ds_map_set(pmap, "stamina", 10);
	ds_map_set(pmap, "max_skill", 10);
	ds_map_set(pmap, "max_speed", 10);
	ds_map_set(pmap, "max_strength", 10);
	ds_map_set(pmap, "max_stamina", 10);
	room_goto(rm_roster);
}

function btn_click_Profile_JefeOutOfRetirement() {
	s_create_message("Boost player", "Do you want to bring this player out of retirement?", s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, s_JefeOutOfRetirement, global.c_background, 1);
}

function s_JefeOutOfRetirement() {
	s_msg_clear();
	with (obj_master) {
		var phof = player_profile;
		var sz = ds_list_size(roster);
		for (var r = 0; r < sz; r++) {
			if (ds_list_find_value(roster, r) == phof) {
				s_do_message("This player is already on your roster.");
				return;
			}
		}
		if (sz >= s_get_roster_limit()) {
			s_do_message("You don't have enough space on your roster to bring this player out of retirement.");
			return;
		}
		ds_map_set(player_profile, "contract", max(2, ds_map_find_value(player_profile, "contract")));
		ds_list_delete(hoflist, ds_list_find_index(hoflist, player_profile));
		ds_list_add(roster, player_profile);
		room_goto(rm_halloffame_players);
	}
}

