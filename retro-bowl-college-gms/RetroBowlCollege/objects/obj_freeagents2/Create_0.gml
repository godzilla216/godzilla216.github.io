draw_set_font(global.fnt_small_flex);
draw_set_halign(0);
draw_set_valign(1);
inst_100157.visible = false;
inst_100156.visible = false;
var page = obj_master.fa_page;
s_create_storelist(false);
s_savegame();
var i = 0;
switch (page) {
	case 2:
		inst_100157.visible = true;
		i = 10;
		break;
	default:
		inst_100156.visible = true;
		break;
}
with (obj_master) {
	var pmap = s_get_store_player_by_position(1, page);
	inst_100140.pmap = pmap;
	if (ds_map_exists(pmap, "creditcost")) {
		inst_100134.text = string(ds_map_find_value(pmap, "creditcost"));
	}
	pmap = s_get_store_player_by_position(2, page);
	inst_100141.pmap = pmap;
	if (ds_map_exists(pmap, "creditcost")) {
		inst_100135.text = string(ds_map_find_value(pmap, "creditcost"));
	}
	i++;
	pmap = s_get_store_player_by_position(3, page);
	inst_100142.pmap = pmap;
	if (ds_map_exists(pmap, "creditcost")) {
		inst_100136.text = string(ds_map_find_value(pmap, "creditcost"));
	}
	i++;
	pmap = s_get_store_player_by_position(4, page);
	inst_100143.pmap = pmap;
	if (ds_map_exists(pmap, "creditcost")) {
		inst_100137.text = string(ds_map_find_value(pmap, "creditcost"));
	}
	i++;
	pmap = s_get_store_player_by_position(5, page);
	inst_100144.pmap = pmap;
	if (ds_map_exists(pmap, "creditcost")) {
		inst_100138.text = string(ds_map_find_value(pmap, "creditcost"));
	}
	i++;
	pmap = s_get_store_player_by_position(6, page);
	inst_100145.pmap = pmap;
	if (ds_map_exists(pmap, "creditcost")) {
		inst_100139.text = string(ds_map_find_value(pmap, "creditcost"));
	}
	i++;
	pmap = s_get_store_player_by_position(7, page);
	inst_100147.pmap = pmap;
	if (ds_map_exists(pmap, "creditcost")) {
		inst_100146.text = string(ds_map_find_value(pmap, "creditcost"));
	}
	i++;
	pmap = s_get_store_player_by_position(8, page);
	inst_100149.pmap = pmap;
	if (ds_map_exists(pmap, "creditcost")) {
		inst_100148.text = string(ds_map_find_value(pmap, "creditcost"));
	}
	i++;
	pmap = s_get_store_player_by_position(10, page);
	inst_100151.pmap = pmap;
	if (ds_map_exists(pmap, "creditcost")) {
		inst_100150.text = string(ds_map_find_value(pmap, "creditcost"));
	}
	i++;
}
