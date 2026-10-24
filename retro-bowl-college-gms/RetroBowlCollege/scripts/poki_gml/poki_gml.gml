// Functions that shipped inside the Poki extension (recovered from the HTML5 build).

function poki_init() {
	if (poki_init_raw()) {
		gmcallback_poki_closure(0, 0, 0);
	}
}

function poki_commercial_break() {
	var script = argument[0];
	var custom;
	if (argument_count > 1) {
		custom = argument[1];
	} else {
		custom = undefined;
	}
	poki_commercial_break_raw(poki_script_closure(script, custom));
}

function poki_rewarded_break() {
	var script = argument[0];
	var custom;
	if (argument_count > 1) {
		custom = argument[1];
	} else {
		custom = undefined;
	}
	poki_rewarded_break_raw(poki_script_closure(script, custom));
}

function poki_script_closure(_arg0, _arg1) {
	return poki_script_closure_raw(argument[-2], argument[-1], _arg0, _arg1);
}

function gmcallback_poki_closure(_arg0, _arg1, _arg2) {
	script_execute(_arg0, _arg1, _arg2);
}

function poki_get_team() {
	return poki_get_team_raw();
}

function poki_set_team(_arg0) {
	return poki_set_team_raw(_arg0);
}

