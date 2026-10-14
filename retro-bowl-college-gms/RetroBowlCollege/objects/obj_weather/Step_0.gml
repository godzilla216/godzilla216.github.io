switch (type) {
	case 1:
		repeat (rain_rate) {
			instance_create_layer(irandom(g_pBuiltIn.room_width), 0, "Weather", obj_raindrop);
		}
		break;
	case 2:
		var cw = camera_get_view_width(g_pBuiltIn.view_camera[0]);
		var cx = camera_get_view_x(g_pBuiltIn.view_camera[0]);
		var sx = cx + irandom(cw);
		if (!irandom(2)) {
			instance_create_layer(sx, 0, "Weather", obj_snowflake);
		}
		break;
}
