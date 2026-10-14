function btn_response_deletegame1() {
	file_delete(global.g_savename1);
	file_delete("uniforms_custom_1.txt");
	s_custom_data_file_delete(1);
	s_nx_commit();
	room_goto(rm_master);
}

