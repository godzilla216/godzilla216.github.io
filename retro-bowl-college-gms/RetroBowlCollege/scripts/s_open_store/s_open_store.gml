function s_open_store() {
	s_msg_clear();
	if (global.mobile_device) {
		if (!global.IAP_Enabled || !os_is_network_connected()) {
			s_create_message("", s_str("msg_StoreConnect"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			return;
		}
	}
	with (obj_master) {
		var bg = instance_create_layer(0, 0, "PopUps", obj_msgbg);
		bg.colour = global.c_background;
		bg.alpha = 1;
		var title = instance_create_layer(display_get_gui_width() * 0.5, 32, "PopUps", obj_roomtitle);
		title.text = s_str("ui_Store");
		title.show_stars = true;
		title.depth = bg.depth - 1;
		var btn_store_exit = instance_create_layer(8, 232, "PopUps", obj_button_sqr);
		btn_store_exit.image = spr_arrowL;
		btn_store_exit.onClickAction = s_btn_store_exit;
		btn_store_exit.depth = bg.depth - 1;
		btn_store_exit.gp_mapped_hidden = global.gp_back;
		var btn_store_restore = instance_create_layer(384, 232, "PopUps", obj_btn_restore);
		btn_store_restore.depth = bg.depth - 1;
		var obj_cc = instance_create_layer(16, 16, "PopUps", obj_box_coachcredit);
		obj_cc.depth = bg.depth - 1;
		var by = 52;
		var bh = 36;
		for (var i = 0; i < 5; ++i) {
			var _name = "";
			var _price = 0;
			var _desc = "";
			slog("_______________________");
			switch (os_type) {
				case 4:
					slog("Get store details: android");
					_name = extension_stubfunc_string(global.IAP_PurchaseID[i][0]);
					_name = string_replace(_name, " (Retro Bowl)", "");
					_name = string_replace(_name, " (Retro Bowl: College Edition)", "");
					_name = string_replace(_name, " (Retro Bowl College)", "");
					_price = extension_stubfunc_string(global.IAP_PurchaseID[i][0]);
					_desc = extension_stubfunc_string(global.IAP_PurchaseID[i][0]);
					break;
				case 3:
					slog("Get store details: ios");
					_price = global.IAP_PurchaseID[i][1];
					_name = global.IAP_PurchaseID[i][3];
					_desc = global.IAP_PurchaseID[i][2];
					break;
			}
			slog("Product name = " + string(_name));
			slog("Product price = " + string(_price));
			slog("Product desc = " + string(_desc));
			vbox_iap[i] = instance_create_layer(80, by, "PopUps", obj_vbox);
			vbox_iap[i].image_xscale = 1.3;
			vbox_iap[i].image_yscale = 0.25;
			vbox_iap[i].title = "";
			vbox_iap[i].text = _name;
			vbox_iap[i].depth = bg.depth - 1;
			btn_iap[i] = instance_create_layer(294, by, "PopUps", obj_btn_buy);
			btn_iap[i].depth = bg.depth - 1;
			btn_iap[i].text = _price;
			switch (i) {
				case 0:
					vbox_iap[i].text += s_str("info_UnlimitedVersion");
					vbox_iap[i].image_yscale = 0.5;
					btn_iap[i].onClickAction = s_iap_purchase_FullVersion;
					by += bh;
					break;
				case 1:
					btn_iap[i].onClickAction = s_iap_purchase_Credits_20;
					break;
				case 2:
					btn_iap[i].onClickAction = s_iap_purchase_Credits_50;
					break;
				case 3:
					btn_iap[i].onClickAction = s_iap_purchase_Credits_100;
					break;
				case 4:
					btn_iap[i].onClickAction = s_iap_purchase_Credits_250;
					break;
			}
			btn_iap[i].active = false;
			btn_iap[i].step_check = btn_step_check_iaps;
			by += bh;
		}
		if (!ds_map_find_value(map_options, "fullversion")) {
			btn_iap[0].active = true;
		}
		btn_iap[0].step_check = btn_step_check_fullversion;
	}
}

function s_btn_store_exit() {
	s_msg_clear();
	s_update_options_if_present();
	if (s_is_co_mode() && obj_master.store_to_dilemma) {
		with (obj_master) {
			s_create_dilemma(map_dilemma);
		}
	}
}

