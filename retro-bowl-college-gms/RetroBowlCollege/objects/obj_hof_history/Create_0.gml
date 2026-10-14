draw_set_font(global.fnt_small_flex);
txt_h = string_hd_height("I");
listsize = s_history_display_lines_count();
clampsize = -listsize * txt_h + sprite_height;
if (global.gamepad && listsize * txt_h > sprite_height - 16) {
	active = true;
}
active = true;
s_log_full_history();
