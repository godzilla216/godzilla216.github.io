draw_set_font(global.fnt_small_flex);
title = s_str("ui_Achievements") + " " + string(s_get_achievement_percentage()) + "%";
if (use_player_awards) {
	title = s_str("ui_CurriculumVitae");
}
txt_h = string_hd_height(title);
listsize = ds_list_size(obj_master.achievements);
ach_list = obj_master.achievements;
if (use_player_awards) {
	ach_list = obj_master.player_cv;
	listsize = ds_list_size(obj_master.player_cv);
}
clampsize = -listsize * txt_h + sprite_height;
active = true;
