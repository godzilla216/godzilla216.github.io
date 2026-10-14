if (!splash) {
	draw_sprite(sprite_index, im, x, y);
	draw_sprite(sprite_index, im, x2, y2);
	draw_sprite(sprite_index, im, x3, y2);
	draw_sprite(sprite_index, im, x4, y3);
	draw_sprite(sprite_index, im, x5, y3);
} else {
	draw_sprite(sprite_index, image_index, x, y);
	draw_sprite(sprite_index, image_index, x2, y2);
	draw_sprite(sprite_index, image_index, x3, y2);
	draw_sprite(sprite_index, image_index, x4, y3);
	draw_sprite(sprite_index, image_index, x5, y3);
}
