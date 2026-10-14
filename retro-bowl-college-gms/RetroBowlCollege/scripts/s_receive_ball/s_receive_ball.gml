function s_receive_ball() {
	slog("s_receive_ball");
	with (global.master_ball) {
		holder = other.id;
		last_touched_by = other.id;
		state = 5;
		xreceived = x;
		yreceived = y;
	}
	if (obj_master.qb_mode) {
		if (rewarded_route) {
			s_sound(snd_success);
			if (pmap) {
				ds_map_set(pmap, "attitude", clamp(ds_map_find_value(pmap, "attitude") + 1, 1, 100));
				s_fieldimg(spr_morale, 0, 2);
			} else {
				var qb = s_get_qb_pmap();
				ds_map_set(qb, "xp_gain", ds_map_find_value(qb, "xp_gain") + 2);
				s_fieldimg(spr_xp, 0, 2);
			}
		}
		with (obj_playerOF) {
			rewarded_route = false;
		}
	}
	global.flickVelX = 0;
	global.flickVelY = 0;
}

