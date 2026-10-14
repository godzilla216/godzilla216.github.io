function s_convert_string_to_sprite(_arg0) {
	switch (_arg0) {
		case "spr_attitude":
			return spr_attitude;
			break;
		case "spr_star":
			return spr_star;
			break;
		case "spr_credit":
			return spr_credit;
			break;
		case "spr_fans":
			return spr_fans;
			break;
		case "spr_xp":
			return spr_xp;
			break;
		case "spr_nrg":
			return spr_nrg;
			break;
		case "spr_gpa":
			return spr_gpa;
			break;
		case "spr_credit_rec":
			return spr_credit_rec;
			break;
	}
	return -1;
}

