if (!global.gamepad) {
	exit;
}
if (!visible) {
	exit;
}
if (layer && !layer_get_visible(layer)) {
	exit;
}
if (variable_instance_exists(id, "active") && !active) {
	exit;
}
with (obj_msgbg) {
	if (depth < other.depth) {
		exit;
	}
}
with (obj_input_box) {
	if (editing) {
		exit;
	}
}
var bx = x + sprite_width;
var by = y;
if (gp_flip_icons_position) {
	bx = x + 6;
	by = y + sprite_height - 6;
}
if (variable_instance_exists(self, "clicked") && clicked) {
	bx -= 2;
	by += 2;
}
var spr = spr_gamepad_any;
switch (os_type) {
	case 15:
	case 23:
	case 0:
		spr = spr_gamepad_xbox1;
		break;
	case 21:
		spr = spr_gamepad_switch;
		break;
}
var mb = gp_mapped_button;
if (room == rm_master && global.gamepad) {
	if (s_is_ui_selected()) {
		mb = global.gp_select;
	} else {
		mb = -1;
	}
}
switch (mb) {
	case -1:
		break;
	case global.gp_select:
		draw_sprite(spr, 0, bx, by);
		break;
	case global.gp_back:
		draw_sprite(spr, 1, bx, by);
		break;
	case 32771:
		draw_sprite(spr, 2, bx, by);
		break;
	case 32772:
		draw_sprite(spr, 3, bx, by);
		break;
}
