function s_str(_arg0) {
	return s_co_str(_arg0);
	if (_arg0 == "@" || _arg0 == "") {
		return "";
	}
	if (!instance_exists(obj_master) || !ds_exists(obj_master.stringmap, 1)) {
		return "";
	}
	var txt = ds_map_find_value(obj_master.stringmap, _arg0);
	if (is_undefined(txt)) {
		slog("@" + _arg0);
		return "@" + _arg0;
	}
	return string_hash_to_newline(txt);
}

function s_str_u(_arg0) {
	return string_upper(s_str(_arg0));
}

function s_str_real(_arg0) {
	return s_co_str_real(_arg0);
	if (_arg0 == "@" || _arg0 == "") {
		return 0;
	}
	var txt = ds_map_find_value(obj_master.stringmap, _arg0);
	if (is_undefined(txt)) {
		slog("@" + _arg0);
		return 0;
	}
	return real(txt);
}

function s_strf() {
	var str = argument[0];
	for (var i = argument_count - 1; i > 0; i--) {
		str = string_replace_all(str, "%" + string(i), string(argument[i]));
	}
	return string_upper(str);
}

function s_strfl() {
	var str = argument[0];
	for (var i = argument_count - 1; i > 0; i--) {
		str = string_replace_all(str, "%" + string(i), string(argument[i]));
	}
	return str;
}

function s_co_str(_arg0) {
	if (_arg0 == "@" || _arg0 == "") {
		return "";
	}
	if (!instance_exists(obj_master) || !is_struct(global.g_m.langdata)) {
		return "";
	}
	var txt = struct_get_from_hash(global.g_m.langdata, variable_get_hash(_arg0));
	if (is_undefined(txt)) {
		slog("@" + _arg0);
		return "@" + _arg0;
	}
	return string_hash_to_newline(txt);
}

function s_co_str_real(_arg0) {
	if (_arg0 == "@" || _arg0 == "") {
		return 0;
	}
	var txt = struct_get_from_hash(global.g_m.langdata, variable_get_hash(_arg0));
	if (is_undefined(txt)) {
		slog("@" + _arg0);
		return 0;
	}
	return real(txt);
}

