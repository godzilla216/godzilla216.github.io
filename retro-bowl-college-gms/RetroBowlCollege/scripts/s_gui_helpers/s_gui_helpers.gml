function s_create_label(_arg0, _arg1, _arg2, _arg3) {
	if (_arg3 == undefined) {
		_arg3 = 1;
	}
	var label = instance_create_layer(_arg0, _arg1, "Instances", obj_text);
	label.text = _arg2;
	label.draw_box = false;
	label.halign = _arg3;
	return label;
}

function s_is_new_shadow() {
	return 1;
}

