if (obj_master.stage != 7) {
	exit;
}
with (obj_msgbg) {
	if (depth < other.depth) {
		stage_time = current_time;
	}
}
if (current_time < stage_time + (stage + 1) * 1000) {
	exit;
}
switch (stage) {
	case 0:
		var done = true;
		for (var i = 1; i < ds_list_size(l_condition); i++) {
			var pmap = ds_list_find_value(obj_master.roster, i - 1);
			ds_list_set(l_condition, i, clamp(ds_list_find_value(l_condition, i) + 1, 1, ds_map_find_value(pmap, "condition")));
			if (ds_list_find_value(l_condition, i) < ds_map_find_value(pmap, "condition")) {
				done = false;
			}
		}
		for (var i = 1; i < ds_list_size(l_gpa); i++) {
			var pmap = ds_list_find_value(obj_master.roster, i - 1);
			ds_list_set(l_gpa, i, lerp(ds_list_find_value(l_gpa, i), ds_map_find_value(pmap, "percent_grade"), 0.1));
			if (ds_list_find_value(l_gpa, i) != ds_map_find_value(pmap, "percent_grade")) {
				done = false;
			}
		}
		if (done) {
			stage++;
		}
		break;
	case 1:
		inst_100621.visible = true;
		stage++;
		break;
}
