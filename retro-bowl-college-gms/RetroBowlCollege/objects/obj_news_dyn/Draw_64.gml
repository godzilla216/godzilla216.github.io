draw_sprite_ext(spr_msg_bg, 0, 0, 0, image_xscale, image_yscale, 0, bg_colour, bg_alpha);
switch (msg_type) {
	case "web":
		draw_sprite(spr_bg_news, 0, 0, 0);
		break;
}
draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
draw_set_valign(1);
draw_set_color(16777215);
var sep = -1;
if (string_hd_height_ext(text, sep, msg_width) > 80) {
	sep = 12;
}
draw_hd_text_ext(270, 160, text, sep, msg_width);
s_draw_player_image(36, 132, pmap, 2);
