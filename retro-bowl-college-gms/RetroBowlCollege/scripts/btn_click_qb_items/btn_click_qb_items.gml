function btn_click_qb_items() {
	with (obj_master) {
		shopping_type = 0;
		shopping_page = 1;
		room_goto(rm_qb_shopping);
	}
}

function btn_click_qb_vehicles() {
	with (obj_master) {
		shopping_type = 1;
		shopping_page = 1;
		room_goto(rm_qb_shopping);
	}
}

function btn_click_qb_property() {
	with (obj_master) {
		shopping_type = 2;
		shopping_page = 1;
		room_goto(rm_qb_shopping);
	}
}

