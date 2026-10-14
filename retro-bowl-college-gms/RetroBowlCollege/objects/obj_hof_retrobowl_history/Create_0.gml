retrobowlhistory = s_load_retrobowl_history();
with (obj_master) {
	rbhistorylist = s_sort_retrobowl_history_list(rbhistorylist);
	for (var i = 0; i < ds_list_size(rbhistorylist); i++) {
		var map = ds_list_find_value(rbhistorylist, i);
		ds_list_add(other.retrobowlhistory, map);
	}
}
draw_set_font(global.fnt_small_flex);
title = s_str("ui_RetroBowlWinners");
txt_h = string_hd_height(title);
listsize = ds_list_size(retrobowlhistory);
clampsize = -listsize * txt_h + sprite_height;
active = true;
