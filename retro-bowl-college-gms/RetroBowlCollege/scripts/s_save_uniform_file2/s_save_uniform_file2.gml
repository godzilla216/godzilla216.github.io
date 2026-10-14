function s_save_uniform_file2(_arg0, _arg1, _arg2) {
	slog("s_save_uniform_file2");
	var uid = _arg0;
	var obj_uni = _arg1;
	var uniformtype = _arg2;
	var file_name = "uniforms_custom_" + string(ds_map_find_value(obj_master.map_options, "saveslot")) + ".txt";
	if (!file_exists(file_name)) {
		file_copy(s_uniforms_default_file(), file_name);
	}
	var file_old = file_text_open_read(file_name);
	var list = ds_list_create();
	var count = -1;
	while (!file_text_eof(file_old)) {
		ds_list_add(list, file_text_readln(file_old));
	}
	file_text_close(file_old);
	file_delete(file_name);
	var file_new = file_text_open_write(file_name);
	for (var count = 0; count < ds_list_size(list); count++) {
		if (string_length(ds_list_find_value(list, count)) < 10) {
			continue;
		}
		var values = s_split_string(ds_list_find_value(list, count));
		if (values[0] == uid) {
			values[1] = obj_uni.name;
			values[2] = obj_uni.tla;
			switch (uniformtype) {
				case 0:
					values[3] = obj_uni.hex_helmet;
					values[4] = obj_uni.hex_logo;
					values[5] = obj_uni.hex_shirt;
					values[6] = obj_uni.hex_sleeve;
					values[7] = obj_uni.hex_pants;
					values[8] = obj_uni.hex_stripe;
					values[9] = obj_uni.hex_socks1;
					values[10] = obj_uni.hex_socks2;
					break;
				case 1:
					values[11] = obj_uni.hex_helmet;
					values[12] = obj_uni.hex_logo;
					values[13] = obj_uni.hex_shirt;
					values[14] = obj_uni.hex_sleeve;
					values[15] = obj_uni.hex_pants;
					values[16] = obj_uni.hex_stripe;
					values[17] = obj_uni.hex_socks1;
					values[18] = obj_uni.hex_socks2;
					break;
				case 2:
					values[19] = obj_uni.hex_helmet;
					values[20] = obj_uni.hex_logo;
					values[21] = obj_uni.hex_shirt;
					values[22] = obj_uni.hex_sleeve;
					values[23] = obj_uni.hex_pants;
					values[24] = obj_uni.hex_stripe;
					values[25] = obj_uni.hex_socks1;
					values[26] = obj_uni.hex_socks2;
					break;
				case 3:
					values[27] = obj_uni.hex_helmet;
					values[28] = obj_uni.hex_logo;
					values[29] = obj_uni.hex_shirt;
					values[30] = obj_uni.hex_sleeve;
					values[31] = obj_uni.hex_pants;
					values[32] = obj_uni.hex_stripe;
					values[33] = obj_uni.hex_socks1;
					values[34] = obj_uni.hex_socks2;
					break;
			}
			values[34] = "$" + string_lettersdigits(values[34]);
			values[35] = string(obj_uni.roof);
			values[36] = string(obj_uni.rainfall);
			values[37] = string(obj_uni.snowfall);
			values[38] = string(obj_uni.hex_endzone);
			ds_list_set(list, count, values[0]);
			for (var i = 1; i < array_length_1d(values); i++) {
				ds_list_set(list, count, ds_list_find_value(list, count) + ("\t" + values[i]));
			}
		}
		ds_list_set(list, count, string_replace_all(ds_list_find_value(list, count), "\n", ""));
		ds_list_set(list, count, ds_list_find_value(list, count) + "\n");
		file_text_write_string(file_new, ds_list_find_value(list, count));
	}
	file_text_close(file_new);
}

