function s_record_frame() {
	if (global.browser) {
		return;
	}
	var frame = [x, y, height, sprite_index, image_index, image_xscale, depth, hidden, rotation];
	ds_list_add(my_replay, frame);
	if (ds_list_size(my_replay) > 300) {
		ds_list_delete(my_replay, 0);
	}
}

