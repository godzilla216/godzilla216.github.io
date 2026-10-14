function s_notification(_arg0, _arg1) {
	slog(">>> s_notification: " + _arg0);
	slog(_arg1);
	var title = _arg0;
	var text = _arg1;
	if (window_get_cursor() == -1) {
		return;
	}
	var ntf = instance_create_layer(0, 0, "PopUps", obj_notification);
	ntf.depth = -100;
	ntf.title = title;
	ntf.text = text;
	ntf.text_col = 16777215;
	ntf.colour = make_color_rgb(79, 143, 35);
	if (s_is_co_mode()) {
		ntf.colour = make_color_rgb(210, 210, 10);
		ntf.text_shadow = true;
	}
	if (ds_list_size(obj_master.list_notifications) > 0) {
		ntf.visible = false;
	}
	ds_list_add(obj_master.list_notifications, ntf);
	slog("Notification count = " + string(ds_list_size(obj_master.list_notifications)));
}

