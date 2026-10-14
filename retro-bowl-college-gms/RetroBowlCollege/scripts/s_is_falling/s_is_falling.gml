function s_is_falling() {
	if (sprite_index == spr_falling || sprite_index == spr_falling_ball || sprite_index == spr_falling_ball2) {
		return true;
	}
	if (sprite_index == spr_falling_thin || sprite_index == spr_falling_ball_thin || sprite_index == spr_falling_ball2_thin) {
		return true;
	}
	if (sprite_index == spr_falling_bulky || sprite_index == spr_falling_ball_bulky || sprite_index == spr_falling_ball2_bulky) {
		return true;
	}
	return false;
}

