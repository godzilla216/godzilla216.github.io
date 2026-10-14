function s_create_boundary(_arg0, _arg1, _arg2, _arg3) {
	var typ = _arg0;
	var bx = _arg1;
	var by = _arg2;
	var len = _arg3;
	var b = instance_create_layer(bx, by, "Shadows", obj_boundary);
	b.bound_type = typ;
	b.bound_len = len;
}

