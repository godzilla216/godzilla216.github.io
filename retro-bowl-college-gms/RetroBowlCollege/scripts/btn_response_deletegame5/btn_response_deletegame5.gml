function btn_response_deletegame5() {
	file_delete(global.g_savename5);
	file_delete("uniforms_custom_5.txt");
	s_custom_data_file_delete(5);
	s_nx_commit();
	room_goto(rm_master);
}

