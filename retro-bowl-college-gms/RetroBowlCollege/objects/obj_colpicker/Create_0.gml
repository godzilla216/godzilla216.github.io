surf = surface_create(480, 270);
surface_set_target(surf);
draw_clear_alpha(16777215, 0.5);
draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, 16777215, 1);
surface_reset_target();
view_surface_id[0] = surf;
gp_x = 240;
gp_y = 135;
gp_mp = 2;
