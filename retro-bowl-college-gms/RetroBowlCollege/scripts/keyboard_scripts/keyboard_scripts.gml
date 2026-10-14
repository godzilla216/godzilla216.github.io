function s_keyboard_custom_enabled() {
	switch (os_type) {
		case 21:
			return true;
	}
	return false;
}

function s_keyboard_custom_init() {
	global.custkb = {
		base: -4,
		type: 0,
		active: false,
		input_id: undefined,
		layer_id: undefined,
		caps: true,
		caps_key: -4,
		default_key: -1
	};
}

function s_keyboard_custom_show(_arg0) {
	slog("Show custom keyboard");
	with (global.custkb) {
		active = true;
		input_id = _arg0;
		layer_id = s_keyboard_custom_layer();
		s_keyboard_custom_create(layer_id);
	}
}

function s_keyboard_custom_hide() {
	slog("Hide custom keyboard");
	global.custkb.active = false;
	s_keyboard_custom_destroy();
}

function s_keyboard_custom_layer() {
	var lid = layer_get_id("Keyboard");
	if (lid < 0) {
		lid = layer_create(-1000, "Keyboard");
	}
	return lid;
}

function s_keyboard_custom_create(_arg0) {
	var kb_type = global.custkb.input_id.custom_keyboard_type;
	var kb_cols, kb_rows;
	switch (kb_type) {
		case 2:
			kb_cols = 8;
			kb_rows = 2;
			break;
		case 1:
			kb_cols = 11;
			kb_rows = 2;
			break;
		default:
			kb_cols = 13;
			kb_rows = 4;
			break;
	}
	var key_default = -1;
	var key_size = 28;
	var key_step = 30;
	var margin = 8;
	var kb_width = key_step * kb_cols + margin * 2 + 2;
	var kb_height = key_step * kb_rows + margin * 2;
	var kb_x = (480 - kb_width) / 2;
	var kb_y = 270 - kb_height - margin;
	var kb_xo = 0;
	var kb_yo = 0;
	var keys;
	keys[0] = "0123456789\b\nABCDEFGHIJKLM\nNOPQRSTUVWXYZ\n!/*⇧ ,.-\r";
	keys[1] = "01234567\b\n89ABCDEF\r";
	keys[2] = "01234\b\n56789\r";
	var char, nl, skip, width, image;
	var key;
	for (var i = 0; i < string_length(keys[kb_type]); i++) {
		char = string_char_at(keys[kb_type], i + 1);
		nl = false;
		skip = false;
		width = 1;
		image = -1;
		switch (char) {
			case "\n":
				nl = true;
				skip = true;
				break;
			case "\b":
				image = spr_arrowL;
				width = 3;
				break;
			case "\r":
				image = spr_arrowR;
				width = 3;
				break;
			case "⇧":
				image = spr_arrowU;
				break;
			case " ":
				width = 3;
				break;
		}
		if (!skip) {
			key = s_keyboard_custom_create_button(char, char, kb_x + kb_xo + 10, kb_y + kb_yo + 10, _arg0);
			key.image_xscale = (key_step * width - (key_step - key_size)) / key.sprite_width;
			key.image_yscale = key_size / key.sprite_height;
			key.onClickAction = s_custkb_key_tap;
			key.gp_active_editing = true;
			if (image >= 0) {
				key.image = image;
			}
			kb_xo += key_step * width;
			if (key_default < 0) {
				key_default = key;
			}
		}
		if (kb_xo > kb_width || nl) {
			kb_xo = 0;
			kb_yo += key_step;
		}
	}
	var base = instance_create_layer(kb_x, kb_y, _arg0, obj_blank);
	base.sprite_index = spr_box_flex_fill;
	base.image_xscale = kb_width / 16;
	base.image_yscale = kb_height / 16;
	base.action_step = s_custkb_base_step;
	base.action_draw_gui = s_custkb_base_draw_gui;
	global.custkb.base = base;
	global.custkb.type = kb_type;
	global.custkb.caps = true;
	if (global.gamepad) {
		global.custkb.default_key = key_default;
		s_find_default_button();
	}
	return _arg0;
}

function s_keyboard_custom_destroy() {
	with (global.custkb) {
		if (!is_undefined(layer_id)) {
			layer_destroy(layer_id);
		}
	}
	if (global.gamepad) {
		with (global.custkb.input_id) {
			s_save_last_selected();
		}
	}
}

function s_keyboard_custom_create_button(_arg0, _arg1, _arg2, _arg3, _arg4) {
	var key = instance_create_layer(_arg2, _arg3, _arg4, obj_kb_key);
	key.symbol = _arg0;
	key.text = _arg1;
	return key;
}

function s_custkb_base_draw_gui() {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, 16777215, 1);
}

function s_custkb_base_step() {
	if ((os_type == 21 || os_type == 1) && global.gamepad) {
		if (gamepad_button_check_released(global.gp.slot, 32778)) {
			s_custkb_confirm();
		}
		if (gamepad_button_check_released(global.gp.slot, global.gp_back)) {
			s_custkb_delete();
		}
	}
}

function s_custkb_confirm() {
	with (global.custkb.input_id) {
		text = g_pBuiltIn.keyboard_string;
		editing = false;
		s_keyboard_custom_hide();
		if (script_exists(validate_script)) {
			script_execute(self, other, validate_script);
		}
	}
}

function s_custkb_delete() {
	if (string_length(g_pBuiltIn.keyboard_string) > 0) {
		g_pBuiltIn.keyboard_string = string_delete(g_pBuiltIn.keyboard_string, string_length(g_pBuiltIn.keyboard_string), 1);
	}
}

function s_custkb_shift_toggle() {
	global.custkb.caps = !global.custkb.caps;
}

function s_custkb_add_text() {
	g_pBuiltIn.keyboard_string += text;
	if (global.custkb.type == 0) {
		var lc = string_copy(g_pBuiltIn.keyboard_string, string_length(g_pBuiltIn.keyboard_string), 1);
		switch (lc) {
			case "":
			case " ":
				global.custkb.caps = true;
				break;
			default:
				global.custkb.caps = false;
				break;
		}
	}
}

function s_custkb_key_init() {
	event_inherited();
}

function s_custkb_key_draw_gui() {
	event_inherited();
}

function s_custkb_key_step() {
	event_inherited();
	text = global.custkb.caps ? string_upper(text) : string_lower(text);
	if (text == "⇧") {
		image = global.custkb.caps ? spr_arrowD : spr_arrowU;
	}
}

function s_custkb_key_tap() {
	switch (text) {
		case "\b":
			s_custkb_delete();
			break;
		case "\r":
			s_custkb_confirm();
			break;
		case "⇧":
			s_custkb_shift_toggle();
			break;
		default:
			s_custkb_add_text();
			break;
	}
}

