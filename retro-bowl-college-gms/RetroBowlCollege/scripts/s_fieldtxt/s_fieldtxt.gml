function s_fieldtxt(_arg0) {
	with (obj_fieldtxt) {
		if (img) {
			return;
		} else {
			instance_destroy();
		}
	}
	var ft = instance_create_layer(x, y - 48, "Text", obj_fieldtxt);
	ft.depth = -10000;
	ft.txt = _arg0;
}

function s_fieldtxt_yards(_arg0) {
	var yds = round(_arg0);
	if (yds == 0) {
		return;
	}
	with (obj_fieldtxt) {
		if (string_count(s_str("match_Recovered"), txt) > 0) {
			return;
		}
		if (!img) {
			instance_destroy();
		}
	}
	var ft = instance_create_layer(x, y - 32, "Text", obj_fieldtxt);
	ft.depth = -10000;
	ft.txt = string(yds) + s_str("sla_yards");
}

function s_fieldimg(_arg0, _arg1, _arg2) {
	var ft = instance_create_layer(x, y - 48, "Text", obj_fieldtxt);
	ft.depth = -10000;
	ft.img = _arg0;
	ft.subimg = _arg1;
	ft.imgscl = _arg2;
}

