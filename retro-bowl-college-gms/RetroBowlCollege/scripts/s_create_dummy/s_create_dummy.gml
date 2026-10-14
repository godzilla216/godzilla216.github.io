function s_create_dummy(_arg0, _arg1, _arg2, _arg3, _arg4) {
	var dummy = instance_create_layer(0, 0, "Players", obj_dummy);
	dummy.x = _arg0;
	dummy.y = _arg1;
	dummy.start_x = _arg0;
	dummy.start_y = _arg1;
	dummy.move_speed = _arg2;
	dummy.range_x = _arg3;
	dummy.range_y = _arg4;
	dummy.edge_pause = 250 + irandom(1250);
}

