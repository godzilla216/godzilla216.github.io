function btn_click_ChooseFacePrev() {
	obj_master.face_page--;
	if (obj_master.face_page < 1) {
		obj_master.face_page = 1;
	}
	room_goto(rm_choose_face);
}

