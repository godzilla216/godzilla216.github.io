event_inherited();
draw_arc = false;
draw_bounce = false;
plot_x = array_create(50, 0);
plot_y = array_create(50, 0);
plot_z = array_create(50, 0);
bounce_x = 0;
bounce_y = 0;
jump_x = 0;
jump_y = 0;
plot_len = 10;
zvel_limit = 0;
gap = 2;
if (global.master_ball.holder && global.master_ball.holder.pmap) {
	var skl = s_get_attribute(global.master_ball.holder.pmap, "skill");
	plot_len = 10 + skl;
	zvel_limit = -skl * 0.15;
} else if (global.exhibition && global.master_ball.holder) {
	var skl = global.master_ball.holder.skill;
	plot_len = 10 + skl;
	zvel_limit = -skl * 0.15;
}
layer_sprite_destroy(my_shadow);
