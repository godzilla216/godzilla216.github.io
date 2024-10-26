console.log("Poki wrapper load");

function poki_init_raw() {
    console.log("Poki wrapper init");
    // Fix GMS1 bug with iframes
    var ctr = document.getElementById("gm4html5_div_id");
    if (ctr && !ctr.frames) ctr.frames = [];
    return 0;
}

///~
function poki_script_closure_raw(self, other, script, custom) {
    return function(result) {
        window.gml_Script_gmcallback_poki_closure(self, other, script, result, custom)
    }
}

function poki_is_blocked() {
    return !window.PokiSDK_OK;
}

function poki_gameplay_start() {
    if (PokiSDK) PokiSDK.gameplayStart();
}

function poki_gameplay_stop() {
    if (PokiSDK) PokiSDK.gameplayStop();
}

function poki_happy_time(magnitude) {
    if (PokiSDK) PokiSDK.happyTime(magnitude);
}

///~
// Modified to disable ads by immediately calling the callback without showing ads
function poki_commercial_break_raw(fn) {
    setTimeout(function() { fn(false); }, 0); // Call the callback with "false" to indicate no ad shown
}

///~
// Modified to disable rewarded ads similarly
function poki_rewarded_break_raw(fn) {
    setTimeout(function() { fn(false); }, 0); // Call the callback with "false" to indicate no ad shown
}

/// Loading bar for the game
var inst = { };

function poki_loadbar(ctx, width, height, total, current, image) {
    if (window.PokiSDK) { // SDK integration for load state tracking
        if (window.PokiSDK_loadState == 0) {
            window.PokiSDK_isLoading = 1;
            PokiSDK.gameLoadingStart();
        }
        PokiSDK.gameLoadingProgress({ percentageDone: current / total });
        if (current >= total && window.PokiSDK_loadState != 2) {
            window.PokiSDK_loadState = 2;
            PokiSDK.gameLoadingFinished();
        }
    }

    // Loading bar rendering logic
    function getv(s) {
        if (window.gml_Script_gmcallback_poki_loadbar) {
            return window.gml_Script_gmcallback_poki_loadbar(inst, null,
                s, current, total,
                width, height, image ? image.width : 0, image ? image.height : 0)
        } else return undefined;
    }
    function getf(s, d) {
        var r = getv(s);
        return typeof(r) == "number" ? r : d;
    }
    function getw(s, d) {
        var r = getv(s);
        return r && r.constructor == Array ? r : d;
    }
    function getc(s, d) {
        var r = getv(s);
        if (typeof(r) == "number") {
            r = r.toString(16);
            while (r.length < 6) r = "0" + r;
            return "#" + r;
        } else if (typeof(r) == "string") {
            return r;
        } else return d;
    }
    // Bar style parameters:
    var backgroundColor = getc("background_color", "#FFFFFF");
    var barBackgroundColor = getc("bar_background_color", "#FFFFFF");
    var barForegroundColor = getc("bar_foreground_color", "#242238");
    var barBorderColor = getc("bar_border_color", "#242238");
    var barWidth = getf("bar_width", Math.round(width * 0.6));
    var barHeight = getf("bar_height", 20);
    var barBorderWidth = getf("bar_border_width", 2);
    var barOffset = getf("bar_offset", 10);
    // Background:
    ctx.fillStyle = backgroundColor;
    ctx.fillRect(0, 0, width, height);
    // Image handling:
    var totalHeight, barTop;
    if (image != null) {
        var rect = getw("image_rect");
        if (!rect) rect = [0, 0, image.width, image.height];
        totalHeight = rect[3] + barOffset + barHeight;
        var image_y = (height - totalHeight) >> 1;
        ctx.drawImage(image, rect[0], rect[1], rect[2], rect[3],
            (width - rect[2]) >> 1, image_y, rect[2], rect[3]);
        barTop = image_y + rect[3] + barOffset;
    } else barTop = (height - barHeight) >> 1;
    // Bar border:
    var barLeft = (width - barWidth) >> 1;
    ctx.fillStyle = barBorderColor;
    ctx.fillRect(barLeft, barTop, barWidth, barHeight);
    //
    var barInnerLeft = barLeft + barBorderWidth;
    var barInnerTop = barTop + barBorderWidth;
    var barInnerWidth = barWidth - barBorderWidth * 2;
    var barInnerHeight = barHeight - barBorderWidth * 2;
    // Bar background:
    ctx.fillStyle = barBackgroundColor;
    ctx.fillRect(barInnerLeft, barInnerTop, barInnerWidth, barInnerHeight);
    // Bar foreground:
    var barLoadedWidth = Math.round(barInnerWidth * current / total);
    ctx.fillStyle = barForegroundColor;
    ctx.fillRect(barInnerLeft, barInnerTop, barLoadedWidth, barInnerHeight);
}

///~
// Team functions for passing information
function poki_get_team_raw() {
    return PokiSDK.getURLParam('team');
}

function poki_set_team_raw(team) {
    return window.parent.postMessage({ type: 'RetroBowl_teamSwitch', content: { team } }, '*');
}
