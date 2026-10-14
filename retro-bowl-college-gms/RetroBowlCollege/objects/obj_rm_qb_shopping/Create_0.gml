with (obj_master) {
	inst_100707.colour = global.c_background;
	inst_100708.colour = global.c_background;
	inst_100709.colour = global.c_background;
	switch (shopping_type) {
		case 0:
			inst_100707.colour = global.c_primary;
			break;
		case 1:
			inst_100708.colour = global.c_primary;
			break;
		case 2:
			inst_100709.colour = global.c_primary;
			break;
	}
}
s_update_shopping_buttons();
