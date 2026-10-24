if (obj_master.rm_winners_do_awards == 1) {
	s_do_player_awards();
}
inst_100608.onClickAction = btn_click_Home;
if (variable_struct_exists(global.rm_params, "click_continue")) {
	inst_100608.onClickAction = global.rm_params.click_continue;
}
has_fireworks = true;
firework_rate = 30;
alarm[0] = 1;
c_sky = make_color_rgb(0, 40, 180);
var bowlnum = obj_master.start_year + obj_master.year - 1966;
inst_100607.text = s_str("ui_SuperBowl") + " " + s_roman_numerals(bowlnum);
inst_100609.text = ds_map_find_value(obj_master.myteam, "name") + " are " + s_str("ui_Champions") + "!";
inst_100612.text = ds_map_find_value(obj_master.myteam, "name");
inst_100612.visible = false;
if (obj_master.rm_winners_cid != -1) {
	var comp = s_get_competition(obj_master.rm_winners_cid);
	inst_100607.text = "" + comp.name;
}
if (obj_master.rm_winners_custom != "") {
	inst_100607.text = "" + obj_master.rm_winners_custom;
}
if (obj_master.rm_winners_tier == "v_gold") {
	has_fireworks = true;
	firework_rate = 30;
	c_sky = make_color_rgb(180, 167, 0);
} else if (obj_master.rm_winners_tier == "v_silver") {
	has_fireworks = true;
	firework_rate = 100;
	c_sky = make_color_rgb(156, 156, 156);
} else if (obj_master.rm_winners_tier == "v_bronze") {
	has_fireworks = false;
	firework_rate = 0;
	c_sky = make_color_rgb(145, 116, 72);
}
inst_100610.text = s_str("ui_HeadCoach");
inst_100613.text = s_str("short_STAFF_DF");
inst_100614.text = s_str("short_STAFF_OF");
obj_master.roster = s_sort_players(obj_master.roster, 4);
var size = ds_list_size(obj_master.roster);
var px = round(room_width * 0.5);
var py = 138;
var pw = sprite_get_width(spr_light_001);
if (size > 5) {
	py -= 44;
	px -= 4 * (pw * 1);
} else {
	px -= (size - 1) * (pw * 1);
}
var uniform = instance_create_layer(0, 0, "Instances", obj_uniform);
uniform.visible = false;
s_load_uniform_file2(obj_master.myteam_id, uniform, 0, "");
var dpth = 10;
for (var r = 0; r < size; r++) {
	roster_profile[r] = instance_create_layer(0, 0, "Instances", obj_player_image);
	roster_profile[r].pmap = ds_list_find_value(obj_master.roster, r);
	with (roster_profile[r]) {
		s_set_up_uniform_profile(uniform);
	}
	roster_profile[r].x = px;
	roster_profile[r].y = py - roster_profile[0].sprite_height * 0.5;
	roster_profile[r].depth = dpth;
	px += pw * 2;
	if (r == 4) {
		var sz = size - 5;
		px = room_width * 0.5;
		px -= (sz - 1) * (pw * 1);
		py += 64;
		dpth -= 1;
	}
}
boss = instance_create_layer(0, 0, "Instances", obj_player_image);
boss.pmap = s_get_staff(100);
with (boss) {
	s_set_up_uniform_profile(uniform);
}
of = instance_create_layer(0, 0, "Instances", obj_player_image);
of.pmap = s_get_staff(102);
with (of) {
	s_set_up_uniform_profile(uniform);
}
df = instance_create_layer(0, 0, "Instances", obj_player_image);
df.pmap = s_get_staff(101);
with (df) {
	s_set_up_uniform_profile(uniform);
}
boss.x = inst_100610.x;
boss.y = 202;
boss.depth = dpth;
of.x = inst_100614.x;
of.y = 202;
of.depth = dpth;
df.x = inst_100613.x;
df.y = 202;
df.depth = dpth;
