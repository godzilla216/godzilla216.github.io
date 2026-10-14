function btn_click_ChooseFaceDone() {
	if (obj_master.player_profile) {
		ds_map_set(obj_master.player_profile, "skin", skin);
		ds_map_set(obj_master.player_profile, "face_x", face_x);
		ds_map_set(obj_master.player_profile, "face_y", face_y);
		ds_map_set(obj_master.player_profile, "face_set", face_set);
		switch (ds_map_find_value(obj_master.player_profile, "position")) {
			case 100:
				obj_master.myface_x = face_x;
				obj_master.myface_y = face_y;
				btn_click_EditProfile();
				break;
			case 102:
			case 101:
				btn_click_EditProfile();
				break;
			default:
				btn_click_EditProfile();
				break;
		}
		s_savegame();
	} else {
		obj_master.my_skin = skin;
		obj_master.myface_x = face_x;
		obj_master.myface_y = face_y;
		slog("skin = " + string(skin));
		slog("face_x = " + string(face_x));
		slog("face_y = " + string(face_y));
		if (obj_master.year == 1 && obj_master.week == 1) {
			room_goto(rm_details);
		} else {
			room_goto(rm_home);
		}
	}
}

function btn_click_cancel_chooseface() {
	if (obj_master.player_profile) {
		switch (ds_map_find_value(obj_master.player_profile, "position")) {
			case 100:
				btn_click_EditProfile();
				break;
			case 102:
			case 101:
				btn_click_EditProfile();
				break;
			default:
				btn_click_EditProfile();
				break;
		}
	} else if (obj_master.year == 1 && obj_master.week == 1) {
		room_goto(rm_details);
	} else {
		room_goto(rm_home);
	}
}

