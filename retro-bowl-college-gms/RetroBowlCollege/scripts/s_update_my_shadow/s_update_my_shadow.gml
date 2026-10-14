function s_update_my_shadow() {
	layer_sprite_change(my_shadow, sprite_index);
	layer_sprite_index(my_shadow, image_index);
	layer_sprite_xscale(my_shadow, image_xscale);
	layer_sprite_x(my_shadow, x);
	layer_sprite_y(my_shadow, y);
}

