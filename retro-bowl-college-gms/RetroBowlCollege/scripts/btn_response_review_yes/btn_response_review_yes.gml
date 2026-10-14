function btn_response_review_yes() {
	obj_master.coach_credit += 5;
	s_savegame();
	s_msg_clear();
	switch (os_type) {
		case 3:
			url_open("https://apps.apple.com/app/retrobowl/id1478902583");
			break;
		case 4:
			url_open("https://play.google.com/store/apps/details?id=com.newstargames.retrobowl");
			break;
		default:
			url_open("https://www.newstargames.com");
			break;
	}
}

function btn_response_review_no() {
	s_save_options();
	s_msg_clear();
}

