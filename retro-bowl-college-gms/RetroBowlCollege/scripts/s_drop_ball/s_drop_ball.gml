function s_drop_ball(_arg0) {
	slog("s_drop_ball: Dropped!");
	with (global.master_ball) {
		direc = other.jdir + irandom_range(-20, 20);
		velocity = 1 + random_range(0.1, 1);
		zvel = clamp(random(height * 0.1), 0.1, 2);
		roll = 5 + irandom(5);
		dropped_time = current_time - irandom(250);
		if (_arg0) {
			fumble_time = current_time;
		}
		if (_arg0 && !obj_master.gamepractice && holder && holder.pmap) {
			ds_map_set_post(holder.pmap, "stat_fumbles", ds_map_find_value(holder.pmap, "stat_fumbles") + 1);
		}
		state = 3;
		holder = -4;
		if (_arg0) {
			s_fieldtxt(s_str("match_Fumble") + "!");
			obj_controller.drop_happened = true;
		}
	}
}

