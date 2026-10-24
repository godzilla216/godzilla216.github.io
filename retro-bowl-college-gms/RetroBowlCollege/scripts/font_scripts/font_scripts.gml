function s_data_path(_arg0) {
	return working_directory + _arg0;
}

function s_fonts_init() {
	slog("Load JAPAN ttf font");
	global.fnt_small_flex = fnt_tecmo_small;
	global.fnt_flex = fnt_tecmo;
	global.fnt_restart_flex = fnt_restart;
	global.hd_fonts = false;
	if (os_get_config() == "Japan") {
		slog("Load JAPAN ttf font");
		var japFontPath = s_data_path("TT_DotGothic16-M.TTF");
		font_add_enable_aa(false);
		global.fnt_jp = font_add(japFontPath, 50.4, false, false, 32, 128);
		global.fnt_small_jp = font_add(japFontPath, 28.8, false, false, 32, 128);
		global.fnt_restart_jp = font_add(japFontPath, 50.4, false, false, 32, 128);
		global.fnt_flex = global.fnt_jp;
		global.fnt_small_flex = global.fnt_small_jp;
		global.fnt_restart_flex = global.fnt_restart_jp;
		global.hd_fonts = true;
		slog("Load ttf font [" + string(japFontPath) + "] done:[" + string(global.fnt_jp) + "]");
	}
}

function s_erase_text_background(_arg0, _arg1, _arg2, _arg3) {
	if (_arg3 == undefined) {
		_arg3 = 4;
	}
	var sw = string_hd_width(_arg2);
	var alpha = draw_get_alpha();
	var hal = draw_get_halign();
	switch (hal) {
		case 1:
			_arg0 -= sw / 2;
			break;
		case 2:
			_arg0 -= sw;
			break;
	}
	draw_set_alpha(1);
	draw_rectangle_color(_arg0 - _arg3, _arg1 - _arg3, _arg0 + sw + _arg3, _arg1 + _arg3, global.c_background, global.c_background, global.c_background, global.c_background, 0);
	draw_set_alpha(alpha);
}

function draw_hd_text(_arg0, _arg1, _arg2, _arg3) {
	if (_arg3 == undefined) {
		_arg3 = false;
	}
	if (_arg3) {
		s_erase_text_background(_arg0, _arg1, _arg2);
	}
	if (global.hd_fonts) {
		draw_text_transformed(_arg0, _arg1, _arg2, 0.25, 0.25, 0);
	} else {
		draw_text(_arg0, _arg1, _arg2);
	}
}

function draw_hd_text_color(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7) {
	if (global.hd_fonts) {
		draw_text_transformed_color(_arg0, _arg1, _arg2, 0.25, 0.25, 0, _arg3, _arg4, _arg5, _arg6, _arg7);
	} else {
		draw_text_color(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7);
	}
}

function draw_hd_text_ext(_arg0, _arg1, _arg2, _arg3, _arg4) {
	if (global.hd_fonts) {
		draw_text_ext_transformed(_arg0, _arg1, _arg2, _arg3 * 4, _arg4 * 4, 0.25, 0.25, 0);
	} else {
		draw_text_ext(_arg0, _arg1, _arg2, _arg3, _arg4);
	}
}

function draw_hd_text_ext_color(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9) {
	if (global.hd_fonts) {
		draw_text_ext_transformed(_arg0, _arg1, _arg2, _arg3 * 4, _arg4 * 4, 0.25, 0.25, 0);
	} else {
		draw_text_ext_color(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9);
	}
}

function draw_hd_text_transformed(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5) {
	if (global.hd_fonts) {
		draw_text_transformed(_arg0, _arg1, _arg2, _arg3 / 4, _arg4 / 4, _arg5);
	} else {
		draw_text_transformed(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5);
	}
}

function draw_hd_text_transformed_color(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10) {
	if (global.hd_fonts) {
		draw_text_transformed_color(_arg0, _arg1, _arg2, _arg3 / 4, _arg4 / 4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10);
	} else {
		draw_text_transformed_color(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10);
	}
}

function draw_hd_text_ext_transformed(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7) {
	if (global.hd_fonts) {
		draw_text_ext_transformed(_arg0, _arg1, _arg2, _arg3 * 4, _arg4 * 4, _arg5 / 4, _arg6 / 4, _arg7);
	} else {
		draw_text_ext_transformed(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7);
	}
}

function string_hd_width(_arg0) {
	if (global.hd_fonts) {
		return string_width(_arg0) / 4;
	} else {
		return string_width(_arg0);
	}
}

function string_hd_width_ext(_arg0, _arg1, _arg2) {
	if (global.hd_fonts) {
		return string_width_ext(_arg0, _arg1 * 4, _arg2 * 4) / 4;
	} else {
		return string_width_ext(_arg0, _arg1, _arg2);
	}
}

function string_hd_height(_arg0) {
	if (global.hd_fonts) {
		return string_height(_arg0) / 4;
	} else {
		return string_height(_arg0);
	}
}

function string_hd_height_ext(_arg0, _arg1, _arg2) {
	if (global.hd_fonts) {
		return string_height_ext(_arg0, _arg1 * 4, _arg2 * 4) / 4;
	} else {
		return string_height_ext(_arg0, _arg1, _arg2);
	}
}

