inst_100667.title = s_str("ui_Happiness") + " " + string(round(s_get_happiness())) + "%";
inst_100682.text = string(obj_master.qb_nrg);
if (s_get_qb_energy() > 99) {
	inst_100678.active = false;
}
