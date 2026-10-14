function s_title_goto() {
	if (!global.show_title) {
		return;
	}
	var doShow = false;
	switch (os_type) {
		case 21:
			doShow = true;
			break;
	}
	if (s_is_co_mode()) {
		doShow = true;
	}
	if (doShow) {
		s_set_desktop_dev_window_size();
		global.show_title = false;
		room_goto(rm_title);
	}
}

function s_title_create() {
	s_refresh_gamepads();
	s_title_create_image();
}

function s_title_exit() {
	display_set_gui_size(480, 270);
	surface_resize(g_pBuiltIn.application_surface, 480, 270);
	room_goto(rm_master);
}

function s_title_check_any_button() {
	s_update_gamepad();
	return global.gp.gamepad_anybutton || mouse_check_button_released(1) || mouse_check_button_released(2);
}

function s_title_create_image() {
	action_step = s_title_step_image;
	action_draw_gui = s_title_draw_gui_image;
	inst_100022.title_spr = spr_title;
	inst_100022.title_frame = 0;
	inst_100022.title_x = 0;
	inst_100022.title_y = 0;
	inst_100022.text_x = 240;
	inst_100022.text_y = 242;
	if (s_is_co_mode()) {
		inst_100022.text_x = 240;
		inst_100022.text_y = 76;
		inst_100022.title_spr = spr_title_co_wide;
		inst_100022.title_frame = 0;
		var slot = ds_map_find_value(obj_master.map_options, "saveslot");
		var sav_week = 1;
		var sav_stage = 1;
		var sav_college_admissions_draft_round = 0;
		var filename = global.g_savename1;
		if (slot == 2) {
			filename = global.g_savename2;
		}
		if (slot == 3) {
			filename = global.g_savename3;
		}
		if (slot == 4) {
			filename = global.g_savename4;
		}
		if (slot == 5) {
			filename = global.g_savename5;
		}
		if (file_exists(filename)) {
			slog("Opening file: " + filename);
			ini_open(filename);
			sav_week = ini_read_real("savegame", "week", 1);
			sav_college_admissions_draft_round = ini_read_real("savegame", "college_admissions_draft_round", 0);
			sav_stage = ini_read_real("savegame", "stage", 1);
			ini_close();
		}
		if (sav_stage == -10 || sav_college_admissions_draft_round > 0) {
			slog("TITLE slot:[" + string(slot) + "] sav_stage(" + string(sav_stage) + ") sav_college_admissions_draft_round(" + string(sav_college_admissions_draft_round) + ") Between seasons -> Spring");
			inst_100022.title_frame = 1;
		} else if (sav_week < obj_master.last_week_regular) {
			slog("TITLE slot:[" + string(slot) + "] week(" + string(sav_week) + ") Regular season -> Fall");
			inst_100022.title_frame = 0;
		} else {
			slog("TITLE slot:[" + string(slot) + "] week(" + string(sav_week) + ") Post season -> Winter");
			inst_100022.title_frame = 2;
		}
		var dW = display_get_width();
		var dH = display_get_height();
		var s_ar = real(dW) / real(dH);
		var sW = sprite_get_width(inst_100022.title_spr);
		var sH = sprite_get_height(inst_100022.title_spr);
		var newDW = 480;
		var newDH = 270;
		var is_tall = s_ar > 1.7777777777777777;
		if (is_tall) {
			slog("TITLE -> Tall device [" + string(dW) + "," + string(dH) + "]");
			var tH = 270;
			var tW = tH * s_ar;
			newDW = tW;
			newDH = tH;
			inst_100022.title_x = (tW - sW) / 2;
			inst_100022.title_y = 0;
			inst_100022.text_x += (tW - 480) / 2;
			inst_100022.text_y += (tH - 270) / 2;
		} else {
			slog("TITLE -> Not Tall device [" + string(dW) + "," + string(dH) + "]");
			inst_100022.title_x = (480 - sW) / 2;
		}
		slog("----------------");
		slog("newDW [" + string(newDW) + "]");
		slog("newDH [" + string(newDH) + "]");
		slog("----------------");
		display_set_gui_size(newDW, newDH);
		surface_resize(g_pBuiltIn.application_surface, newDW, newDH);
	}
}

function s_title_step_image() {
	if (s_title_check_any_button()) {
		if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
			audio_play_sound(snd_click, 1, false);
		}
		s_title_exit();
	}
}

function s_title_draw_gui_image() {
	draw_sprite(inst_100022.title_spr, inst_100022.title_frame, inst_100022.title_x, inst_100022.title_y);
	var tx = inst_100022.text_x;
	var ty = inst_100022.text_y;
	var msg = global.mobile_device ? "ui_PressStart_mob" : "ui_PressStart";
	var msgTxt = string_upper(s_str(msg));
	if (current_time mod 1000 > 500) {
		draw_set_font(global.fnt_small_flex);
		draw_set_color(16777215);
		draw_set_halign(1);
		draw_set_valign(1);
		draw_hd_text(tx, ty, msgTxt);
	}
}

function f_almost_same(_arg0, _arg1) {
	return abs(_arg0 - _arg1) < 0.011;
}

function s_title_create_video() {
	action_async_social = s_title_async_social_video;
	action_draw_gui = s_title_draw_gui_video;
	action_step = s_title_step_video;
	slogf("Window: %1x%2", window_get_width(), window_get_height());
	slogf("Screen: %1x%2", display_get_width(), display_get_height());
	var vidName = "16x9_Landscape_1920.mp4";
	var resW = 1920;
	var resH = 1080;
	var dW = display_get_width();
	var dH = display_get_height();
	var aspRat = "?";
	var s_ar = real(dW) / real(dH);
	if (f_almost_same(1.7777777777777777, s_ar)) {
		aspRat = "16:9";
		if (dW < 2000) {
			resW = 1920;
			resH = 1080;
			vidName = "16x9_Landscape_1920.mp4";
		} else if (dW < 5000) {
			resW = 4096;
			resH = 2304;
			vidName = "16x9_Landscape_4096.mp4";
		} else {
			resW = 5120;
			resH = 2880;
			vidName = "16x9_Landscape_5120.mp4";
		}
	} else if (f_almost_same(1.6, s_ar)) {
		aspRat = "16:10";
		if (dW < 2000) {
			resW = 1440;
			resH = 900;
			vidName = "16x10_Landscape_1440.mp4";
		} else {
			resW = 2880;
			resH = 1800;
			vidName = "16x10_Landscape_2880.mp4";
		}
	} else if (f_almost_same(1.3333333333333333, s_ar)) {
		resW = 2732;
		resH = 2048;
		vidName = "4x3_Landscape.mp4";
		aspRat = "4:3";
	} else if (f_almost_same(2.1666666666666665, s_ar)) {
		resW = 2688;
		resH = 1242;
		vidName = "19.5x9_Landscape.mp4";
		aspRat = "19.5:9";
	} else if (f_almost_same(1.525, s_ar)) {
		resW = 2266;
		resH = 1488;
		vidName = "4.6x3_Landscape.mp4";
		aspRat = "4.5:3 but really 6.1:4";
	} else if (f_almost_same(1.4285714285714286, s_ar)) {
		resW = 2388;
		resH = 1668;
		vidName = "4.3x3_Landscape.mp4";
		aspRat = "4.3:3 but really 10:7";
	}
	slog("s_title_create_video [" + vidName + "] size [" + string(resW) + "/" + string(resH) + "] for screen [" + string(dW) + "/" + string(dH) + "]  aspRat[" + aspRat + "]");
	video_open("AppleArcade/" + vidName);
	display_set_gui_size(resW, resH);
	surface_resize(g_pBuiltIn.application_surface, resW, resH);
}

function s_title_async_social_video() {
	var _type = ds_map_find_value(async_load, "type");
	if (_type == "video_start") {
		slog("video_start");
	} else if (_type == "video_end") {
		s_title_do_video_end();
		s_title_create_fadeinout_splash();
	}
}

function s_title_do_video_end() {
	slog("video_end");
	ds_map_set(obj_master.map_options, "aa_video_watched", 1);
	obj_scanlines.visible = true;
	s_save_options();
	video_close();
	display_set_gui_size(480, 270);
	surface_resize(g_pBuiltIn.application_surface, 480, 270);
}

function s_title_step_video() {
	if (s_title_check_any_button()) {
		slog("aa_video_watched[" + string(ds_map_find_value(obj_master.map_options, "aa_video_watched")) + "]");
		if (ds_map_find_value(obj_master.map_options, "aa_video_watched") == 0) {
			return;
		}
		slog("video_skip");
		s_title_do_video_end();
		s_title_exit();
	}
}

function s_title_draw_gui_video() {
	var _data = video_draw();
	var _status = _data[0];
	if (_status == 0) {
		var _surface = _data[1];
		draw_surface(_surface, x, y);
	}
}

function s_title_create_fadeinout_splash() {
	action_async_social = -4;
	action_step = s_title_step_fadeinout_splash;
	action_draw_gui = s_title_draw_fadeinout_splash;
	inst_100022.title_spr = spr_title_aa;
	inst_100022.fade_start_t = current_time;
}

function s_title_step_fadeinout_splash() {
	if (s_title_check_any_button()) {
		s_title_exit();
		return;
	}
	var t = current_time - fade_start_t;
	if (t >= 2100) {
		s_title_exit();
	}
}

function s_title_draw_fadeinout_splash() {
	var a = 1;
	var t = current_time - fade_start_t;
	if (t <= 350) {
		a = lerp(0, 1, t / 350);
	} else if (t > 350 && t <= 1850) {
		a = 1;
	} else if (t > 1850 && t <= 2100) {
		a = lerp(1, 0, (t - 1850) / 250);
	} else {
		a = 0;
	}
	draw_sprite_ext(inst_100022.title_spr, 0, 0, 0, 1, 1, 0, 16777215, a);
}

