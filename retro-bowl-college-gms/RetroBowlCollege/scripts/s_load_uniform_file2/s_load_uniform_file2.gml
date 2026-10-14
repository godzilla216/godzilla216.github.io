function s_load_uniform_file2(_arg0, _arg1, _arg2, _arg3, _arg4) {
	if (_arg4 == undefined) {
		_arg4 = false;
	}
	if (_arg4 == false) {
		if (global.browser || global.exhibition) {
			_arg3 = s_uniforms_default_file();
		} else {
			if (_arg3 == "") {
				_arg3 = "uniforms_custom_" + string(ds_map_find_value(obj_master.map_options, "saveslot")) + ".txt";
			}
			if (!file_exists(_arg3)) {
				file_copy(s_uniforms_default_file(), _arg3);
			}
		}
	}
	slog("s_load_uniform_file:" + _arg3 + ": Team=" + string(_arg0));
	var file = file_text_open_read(_arg3);
	if (file) {
		var keys = s_split_string(file_text_read_string(file));
		file_text_readln(file);
		while (!file_text_eof(file)) {
			var str = file_text_read_string(file);
			var values = s_split_string(str);
			file_text_readln(file);
			if (values[0] == _arg0) {
				_arg1.name = values[1];
				_arg1.tla = values[2];
				switch (_arg2) {
					case 0:
						_arg1.hex_helmet = values[3];
						_arg1.hex_logo = values[4];
						_arg1.hex_shirt = values[5];
						_arg1.hex_sleeve = values[6];
						_arg1.hex_pants = values[7];
						_arg1.hex_stripe = values[8];
						_arg1.hex_socks1 = values[9];
						_arg1.hex_socks2 = values[10];
						break;
					case 1:
						_arg1.hex_helmet = values[11];
						_arg1.hex_logo = values[12];
						_arg1.hex_shirt = values[13];
						_arg1.hex_sleeve = values[14];
						_arg1.hex_pants = values[15];
						_arg1.hex_stripe = values[16];
						_arg1.hex_socks1 = values[17];
						_arg1.hex_socks2 = values[18];
						break;
					case 2:
						_arg1.hex_helmet = values[19];
						_arg1.hex_logo = values[20];
						_arg1.hex_shirt = values[21];
						_arg1.hex_sleeve = values[22];
						_arg1.hex_pants = values[23];
						_arg1.hex_stripe = values[24];
						_arg1.hex_socks1 = values[25];
						_arg1.hex_socks2 = values[26];
						break;
					case 3:
						_arg1.hex_helmet = values[27];
						_arg1.hex_logo = values[28];
						_arg1.hex_shirt = values[29];
						_arg1.hex_sleeve = values[30];
						_arg1.hex_pants = values[31];
						_arg1.hex_stripe = values[32];
						_arg1.hex_socks1 = values[33];
						_arg1.hex_socks2 = values[34];
						break;
				}
				if (array_length_1d(values) > 35) {
					slog("loading 35");
					_arg1.roof = real(values[35]);
					_arg1.rainfall = values[36];
					_arg1.snowfall = values[37];
					_arg1.hex_endzone = values[38];
				} else {
					slog("pulling from tmap");
					var tmap = ds_list_find_value(obj_master.teamlist, _arg0);
					_arg1.roof = real(ds_map_find_value(tmap, "roof"));
					_arg1.rainfall = ds_map_find_value(tmap, "rainfall");
					_arg1.snowfall = ds_map_find_value(tmap, "snowfall");
					_arg1.hex_endzone = s_load_endzone_from_uniform_file(_arg0, s_uniforms_default_file());
				}
				break;
			}
		}
		file_text_close(file);
	}
	slog("Uniform loaded");
	s_convert_uniform_colours_all(_arg1);
}

