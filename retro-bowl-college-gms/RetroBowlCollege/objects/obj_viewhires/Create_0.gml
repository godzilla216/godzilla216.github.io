draw_set_font(global.fnt_small_flex);
draw_set_halign(0);
draw_set_valign(1);
var uniform = instance_create_layer(0, 0, "Instances", obj_uniform);
uniform.visible = false;
s_load_uniform_file2(obj_master.myteam_id, uniform, 0, "");
inst_100590.pmap = s_get_staff(102);
with (inst_100590) {
	s_set_up_uniform_profile(uniform);
}
inst_100591.pmap = s_get_staff(101);
with (inst_100591) {
	s_set_up_uniform_profile(uniform);
}
s_create_hirelist(false, false);
with (obj_master) {
	inst_100583.pmap = ds_list_find_value(hirelist, 0);
	inst_100584.pmap = ds_list_find_value(hirelist, 1);
	inst_100585.pmap = ds_list_find_value(hirelist, 2);
	inst_100586.pmap = ds_list_find_value(hirelist, 3);
	inst_100592.pmap = ds_list_find_value(hirelist, 4);
	inst_100593.pmap = ds_list_find_value(hirelist, 5);
	inst_100594.pmap = ds_list_find_value(hirelist, 6);
	inst_100595.pmap = ds_list_find_value(hirelist, 7);
}
