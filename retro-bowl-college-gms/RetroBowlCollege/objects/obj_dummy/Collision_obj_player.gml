if (distance_to_object(other) < 10) {
	dead = true;
	if (other.anim != 4) {
		s_set_anim(4);
	}
}
