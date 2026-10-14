switch (anim) {
	case 0:
	case 1:
	case 2:
		break;
	case 3:
		if (tackling == -4 || tackling.anim != 3) {
			s_set_anim(0);
		}
		break;
	case 4:
	case 5:
		dead = current_time;
		image_speed = 0;
		image_index = image_number - 1;
		break;
	case 6:
		s_set_anim(0);
		break;
	case 7:
	case 12:
		s_set_anim(0);
		break;
	case 8:
		s_set_anim(2);
		break;
	case 9:
		s_set_anim(2);
		break;
	case 10:
		s_set_anim(2);
		break;
	case 11:
		break;
	case 13:
		break;
	case 14:
		hspeed = 0;
		image_speed = 0;
		image_index = image_number - 1;
		break;
	case 15:
		if (s_is_kickoff(false)) {
			s_set_anim(2);
			break;
		}
		image_speed = 0;
		image_index = image_number - 1;
		break;
	case 16:
		s_spike_ball();
		s_set_anim(0);
		break;
	case 17:
		break;
	case 18:
		image_speed = 0;
		image_index = image_number - 1;
		break;
	case 19:
		dead = current_time;
		image_speed = 0;
		image_index = image_number - 1;
		break;
}
