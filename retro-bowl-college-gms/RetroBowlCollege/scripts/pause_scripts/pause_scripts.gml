function s_pause_toggle(_arg0) {
	with (obj_controller) {
		if (!s_pause_is_available()) {
			return;
		}
		if (!is_undefined(_arg0)) {
			draw_pause_ui = _arg0;
		}
		if (state != 10) {
			state_previous = state;
			if (state == 2) {
				with (obj_player) {
					hspeed_previous = hspeed;
					vspeed_previous = vspeed;
					image_speed_previous = image_speed;
					hspeed = 0;
					vspeed = 0;
					image_speed = 0;
					layer_sprite_speed(my_shadow, image_speed);
				}
				with (obj_ball) {
					image_speed_previous = image_speed;
					image_speed = 0;
				}
			}
			state = 10;
		} else {
			s_save_options();
			state = state_previous;
			if (state == 2) {
				with (obj_player) {
					hspeed = hspeed_previous;
					vspeed = vspeed_previous;
					image_speed = image_speed_previous;
					layer_sprite_speed(my_shadow, image_speed);
				}
				with (obj_ball) {
					image_speed = image_speed_previous;
				}
			}
		}
	}
}

function s_pause_is_available() {
	with (obj_controller) {
		if (global.browser) {
			return false;
		}
		if (global.debug_aa_hide_ui) {
			return false;
		}
		if (state == 3) {
			return false;
		}
		if (instance_exists(obj_msgbg)) {
			return false;
		}
		if (alarm[0] > 0) {
			return false;
		}
		switch (comm_stage) {
			case 0:
			case 12:
			case 13:
			case 17:
			case 18:
				return false;
		}
		if (obj_master.gamepractice > 0) {
			return false;
		}
		if (state == 2 && kicking && !s_cpu_is_kicking_off()) {
			return false;
		}
		return true;
	}
}

function s_pause_step() {
	if (state != pause_state_previous) {
		if (pause_state_previous == 10) {
			if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
				if (audio_is_paused(snd_audience_idle)) {
					audio_resume_sound(snd_audience_idle);
				}
				audio_resume_all();
			}
			s_pause_options_dismiss();
			draw_pause_ui = true;
		}
		if (state == 10) {
			audio_pause_all();
			s_pause_options_init();
		}
	}
	pause_state_previous = state;
	if (global.gamepad) {
		if (gamepad_button_check_released(global.gp.slot, 32778) || state == 10 && gamepad_button_check_released(global.gp.slot, global.gp_back)) {
			s_pause_toggle();
		}
	}
}

function s_is_paused_or_just_unpaused() {
	with (obj_controller) {
		return state == 10 || pause_state_previous == 10;
	}
	return false;
}

function s_draw_pause() {
	if (state != 10) {
		return;
	}
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(1);
	draw_set_valign(1);
	draw_set_alpha(1);
	var pause_text = s_str("ui_GamePaused");
	var tx = display_get_gui_width() * 0.5;
	var ty = display_get_gui_height() * 0.6;
	var tw = string_hd_width(pause_text) * 0.5 + 8;
	draw_sprite_ext(spr_commentary_bg, 0, tx - tw, ty - 8, tw / 16 * 2, 1.1, 0, 0, 1);
	draw_hd_text(tx, ty, pause_text);
}

function s_pause_btn_init() {
	var bx = display_get_gui_width() / 2 + 50;
	var by = 8;
	is_paused = false;
	is_avalable = false;
	controlled_by = 0;
	instance_create_layer(bx, by, "Text", obj_btn_pause);
}

function s_pause_btn_step() {
	is_available = s_pause_is_available();
	if (global.gamepad || !is_available || !s_is_touch_allowed()) {
		return;
	}
	mx = device_mouse_x_to_gui(0);
	my = device_mouse_y_to_gui(0);
	hover = false;
	offset = sprite_width / 2 + 2;
	if (point_in_rectangle(mx, my, x - offset, y - offset, x + offset, y + offset)) {
		hover = true;
	}
	if (hover && mouse_check_button_pressed(1)) {
		s_pause_toggle();
	}
}

function s_pause_btn_draw_gui() {
	if (global.gamepad || !is_available) {
		return;
	}
	is_paused = obj_controller.state == 10 ? 1 : 0;
	draw_sprite_ext(sprite_index, is_paused, x, y, 1, 1, 0, 16777215, 1);
}

function s_pause_btn_recenter() {
	x = display_get_gui_width() / 2 + 50;
}

function s_pause_options_init() {
	if (variable_instance_exists(id, "draw_pause_ui") && !draw_pause_ui) {
		return;
	}
	layer_id = s_keyboard_custom_layer();
	obj_btn_pause.layer_id = layer_id;
	obj_btn_pause.controlled_by = global.gamepad ? (s_is_multicon() ? global.gp.id : 0) : 0;
	var gx = display_get_gui_width() / 2 + (s_is_multicon() ? -37 : 0);
	var txt = instance_create_layer(gx, 46, obj_btn_pause.layer_id, obj_text_exp);
	txt.image_xscale = 3;
	txt.draw_box = false;
	txt.halign = 1;
	txt.text = s_str("ui_GamePaused");
	obj_btn_pause.options_btns = [];
	s_pause_options_add_button(1, 0, "ui_Zoom", 1, gx);
	s_pause_options_add_button(1, 1, "ui_Replays", 2, gx);
	s_pause_options_add_button(2, 2, "ui_AimingInvert", 3, gx);
	s_pause_options_add_button(2, 3, "ui_AutoRun", 5, gx);
	s_pause_options_add_button(1, 4, "ui_GamepadGuides", 4, gx);
	if (global.exhibition) {
		s_pause_options_add_quit(obj_btn_pause.controlled_by);
	}
	s_pause_options_update_buttons();
	var base = instance_create_layer(gx - 90, 30, layer_id, obj_blank);
	base.sprite_index = spr_box_flex_fill;
	base.image_xscale = (180 + (s_is_multicon() ? 74 : 0)) / 16;
	base.image_yscale = 14.75;
	base.action_draw_gui = s_pause_options_draw_gui;
	if (global.gamepad) {
		with (obj_btn_pause.options_btns[0]) {
			s_save_last_selected();
		}
	}
}

function s_pause_options_recenter() {
	slogf("Pause options recenter");
	s_pause_options_dismiss();
	s_pause_options_init();
}

function s_pause_options_dismiss() {
	if (variable_instance_exists(obj_btn_pause, "layer_id") && !is_undefined(obj_btn_pause.layer_id)) {
		layer_destroy(obj_btn_pause.layer_id);
	}
}

function s_pause_options_draw_gui() {
	draw_sprite_ext(spr_box_flex_bg, image_index, x, y, image_xscale, image_yscale, 0, global.c_background, 1);
	draw_sprite_ext(spr_box_flex, image_index, x, y, image_xscale, image_yscale, 0, 16777215, 1);
}

function s_pause_options_layer() {
	var lid = layer_get_id("PauseOptions");
	if (lid < 0) {
		lid = layer_create(-1000, "PauseOptions");
	}
	return lid;
}

function s_pause_options_add_button(_arg0, _arg1, _arg2, _arg3, _arg4) {
	var tx = _arg4 - 2;
	var ty = 60 + 40 * _arg1;
	var txt = instance_create_layer(tx, ty + 16, obj_btn_pause.layer_id, obj_text_exp);
	txt.draw_box = false;
	txt.halign = 2;
	txt.image_xscale = 2;
	txt.text = s_str(_arg2);
	var btn1 = instance_create_layer(tx + 6, ty, obj_btn_pause.layer_id, obj_button_9s);
	btn1.onClickAction = s_pause_options_button_action;
	btn1.type = _arg3;
	btn1.player = 1;
	btn1.image_xscale = 74 / btn1.sprite_width;
	btn1.gp_allowed = s_is_multicon() ? 1 : 3;
	array_push(obj_btn_pause.options_btns, btn1);
	if (_arg0 > 1 && s_is_multicon()) {
		var btn2 = instance_create_layer(tx + 6 + 74 + 6, ty, obj_btn_pause.layer_id, obj_button_9s);
		btn2.onClickAction = s_pause_options_button_action;
		btn2.type = _arg3;
		btn2.player = 2;
		btn2.image_xscale = 74 / btn2.sprite_width;
		btn2.gp_allowed = 2;
		array_push(obj_btn_pause.options_btns, btn2);
	}
}

function s_pause_options_add_quit(_arg0) {
	var tall = display_get_gui_width() < 480;
	var bw = tall ? 45 : 90;
	var mx = tall ? 4 : 10;
	var tx = _arg0 < 2 ? mx : display_get_gui_width() - mx - bw;
	var ty = 30;
	var btn = instance_create_layer(tx, ty, obj_btn_pause.layer_id, obj_button_9s);
	btn.onClickAction = s_pause_options_quit_game;
	btn.image_xscale = bw / btn.sprite_width;
	btn.text = s_str(tall ? "ui_Quit" : "ui_QuitGame");
	btn.gp_allowed = s_is_multicon() ? _arg0 : 3;
}

function s_pause_options_update_buttons() {
	for (var i = 0; i < array_length(obj_btn_pause.options_btns); i++) {
		var btn = obj_btn_pause.options_btns[i];
		switch (btn.type) {
			case 1:
				switch (ds_map_find_value(obj_master.map_options, "op_zoom")) {
					case true:
					case "true":
						btn.text = s_str("ui_On");
						break;
					case false:
					case "false":
						btn.text = s_str("ui_Off");
						break;
				}
				break;
			case 2:
				switch (ds_map_find_value(obj_master.map_options, "op_replays")) {
					case 0:
						btn.text = s_str("ui_Off");
						break;
					case 1:
						btn.text = s_str("ui_Dynamic");
						break;
					case 2:
						btn.text = s_str("ui_EveryPlay");
						break;
				}
				break;
			case 3:
				switch (ds_map_find_value(obj_master.map_options, btn.player == 2 ? "op_invert_throw_p2" : "op_invert_throw")) {
					case 0:
						btn.text = s_str("ui_Normal");
						break;
					case 1:
						btn.text = s_str("ui_Inverted");
						break;
					case 2:
						btn.text = s_str("ui_AnalogueL");
						break;
					case 3:
						btn.text = s_str("ui_AnalogueR");
						break;
				}
				if (!global.console_build && !global.gamepad) {
					btn.active = false;
				}
				break;
			case 4:
				switch (ds_map_find_value(obj_master.map_options, "op_gamepad_guides")) {
					case true:
					case "true":
						btn.text = s_str("ui_On");
						break;
					case false:
					case "false":
						btn.text = s_str("ui_Off");
						break;
				}
				if (!global.console_build && !global.gamepad) {
					btn.active = false;
				}
				break;
			case 5:
				switch (btn.player == 2 ? obj_master.op_autorun_p2 : obj_master.op_autorun) {
					case true:
					case "true":
						btn.text = s_str("ui_On");
						break;
					case false:
					case "false":
						btn.text = s_str("ui_Off");
						break;
				}
				if (!global.console_build && !global.gamepad) {
					btn.active = false;
				}
				break;
			case 98:
				switch (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
					case 0:
						btn.text = s_str("ui_Off");
						break;
					case 1:
						btn.text = s_str("ui_SoundFX");
						break;
					case 2:
						btn.text = s_str("ui_SoundFX") + "\n& " + s_str("ui_Music");
						break;
				}
				break;
			case 99:
				switch (ds_map_find_value(obj_master.map_options, "op_scanlines")) {
					case true:
					case "true":
						btn.text = s_str("ui_On");
						break;
					case false:
					case "false":
						btn.text = s_str("ui_Off");
						break;
				}
				break;
			case 10:
				switch (global.debug_aa_hide_ui) {
					case true:
						btn.text = s_str("ui_Off");
						break;
					case false:
						btn.text = s_str("ui_On");
						break;
				}
				break;
		}
	}
}

function s_pause_options_button_action() {
	switch (type) {
		case 1:
			with (obj_master) {
				ds_map_set(map_options, "op_zoom", !ds_map_find_value(map_options, "op_zoom"));
			}
			break;
		case 2:
			with (obj_master) {
				ds_map_set(map_options, "op_replays", (ds_map_find_value(map_options, "op_replays") + 1) mod 3);
			}
			break;
		case 3:
			with (obj_master) {
				var opt = other.player == 2 ? "op_invert_throw_p2" : "op_invert_throw";
				ds_map_set(map_options, opt, (ds_map_find_value(map_options, opt) + 1) mod 2);
			}
			break;
		case 4:
			with (obj_master) {
				ds_map_set(map_options, "op_gamepad_guides", !ds_map_find_value(map_options, "op_gamepad_guides"));
			}
			break;
		case 5:
			with (obj_master) {
				if (other.player == 2) {
					op_autorun_p2 = !op_autorun_p2;
				} else {
					op_autorun = !op_autorun;
				}
			}
			break;
		case 98:
			with (obj_master) {
				ds_map_set(map_options, "op_soundfx", (ds_map_find_value(map_options, "op_soundfx") + 1) mod 3);
			}
			break;
		case 99:
			with (obj_master) {
				ds_map_set(map_options, "op_scanlines", !ds_map_find_value(map_options, "op_scanlines"));
				obj_scanlines.on = ds_map_find_value(map_options, "op_scanlines");
			}
			break;
		case 10:
			with (obj_master) {
				s_pause_toggle();
				global.debug_aa_hide_ui = !global.debug_aa_hide_ui;
			}
			break;
	}
	s_pause_options_update_buttons();
}

function s_pause_options_quit_game() {
	var gp_allow = s_is_multicon() ? obj_btn_pause.controlled_by : 3;
	s_pause_options_dismiss();
	s_create_message("", s_str("msg_QuitExhibition"), s_str("ui_Cancel"), s_str("ui_Confirm"), btn_response_quit_exhibition_cancel, btn_response_quit_exhibition_confirm, global.c_background, 1, undefined, gp_allow);
}

function btn_response_quit_exhibition_cancel() {
	s_pause_options_init();
	s_msg_clear();
}

function btn_response_quit_exhibition_confirm() {
	obj_master.btn_continue_state = 0;
	s_set_multicon_turn();
	exhibition_handle_exit_match();
	room_goto(rm_exhibition);
}

