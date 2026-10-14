pmap = obj_master.player_profile;
if (pmap == -4) {
	exit;
}
is_draft_player = false;
if (ds_list_find_index(obj_master.draftlist, pmap) >= 0) {
	is_draft_player = true;
}
if (!ds_map_exists(pmap, "scouted")) {
	ds_map_set(pmap, "scouted", 0);
}
s_round_player_attributes(pmap);
if (!obj_master.tag_kr_message_done || ds_map_find_value(pmap, "position") != 2 && ds_map_find_value(pmap, "position") != 4 && ds_map_find_value(pmap, "position") != 8 && ds_map_find_value(pmap, "position") != 9) {
	with (obj_tag_kr) {
		obj_tag_kr.visible = false;
	}
}
slog("face_x=" + string(ds_map_find_value(pmap, "face_x")));
slog("face_y=" + string(ds_map_find_value(pmap, "face_y")));
draw_set_font(global.fnt_small_flex);
draw_set_halign(0);
draw_set_valign(1);
obj_roomtitle.visible = false;
var name = s_get_string_position(ds_map_find_value(pmap, "position")) + " - " + ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname");
inst_100434.text = name;
var age = s_str("ui_Age") + ": " + string(ds_map_find_value(pmap, "age"));
if (ds_map_find_value(pmap, "age") == s_rookie_age_internal()) {
	age += " " + s_str("ui_Rookie") + "  ";
} else if (ds_map_find_value(pmap, "age") >= s_get_max_age(pmap)) {
	age += " (" + s_str("ui_Retiring") + ")";
}
if (s_is_co_mode()) {
	age = s_college_age_label(ds_map_find_value(pmap, "age"));
}
inst_100443.text = age;
x_rookie = inst_100443.x + string_hd_width(inst_100443.text);
y_rookie = inst_100443.y;
if (ds_map_find_value(pmap, "age") > s_rookie_age_internal() || s_is_co_mode()) {
	y_rookie = -999;
}
inst_100433.title = s_get_string_position_full(ds_map_find_value(pmap, "position"));
inst_100436.text = string_upper(s_str("ui_Condition") + ": ");
x_condition = inst_100436.x + string_hd_width(inst_100436.text);
y_condition = inst_100436.y;
txt_condition = string_upper(s_get_string_condition(ds_map_find_value(pmap, "condition")));
show_spr_condition = true;
if (obj_master.qb_mode) {
	txt_condition = string(ds_map_find_value(pmap, "condition")) + "%";
	if (s_qb_mode_benched_status()) {
		txt_condition += " " + string_upper(s_str("ui_Benched"));
	}
}
if (is_draft_player && !ds_map_find_value(pmap, "scouted")) {
	txt_condition = "?";
}
col_condition = 16777215;
i_condition = -1;
if (obj_master.qb_mode) {
	i_condition = s_get_condition_icon(pmap);
	col_condition = s_get_condition_colour(ds_map_find_value(pmap, "condition"), 65280);
} else if (ds_map_find_value(pmap, "resting")) {
	col_condition = global.c_primary;
	i_condition = 3;
} else if (ds_map_find_value(pmap, "condition") <= 0) {
	col_condition = 255;
	i_condition = 0;
} else if (ds_map_find_value(pmap, "condition") <= 20) {
	col_condition = 4235519;
	i_condition = 1;
} else if (ds_map_find_value(pmap, "condition") <= 40) {
	col_condition = 65535;
	i_condition = 2;
}
x_condition2 = x_condition + string_hd_width(txt_condition + "  ");
var contract = s_str("ui_Contract") + ": $" + string(ds_map_find_value(pmap, "salary")) + "m (" + string(ds_map_find_value(pmap, "contract")) + s_str("sla_Year") + ")";
if (obj_master.qb_mode) {
	contract = s_str("ui_Contract") + ": " + string(ds_map_find_value(pmap, "contract")) + s_str("sla_Year");
}
inst_100435.text = contract;
inst_100441.text = string_upper(s_str("ui_Attitude") + ": " + s_get_string_attitude(ds_map_find_value(pmap, "attitude")));
if (is_draft_player && ds_map_find_value(pmap, "scouted") == 0) {
	inst_100441.text = string_upper(s_str("ui_Attitude") + ": ?");
}
x_attitude = inst_100441.x + string_hd_width(inst_100441.text + "  ");
y_attitude = inst_100441.y;
show_spr_attitude = true;
inst_100442.text = s_str("ui_Rating");
var sw = string_hd_width(inst_100442.text) + 8;
x_star_rating = inst_100442.x;
y_star_rating = inst_100442.y + 12;
star_rating = 0;
show_spr_star_rating_cb = true;
inst_100445.text = s_str("ui_Potential");
var sw = string_hd_width(inst_100445.text) + 8;
x_star_potential = inst_100445.x;
y_star_potential = inst_100445.y + 12;
star_potential = 0;
show_spr_star_rating_cbn = true;
var tval = 1;
if (!s_is_staff(ds_map_find_value(pmap, "position"))) {
	star_rating = s_get_player_rating(pmap);
	star_potential = s_get_player_potential(pmap);
	if (is_draft_player && ds_map_find_value(pmap, "scouted") == 0) {
		star_potential = 0;
	}
	tval = s_get_trade_value(pmap);
}
var trade_value = s_str("ui_Value") + ": " + s_get_string_trade_value(tval);
inst_100447.text = trade_value;
inst_100448.text = "";
inst_100448.tcolour = global.c_primary;
if (obj_master.qb_mode) {
	inst_100447.visible = false;
	inst_100448.visible = false;
}
x_trade = 0;
y_trade = 0;
inst_100403.visible = true;
inst_100402.visible = true;
if (ds_list_find_index(obj_master.tradelist, obj_master.player_profile) > -1) {
	if (ds_list_size(obj_master.tradelist) < 2) {
		inst_100403.visible = false;
		inst_100402.visible = false;
	}
	var pck = ds_map_find_value(obj_master.player_profile, "intrade_pick");
	inst_100448.text = string_upper(s_str("ui_Cost") + ": " + s_get_string_trade_value(pck) + " (" + s_get_string_picks(true) + ")");
	x_trade = inst_100448.x + string_hd_width(inst_100448.text + "  ");
	y_trade = inst_100448.y;
} else if (ds_list_find_index(obj_master.roster, obj_master.player_profile) > -1 && ds_map_find_value(obj_master.player_profile, "outtrade_pick") > 0) {
	if (ds_list_size(obj_master.roster) < 2) {
		inst_100403.visible = false;
		inst_100402.visible = false;
	}
	var pck = ds_map_find_value(obj_master.player_profile, "outtrade_pick");
	var rem_txt = " (" + s_get_string_picks(true) + ")";
	inst_100448.text = s_str("ui_Offer") + ": " + s_get_string_trade_value(pck) + rem_txt;
	x_trade = inst_100448.x + string_hd_width(inst_100448.text + "  ");
	y_trade = inst_100448.y;
} else if (ds_list_find_index(obj_master.roster, obj_master.player_profile) > -1) {
	if (ds_list_size(obj_master.roster) < 2) {
		inst_100403.visible = false;
		inst_100402.visible = false;
	}
}
if (s_is_staff(ds_map_find_value(pmap, "position"))) {
	x_trade = 0;
}
inst_100438.title = s_str("attribute_Catching");
inst_100439.title = s_str("attribute_Speed");
inst_100440.title = s_str("attribute_Strength");
inst_100444.title = s_str("attribute_Stamina");
switch (ds_map_find_value(pmap, "position")) {
	case 1:
		inst_100438.title = s_str("attribute_ThrowAccuracy");
		inst_100440.title = s_str("attribute_ArmStrength");
		inst_100405.text = s_str("attribute_Throwing");
		break;
	case 10:
		inst_100438.title = s_str("attribute_KickAccuracy");
		inst_100440.title = s_str("attribute_KickRange");
		inst_100405.text = s_str("attribute_Accuracy");
		inst_100407.text = s_str("attribute_Range");
		break;
	case 5:
		inst_100438.title = s_str("attribute_Blocking");
		inst_100405.text = s_str("attribute_Blocking");
		break;
	case 6:
	case 7:
	case 8:
	case 9:
		inst_100438.title = s_str("attribute_Tackling");
		inst_100405.text = s_str("attribute_Tackling");
		break;
	default:
		break;
}
inst_100438.potential = ds_map_find_value(pmap, "max_skill") * 10;
inst_100438.percent = ds_map_find_value(pmap, "skill") * 10;
inst_100439.potential = ds_map_find_value(pmap, "max_speed") * 10;
inst_100439.percent = ds_map_find_value(pmap, "speed") * 10;
inst_100440.potential = ds_map_find_value(pmap, "max_strength") * 10;
inst_100440.percent = ds_map_find_value(pmap, "strength") * 10;
inst_100444.potential = ds_map_find_value(pmap, "max_stamina") * 10;
inst_100444.percent = ds_map_find_value(pmap, "stamina") * 10;
inst_100405.active = true;
inst_100406.active = true;
inst_100407.active = true;
inst_100408.active = true;
inst_100410.visible = false;
if (ds_map_find_value(pmap, "skill") >= ds_map_find_value(pmap, "max_skill")) {
	inst_100405.active = false;
}
if (ds_map_find_value(pmap, "speed") >= ds_map_find_value(pmap, "max_speed")) {
	inst_100406.active = false;
}
if (ds_map_find_value(pmap, "strength") >= ds_map_find_value(pmap, "max_strength")) {
	inst_100407.active = false;
}
if (ds_map_find_value(pmap, "stamina") >= ds_map_find_value(pmap, "max_stamina")) {
	inst_100408.active = false;
}
if (ds_list_find_index(obj_master.roster, pmap) < 0) {
	ds_map_set(pmap, "xp_gain", 0);
	ds_map_set(pmap, "skill_points", 0);
}
layer_back = layer_get_id("Buttons_Back");
layer_nav = layer_get_id("Buttons_Navigate");
layer_main = layer_get_id("Buttons_Main");
layer_main_QB = layer_get_id("Buttons_Main_QB");
layer_main_teammate = layer_get_id("Buttons_Main_Teammate");
layer_hoftag = layer_get_id("HOF_Tag");
layer_pick = layer_get_id("Buttons_Pick");
layer_xp = layer_get_id("Buttons_XP");
layer_xp_cont = layer_get_id("Buttons_XP_Continue");
layer_set_visible(layer_back, true);
layer_set_visible(layer_nav, true);
layer_set_visible(layer_main, false);
layer_set_visible(layer_main_QB, false);
layer_set_visible(layer_main_teammate, false);
layer_set_visible(layer_hoftag, false);
layer_set_visible(layer_pick, false);
layer_set_visible(layer_xp, false);
layer_set_visible(layer_xp_cont, false);
if (obj_master.intro > 0) {
	layer_set_visible(layer_main, true);
	inst_100428.active = false;
	inst_100427.active = false;
	inst_100426.active = false;
	inst_100425.active = false;
	if (s_is_co_mode()) {
		rm_player_profile_college_create();
	}
	s_check_intro();
	exit;
} else if (ds_map_find_value(pmap, "xp_gain") > 0) {
	layer_set_visible(layer_back, false);
	layer_set_visible(layer_nav, false);
} else if (ds_map_find_value(pmap, "skill_points") > 0) {
	slog("Skill points = " + string(ds_map_find_value(pmap, "skill_points")));
	layer_set_visible(layer_back, false);
	layer_set_visible(layer_nav, false);
	layer_set_visible(layer_xp, true);
	if (obj_master.qb_mode && pmap != s_get_qb_pmap()) {
		s_qb_mode_auto_xp(inst_100405.active, inst_100406.active, inst_100407.active, inst_100408.active);
	} else {
		if (inst_100405.active) {
			inst_100438.flash = true;
		}
		if (inst_100406.active) {
			inst_100439.flash = true;
		}
		if (inst_100407.active) {
			inst_100440.flash = true;
		}
		if (inst_100408.active) {
			inst_100444.flash = true;
		}
	}
	if (!inst_100405.active && !inst_100406.active && !inst_100407.active && !inst_100408.active) {
		layer_set_visible(layer_xp, false);
		layer_set_visible(layer_xp_cont, true);
	}
} else if (ds_list_find_index(obj_master.roster, pmap) >= 0) {
	if (obj_master.qb_mode) {
		if (ds_map_find_value(pmap, "position") == 1) {
			layer_set_visible(layer_main_QB, true);
		} else {
			layer_set_visible(layer_main_teammate, true);
		}
	} else {
		layer_set_visible(layer_main, true);
		layer_set_visible(layer_hoftag, true);
		inst_100413.selected = false;
		inst_100414.selected = false;
		if (ds_map_exists(pmap, "hof")) {
			inst_100413.selected = ds_map_find_value(pmap, "hof");
		}
		if (ds_map_exists(pmap, "kr")) {
			inst_100414.selected = ds_map_find_value(pmap, "kr");
		}
		inst_100411.visible = false;
		if (s_attribute_buff(pmap, "skill")) {
			inst_100438.buff = 1;
		}
		if (s_attribute_buff(pmap, "speed")) {
			inst_100439.buff = 1;
		}
		if (s_attribute_buff(pmap, "strength")) {
			inst_100440.buff = 1;
		}
		if (s_attribute_buff(pmap, "stamina")) {
			inst_100444.buff = 1;
		}
		inst_100438.col_buff = 65535;
		inst_100439.col_buff = 65280;
		inst_100440.col_buff = 255;
		inst_100444.col_buff = global.c_toxic;
	}
} else {
	layer_set_visible(layer_pick, true);
	if (ds_list_find_index(obj_master.freeagentlist, pmap) >= 0) {
		inst_100410.visible = true;
	}
	if (ds_list_find_index(obj_master.tradelist, pmap) >= 0) {
		inst_100410.visible = true;
	}
	inst_100411.visible = false;
	inst_100412.visible = false;
	if (ds_map_find_value(pmap, "career_games") > 0) {
		layer_set_visible(layer_hoftag, true);
		inst_100413.selected = false;
		inst_100414.selected = false;
		if (ds_map_exists(pmap, "hof")) {
			inst_100413.selected = ds_map_find_value(pmap, "hof");
		}
		if (ds_map_exists(pmap, "kr")) {
			inst_100414.selected = ds_map_find_value(pmap, "kr");
		}
		inst_100412.visible = true;
	} else if (ds_list_find_index(obj_master.draftlist, pmap) >= 0) {
		inst_100411.visible = true;
		if (ds_map_find_value(pmap, "scouted") > 0) {
			inst_100411.visible = false;
		}
		if (inst_100411.visible) {
			inst_100438.potential = ds_map_find_value(pmap, "skill") * 10;
			inst_100439.potential = ds_map_find_value(pmap, "speed") * 10;
			inst_100440.potential = ds_map_find_value(pmap, "strength") * 10;
			inst_100444.potential = ds_map_find_value(pmap, "stamina") * 10;
			if (obj_master.interviews > 0) {
				inst_100411.text = s_str("btn_ScoutPlayer") + " (" + string(obj_master.interviews) + ")";
			} else {
				inst_100411.active = false;
			}
		}
		if (s_is_co_mode()) {
			if (inst_100411.visible) {
				if (string(ds_map_find_value(pmap, "rc_cost")) > obj_master.recruitment_credits) {
					inst_100411.visible = false;
				}
			}
		}
	}
}
target = ds_map_find_value(pmap, "xp_level") * 100;
prc = ds_map_find_value(pmap, "xp") / target * 100;
inst_100446.title = s_str("ui_XPLevel") + " " + string(ds_map_find_value(pmap, "xp_level"));
inst_100446.percent = prc;
if (ds_map_find_value(pmap, "condition") < 0) {
	inst_100428.active = false;
} else {
	switch (ds_map_find_value(pmap, "resting")) {
		case 0:
			inst_100428.text = s_str("ui_Bench");
			inst_100428.colour = global.c_background;
			break;
		case 1:
			inst_100428.text = s_str("ui_Benched");
			inst_100428.colour = global.c_primary;
			break;
	}
	if (s_is_co_mode()) {
		if (ds_map_find_value(pmap, "suspended")) {
			inst_100428.text = s_str("ui_Suspended");
			inst_100428.colour = global.c_primary;
		}
	}
}
if (s_is_co_mode()) {
	var viewOnly = false;
	if (s_doing_college_draft()) {
		viewOnly = true;
	}
	if (obj_master.profile_back_to == 1 || obj_master.profile_back_to == 2) {
		viewOnly = true;
	}
	if (viewOnly) {
		inst_100429.visible = false;
		inst_100428.visible = false;
		inst_100403.visible = false;
		inst_100402.visible = false;
		inst_100426.visible = false;
		inst_100425.visible = false;
	}
	if (obj_master.college_admissions_draft_round > 0) {
		if (ds_map_find_value(pmap, "age") == s_rookie_age_internal()) {
			inst_100425.visible = false;
		} else {
			inst_100425.visible = true;
		}
	}
	inst_100425.onClickAction = btn_click_Profile_College_Cut;
	inst_100425.text = s_str("ui_Cut");
	if (obj_master.college_admissions_draft_round > 0) {
		inst_100425.onClickAction = btn_click_Profile_College_Cut_During_Admission_Draft;
		inst_100425.text = s_str("ui_AdmissCutForRC");
	}
}
s_position_edit_name_btn();
if (s_is_co_mode()) {
	rm_player_profile_college_create();
}
if (obj_master.qb_mode) {
	s_player_profile_qb_mode();
}
s_find_default_button(true);
if (global.exhibition) {
	rm_player_profile_exhibition_create();
}
