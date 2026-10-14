function s_lines_intersect(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7) {
	var Ax = _arg0;
	var Ay = _arg1;
	var Bx = _arg2;
	var By = _arg3;
	var Cx = _arg4;
	var Cy = _arg5;
	var Dx = _arg6;
	var Dy = _arg7;
	var ipoint = instance_create_layer(0, 0, "Players", obj_intercept_point);
	var Rn = (Ay - Cy) * (Dx - Cx) - (Ax - Cx) * (Dy - Cy);
	var Rd = (Bx - Ax) * (Dy - Cy) - (By - Ay) * (Dx - Cx);
	if (Rd == 0) {
		ipoint.intercept = false;
	} else {
		ipoint.intercept = true;
		var Sn = (Ay - Cy) * (Bx - Ax) - (Ax - Cx) * (By - Ay);
		ipoint.intercept_AB = Rn / Rd;
		ipoint.intercept_CD = Sn / Rd;
		ipoint.px = Ax + ipoint.intercept_AB * (Bx - Ax);
		ipoint.py = Ay + ipoint.intercept_AB * (By - Ay);
		if (ipoint.intercept_AB > 1) {
			ipoint.intercept = false;
		}
		if (ipoint.intercept_AB < 0) {
			ipoint.intercept = false;
		}
		if (ipoint.intercept_CD > 1) {
			ipoint.intercept = false;
		}
		if (ipoint.intercept_CD < 0) {
			ipoint.intercept = false;
		}
	}
	return ipoint;
}

