function s_set_up_uniforms_training() {
	var teamid_away = s_get_random_team_id();
	var teamid_home = obj_master.myteam_id;
	obj_master.team[0] = ds_list_find_value(obj_master.teamlist, teamid_away);
	obj_master.team[1] = ds_list_find_value(obj_master.teamlist, teamid_home);
	obj_master.playerteamindex = 1;
	var str_helmet1 = ds_map_find_value(obj_master.team[0], "colhelmet");
	var str_shirt1 = ds_map_find_value(obj_master.team[0], "colshirt");
	var str_pants1 = ds_map_find_value(obj_master.team[0], "colpants");
	var str_helmet2 = ds_map_find_value(obj_master.team[1], "colhelmet");
	var str_shirt2 = ds_map_find_value(obj_master.team[1], "colshirt");
	var str_pants2 = ds_map_find_value(obj_master.team[1], "colpants");
	if (str_helmet1 == str_helmet2) {
		str_helmet1 = str_shirt1;
	}
	if (str_shirt1 == str_shirt2) {
		str_shirt1 = str_pants1;
	}
	if (str_pants1 == str_pants2) {
		str_pants1 = str_helmet1;
	}
	var colhelmet = s_hex_string_to_col(str_helmet2);
	var colshirt = s_hex_string_to_col(str_shirt2);
	var colpants = s_hex_string_to_col(str_pants2);
	obj_master.col_helmet_home[0] = colour_get_blue(colhelmet) / 256;
	obj_master.col_helmet_home[1] = colour_get_green(colhelmet) / 256;
	obj_master.col_helmet_home[2] = colour_get_red(colhelmet) / 256;
	obj_master.col_shirt_home[0] = colour_get_blue(colshirt) / 256;
	obj_master.col_shirt_home[1] = colour_get_green(colshirt) / 256;
	obj_master.col_shirt_home[2] = colour_get_red(colshirt) / 256;
	obj_master.col_sleeve_home[0] = colour_get_blue(colshirt) / 300;
	obj_master.col_sleeve_home[1] = colour_get_green(colshirt) / 300;
	obj_master.col_sleeve_home[2] = colour_get_red(colshirt) / 300;
	obj_master.col_pants_home[0] = colour_get_blue(colpants) / 256;
	obj_master.col_pants_home[1] = colour_get_green(colpants) / 256;
	obj_master.col_pants_home[2] = colour_get_red(colpants) / 256;
	obj_master.col_pants_home_b[0] = colour_get_blue(colpants) / 300;
	obj_master.col_pants_home_b[1] = colour_get_green(colpants) / 300;
	obj_master.col_pants_home_b[2] = colour_get_red(colpants) / 300;
	colhelmet = s_hex_string_to_col(str_helmet1);
	colshirt = s_hex_string_to_col(str_shirt1);
	colpants = s_hex_string_to_col(str_pants1);
	obj_master.col_helmet_away[0] = colour_get_blue(colhelmet) / 256;
	obj_master.col_helmet_away[1] = colour_get_green(colhelmet) / 256;
	obj_master.col_helmet_away[2] = colour_get_red(colhelmet) / 256;
	obj_master.col_shirt_away[0] = colour_get_blue(colshirt) / 256;
	obj_master.col_shirt_away[1] = colour_get_green(colshirt) / 256;
	obj_master.col_shirt_away[2] = colour_get_red(colshirt) / 256;
	obj_master.col_sleeve_away[0] = colour_get_blue(colshirt) / 300;
	obj_master.col_sleeve_away[1] = colour_get_green(colshirt) / 300;
	obj_master.col_sleeve_away[2] = colour_get_red(colshirt) / 300;
	obj_master.col_pants_away[0] = colour_get_blue(colpants) / 256;
	obj_master.col_pants_away[1] = colour_get_green(colpants) / 256;
	obj_master.col_pants_away[2] = colour_get_red(colpants) / 256;
	obj_master.col_pants_away_b[0] = colour_get_blue(colpants) / 300;
	obj_master.col_pants_away_b[1] = colour_get_green(colpants) / 300;
	obj_master.col_pants_away_b[2] = colour_get_red(colpants) / 300;
}

