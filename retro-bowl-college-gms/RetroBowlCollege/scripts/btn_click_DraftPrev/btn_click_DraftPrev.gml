function btn_click_DraftPrev() {
	with (obj_draft) {
		obj_master.draft_page--;
		if (obj_master.draft_page < 1) {
			obj_master.draft_page = page_max;
		}
		s_update_draft_page();
	}
}

