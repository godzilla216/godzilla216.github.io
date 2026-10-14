function btn_click_StaffProfile() {
	if (current_room == rm_profile_staff) {
		return;
	}
	obj_master.player_profile = pmap;
	room_goto(rm_profile_staff);
}

