layer_FM = layer_get_id("Layer_FM");
layer_QB = layer_get_id("Layer_QB");
switch (obj_master.qb_mode) {
	case 0:
		layer_set_visible(layer_FM, true);
		layer_set_visible(layer_QB, false);
		break;
	case 1:
		layer_set_visible(layer_FM, false);
		layer_set_visible(layer_QB, true);
		break;
}
if (s_is_co_mode()) {
	inst_100622.show_stars = false;
}
inst_100621.visible = false;
inst_100630.visible = false;
inst_100631.visible = false;
with (inst_100632) {
	visible = false;
}
s_update_rest_all_button();
obj_master.roster = s_sort_players(obj_master.roster, 4);
l_names = ds_list_create();
l_attitude = ds_list_create();
l_condition = ds_list_create();
l_resting = ds_list_create();
l_pos = ds_list_create();
l_yards = ds_list_create();
l_tackles = ds_list_create();
l_rating = ds_list_create();
l_tds = ds_list_create();
l_fumbles = ds_list_create();
l_intsacks = ds_list_create();
l_xp = ds_list_create();
l_levelup = ds_list_create();
l_gpa = ds_list_create();
l_gpa_col = ds_list_create();
l_suspended = ds_list_create();
if (obj_master.stage == 7) {
	stage_time = current_time;
	if (obj_master.week > obj_master.last_week_regular) {
		inst_100622.text = s_str("ui_EndWeek");
	} else {
		inst_100622.text = s_str("ui_EndWeekN");
		inst_100622.text = string_replace(inst_100622.text, "$num", obj_master.week);
	}
	inst_100624.visible = false;
	inst_100624.visible = false;
	s_post_match_gpa_refresh();
	s_set_up_xp_headers(s_is_bye_week(obj_master.week), true);
	s_do_postmatch_effects();
} else {
	s_tag_backups();
	inst_100622.text = s_str("ui_Roster");
	s_set_up_xp_headers(true, false);
	if (!obj_master.qb_mode) {
		inst_100630.visible = true;
		inst_100631.visible = true;
		if (s_is_co_mode()) {
			inst_100632.visible = true;
		}
		if (ds_list_size(obj_master.roster) < 2) {
			inst_100630.active = false;
			inst_100631.active = false;
			if (s_is_co_mode()) {
				inst_100632.visible = false;
			}
		}
		if (s_get_morale() >= 100) {
			inst_100630.active = false;
		}
		if (s_get_condition_squad() > 95) {
			inst_100630.active = false;
		}
		if (s_is_co_mode()) {
			if (s_get_percent_grade_squad() > 92) {
				inst_100632.visible = false;
			}
		}
	}
}
