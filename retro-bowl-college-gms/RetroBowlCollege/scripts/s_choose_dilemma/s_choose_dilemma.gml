function s_choose_dilemma(_arg0) {
	with (obj_master) {
		ds_list_shuffle(dilemma_tags);
		var res = s_extract_dilemma_from_pool(_arg0, true);
		if (res != "") {
			slog("s_choose_dilemma.1: Existing list [" + string(res) + "]");
			return res;
		}
		slog("Repopulate dilemma_tags...");
		s_add_tag_matches_to_list(dilemma_tags, _arg0, s_select_lang_file());
		s_add_tag_matches_to_list(dilemma_tags, _arg0, s_select_override_lang_file());
		var res = s_extract_dilemma_from_pool(_arg0, true);
		if (res != "") {
			slog("s_choose_dilemma.2: Fresh list [" + string(res) + "]");
			return res;
		}
		var res = s_extract_dilemma_from_pool(_arg0, false);
		if (res != "") {
			slog("s_choose_dilemma.3: No constraints list [" + string(res) + "]");
			return res;
		}
		slog("s_choose_dilemma.4: Failed");
		return "";
	}
}

function s_extract_dilemma_from_pool(_arg0, _arg1) {
	for (var i = ds_list_size(dilemma_tags) - 1; i >= 0; i--) {
		var str = ds_list_find_value(dilemma_tags, i);
		if (string_count(_arg0, str)) {
			ds_list_delete(dilemma_tags, i);
			if (_arg1) {
				if (s_is_co_mode()) {
					if (s_reject_dilemma_not_enough_RC(str)) {
						continue;
					}
				}
			}
			return str;
		}
	}
	return "";
}

function s_add_tag_matches_to_list(_arg0, _arg1, _arg2, _arg3) {
	if (_arg3 == undefined) {
		_arg3 = "";
	}
	var file = file_text_open_read(_arg2);
	if (file == -1) {
		return;
	}
	while (!file_text_eof(file)) {
		var txt = file_text_read_string(file);
		file_text_readln(file);
		if (string_pos("//", txt) != 0) {
			continue;
		}
		if (_arg3 != "" && string_count(_arg3, txt)) {
			continue;
		}
		if (string_count(_arg1, txt)) {
			var pos = string_pos("\t", txt);
			txt = string_copy(txt, 1, pos - 1);
			if (ds_list_find_index(_arg0, txt) == -1) {
				ds_list_add(_arg0, txt);
				slog(txt);
			}
		}
	}
	file_text_close(file);
}

function s_reject_dilemma_not_enough_RC(_arg0) {
	var msg = s_str(_arg0);
	if (string_count("-choice_FocusRC", msg)) {
		var bonus = s_str_real("choice_FocusRC_bonus");
		if (can_fit_recruitment_credits(bonus) == false) {
			slog("s_reject_dilemma_not_enough_RC rejected[" + _arg0 + "]");
			return true;
		}
	}
	return false;
}

