inst_100474.text = s_get_credit();
if (!ds_exists(pmap, 1)) {
	exit;
}
if (is_undefined(ds_map_find_value(pmap, "xp_gain"))) {
	exit;
}
if (real(ds_map_find_value(pmap, "xp_gain")) > 0) {
	layer_set_visible(layer_nav, false);
	layer_set_visible(layer_hire, false);
	layer_set_visible(layer_training, false);
	ds_map_set(pmap, "xp_gain", real(ds_map_find_value(pmap, "xp_gain")) - 1);
	ds_map_set(pmap, "xp", real(ds_map_find_value(pmap, "xp")) + 1);
	if (ds_map_find_value(pmap, "xp") >= target) {
		ds_map_set(pmap, "xp", 1);
		ds_map_set(pmap, "xp_level", ds_map_find_value(pmap, "xp_level") + 1);
		ds_map_set(pmap, "attitude", clamp(ds_map_find_value(pmap, "attitude") + 10, 1, 100));
		if (ds_map_find_value(pmap, "xp_gain") < 1) {
			ds_map_set(pmap, "xp_gain", 1);
		}
		var cx = inst_100475.x + inst_100475.sprite_width * 0.9;
		var cy = inst_100475.y + inst_100475.sprite_height * 0.5;
		if (ds_map_find_value(pmap, "rating") < 10) {
			var dx = inst_100471.x + inst_100471.sprite_width * 0.5;
			var dy = inst_100471.y + inst_100471.sprite_height * 0.8;
			s_create_credit(cx, cy, dx, dy, 1, 2, pmap, true);
		} else {
			s_create_credit(cx, cy, inst_100474.x, inst_100474.y, 1, 1, -4, true);
		}
		exit;
	}
	prc = ds_map_find_value(pmap, "xp") / target * 100;
	inst_100475.title = s_str("ui_XPLevel") + " " + string(ds_map_find_value(pmap, "xp_level"));
	inst_100475.percent = prc;
	if (ds_map_find_value(pmap, "xp_gain") < 1) {
		ds_map_set(pmap, "xp_gain", 0);
		layer_set_visible(layer_xp, true);
	}
}
