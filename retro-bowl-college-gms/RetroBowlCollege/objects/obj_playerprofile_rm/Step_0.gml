inst_100451.text = s_get_credit();
if (!ds_exists(pmap, 1)) {
	exit;
}
if (is_undefined(ds_map_find_value(pmap, "xp_gain"))) {
	exit;
}
draw_set_font(global.fnt_small_flex);
draw_set_halign(0);
draw_set_valign(1);
inst_100441.text = string_upper(s_str("ui_Attitude") + ": " + s_get_string_attitude(ds_map_find_value(pmap, "attitude")));
x_attitude = inst_100441.x + string_hd_width(inst_100441.text + "  ");
y_attitude = inst_100441.y;
if (is_draft_player && ds_map_find_value(pmap, "scouted") == 0) {
	inst_100441.text = string_upper(s_str("ui_Attitude") + ": ?");
	y_attitude = -99999;
}
if (real(ds_map_find_value(pmap, "xp_gain")) > 0) {
	ds_map_set(pmap, "xp_gain", real(ds_map_find_value(pmap, "xp_gain")) - 1);
	ds_map_set(pmap, "xp", real(ds_map_find_value(pmap, "xp")) + 1);
	if (ds_map_find_value(pmap, "xp") >= target) {
		ds_map_set(pmap, "xp", 1);
		ds_map_set(pmap, "xp_level", ds_map_find_value(pmap, "xp_level") + 1);
		ds_map_set(pmap, "attitude", clamp(ds_map_find_value(pmap, "attitude") + 10, 1, 100));
		if (ds_map_find_value(pmap, "xp_gain") < 1) {
			ds_map_set(pmap, "xp_gain", 1);
		}
		if (!s_player_at_max_potential(pmap)) {
			ds_map_set(pmap, "skill_points", ds_map_find_value(pmap, "skill_points") + 1);
			room_goto(rm_profile_player);
		} else {
			var cx = inst_100446.x + inst_100446.sprite_width * 0.9;
			var cy = inst_100446.y + inst_100446.sprite_height * 0.5;
			s_create_credit(cx, cy, inst_100451.x, inst_100451.y, 1, 1, -4, true);
			s_find_default_button(true);
		}
		exit;
	}
	prc = ds_map_find_value(pmap, "xp") / target * 100;
	inst_100446.title = s_str("ui_XPLevel") + " " + string(ds_map_find_value(pmap, "xp_level"));
	inst_100446.percent = prc;
	if (ds_map_find_value(pmap, "xp_gain") < 1) {
		ds_map_set(pmap, "xp_gain", 0);
		if (ds_map_find_value(pmap, "skill_points") > 0) {
			room_goto(rm_profile_player);
			exit;
		}
		layer_set_visible(layer_back, false);
		layer_set_visible(layer_main, false);
		layer_set_visible(layer_pick, false);
		layer_set_visible(layer_xp, false);
		layer_set_visible(layer_xp_cont, true);
	}
}
if (s_is_co_mode()) {
	rm_player_profile_college_step();
}
