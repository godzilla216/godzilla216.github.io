function btn_response_deletegame4() {
	file_delete(global.g_savename4);
	file_delete("uniforms_custom_4.txt");
	s_custom_data_file_delete(4);
	s_nx_commit();
	room_goto(rm_master);
}

