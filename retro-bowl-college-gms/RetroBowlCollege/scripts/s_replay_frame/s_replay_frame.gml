function s_replay_frame() {
	if (global.browser) {
		return;
	}
	var sz = ds_list_size(my_replay);
	if (sz < 1) {
		return;
	}
	if (global.replay_frame < 0 || global.replay_frame >= sz) {
		global.replay_frame = 0;
	}
	var frame = ds_list_find_value(my_replay, global.replay_frame);
	var last_frame = ds_list_find_value(my_replay, global.replay_frame);
	if (global.replay_frame > 0) {
		last_frame = ds_list_find_value(my_replay, global.replay_frame - 1);
	}
	x = lerp(last_frame[0], frame[0], frac(global.replay_frame));
	y = lerp(last_frame[1], frame[1], frac(global.replay_frame));
	height = lerp(last_frame[2], frame[2], frac(global.replay_frame));
	sprite_index = frame[3];
	image_index = frame[4];
	image_xscale = frame[5];
	depth = frame[6];
	hidden = frame[7];
	rotation = frame[8];
	s_update_my_shadow();
	if (hidden) {
		layer_sprite_y(my_shadow, -99999);
	}
}

