function s_get_string_division(_arg0, _arg1) {
	var _conf = _arg0;
	var _div = _arg1;
	switch (_conf) {
		case 0:
			switch (_div) {
				case 0:
					return obj_master.name_div1;
					break;
				case 1:
					return obj_master.name_div2;
					break;
				case 2:
					return obj_master.name_div3;
					break;
				case 3:
					return obj_master.name_div4;
					break;
			}
			break;
		case 1:
			switch (_div) {
				case 0:
					return obj_master.name_div1b;
					break;
				case 1:
					return obj_master.name_div2b;
					break;
				case 2:
					return obj_master.name_div3b;
					break;
				case 3:
					return obj_master.name_div4b;
					break;
			}
			break;
	}
}

