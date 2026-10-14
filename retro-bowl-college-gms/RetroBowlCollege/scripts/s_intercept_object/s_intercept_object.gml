function s_intercept_object(_arg0) {
	var dist = point_distance(x, y, _arg0.x, _arg0.y);
	var timefactor = dist * 0.5;
	if (abs(y - _arg0.y) < 40) {
		timefactor *= 0.5;
	}
	des_x = _arg0.x + lengthdir_x(_arg0.speed * timefactor, _arg0.direction);
	des_y = _arg0.y + lengthdir_y(_arg0.speed * timefactor, _arg0.direction);
	if (y < _arg0.y) {
		des_y -= 2;
	} else {
		des_y += 2;
	}
	jdir = point_direction(x, y, des_x, des_y);
	jforce = 1;
}

