function s_decline_facilities() {
	with (obj_master) {
		switch (irandom(2)) {
			case 0:
				if (facility_upgraded_stadium == 0 && facility_stadium > 1) {
					facility_stadium--;
					s_add_news(s_str("msg_FacilityDeclineStadium"));
				}
				break;
			case 1:
				if (facility_upgraded_training == 0 && facility_training > 1) {
					facility_training--;
					s_add_news(s_str("msg_FacilityDeclineTraining"));
				}
			case 2:
				if (facility_upgraded_rehab == 0 && facility_rehab > 1) {
					facility_rehab--;
					s_add_news(s_str("msg_FacilityDeclineRehab"));
				}
		}
		facility_upgraded_stadium = 0;
		facility_upgraded_training = 0;
		facility_upgraded_rehab = 0;
	}
}

