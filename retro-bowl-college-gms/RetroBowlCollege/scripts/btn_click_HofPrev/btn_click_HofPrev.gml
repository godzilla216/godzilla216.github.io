function btn_click_HofPrev() {
	with (obj_hof_players) {
		obj_master.hof_page--;
		room_goto(rm_halloffame_players);
	}
}

