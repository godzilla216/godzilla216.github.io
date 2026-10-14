function s_get_string_record(_arg0, _arg1) {
	var tmap = _arg0;
	var always_include_ties = _arg1;
	var txt = string(ds_map_find_value(tmap, "wins"));
	txt += "-" + string(ds_map_find_value(tmap, "losses"));
	if (!s_is_co_mode() && (ds_map_find_value(tmap, "ties") > 0 || always_include_ties)) {
		txt += "-" + string(ds_map_find_value(tmap, "ties"));
	}
	return txt;
}

function s_get_string_record_co_extended(_arg0) {
	var txt = "";
	if (ds_map_find_value(_arg0, "conference") != 7) {
		txt += string_upper(s_str("tla_Conference")) + " ";
		txt += string(ds_map_find_value(_arg0, "wins_cnf")) + "-" + string(ds_map_find_value(_arg0, "losses_cnf")) + "   ";
	}
	txt += string_upper(s_str("tla_Overall")) + " ";
	txt += string(ds_map_find_value(_arg0, "wins")) + "-" + string(ds_map_find_value(_arg0, "losses"));
	return txt;
}

function s_get_string_conf_tag(_arg0, _arg1) {
	var otherFBSrank = s_subdivision_get_team_ranking(1, ds_map_find_value(_arg1, "uid"));
	var otherFCSrank = s_subdivision_get_team_ranking(2, ds_map_find_value(_arg1, "uid"));
	var otherIsFBS = otherFBSrank != -1;
	var otherIsFCS = otherFCSrank != -1;
	var FBSrank = s_subdivision_get_team_ranking(1, ds_map_find_value(_arg0, "uid"));
	var FCSrank = s_subdivision_get_team_ranking(2, ds_map_find_value(_arg0, "uid"));
	var rank = -1;
	var bothTeamsSame = false;
	if (FBSrank != -1) {
		rank = FBSrank;
		bothTeamsSame = otherIsFBS;
	}
	if (FCSrank != -1) {
		rank = FCSrank;
		bothTeamsSame = otherIsFCS;
	}
	if (rank != -1 && rank <= 24 && bothTeamsSame) {
		return "#" + string(rank + 1) + " ";
	}
	return "";
}

