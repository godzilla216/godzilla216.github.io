kittype = 0;
uid = ds_map_find_value(obj_master.edit_team, "uid");
s_load_uniform_file2(uid, 100115, 0, "");
s_load_uniform_file2(uid, 100116, 1, "");
s_load_uniform_file2(uid, 100118, 2, "");
s_load_uniform_file2(uid, 100119, 3, "");
current_uni = 100115;
s_set_up_edit_screen();
