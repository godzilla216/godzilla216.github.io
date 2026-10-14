function s_get_happiness() {
	with (obj_master) {
		var hap = fans + relationship_boss + s_get_morale();
		return hap / 3;
	}
}

