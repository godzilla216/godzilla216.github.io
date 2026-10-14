function s_stop_tackling() {
	if (!tackling) {
		return;
	}
	tackling = -4;
	if (anim == 3) {
		s_set_anim(0);
	}
}

