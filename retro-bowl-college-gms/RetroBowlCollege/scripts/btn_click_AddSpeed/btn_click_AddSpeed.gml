function btn_click_AddSpeed() {
	s_increase_player_attribute(obj_master.player_profile, 2);
	with (obj_playerprofile_rm) {
		inst_100439.percent = ds_map_find_value(pmap, "speed") * 10;
		inst_100438.flash = false;
		inst_100439.flash = true;
		inst_100440.flash = false;
		inst_100444.flash = false;
		layer_set_visible(layer_back, false);
		layer_set_visible(layer_main, false);
		layer_set_visible(layer_pick, false);
		layer_set_visible(layer_xp, false);
		layer_set_visible(layer_xp_cont, true);
		s_sound(snd_starrating);
	}
}

