// Local compatibility hooks for names embedded in the compiled game.
// These functions never load an SDK, collect data, or make network requests.
function poki_loading_finished() {}
function poki_loading_update(percents) {}
function poki_gameplay_start(reason) {}
function poki_gameplay_stop(reason) {}
function poki_happy(value) {}

// Complete legacy ad states immediately so play and rewards can continue.
function poki_break(tag) {
    poki_callback("poki.break.started", tag);
    poki_callback("poki.break.completed", tag);
}

function poki_rewarded_break(tag) {
    poki_callback("poki.rewarded.started", tag);
    poki_callback("poki.rewarded.completed", tag);
}

function poki_callback(event, args) {
    gmCallback.game_callback(event, args);
}
