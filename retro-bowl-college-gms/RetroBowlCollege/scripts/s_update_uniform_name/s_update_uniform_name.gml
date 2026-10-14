function s_update_uniform_name() {
	with (obj_edit_team) {
		if (string_letters(inst_100084.text) != "") {
			current_uni.name = inst_100084.text;
		} else {
			inst_100084.text = current_uni.name;
		}
		if (string_letters(inst_100085.text) != "") {
			current_uni.tla = inst_100085.text;
		} else {
			inst_100085.text = current_uni.tla;
		}
		var rain = real(string_digits("0" + inst_100076.text));
		current_uni.rainfall = clamp(rain, 0, 100);
		inst_100076.text = string(current_uni.rainfall);
		var snow = real(string_digits("0" + inst_100077.text));
		current_uni.snowfall = clamp(snow, 0, 100);
		inst_100077.text = string(current_uni.snowfall);
		current_uni.roof = inst_100078.state;
	}
}

