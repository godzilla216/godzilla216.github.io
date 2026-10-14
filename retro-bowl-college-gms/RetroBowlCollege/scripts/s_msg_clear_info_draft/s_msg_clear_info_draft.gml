function s_msg_clear_info_draft() {
	with (obj_roomtitle) {
		if (depth < 0) {
			instance_destroy();
		}
	}
	with (obj_msgbg) {
		instance_destroy();
	}
	with (obj_button) {
		if (depth < 0) {
			instance_destroy();
		}
	}
	with (obj_messagebox) {
		if (depth < 0) {
			instance_destroy();
		}
	}
	s_do_banner_draft();
}

