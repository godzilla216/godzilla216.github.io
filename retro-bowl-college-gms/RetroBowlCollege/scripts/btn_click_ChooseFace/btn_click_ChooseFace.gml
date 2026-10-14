function btn_click_ChooseFace() {
	slog("btn_click_ChooseFace");
	obj_master.fname = inst_100025.text;
	obj_master.lname = inst_100026.text;
	room_goto(rm_choose_face);
}

function s_goto_rm_choose_face() {
	slog("s_goto_rm_choose_face");
	s_edit_confirm_profile();
	room_goto(rm_choose_face);
}

