function s_spike_ball() {
	slog("s_spike_ball");
	with (global.master_ball) {
		if (holder) {
			x = holder.x + holder.facing * 4;
			y = holder.y + 2;
			direc = holder.jdir;
		}
		height = 1;
		velocity = 4;
		zvel = -5;
		holder = -4;
		s_sound_bounce();
	}
}

