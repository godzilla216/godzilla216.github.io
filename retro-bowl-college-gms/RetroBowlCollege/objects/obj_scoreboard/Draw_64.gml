draw_self();
var gx = x;
var gy = y;
draw_set_font(global.fnt_flex);
draw_set_halign(0);
draw_set_alpha(1);
draw_hd_text_color(gx + 8, gy + 14, teamnames[0], col1, col1, col1, col1, 1);
draw_hd_text_color(gx + 8, gy + 57, teamnames[1], col2, col2, col2, col2, 1);
draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
var sx = gx + 78;
var sy = gy + 14;
var sy2 = gy + 57;
var gap = 25;
draw_hd_text_color(sx, sy, scores1[0], col1, col1, col1, col1, 1);
draw_hd_text_color(sx, sy2, scores2[0], col2, col2, col2, col2, 1);
sx += gap;
draw_hd_text_color(sx, sy, scores1[1], col1, col1, col1, col1, 1);
draw_hd_text_color(sx, sy2, scores2[1], col2, col2, col2, col2, 1);
sx += gap;
draw_hd_text_color(sx, sy, scores1[2], col1, col1, col1, col1, 1);
draw_hd_text_color(sx, sy2, scores2[2], col2, col2, col2, col2, 1);
sx += gap;
draw_hd_text_color(sx, sy, scores1[3], col1, col1, col1, col1, 1);
draw_hd_text_color(sx, sy2, scores2[3], col2, col2, col2, col2, 1);
sx += gap;
draw_set_font(global.fnt_flex);
draw_hd_text_color(sx + 7, sy, scores1[4], col1, col1, col1, col1, 1);
draw_hd_text_color(sx + 7, sy2, scores2[4], col2, col2, col2, col2, 1);
var sx1 = gx + 9;
var sx2 = sx1 + 2;
switch (ratings1[0]) {
	case 1:
		sx2 += 6;
		break;
	case 2:
		sx2 += 9;
		break;
	case 3:
		sx2 += 15;
		break;
	case 4:
		sx2 += 18;
		break;
	case 5:
		sx2 += 24;
		break;
	case 6:
		sx2 += 27;
		break;
	case 7:
		sx2 += 30;
		break;
	case 8:
		sx2 += 36;
		break;
	case 9:
		sx2 += 39;
		break;
	case 10:
		sx2 += 45;
		break;
}
draw_sprite_ext(spr_star_rating_b, ratings1[0], sx1, gy + 35, 1, 1, 0, global.c_offense, 1);
draw_sprite_ext(spr_star_rating_b, ratings1[1], sx2, gy + 35, 1, 1, 0, global.c_defense, 1);
sx2 = sx1 + 2;
switch (ratings2[0]) {
	case 1:
		sx2 += 6;
		break;
	case 2:
		sx2 += 9;
		break;
	case 3:
		sx2 += 15;
		break;
	case 4:
		sx2 += 18;
		break;
	case 5:
		sx2 += 24;
		break;
	case 6:
		sx2 += 27;
		break;
	case 7:
		sx2 += 30;
		break;
	case 8:
		sx2 += 36;
		break;
	case 9:
		sx2 += 39;
		break;
	case 10:
		sx2 += 45;
		break;
}
draw_sprite_ext(spr_star_rating_b, ratings2[0], sx1, gy + 78, 1, 1, 0, global.c_offense, 1);
draw_sprite_ext(spr_star_rating_b, ratings2[1], sx2, gy + 78, 1, 1, 0, global.c_defense, 1);
