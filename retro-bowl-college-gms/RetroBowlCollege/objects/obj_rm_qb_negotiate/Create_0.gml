inst_100743.visible = false;
inst_100747.visible = false;
with (obj_master) {
	var list_numbers = ds_list_create();
	for (var i = 0; i < 11; i++) {
		ds_list_add(list_numbers, i + 1);
	}
	var sz = clamp(2, 7, 1 + qb_new_offer._salary_neg + qb_new_offer._tdbonus_neg + qb_new_offer._length_neg);
	for (var i = -1; i < sz - 1; i++) {
		ds_list_shuffle(list_numbers);
		var ob = instance_create_layer(240 + 78 * i, 180, "Instances", obj_negotiate_num);
		ob.number = ds_list_find_value(list_numbers, 1);
		ob.position = i;
		ds_list_delete(list_numbers, 1);
	}
}
s_check_hilo_buttons();
