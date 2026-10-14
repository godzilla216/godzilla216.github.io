function s_create_news_dyn_message(_arg0) {
	var bx = display_get_gui_width() - 157;
	var ond = instance_create_layer(0, 0, "PopUps", obj_news_dyn);
	var btn_1 = instance_create_layer(bx, 215, "PopUps", obj_button);
	ond.msg_type = ds_map_find_value(_arg0, "typ");
	ond.text = string_hash_to_newline(ds_map_find_value(_arg0, "txt"));
	var _pmap = ds_map_create();
	ds_map_set(_pmap, "teamid", real(ds_map_find_value(_arg0, "pmap_teamid")));
	ds_map_set(_pmap, "position", real(ds_map_find_value(_arg0, "pmap_position")));
	ds_map_set(_pmap, "skin", real(ds_map_find_value(_arg0, "pmap_skin")));
	ds_map_set(_pmap, "face_x", real(ds_map_find_value(_arg0, "pmap_face_x")));
	ds_map_set(_pmap, "face_y", real(ds_map_find_value(_arg0, "pmap_face_y")));
	ond.pmap = _pmap;
	btn_1.text = s_str("ui_Continue");
	btn_1.onClickAction = s_news_clear;
	btn_1.depth = ond.depth - 1;
}

