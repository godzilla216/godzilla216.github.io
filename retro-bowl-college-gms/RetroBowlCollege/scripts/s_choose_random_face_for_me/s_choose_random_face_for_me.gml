function s_choose_random_face_for_me() {
	slog("s_choose_random_face_for_me");
	with (obj_master) {
		if (qb_mode) {
			my_skin = choose(2, 1, 0);
			myface_x = irandom(7);
			switch (my_skin) {
				case 2:
					myface_y = irandom(2);
					break;
				case 1:
					myface_y = 0;
					break;
				case 0:
					myface_y = irandom(8);
					break;
			}
			slog("new skin = " + string(obj_master.my_skin));
			slog("new face_x = " + string(obj_master.myface_x));
			slog("new face_y = " + string(obj_master.myface_y));
		} else {
			myface_x = irandom(8);
			myface_y = irandom(3);
		}
	}
}

