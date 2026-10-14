if (hidden) {
	exit;
}
if (obj_controller.state == 2 && (state == 0 || state == 1) && !obj_controller.kicking) {
	switch (obj_controller.drivedir) {
		case -1:
			draw_sprite_ext(sprite_index, image_index, x + 4, y - height, 2, 2, rotation, 16777215, 1);
			break;
		case 1:
			draw_sprite_ext(sprite_index, image_index, x - 4, y - height, 2, 2, rotation, 16777215, 1);
			break;
	}
} else {
	if (obj_controller.state == 2 && state == 3) {
		var a = min(height * 0.005, 0.09);
		for (var i = 0; i < 20; i++) {
			draw_sprite_ext(spr_blur, image_index, l_blur[i][0], l_blur[i][1], 2, 2, rotation, 16777215, a);
			a *= 0.9;
		}
	}
	draw_sprite_ext(sprite_index, image_index, x, y - height, 2, 2, rotation, 16777215, 1);
}
