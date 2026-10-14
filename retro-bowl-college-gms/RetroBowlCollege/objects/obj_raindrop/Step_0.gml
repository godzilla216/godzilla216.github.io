switch (splash) {
	case false:
		if (y > ground) {
			splash = true;
			vspeed = 0;
			hspeed = 0;
			sprite_index = spr_splash;
			image_index = 0;
			image_speed = 4;
		} else {
			y2 = y - 25;
			y3 = y + 50;
			x2 = x - 250;
			x3 = x + 250;
			x4 = x - 500;
			x5 = x + 500;
		}
		break;
	case true:
		if (image_index > image_number - 1) {
			instance_destroy();
		}
		break;
}
