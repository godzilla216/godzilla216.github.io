function btn_click_DraftNext() {
	with (obj_draft) {
		obj_master.draft_page++;
		if (obj_master.draft_page > page_max) {
			obj_master.draft_page = 1;
		}
		s_update_draft_page();
	}
}

