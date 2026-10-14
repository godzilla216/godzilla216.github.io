function s_update_shopping_buttons() {
	var item_count = s_count_shop_items_by_type(obj_master.shopping_type);
	var max_pages = ceil(item_count / 6);
	slog("Max pages = " + string(max_pages));
	with (obj_master) {
		shopping_page = clamp(shopping_page, 1, max_pages);
		inst_100700.visible = true;
		inst_100701.visible = true;
		if (shopping_page == 1) {
			inst_100700.visible = false;
		}
		if (shopping_page >= max_pages) {
			inst_100701.visible = false;
		}
		inst_100702.text = "";
		if (max_pages > 1) {
			inst_100702.text = s_str("ui_Page") + " " + string(shopping_page) + "/" + string(max_pages);
		}
	}
	var first_item = (obj_master.shopping_page - 1) * 6;
	var item_num = 0;
	var bx = 32;
	var by = 48;
	for (var i = 0; i < ds_list_size(obj_master.shoppinglist); i++) {
		var map = ds_list_find_value(obj_master.shoppinglist, i);
		slog(ds_map_find_value(map, "name"));
		if (real(ds_map_find_value(map, "type")) == obj_master.shopping_type) {
			if (item_num >= first_item && item_num < first_item + 6) {
				var btn = instance_create_layer(bx, by, "Instances", obj_button_9s);
				btn.onClickAction = btn_shopping_purchase;
				btn.image_xscale = 4;
				btn.image_yscale = 2.5;
				btn.text = ds_map_find_value(map, "name");
				if (real(ds_map_find_value(map, "owned"))) {
					btn.active = false;
					btn.text += "#" + string(round(real(ds_map_find_value(map, "life")))) + "%";
				} else {
					btn.text += "#$" + string(ds_map_find_value(map, "price"));
				}
				btn.text = string_hash_to_newline(btn.text);
				btn.uid = i;
				var bw = btn.image_xscale * 32;
				var bh = btn.image_yscale * 32;
				bx += 16 + bw;
				if (bx >= 480 - bw) {
					bx = 32;
					by += 12 + bh;
				}
			}
			item_num++;
		}
	}
}

function btn_click_shopping_next() {
	obj_master.shopping_page++;
	room_goto(rm_qb_shopping);
}

function btn_click_shopping_prev() {
	obj_master.shopping_page--;
	room_goto(rm_qb_shopping);
}

function btn_shopping_purchase() {
	with (obj_master) {
		shopping_item = other.uid;
		var map = ds_list_find_value(shoppinglist, shopping_item);
		slog(ds_map_find_value(map, "name"));
		if (coach_credit < ds_map_find_value(map, "price")) {
			s_create_message("", s_str("msg_NotEnoughCash"), s_str("ui_Ok"), "", s_msg_clear, "", global.c_background, 1);
		} else {
			var msg = s_str("msg_ConfirmPurchase");
			msg = string_replace(msg, "$price", string(ds_map_find_value(map, "price")));
			msg = string_replace(msg, "$itemname", string(ds_map_find_value(map, "name")));
			s_create_message("", msg, s_str("ui_Yes"), s_str("ui_No"), s_confirm_purchase, s_msg_clear, global.c_background, 1);
		}
	}
}

function s_confirm_purchase() {
	with (obj_master) {
		var map = ds_list_find_value(shoppinglist, shopping_item);
		ds_map_set(map, "owned", 1);
		coach_credit -= ds_map_find_value(map, "price");
		room_goto(rm_qb_shopping);
	}
}

function s_count_shop_items_by_type(_arg0) {
	with (obj_master) {
		var count = 0;
		for (var i = 0; i < ds_list_size(shoppinglist); i++) {
			var map = ds_list_find_value(shoppinglist, i);
			if (real(ds_map_find_value(map, "type")) == _arg0) {
				count++;
			}
		}
		return count;
	}
}

function s_degrade_shop_items() {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(shoppinglist); i++) {
			var map = ds_list_find_value(shoppinglist, i);
			if (real(ds_map_find_value(map, "owned")) == 1) {
				switch (real(ds_map_find_value(map, "type"))) {
					case 0:
						ds_map_set(map, "life", real(ds_map_find_value(map, "life")) - irandom_range(2, 10));
						break;
					case 1:
						ds_map_set(map, "life", real(ds_map_find_value(map, "life")) - irandom_range(1, 5));
						break;
					case 2:
						ds_map_set(map, "life", real(ds_map_find_value(map, "life")) - irandom(2));
						break;
				}
				if (ds_map_find_value(map, "life") <= 0) {
					ds_map_set(map, "owned", 0);
					var msg = s_str("msg_ItemDegraded");
					msg = string_replace(msg, "$itemname", string(ds_map_find_value(map, "name")));
					s_add_news(msg);
				}
			}
		}
	}
}

