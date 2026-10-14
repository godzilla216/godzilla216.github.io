lines = ds_list_create();
pmap = obj_master.player_profile;
if (pmap == -4) {
	exit;
}
var name = ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname");
inst_100532.title = name;
inst_100539.text = string(round(ds_map_find_value(pmap, "attitude"))) + "%";
inst_100538.text = string(round(clamp(ds_map_find_value(pmap, "condition"), 0, 100))) + "%";
inst_100540.text = string(ds_map_find_value(pmap, "xp_level"));
var contract = "$" + string(ds_map_find_value(pmap, "salary")) + "m (" + string(ds_map_find_value(pmap, "contract")) + s_str("sla_Year") + ")";
inst_100541.text = contract;
inst_100535.text = s_str("ui_BoostMorale");
inst_100534.text = s_str("ui_BoostCondition");
inst_100536.text = s_str("ui_LevelUp");
inst_100537.text = s_str("ui_ExtendContract");
inst_100543.text = string(s_get_meeting_cost_morale(pmap));
inst_100545.text = string(s_get_meeting_cost_condition(pmap));
inst_100546.text = s_get_meeting_cost_levelup(pmap);
if (ds_map_find_value(pmap, "attitude") >= 100) {
	inst_100543.active = false;
}
if (ds_map_find_value(pmap, "condition") < 0 || ds_map_find_value(pmap, "condition") >= 100) {
	inst_100545.active = false;
}
retirement = false;
var m4Image = inst_100547.image;
if (ds_map_find_value(pmap, "age") == s_rookie_age_internal()) {
	inst_100547.active = false;
	inst_100547.text = s_str("ui_Rookie");
	inst_100547.image = -1;
} else if (ds_map_find_value(pmap, "age") >= s_get_max_age_normal(pmap)) {
	retirement = true;
	inst_100537.text = s_str("ui_DelayRetirement");
	inst_100547.text = max(s_get_meeting_cost_extend_contract(pmap), s_get_meeting_cost_delay_retirement(pmap));
	if (ds_map_find_value(pmap, "age") < s_get_max_age(pmap) || ds_map_find_value(pmap, "age") > s_get_max_age_normal(pmap) + 4) {
		inst_100547.active = false;
	}
} else {
	inst_100547.text = s_get_meeting_cost_extend_contract(pmap);
	if (ds_map_find_value(pmap, "contract") > 4) {
		inst_100547.active = false;
	} else if (ds_map_find_value(pmap, "age") + ds_map_find_value(pmap, "contract") > s_get_max_age(pmap)) {
		inst_100547.active = false;
	}
}
if (s_is_co_mode()) {
	inst_100547.text = s_get_meeting_cost_extend_contract(pmap);
	inst_100547.active = true;
	inst_100547.image = m4Image;
	inst_100541.text = s_gpa_string(pmap);
	inst_100541.title = s_str("ui_GPA");
}
inst_100549.visible = false;
if (ds_map_exists(pmap, "meetingdone") && ds_map_find_value(pmap, "meetingdone") > 0) {
	inst_100549.text = string_replace(s_str("msg_MeetingDone"), "$playername", name);
	inst_100549.visible = true;
	inst_100543.active = false;
	inst_100545.active = false;
	inst_100546.active = false;
	inst_100547.active = false;
}
