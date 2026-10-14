var bx = x;
var by = y;
var b_end = false;
switch (bound_type) {
	case 0:
		bx -= 2;
		break;
	case 1:
		bx += 2;
		break;
	case 2:
		by -= 2;
		break;
	case 3:
		by += 2;
		break;
}
do {
	var cone = spr_cone_noout;
	draw_sprite_ext(cone, 0, bx, by, 2, 2, 0, 16777215, 1);
	switch (bound_type) {
		case 0:
		case 1:
			by += gap;
			b_end = by > y + bound_len;
			break;
		case 2:
		case 3:
			bx += gap;
			b_end = bx > x + bound_len;
			break;
	}
} until (!!b_end);
