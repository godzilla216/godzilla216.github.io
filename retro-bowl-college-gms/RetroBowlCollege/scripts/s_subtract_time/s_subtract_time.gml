function s_subtract_time(_arg0, _arg1, _arg2) {
	var tm = irandom_range(_arg0, _arg1);
	if (goforit) {
		tm = 1 + tm * 0.5;
	} else if (_arg1 > 1 && team_score[human_team] > team_score[!human_team ? 1 : 0] + 7 && obj_master.op_matchlength > -1) {
		tm *= 1.5;
	}
	time_subtract += round(tm);
}

