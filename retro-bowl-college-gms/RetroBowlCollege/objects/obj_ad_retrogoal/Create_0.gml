var lay_id = layer_get_id("Background");
var back_id = layer_background_get_id(lay_id);
switch (ds_map_find_value(obj_master.map_options, "done_ad_retrogoal") mod 6) {
	case 0:
		layer_background_sprite(back_id, spr_adSWITCH);
		break;
	case 1:
		layer_background_sprite(back_id, spr_adNSGP);
		break;
	case 2:
		layer_background_sprite(back_id, spr_adRG);
		break;
	case 3:
		layer_background_sprite(back_id, spr_adNSS);
		break;
	case 4:
		layer_background_sprite(back_id, spr_adNSB);
		break;
	case 5:
		layer_background_sprite(back_id, spr_adNSM);
		break;
}
