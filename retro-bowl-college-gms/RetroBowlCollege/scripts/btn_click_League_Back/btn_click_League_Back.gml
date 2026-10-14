function btn_click_League_Back() {
	switch (obj_master.stage) {
		case 3:
			room_goto(rm_pre_match);
			break;
		case 5:
			room_goto(rm_post_match);
			break;
		default:
			room_goto(rm_home);
			break;
	}
}

