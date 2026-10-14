function btn_response_hof_select() {
	s_msg_clear();
	ds_map_set(obj_master.player_profile, "hof", false);
	var pos = ds_list_find_index(obj_master.hoflist, obj_master.player_profile);
	if (pos > -1) {
		ds_list_delete(obj_master.hoflist, pos);
		ds_map_destroy(obj_master.player_profile);
		obj_master.player_profile = -1;
	}
	room_goto(rm_halloffame_players);
}

