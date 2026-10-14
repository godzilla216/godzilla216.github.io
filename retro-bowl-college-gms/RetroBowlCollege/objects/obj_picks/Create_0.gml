pick1 = string(obj_master.draft_picks[0]);
pick2 = string(obj_master.draft_picks[1]);
pick3 = string(obj_master.draft_picks[2]);
draft_round = obj_master.draft_round - 1;
alf[0] = 0.4;
alf[1] = 0.4;
alf[2] = 0.4;
if (current_room != rm_draft) {
	draft_round = -1;
	alf[0] = 1;
	alf[1] = 1;
	alf[2] = 1;
}
