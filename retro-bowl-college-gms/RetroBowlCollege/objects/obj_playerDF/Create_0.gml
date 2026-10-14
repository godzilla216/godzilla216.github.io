event_inherited();
inum = instance_number(obj_playerDF);
facing = -obj_controller.drivedir;
goalline_attack = 300;
goalline_defend = 2300;
if (facing == -1) {
	goalline_attack = 300;
	goalline_defend = 2300;
}
image_xscale = facing * 2;
player_roster = obj_controller.team_roster[!obj_controller.possession ? 1 : 0];
var index = obj_controller.possession;
if (s_is_kickoff(0)) {
	index = !index;
	player_roster = obj_controller.team_roster[obj_controller.possession];
}
switch (index) {
	case 0:
		helmet = obj_master.col_helmet_home;
		logo = obj_master.col_logo_home;
		shirt = obj_master.col_shirt_home;
		sleeve = obj_master.col_sleeve_home;
		pants = obj_master.col_pants_home;
		pants_b = obj_master.col_pants_home_b;
		stripe = obj_master.col_stripe_home;
		socks1 = obj_master.col_socks1_home;
		socks2 = obj_master.col_socks2_home;
		break;
	case 1:
		helmet = obj_master.col_helmet_away;
		logo = obj_master.col_logo_away;
		shirt = obj_master.col_shirt_away;
		sleeve = obj_master.col_sleeve_away;
		pants = obj_master.col_pants_away;
		pants_b = obj_master.col_pants_away_b;
		stripe = obj_master.col_stripe_away;
		socks1 = obj_master.col_socks1_away;
		socks2 = obj_master.col_socks2_away;
		break;
}
switch (obj_controller.kicking) {
	case 0:
		s_set_position_defense();
		break;
	case 1:
	case 2:
		s_set_position_defense_fg();
		break;
	case 3:
		s_set_position_take_ko();
}
