switch (obj_master.stage) {
	case 5:
		inst_100258.image = spr_arrowL;
		btn_click_LeaguePanel(2);
		break;
	default:
		btn_click_LeaguePanel(obj_master.myconference);
		break;
}
