function btn_click_TrainingHard() {
	with (obj_master) {
		switch (ds_map_find_value(player_profile, "position")) {
			case 101:
				training_reg_df = 3;
				break;
			case 102:
				training_reg_of = 3;
				break;
		}
	}
	room_goto(rm_profile_staff);
}

