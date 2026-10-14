function btn_click_Roster() {
	if (current_room == rm_home && ds_list_size(obj_master.freeagentlist)) {
		stage = 1;
		room_goto(rm_freeagents);
		return;
	}
	room_goto(rm_roster);
}

