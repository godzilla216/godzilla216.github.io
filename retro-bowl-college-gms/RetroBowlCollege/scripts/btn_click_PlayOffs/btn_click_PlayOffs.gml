function btn_click_PlayOffs() {
	if (s_playoffs_12()) {
		room_goto(rm_playoffs);
	} else {
		room_goto(rm_playoffs2);
	}
}

