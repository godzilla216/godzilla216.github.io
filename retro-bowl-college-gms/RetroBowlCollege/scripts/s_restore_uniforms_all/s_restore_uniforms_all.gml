function s_restore_uniforms_all() {
	var file_name = "uniforms_custom_" + string(ds_map_find_value(obj_master.map_options, "saveslot")) + ".txt";
	file_delete(file_name);
	s_msg_clear();
	obj_master.name_conf1 = "AFC";
	obj_master.name_conf2 = "NFC";
	obj_master.name_div1 = "EAST";
	obj_master.name_div2 = "WEST";
	obj_master.name_div3 = "NORTH";
	obj_master.name_div4 = "SOUTH";
	obj_master.name_div1b = "EAST";
	obj_master.name_div2b = "WEST";
	obj_master.name_div3b = "NORTH";
	obj_master.name_div4b = "SOUTH";
	s_copy_teamnames_from_uniform_file(s_uniforms_default_file());
	room_goto(rm_team_editor);
}

