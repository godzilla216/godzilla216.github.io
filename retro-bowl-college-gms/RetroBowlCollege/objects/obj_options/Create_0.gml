slog("obj_options.create");
inst_100299.hspeed = -1.5;
draw_set_font(global.fnt_small_flex);
wcred = string_hd_width(s_str("ui_Credits"));
if (s_is_co_mode()) {
	inst_100299.x_start = display_get_gui_width() + wcred * 0.5 + 100;
	inst_100299.x_wrap = -(wcred / 2 + 100);
	inst_100299.x = inst_100299.x_start;
	inst_100299.image_xscale = wcred / 48 + 1;
}
s_update_options();
var lay_id_mob = layer_get_id("Links_Mobile");
var lay_id_brow = layer_get_id("Links_Browser");
var lay_id_console = layer_get_id("Instances_ConsoleBuild");
var lay_id_box = layer_get_id("Instances_Box");
var lay_id_exhibition = layer_get_id("Exhibition");
layer_set_visible(lay_id_mob, false);
layer_set_visible(lay_id_brow, false);
layer_set_visible(lay_id_console, false);
layer_set_visible(lay_id_box, false);
layer_set_visible(lay_id_exhibition, false);
if (global.browser) {
	layer_set_visible(lay_id_brow, true);
	layer_set_visible(lay_id_exhibition, true);
} else if (global.console_build) {
	layer_set_visible(lay_id_console, true);
	inst_100314.visible = false;
	inst_100305.visible = false;
} else if (global.mobile_device) {
	layer_set_visible(lay_id_mob, true);
	layer_set_visible(lay_id_box, true);
}
