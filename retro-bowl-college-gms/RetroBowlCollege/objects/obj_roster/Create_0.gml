s_tag_backups();
obj_master.roster = s_sort_players(obj_master.roster, 4);
if (obj_master.qb_mode) {
	inst_100493.visible = false;
	s_qb_mode_update_resting();
}
var gap = 4;
var buf = 10;
var size = ds_list_size(obj_master.roster);
var max_roster = s_get_roster_cap();
var cards_per_row = max_roster / 2;
if (size <= 10) {
	cards_per_row = 5;
	gap = 8;
	buf = 0;
}
if (size <= 8) {
	cards_per_row = 4;
}
if (size <= 6) {
	cards_per_row = 3;
}
var px = round(room_width * 0.5);
var py = round(room_height * 0.49);
var pw = sprite_get_width(spr_box_64x80) + gap;
if (size > cards_per_row) {
	py -= 44;
	px -= (cards_per_row - 1) * pw * 0.5;
	px += buf;
} else {
	px -= (size - 1) * (pw * 0.5);
	px += buf;
}
var uniform = instance_create_layer(0, 0, "Instances", obj_uniform);
uniform.visible = false;
s_load_uniform_file2(obj_master.myteam_id, uniform, 0, "");
for (var r = 0; r < size; r++) {
	roster_profile[r] = instance_create_layer(0, 0, "Instances", obj_player_profile);
	roster_profile[r].pmap = ds_list_find_value(obj_master.roster, r);
	roster_profile[r].onHoldAction = btn_click_Profile_Cut;
	with (roster_profile[r]) {
		s_set_up_uniform_profile(uniform);
	}
	roster_profile[r].x = px - pw * 0.5;
	roster_profile[r].y = py - roster_profile[0].sprite_height * 0.5;
	px += pw;
	if (r == cards_per_row - 1) {
		var sz = size - cards_per_row;
		px = room_width * 0.5;
		px -= (sz - 1) * (pw * 0.5);
		px += buf;
		py += 88;
	}
}
inst_100491.image = spr_home;
with (obj_master) {
	var limit = s_get_roster_cap();
	if (limit == 12) {
		inst_100496.info_msg = "info_StarPlayers12";
	}
	inst_100501.text = s_str("ui_Players") + " " + string(size) + " / " + string(limit);
	if (roster_from_store) {
		inst_100491.image = spr_arrowL;
	} else if (ds_list_size(draftlist) > 0) {
		inst_100491.image = spr_arrowL;
	} else if (ds_list_size(freeagentlist) > 0) {
		inst_100491.image = spr_arrowL;
	} else if (ds_list_size(tradelist) > 0) {
		inst_100491.image = spr_arrowL;
	}
}
if (global.exhibition) {
	rm_roster_exhibition_create();
}
s_check_intro_rm_roster();
s_check_intro();
