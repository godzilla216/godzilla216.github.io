function s_update_draft_page() {
	with (obj_player_profile) {
		instance_destroy();
	}
	var rx = 48;
	var ry = 48;
	var first = (obj_master.draft_page - 1) * 10;
	var last = min(first + 10, ds_list_size(obj_master.draftlist));
	var count = 0;
	for (var r = first; r < last; r++) {
		profile[count] = instance_create_layer(rx, ry, "Instances", obj_player_profile);
		rx += 80;
		profile[count].pmap = ds_list_find_value(obj_master.draftlist, r);
		if (count++ == 4) {
			rx = 48;
			ry += 88;
		}
	}
	var pg = s_str("ui_Page") + " " + string(obj_master.draft_page) + "/" + string(page_max);
	if (page_max <= 1) {
		pg = s_str("ui_Page") + " " + string(obj_master.draft_page);
	}
	inst_100064.text = pg;
	inst_100062.visible = true;
	inst_100063.visible = true;
	if (obj_master.draft_page == 1) {
		inst_100062.visible = false;
	}
	if (obj_master.draft_page == page_max) {
		inst_100063.visible = false;
	}
}

