function btn_click_AddStamina() {
	s_increase_player_attribute(obj_master.player_profile, 4);
	with (obj_playerprofile_rm) {
		inst_100444.percent = ds_map_find_value(pmap, "stamina") * 10;
		inst_100438.flash = false;
		inst_100439.flash = false;
		inst_100440.flash = false;
		inst_100444.flash = true;
		layer_set_visible(layer_back, false);
		layer_set_visible(layer_main, false);
		layer_set_visible(layer_pick, false);
		layer_set_visible(layer_xp, false);
		layer_set_visible(layer_xp_cont, true);
		s_sound(snd_starrating);
	}
}

