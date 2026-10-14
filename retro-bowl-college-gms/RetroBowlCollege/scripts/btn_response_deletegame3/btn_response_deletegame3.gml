function btn_response_deletegame3() {
	file_delete(global.g_savename3);
	file_delete("uniforms_custom_3.txt");
	s_custom_data_file_delete(3);
	s_nx_commit();
	room_goto(rm_master);
}

