function s_aim_AI_kickoff() {
	switch (position) {
		case 1:
			jforce = 1;
			jdir = point_direction(x, y, obj_metaball.bounce_x, obj_metaball.bounce_y);
			break;
		case 12:
			jforce = 1.2;
			jdir = point_direction(x, y, obj_metaball.bounce_x, y);
			switch (inum) {
				case 3:
				case 10:
					jforce = 1.1;
					break;
				case 2:
				case 11:
					jforce = 1.05;
					break;
			}
			break;
		case 13:
			var bdir = point_direction(x, y, obj_metaball.bounce_x, obj_metaball.bounce_y);
			var bdis = point_distance(x, y, obj_metaball.bounce_x, obj_metaball.bounce_y);
			jdir = point_direction(x, y, x + dcos(bdir) * bdis * 0.9, y - dsin(bdir) * bdis * 0.9);
			jforce = clamp(bdis / 20, 0.5, 0.9);
			switch (inum) {
				case 9:
				case 11:
					jforce = 0.75;
					break;
			}
			break;
		case 14:
			jdir = point_direction(x, y, obj_metaball.bounce_x, obj_metaball.bounce_y);
			jforce = clamp(bouncedist / 20, 0.1, 1);
			break;
	}
}

