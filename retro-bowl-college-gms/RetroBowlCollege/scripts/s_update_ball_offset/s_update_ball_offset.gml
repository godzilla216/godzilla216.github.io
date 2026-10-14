function s_update_ball_offset() {
	var offsetx = 0;
	var offsety = 0;
	roll = 0;
	rotation = 0;
	if (s_is_kickoff(false)) {
		offsetx = 11;
		offsety = 1;
		height = 1;
		rotation = 90;
		return;
	}
	if (obj_controller.kicking && holder.position == 1) {
		offsetx = 11;
		offsety = 1;
		height = 1;
		rotation = 90;
	} else {
		switch (holder.anim) {
			case 0:
				offsetx = 1;
				offsety = 2;
				height = 7 * holder.image_yscale;
				break;
			case 6:
			case 1:
				offsetx = 3;
				offsety = -2;
				height = 0;
				break;
			case 7:
			case 2:
				offsetx = 1 + holder.image_index / 2;
				offsety = 2;
				height = 10 * holder.image_yscale;
				break;
			case 3:
				offsetx = 4;
				offsety = -2;
				height = 8 * holder.image_yscale;
				break;
			case 4:
				if (holder.image_index < 1) {
					offsetx = 2;
					offsety = -2;
					height = 9 * holder.image_yscale;
				} else {
					offsetx = 0;
					offsety = -2;
					height = 9 * holder.image_yscale;
					if (holder.speed < 1) {
						height = 0;
					}
				}
				break;
			case 5:
				offsetx = 9;
				offsety = -2;
				height = 0;
				if (holder.image_index < 2) {
					offsety = -3;
					height = 4;
				}
				break;
			case 8:
				offsetx = 1 + holder.image_index / 2;
				offsety = 2;
				height = 10 * holder.image_yscale;
				switch (holder.image_index) {
					case 0:
						height -= 1;
						break;
					case 1:
						height -= 2;
						break;
					case 2:
						height -= 1;
						break;
				}
				break;
			case 9:
				offsetx = 1;
				offsety = 2;
				height = 10 * holder.image_yscale;
				break;
			case 10:
				offsetx = 1;
				offsety = 0;
				switch (holder.image_index) {
					case 0:
						height = 36;
						break;
					case 1:
						height = 38;
						break;
					case 2:
						height = 40;
						break;
					case 4:
						height = 38;
						break;
					case 5:
						height = 36;
						break;
				}
				break;
			case 18:
				offsetx = 9;
				offsety = -2;
				height = 0;
				break;
			case 19:
				offsetx = 1;
				offsety = 2;
				height = 0;
				break;
		}
	}
	offsetx *= holder.image_xscale;
	offsety *= holder.image_yscale;
	var dist = distance_to_point(holder.x, holder.y);
	if (dist < 3 && s_sprite_holding_ball(holder.sprite_index)) {
		x = holder.x + offsetx;
		y = holder.y + offsety;
	} else {
		x = lerp(x, holder.x + offsetx, 0.2);
		y = lerp(y, holder.y + offsety, 0.2);
	}
}

