if (obj_master.intro > 0) {
	s_check_intro();
	exit;
}
if (obj_master.qb_mode) {
	s_qb_mode_update_resting();
}
s_set_up_uniforms();
if (s_is_co_mode()) {
	inst_100389.text = s_get_week_name();
} else {
	inst_100389.text = s_get_string_week(0);
}
team0 = obj_master.team[0];
team1 = obj_master.team[1];
str_type = s_get_fix_type_string_by_values(team0, team1);
switch (obj_master.force_uniform_sel1) {
	case 0:
		s_load_uniform_file2(ds_map_find_value(team0, "uid"), 100393, 1, "");
		break;
	case 1:
		s_load_uniform_file2(ds_map_find_value(team0, "uid"), 100393, 0, "");
		break;
	case 2:
		s_load_uniform_file2(ds_map_find_value(team0, "uid"), 100393, 2, "");
		break;
	case 3:
		s_load_uniform_file2(ds_map_find_value(team0, "uid"), 100393, 3, "");
		break;
}
switch (obj_master.force_uniform_sel2) {
	case 0:
		s_load_uniform_file2(ds_map_find_value(team1, "uid"), 100394, 0, "");
		break;
	case 1:
		s_load_uniform_file2(ds_map_find_value(team1, "uid"), 100394, 1, "");
		break;
	case 2:
		s_load_uniform_file2(ds_map_find_value(team1, "uid"), 100394, 2, "");
		break;
	case 3:
		s_load_uniform_file2(ds_map_find_value(team1, "uid"), 100394, 3, "");
		break;
}
switch (obj_master.force_uniform_sel1) {
	case 0:
		inst_100398.text = s_str("ui_Away");
		break;
	case 1:
		inst_100398.text = s_str("ui_Home");
		break;
	case 2:
		inst_100398.text = s_str("ui_Alternate");
		break;
	case 3:
		inst_100398.text = s_str("ui_Rush");
		break;
}
switch (obj_master.force_uniform_sel2) {
	case 0:
		inst_100399.text = s_str("ui_Home");
		break;
	case 1:
		inst_100399.text = s_str("ui_Away");
		break;
	case 2:
		inst_100399.text = s_str("ui_Alternate");
		break;
	case 3:
		inst_100399.text = s_str("ui_Rush");
		break;
}
record[0] = s_get_string_record(team0, false);
defense[0] = s_get_team_defense(team0);
offense[0] = s_get_team_offense(team0);
name[0] = ds_map_find_value(team0, "name");
record[1] = s_get_string_record(team1, false);
defense[1] = s_get_team_defense(team1);
offense[1] = s_get_team_offense(team1);
name[1] = ds_map_find_value(team1, "name");
if (s_is_co_mode()) {
	record[0] = s_get_string_record_co_extended(team0);
	record[1] = s_get_string_record_co_extended(team1);
	name[0] = s_get_string_conf_tag(team0, team1) + ds_map_find_value(team0, "name");
	name[1] = s_get_string_conf_tag(team1, team0) + ds_map_find_value(team1, "name");
	inst_100393.body_type = s_get_team_body_type(team0, defense[0], offense[0]);
	inst_100394.body_type = s_get_team_body_type(team1, defense[1], offense[1]);
}
with (obj_master) {
	col_helmet_home = inst_100394.helmet;
	col_logo_home = inst_100394.logo;
	col_shirt_home = inst_100394.shirt;
	col_sleeve_home = inst_100394.sleeve;
	col_pants_home = inst_100394.pants;
	col_pants_home_b = inst_100394.pants_b;
	col_stripe_home = inst_100394.stripe;
	col_socks1_home = inst_100394.socks1;
	col_socks2_home = inst_100394.socks2;
	col_endzone_home = inst_100394.endzone;
	col_helmet_away = inst_100393.helmet;
	col_logo_away = inst_100393.logo;
	col_shirt_away = inst_100393.shirt;
	col_sleeve_away = inst_100393.sleeve;
	col_pants_away = inst_100393.pants;
	col_pants_away_b = inst_100393.pants_b;
	col_stripe_away = inst_100393.stripe;
	col_socks1_away = inst_100393.socks1;
	col_socks2_away = inst_100393.socks2;
	col_endzone_away = inst_100393.endzone;
	s_blackwhite_colour_hack(col_shirt_home);
	s_blackwhite_colour_hack(col_pants_home);
	s_blackwhite_colour_hack(col_stripe_home);
	s_blackwhite_colour_hack(col_shirt_away);
	s_blackwhite_colour_hack(col_pants_away);
	s_blackwhite_colour_hack(col_stripe_away);
}
inst_100395.title = s_str("ui_Ball") + " " + string(obj_master.op_ball + 1);
inst_100397.image_num = obj_master.op_ball;
obj_master.sim_action = false;
inst_100400.visible = false;
if (obj_master.fr_mode) {
	inst_100400.visible = true;
}
if (s_is_co_mode() && 0) {
	inst_100400.visible = true;
}
var rest_text_short = "";
var rest_text_long = "";
with (obj_master) {
	for (var i = 0; i < ds_list_size(roster); i++) {
		var pmap = ds_list_find_value(roster, i);
		if (s_player_benched(pmap)) {
			if (rest_text_short != "") {
				rest_text_short += ", ";
			}
			if (rest_text_long != "") {
				rest_text_long += ", ";
			}
			rest_text_short += s_get_string_position(ds_map_find_value(pmap, "position"));
			rest_text_long += "[" + s_get_string_position(ds_map_find_value(pmap, "position")) + "] " + ds_map_find_value(pmap, "lname");
		}
	}
	if (rest_text_long != "") {
		inst_100390.title = ds_map_find_value(myteam, "name") + " " + s_str("ui_Benched");
		if (string_length(rest_text_long) > 26) {
			if (string_length(rest_text_short) > 26) {
				inst_100391.text = string_copy(rest_text_short, 1, 26);
			} else {
				inst_100391.text = rest_text_short;
			}
		} else {
			inst_100391.text = rest_text_long;
		}
	}
}
if (obj_master.qb_mode) {
	inst_100390.visible = true;
	inst_100391.visible = true;
	switch (s_qb_mode_benched_status()) {
		case 1:
			inst_100390.title = "BENCHED!";
			inst_100391.text = string_replace(s_str("msg_benched_relationship"), "$num", string(obj_master.relationship_boss));
			inst_100391.tcolour = 255;
			exit;
			break;
		case 2:
			inst_100390.colour = 255;
			inst_100390.flash = true;
			inst_100390.title = "BENCHED!";
			inst_100391.text = string_replace(s_str("msg_benched_energy"), "$num", string(s_get_qb_energy()));
			exit;
			break;
	}
}
if (rest_text_long == "") {
	inst_100390.visible = false;
	inst_100391.visible = false;
	if (global.browser) {
		instance_create_layer(56, 232, "Instances", obj_appstore_btn);
		var b2 = instance_create_layer(184, 232, "Instances", obj_appstore_btn);
		b2.sprite_index = spr_app_google;
		b2.google = true;
	}
}
