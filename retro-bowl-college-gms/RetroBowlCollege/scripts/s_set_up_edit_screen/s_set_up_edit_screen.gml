function s_set_up_edit_screen() {
	with (obj_edit_team) {
		inst_100112.colour = global.c_background;
		inst_100113.colour = global.c_background;
		inst_100114.colour = global.c_background;
		inst_100117.colour = global.c_background;
		switch (kittype) {
			case 0:
				inst_100112.colour = global.c_primary;
				break;
			case 1:
				inst_100113.colour = global.c_primary;
				break;
			case 2:
				inst_100114.colour = global.c_primary;
				break;
			case 3:
				inst_100117.colour = global.c_primary;
				break;
		}
		inst_100089.text = current_uni.name;
		inst_100087.text = s_load_team_detail(ds_map_find_value(obj_master.edit_team, "uid"), "name");
		inst_100084.text = current_uni.name;
		inst_100085.text = current_uni.tla;
		inst_100076.text = string(current_uni.rainfall);
		inst_100077.text = string(current_uni.snowfall);
		inst_100078.state = current_uni.roof;
		inst_100096.text = string_upper(string_replace_all(current_uni.hex_helmet, "$", ""));
		inst_100099.text = string_upper(string_replace_all(current_uni.hex_logo, "$", ""));
		inst_100097.text = string_upper(string_replace_all(current_uni.hex_shirt, "$", ""));
		inst_100098.text = string_upper(string_replace_all(current_uni.hex_sleeve, "$", ""));
		inst_100100.text = string_upper(string_replace_all(current_uni.hex_pants, "$", ""));
		inst_100101.text = string_upper(string_replace_all(current_uni.hex_stripe, "$", ""));
		inst_100102.text = string_upper(string_replace_all(current_uni.hex_socks1, "$", ""));
		inst_100103.text = string_upper(string_replace_all(current_uni.hex_socks2, "$", ""));
		inst_100079.text = string_upper(string_replace_all(current_uni.hex_endzone, "$", ""));
		inst_100104.colour = s_rgb_to_bgr(s_hex_string_to_col(current_uni.hex_helmet));
		inst_100105.colour = s_rgb_to_bgr(s_hex_string_to_col(current_uni.hex_logo));
		inst_100106.colour = s_rgb_to_bgr(s_hex_string_to_col(current_uni.hex_shirt));
		inst_100107.colour = s_rgb_to_bgr(s_hex_string_to_col(current_uni.hex_sleeve));
		inst_100108.colour = s_rgb_to_bgr(s_hex_string_to_col(current_uni.hex_pants));
		inst_100109.colour = s_rgb_to_bgr(s_hex_string_to_col(current_uni.hex_stripe));
		inst_100110.colour = s_rgb_to_bgr(s_hex_string_to_col(current_uni.hex_socks1));
		inst_100111.colour = s_rgb_to_bgr(s_hex_string_to_col(current_uni.hex_socks2));
		inst_100080.colour = s_rgb_to_bgr(s_hex_string_to_col(current_uni.hex_endzone));
	}
}

