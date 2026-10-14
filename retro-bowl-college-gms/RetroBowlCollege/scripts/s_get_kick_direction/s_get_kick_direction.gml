function s_get_kick_direction() {
	var skl = holder.my_kick_skill / 3;
	var sp = 9 - skl;
	var dif = (5 + obj_controller.difficulty) / 5;
	sp -= dif;
	sp = clamp(sp, 3, 9);
	var conewid = 100;
	if (s_is_kickoff(false)) {
		sp = 9;
		conewid = 200;
	}
	kicky += kickflip * sp;
	if (kicky > 300 + conewid || kicky < 300 - conewid) {
		kickflip = -kickflip;
	}
	return -point_direction(holder.x, holder.y, kickx, kicky);
}

