function btn_response_deletegame2() {
	file_delete(global.g_savename2);
	file_delete("uniforms_custom_2.txt");
	s_custom_data_file_delete(2);
	s_nx_commit();
	room_goto(rm_master);
}

