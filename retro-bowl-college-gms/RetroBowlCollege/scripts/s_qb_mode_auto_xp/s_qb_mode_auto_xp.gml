function s_qb_mode_auto_xp(_arg0, _arg1, _arg2, _arg3) {
	while (_arg0 + _arg1 + _arg2 + _arg3) {
		switch (irandom(3)) {
			case 0:
				if (_arg0) {
					btn_click_AddSkill();
					return;
				}
				break;
			case 1:
				if (_arg1) {
					btn_click_AddSpeed();
					return;
				}
				break;
			case 2:
				if (_arg2) {
					btn_click_AddStrength();
					return;
				}
				break;
			case 3:
				if (_arg3) {
					btn_click_AddStamina();
					return;
				}
				break;
		}
	}
}

