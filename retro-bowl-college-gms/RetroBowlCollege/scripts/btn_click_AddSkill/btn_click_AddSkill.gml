function btn_click_AddSkill() {
	s_increase_player_attribute(obj_master.player_profile, 1);
	with (obj_playerprofile_rm) {
		inst_100438.percent = ds_map_find_value(pmap, "skill") * 10;
		inst_100438.flash = true;
		inst_100439.flash = false;
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

