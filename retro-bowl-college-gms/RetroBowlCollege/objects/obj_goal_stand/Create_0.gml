if (s_is_co_mode()) {
	sprite_index = spr_goal_stand_co;
}
my_shadow = layer_sprite_create(layer_get_id("Shadows"), x, y, spr_goal_shadow);
layer_sprite_blend(my_shadow, 0);
layer_sprite_alpha(my_shadow, 0.2);
layer_sprite_angle(my_shadow, 0);
layer_sprite_xscale(my_shadow, 2);
layer_sprite_yscale(my_shadow, 2);
image_xscale = 2;
image_yscale = 2;
if (x > 1300) {
	image_xscale = -2;
	layer_sprite_xscale(my_shadow, -2);
}
if (obj_master.week == s_get_week_superbowl()) {
	image_index = 1;
}
