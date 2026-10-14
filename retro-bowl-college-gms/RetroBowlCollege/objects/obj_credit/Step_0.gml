switch (stage) {
	case 0:
		image_xscale += 0.2;
		image_yscale = image_xscale;
		if (image_xscale >= des_scale) {
			stage++;
		}
		break;
	case 1:
		move_towards_point(des_x, des_y, 5);
		image_xscale *= 0.97;
		image_yscale = image_xscale;
		if (point_distance(x, y, des_x, des_y) < 5) {
			stage++;
		}
		break;
	case 2:
		instance_destroy();
		break;
}
