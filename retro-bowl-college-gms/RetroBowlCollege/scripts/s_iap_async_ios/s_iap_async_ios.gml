function s_iap_async_ios() {
	slog("s_iap_async_ios");
	if (!is_array(global.IAP_PurchaseID)) {
		s_set_up_purchase_ids();
	}
	if (!ds_exists(obj_master.map_options, 1)) {
		s_create_map_options();
	}
	var _eventId = ds_exists(async_load, 1) ? ds_map_find_value(async_load, "id") : -4;
	switch (_eventId) {
		case 23004:
			slog("s_iap_async: ios_product_update");
			global.IAP_Enabled = true;
			var _json = ds_map_find_value(async_load, "response_json");
			var _map = json_decode(_json);
			var _plist = ds_map_find_value(_map, "valid");
			var _sz = ds_list_size(_plist);
			for (var i = 0; i < _sz; ++i) {
				var _pmap = ds_list_find_value(_plist, i);
				slog(ds_map_find_value(_pmap, "productId"));
				var _pid = -1;
				switch (ds_map_find_value(_pmap, "productId")) {
					case global.rb_full_version:
						_pid = 0;
						break;
					case global.credits_20:
						_pid = 1;
						break;
					case global.credits_50:
						_pid = 2;
						break;
					case global.credits_100:
						_pid = 3;
						break;
					case global.credits_250:
						_pid = 4;
						break;
					case global.credits_25:
						_pid = 5;
						break;
					case global.credits_75:
						_pid = 6;
						break;
				}
				if (_pid > -1) {
					global.IAP_PurchaseID[_pid][1] = ds_map_find_value(_pmap, "price");
					global.IAP_PurchaseID[_pid][2] = ds_map_find_value(_pmap, "localizedDescription");
					global.IAP_PurchaseID[_pid][3] = ds_map_find_value(_pmap, "localizedTitle");
				}
			}
			ds_map_destroy(_map);
			_map = -1;
			var _json = extension_stubfunc_string();
			if (_json != "") {
				slog("checking for purchases...");
				var _map = json_decode(_json);
				var _plist = ds_map_find_value(_map, "purchases");
				var _sz = ds_list_size(_plist);
				for (var i = 0; i < _sz; ++i) {
					var _pmap = ds_list_find_value(_plist, i);
					var _ptoken = ds_map_find_value(_pmap, "purchaseToken");
					if (ds_map_find_value(_pmap, "purchaseState") != 23002) {
						var _receipt = extension_stubfunc_string();
						switch (ds_map_find_value(_pmap, "productId")) {
							case global.rb_full_version:
								slog("receipt for: rb_full_version");
								if (!ds_map_find_value(obj_master.map_options, "fullversion")) {
									obj_master.coach_credit += 25;
									ds_map_set(obj_master.map_options, "op_weather", 1);
									ds_map_set(obj_master.map_options, "op_replays", 1);
									ds_map_set(obj_master.map_options, "op_kickoffs", 1);
									audio_play_sound(snd_purchase, 1, false);
								}
								ds_map_set(obj_master.map_options, "fullversion", 1);
								break;
							case global.credits_20:
								slog("receipt for: credits_20");
								obj_master.coach_credit += 500;
								ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 500);
								obj_master.season_credits_purchased += 500;
								audio_play_sound(snd_purchase, 1, false);
								break;
							case global.credits_50:
								slog("receipt for: credits_50");
								obj_master.coach_credit += 50;
								ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 50);
								obj_master.season_credits_purchased += 50;
								audio_play_sound(snd_purchase, 1, false);
								break;
							case global.credits_100:
								slog("receipt for: credits_100");
								obj_master.coach_credit += 100;
								ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 100);
								obj_master.season_credits_purchased += 100;
								audio_play_sound(snd_purchase, 1, false);
								break;
							case global.credits_25:
								slog("receipt for: credits_25");
								obj_master.coach_credit += 25;
								ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 25);
								obj_master.season_credits_purchased += 25;
								audio_play_sound(snd_purchase, 1, false);
								break;
							case global.credits_75:
								slog("receipt for: credits_75");
								obj_master.coach_credit += 75;
								ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 75);
								obj_master.season_credits_purchased += 75;
								audio_play_sound(snd_purchase, 1, false);
								break;
							case global.credits_250:
								slog("receipt for: credits_250");
								obj_master.coach_credit += 250;
								ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 250);
								obj_master.season_credits_purchased += 250;
								audio_play_sound(snd_purchase, 1, false);
								break;
						}
						s_savegame();
						s_unfreeze_purchase_buttons();
					} else {
						s_unfreeze_purchase_buttons();
					}
					extension_stubfunc_real(_ptoken);
					ds_map_destroy(_pmap);
					_pmap = -1;
				}
				ds_map_destroy(_map);
				_map = -1;
			}
			break;
		case 23000:
			slog("s_iap_async: ios_payment_queue_update");
			var _json = ds_map_find_value(async_load, "response_json");
			if (_json != "") {
				slog(_json);
				var _map = json_decode(_json);
				if (ds_map_exists(_map, "purchases")) {
					var _plist = ds_map_find_value(_map, "purchases");
					var _sz = ds_list_size(_plist);
					for (var i = 0; i < _sz; ++i) {
						var _pmap = ds_list_find_value(_plist, i);
						var _ptoken = ds_map_find_value(_pmap, "purchaseToken");
						if (ds_map_find_value(_pmap, "purchaseState") != 23002) {
							var _receipt = extension_stubfunc_string();
							switch (ds_map_find_value(_pmap, "productId")) {
								case global.rb_full_version:
									slog("receipt for: rb_full_version");
									if (!ds_map_find_value(obj_master.map_options, "fullversion")) {
										obj_master.coach_credit += 25;
										ds_map_set(obj_master.map_options, "op_weather", 1);
										ds_map_set(obj_master.map_options, "op_replays", 1);
										ds_map_set(obj_master.map_options, "op_kickoffs", 1);
										audio_play_sound(snd_purchase, 1, false);
									}
									ds_map_set(obj_master.map_options, "fullversion", 1);
									break;
								case global.credits_20:
									slog("receipt for: credits_20");
									obj_master.coach_credit += 500;
									ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 500);
									obj_master.season_credits_purchased += 500;
									audio_play_sound(snd_purchase, 1, false);
									break;
								case global.credits_50:
									slog("receipt for: credits_50");
									obj_master.coach_credit += 50;
									ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 50);
									obj_master.season_credits_purchased += 50;
									audio_play_sound(snd_purchase, 1, false);
									break;
								case global.credits_100:
									slog("receipt for: credits_100");
									obj_master.coach_credit += 100;
									ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 100);
									obj_master.season_credits_purchased += 100;
									audio_play_sound(snd_purchase, 1, false);
									break;
								case global.credits_25:
									slog("receipt for: credits_25");
									obj_master.coach_credit += 25;
									ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 25);
									obj_master.season_credits_purchased += 25;
									audio_play_sound(snd_purchase, 1, false);
									break;
								case global.credits_75:
									slog("receipt for: credits_75");
									obj_master.coach_credit += 75;
									ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 75);
									obj_master.season_credits_purchased += 75;
									audio_play_sound(snd_purchase, 1, false);
									break;
								case global.credits_250:
									slog("receipt for: credits_250");
									obj_master.coach_credit += 250;
									ds_map_set(obj_master.map_options, "op_credits_purchased", ds_map_find_value(obj_master.map_options, "op_credits_purchased") + 250);
									obj_master.season_credits_purchased += 250;
									audio_play_sound(snd_purchase, 1, false);
									break;
							}
							s_savegame();
							s_unfreeze_purchase_buttons();
							s_update_options_if_present();
						} else {
							s_unfreeze_purchase_buttons();
						}
						extension_stubfunc_real(_ptoken);
						ds_map_destroy(_pmap);
						_pmap = -1;
					}
				}
				ds_map_destroy(_map);
				_map = -1;
			}
			break;
	}
}

