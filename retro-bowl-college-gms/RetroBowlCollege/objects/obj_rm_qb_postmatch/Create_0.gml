stage_time = current_time;
stage = 0;
delay = 1000;
pmap = s_get_qb_pmap();
var rating = s_get_match_rating(pmap);
coach_effect = rating - 7;
fan_effect = s_get_postmatch_fans_qb();
var team_effect = s_get_morale() - obj_master.prematch_team_morale_qb;
bonus = obj_master.qb_tdbonus * ds_map_find_value(pmap, "stat_touchdowns");
if (s_get_human_fixture_by_week(obj_master.week) == -4) {
	inst_100683.text = s_str("ui_ByeWeek");
	inst_100687.visible = false;
	with (obj_box_relationship) {
		y -= 40;
	}
	with (obj_vbox) {
		y -= 40;
	}
	with (obj_text) {
		y -= 40;
	}
	rating = 0;
	coach_effect = 0;
	fan_effect = 0;
	team_effect = 0;
	bonus = 0;
	stage = 4;
	stage_time -= stage * delay;
	obj_master.prematch_team_morale_qb = s_get_morale();
}
inst_100689.visible = false;
inst_100690.visible = false;
inst_100691.visible = false;
inst_100692.visible = false;
inst_100693.visible = false;
inst_100694.visible = false;
inst_100689.text = s_str("ui_GameRating") + " " + string(rating);
inst_100690.text = s_str("ui_Coach") + (coach_effect > 0 ? " +" : " ") + string(coach_effect);
inst_100691.text = s_str("ui_Team") + (team_effect >= 0 ? " +" : " ") + string(team_effect);
inst_100692.text = s_str("ui_Fans") + (fan_effect >= 0 ? " +" : " ") + string(fan_effect);
inst_100693.text = s_str("ui_Salary") + " +" + string(obj_master.qb_salary);
inst_100694.text = s_str("ui_TouchdownBonus") + " (" + string(ds_map_find_value(pmap, "stat_touchdowns")) + ") +" + string(bonus);
inst_100695.visible = false;
inst_100697.active = false;
inst_100697.percent = obj_master.prematch_team_morale_qb;
inst_100697.text = string(round(obj_master.prematch_team_morale_qb)) + "%";
