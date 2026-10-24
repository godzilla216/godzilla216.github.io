draw_set_color(c_sky);
draw_rectangle(-1, -1, room_width + 1, room_height + 1, 0);
draw_set_color(16777215);
gpu_set_blendmode(1);
draw_ellipse_colour(-400, 0, room_width + 400, room_height + 450, global.c_background, 0, 0);
gpu_set_blendmode(0);
