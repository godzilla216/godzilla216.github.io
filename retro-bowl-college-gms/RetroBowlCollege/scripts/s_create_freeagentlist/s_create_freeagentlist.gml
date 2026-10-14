function s_create_freeagentlist(_arg0) {
	with (obj_master) {
		while (ds_list_size(freeagentlist) < _arg0) {
			ds_list_add(freeagentlist, s_create_freeagent());
		}
		freeagentlist = s_sort_players(freeagentlist, 2);
	}
}

