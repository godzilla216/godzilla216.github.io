function btn_click_ChooseFaceNext() {
	obj_master.face_page++;
	if (obj_master.face_page > obj_choose_face.max_pages) {
		obj_master.face_page = obj_choose_face.max_pages;
	}
	room_goto(rm_choose_face);
}

