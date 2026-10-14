function s_uniforms_default_file() {
	if (s_is_co_mode()) {
		return s_get_versioned_path("uniforms_default_CO.txt");
	}
	return "uniforms_default.txt";
}

function s_extract_uniform_cols_to_record(_arg0, _arg1) {
	var uniform = instance_create_layer(0, 0, "Instances", obj_uniform);
	uniform.visible = false;
	s_load_uniform_file2(_arg0, uniform, 0, _arg1);
	var record = s_uniform_cols_to_record(uniform);
	instance_destroy(uniform);
	return record;
}

function s_uniform_cols_to_record(_arg0) {
	return string(_arg0.helmet[2]) + "|" + string(_arg0.helmet[1]) + "|" + string(_arg0.helmet[0]) + "|" + string(_arg0.shirt[2]) + "|" + string(_arg0.shirt[1]) + "|" + string(_arg0.shirt[0]) + "|" + string(_arg0.pants[2]) + "|" + string(_arg0.pants[1]) + "|" + string(_arg0.pants[0]) + "|";
}

function s_uniform_cols_from_record(_arg0) {
	var i, text, arrI;
	arrI = 0;
	text = "";
	arr = [];
	for (i = 1; i < string_length(_arg0) + 1; i += 1) {
		if (string_char_at(_arg0, i) != "|") {
			text += string_char_at(_arg0, i);
		} else {
			arr[arrI] = real(text);
			arrI++;
			text = "";
		}
	}
	return arr;
}

