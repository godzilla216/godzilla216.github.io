function btn_response_records_reset() {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(records); i++) {
			ds_map_destroy(ds_list_find_value(records, i));
			ds_list_set(records, i, -1);
		}
		ds_list_clear(records);
		ds_list_destroy(records);
		records = -1;
		records = s_load_map_file("PlayerRecords.txt");
		player_record_msg_done = true;
	}
	s_msg_clear();
	room_goto(rm_halloffame_player_records);
}

