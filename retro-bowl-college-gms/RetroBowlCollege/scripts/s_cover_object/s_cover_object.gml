function s_cover_object(_arg0, _arg1) {
	var target = _arg0;
	var range = 180 * _arg1;
	if (target.facing == -1) {
		jdir = point_direction(x, y, target.x - range, target.y);
	} else {
		jdir = point_direction(x, y, target.x + range, target.y);
	}
}

