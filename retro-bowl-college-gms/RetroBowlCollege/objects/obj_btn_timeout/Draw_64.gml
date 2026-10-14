draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
draw_set_valign(1);
draw_sprite_ext(sprite_index, num_tos - 1, x, y, 1, 1, 0, 16777215, 1);
draw_hd_text(x + 48, y + 6, txt);
