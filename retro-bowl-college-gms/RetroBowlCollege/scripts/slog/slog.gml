function slog(_arg0) {
	show_debug_message(string(_arg0));
	return _arg0;
}

function slog2(_arg0) {
	_arg0 += "\n\n ---------- Stack:";
	var cs = debug_get_callstack();
	for (var i = 0; i < array_length_1d(cs); i++) {
		_arg0 += "\n" + string(cs[i]);
	}
	_arg0 += "\n---------------------";
	slog(_arg0);
}

function slogf(_arg0) {
	argument[2 - 2] = _arg0;
	for (var i = argument_count - 1; i > 0; i--) {
		_arg0 = string_replace_all(_arg0, "%" + string(i), string(argument[i]));
	}
	show_debug_message(_arg0);
}

function slog_map(_arg0, _arg1) {
	var output = _arg0 + "\n";
	if (_arg1 != -4 && ds_exists(_arg1, 1)) {
		var map_key = ds_map_find_first(_arg1);
		while (map_key != undefined) {
			output += " [" + string(map_key) + "]:[" + string(ds_map_find_value(_arg1, map_key)) + "]\n";
			map_key = ds_map_find_next(_arg1, map_key);
		}
		show_debug_message(output);
	} else {
		show_debug_message("Error: input_map is not a valid ds_map.");
	}
}

function slog_struct(_arg0, _arg1) {
	var output = _arg0 + "\n";
	if (_arg1 != undefined) {
		var struct_keys = variable_struct_get_names(_arg1);
		for (var i = 0; i < array_length(struct_keys); i++) {
			var key = struct_keys[i];
			var value = variable_struct_get(_arg1, key);
			output += " [" + string(key) + "]:[" + string(value) + "]\n";
		}
		show_debug_message(output);
	} else {
		show_debug_message("Error: input_struct is undefined or not a struct.");
	}
}

