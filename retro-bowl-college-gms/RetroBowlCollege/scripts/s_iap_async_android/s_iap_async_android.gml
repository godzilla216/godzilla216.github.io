function s_debug_purge_all_android_iap() {
	slog("s_debug_purge_all_android_iap");
	slog("Current Tokens [" + string(ds_list_size(global.CurrentTokens)) + "]");
	for (var i = 0; i < ds_list_size(global.CurrentTokens); ++i) {
		slog("..Current Tokens[" + string(i) + "]:[" + string(ds_list_find_value(global.CurrentTokens, i)) + "]");
	}
	slog("Current Products [" + string(ds_list_size(global.CurrentProducts)) + "]");
	for (var i = 0; i < ds_list_size(global.CurrentProducts); ++i) {
		slog("..Current Products[" + string(i) + "]:[" + string(ds_list_find_value(global.CurrentProducts, i)) + "]");
	}
}

function s_iap_async_android() {
	slog("s_iap_async_android");
	var _eventId = ds_map_find_value(async_load, "id");
	if (!ds_exists(obj_master.map_options, 1)) {
		s_create_map_options();
	}
	switch (_eventId) {
		case 12005:
			slog("gpb_store_connect");
			extension_stubfunc_real(global.IAP_PurchaseID[0][0]);
			extension_stubfunc_real(global.IAP_PurchaseID[1][0]);
			extension_stubfunc_real(global.IAP_PurchaseID[2][0]);
			extension_stubfunc_real(global.IAP_PurchaseID[3][0]);
			extension_stubfunc_real(global.IAP_PurchaseID[4][0]);
			extension_stubfunc_real();
			break;
		case 12006:
			slog("gpb_store_connect_failed");
			obj_master.alarm[0] = room_speed * 10;
			break;
		case 12003:
			slog("gpb_product_data_response");
			var _json = ds_map_find_value(async_load, "response_json");
			var _map = json_decode(_json);
			if (ds_map_find_value(_map, "success") == true) {
				global.IAP_Enabled = true;
				var _plist = ds_map_find_value(_map, "skuDetails");
				slog("gpb_product_data_response skuDetails count[" + string(ds_list_size(_plist)) + "]");
				for (var i = 0; i < ds_list_size(_plist); ++i) {
					var _pmap = ds_list_find_value(_plist, i);
					var _num = 0;
					while (ds_map_find_value(_pmap, "productId") != global.IAP_PurchaseID[_num][0]) {
						++_num;
					}
					slog(ds_map_find_value(_pmap, "productId"));
					slog(ds_map_find_value(_pmap, "price"));
					slog(ds_map_find_value(_pmap, "title"));
					slog(ds_map_find_value(_pmap, "description"));
					global.IAP_PurchaseID[_num][0] = ds_map_find_value(_pmap, "productId");
					global.IAP_PurchaseID[_num][1] = ds_map_find_value(_pmap, "price");
					global.IAP_PurchaseID[_num][3] = ds_map_find_value(_pmap, "title");
					global.IAP_PurchaseID[_num][2] = ds_map_find_value(_pmap, "description");
				}
				extension_stubfunc_string("\"inapp\"");
			}
			ds_map_destroy(_map);
			_map = -1;
			break;
		case 12010:
			slog("gpb_query_purchase_async");
			var _json = ds_map_find_value(async_load, "response_json");
			var _purchase_map = json_decode(_json);
			if (ds_map_find_value(_purchase_map, "success") == true) {
				var _list = ds_map_find_value(_purchase_map, "purchases");
				var _sz = ds_list_size(_list);
				for (var i = 0; i < _sz; ++i) {
					var _map = ds_list_find_value(_list, i);
					if (ds_map_find_value(_map, "purchaseState") == 0) {
						var _pid = ds_map_find_value(_map, "productId");
						var _token = ds_map_find_value(_map, "purchaseToken");
						var _add = false;
						slog("gpb_query_purchase_async - [" + string(_pid) + "]");
						if (_pid == global.IAP_PurchaseID[0][0]) {
							slog("gpb_query_purchase_async - acknowledged = " + string(ds_map_find_value(_map, "acknowledged")));
							if (ds_map_find_value(_map, "acknowledged") == 0) {
								extension_stubfunc_real(_token);
							} else if (ds_map_find_value(_map, "acknowledged") == 1) {
								if (!ds_map_find_value(obj_master.map_options, "fullversion")) {
									obj_master.coach_credit += 25;
									ds_map_set(obj_master.map_options, "op_weather", 1);
									ds_map_set(obj_master.map_options, "op_replays", 1);
									ds_map_set(obj_master.map_options, "op_kickoffs", 1);
									audio_play_sound(snd_purchase, 1, false);
								}
								ds_map_set(obj_master.map_options, "fullversion", 1);
							}
							_add = true;
						} else if (_pid == global.IAP_PurchaseID[1][0] || _pid == global.IAP_PurchaseID[2][0] || _pid == global.IAP_PurchaseID[3][0] || _pid == global.IAP_PurchaseID[4][0]) {
							slog("gpb_query_purchase_async - Trigger CONSUME [" + string(_pid) + "]");
							extension_stubfunc_real(_token);
							_add = true;
						}
						if (_add) {
							ds_list_add(global.CurrentTokens, _token);
							ds_list_add(global.CurrentProducts, _pid);
						}
					}
				}
			}
			ds_map_destroy(_purchase_map);
			_purchase_map = -1;
			break;
		case 12001:
			slog("gpb_iap_receipt");
			var _json = ds_map_find_value(async_load, "response_json");
			var _map = json_decode(_json);
			if (ds_map_find_value(_map, "success") == true) {
				if (ds_map_exists(_map, "purchases")) {
					var _plist = ds_map_find_value(_map, "purchases");
					for (var i = 0; i < ds_list_size(_plist); ++i) {
						var _pmap = ds_list_find_value(_plist, i);
						slog("gpb_iap_receipt for [" + string(ds_map_find_value(_pmap, "productId")) + "]");
						var _ptoken = ds_map_find_value(_pmap, "purchaseToken");
						var _sig = extension_stubfunc_string(_ptoken);
						var _pjson = extension_stubfunc_string(_ptoken);
						if (extension_stubfunc_real(_pjson, _sig)) {
							if (ds_map_find_value(_pmap, "productId") == global.IAP_PurchaseID[0][0]) {
								extension_stubfunc_real(_ptoken);
							} else {
								extension_stubfunc_real(_ptoken);
							}
							ds_list_add(global.CurrentTokens, _ptoken);
							ds_list_add(global.CurrentProducts, ds_map_find_value(_pmap, "productId"));
						}
					}
				}
			}
			s_unfreeze_purchase_buttons();
			ds_map_destroy(_map);
			_map = -1;
			break;
		case 12007:
			slog("gpb_product_consume_response");
			var _json = ds_map_find_value(async_load, "response_json");
			var _map = json_decode(_json);
			var _num = -1;
			if (ds_map_exists(_map, "purchaseToken")) {
				for (var i = 0; i < ds_list_size(global.CurrentTokens); ++i) {
					if (ds_map_find_value(_map, "purchaseToken") == ds_list_find_value(global.CurrentTokens, i)) {
						if (ds_list_find_value(global.CurrentProducts, i) == global.IAP_PurchaseID[1][0]) {
							obj_master.coach_credit += 500;
							ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 500);
							obj_master.season_credits_purchased += 500;
							audio_play_sound(snd_purchase, 1, false);
							_num = i;
							break;
						} else if (ds_list_find_value(global.CurrentProducts, i) == global.IAP_PurchaseID[2][0]) {
							obj_master.coach_credit += 50;
							ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 50);
							obj_master.season_credits_purchased += 50;
							audio_play_sound(snd_purchase, 1, false);
							_num = i;
							break;
						} else if (ds_list_find_value(global.CurrentProducts, i) == global.IAP_PurchaseID[3][0]) {
							obj_master.coach_credit += 100;
							ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 100);
							obj_master.season_credits_purchased += 100;
							audio_play_sound(snd_purchase, 1, false);
							_num = i;
							break;
						} else if (ds_list_find_value(global.CurrentProducts, i) == global.IAP_PurchaseID[4][0]) {
							obj_master.coach_credit += 250;
							ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 250);
							obj_master.season_credits_purchased += 250;
							audio_play_sound(snd_purchase, 1, false);
							_num = i;
							break;
						}
					}
				}
				s_savegame();
				if (_num > -1) {
					ds_list_delete(global.CurrentProducts, _num);
					ds_list_delete(global.CurrentTokens, _num);
				}
			} else {
			}
			s_unfreeze_purchase_buttons();
			ds_map_destroy(_map);
			_map = -1;
			break;
		case 12008:
			slog("gpb_acknowledge_purchase_response");
			var _map = json_decode(ds_map_find_value(async_load, "response_json"));
			var _num = -1;
			if (ds_map_exists(_map, "responseCode")) {
				if (ds_map_find_value(_map, "responseCode") == 0) {
					for (var i = 0; i < ds_list_size(global.CurrentProducts); ++i) {
						if (ds_list_find_value(global.CurrentProducts, i) == global.IAP_PurchaseID[0][0]) {
							if (!ds_map_find_value(obj_master.map_options, "fullversion")) {
								obj_master.coach_credit += 25;
								ds_map_set(obj_master.map_options, "op_weather", 1);
								ds_map_set(obj_master.map_options, "op_replays", 1);
								ds_map_set(obj_master.map_options, "op_kickoffs", 1);
								audio_play_sound(snd_purchase, 1, false);
							}
							ds_map_set(obj_master.map_options, "fullversion", 1);
							_num = i;
							break;
						}
					}
					s_savegame();
					if (_num > -1) {
						ds_list_delete(global.CurrentProducts, _num);
						ds_list_delete(global.CurrentTokens, _num);
					}
				} else {
				}
			}
			s_unfreeze_purchase_buttons();
			ds_map_destroy(_map);
			_map = -1;
			break;
	}
}

