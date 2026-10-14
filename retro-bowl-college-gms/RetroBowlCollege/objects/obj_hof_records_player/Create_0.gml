draw_set_font(global.fnt_small_flex);
txt_h = string_hd_height("I");
obj_master.records = s_sort_record_list(obj_master.records);
reclist_a = ds_list_create();
reclist_b = ds_list_create();
reclist_c = ds_list_create();
reclist_d = ds_list_create();
reclist_flash = ds_list_create();
var somestats = false;
for (var i = 0; i < ds_list_size(obj_master.records); i++) {
	var map = ds_list_find_value(obj_master.records, i);
	if (ds_exists(map, 1)) {
		if (ds_map_exists(map, "coachstat") && real(ds_map_find_value(map, "coachstat")) == 1) {
			continue;
		}
		if (ds_map_exists(map, "tag")) {
			ds_list_add(reclist_a, s_str(ds_map_find_value(map, "tag")));
		}
		if (ds_map_exists(map, "stat")) {
			ds_list_add(reclist_b, string(round(ds_map_find_value(map, "stat"))) + string(ds_map_find_value(map, "stat_text")));
			if (real(ds_map_find_value(map, "stat")) > 0) {
				somestats = true;
			}
		}
		var str = "";
		if (ds_map_exists(map, "qbname") && ds_map_find_value(map, "qbname") != "0") {
			str += ds_map_find_value(map, "qbname") + " ";
		}
		if (ds_map_exists(map, "playername") && ds_map_find_value(map, "playername") != "0") {
			str += ds_map_find_value(map, "playername");
		}
		ds_list_add(reclist_c, str);
		str = "";
		if (ds_map_exists(map, "year") && string(ds_map_find_value(map, "year")) != "0") {
			str += "Y" + string(ds_map_find_value(map, "year"));
		}
		ds_list_add(reclist_d, str);
		if (ds_map_exists(map, "year") && real(ds_map_find_value(map, "year")) == obj_master.year && ds_map_exists(map, "week") && real(ds_map_find_value(map, "week")) == obj_master.week - 1) {
			ds_list_add(reclist_flash, 1);
		} else {
			ds_list_add(reclist_flash, 0);
		}
	}
}
listsize = ds_list_size(reclist_a);
clampsize = -listsize * txt_h + sprite_height;
if (!obj_master.player_record_msg_done && !somestats && obj_master.year > 1) {
	s_create_message("", s_str("msg_PlayerRecords"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
	obj_master.player_record_msg_done = true;
}
active = true;
