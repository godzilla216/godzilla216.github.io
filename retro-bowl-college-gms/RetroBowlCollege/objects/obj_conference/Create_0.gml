if (s_is_co_mode()) {
	exit;
}
if (conference == -1) {
	conference = obj_master.myconference;
}
wildcards = 2;
playoff12 = s_playoffs_12();
if (!playoff12) {
	wildcards = 3;
}
text = s_get_string_conference(conference);
seedlist = ds_list_create();
list_w = ds_list_create();
list_l = ds_list_create();
list_t = ds_list_create();
for (var i = 1; i < 17; i++) {
	var team = s_get_team_by_seed(conference, i);
	var txt = string_upper(s_get_team_name_by_id(ds_map_find_value(team, "uid")));
	if (ds_map_find_value(team, "uid") == obj_master.myteam_id) {
		txt = "yel_" + txt;
	}
	ds_list_add(seedlist, txt);
	ds_list_add(list_w, string(ds_map_find_value(team, "wins")));
	ds_list_add(list_l, string(ds_map_find_value(team, "losses")));
	ds_list_add(list_t, string(ds_map_find_value(team, "ties")));
}
slog("obj_conference.created");
