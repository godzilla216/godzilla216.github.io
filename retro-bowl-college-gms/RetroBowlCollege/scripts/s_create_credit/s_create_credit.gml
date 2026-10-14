function s_create_credit(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7) {
	var crd = instance_create_layer(0, 0, "Instances", obj_credit);
	crd.x = _arg0;
	crd.y = _arg1;
	crd.des_x = _arg2;
	crd.des_y = _arg3;
	crd.value = _arg4;
	crd.type = _arg5;
	crd.pmap = _arg6;
	switch (crd.type) {
		case 1:
			crd.sprite_index = spr_credit;
			break;
		case 2:
			crd.sprite_index = spr_star;
			break;
	}
	if (crd.value > 1) {
		crd.des_scale *= 2;
	}
	if (_arg7) {
		s_sound(snd_purchase);
	}
}

