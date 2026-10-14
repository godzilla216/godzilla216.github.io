// Local compatibility adapter for the exported game. No ads or tracking are loaded.
(function () {
    function noop() {}
    function complete() { return Promise.resolve(); }
    function skipAd() { return Promise.resolve(false); }

    window.PokiSDK = {
        init: complete,
        initWithVideoHB: complete,
        commercialBreak: skipAd,
        rewardedBreak: skipAd,
        displayAd: function (_, __, onFailure, onComplete) {
            if (onFailure) onFailure();
            if (onComplete) onComplete(false);
        },
        destroyAd: noop,
        getLeaderboard: complete,
        shareableURL: complete,
        getURLParam: function (name) {
            var params = new URLSearchParams(window.location.search);
            return params.get("gd" + name) || params.get(name) || "";
        },
        getLanguage: function () { return navigator.language.toLowerCase().split("-")[0]; },
        isAdBlocked: function () { return true; }
    };

    ["captureError", "customEvent", "gameInteractive", "gameLoadingFinished",
        "gameLoadingProgress", "gameLoadingStart", "gameplayStart", "gameplayStop",
        "happyTime", "logError", "muteAd", "roundEnd", "roundStart", "sendHighscore",
        "setDebug", "setDebugTouchOverlayController", "setLogging", "setPlayerAge",
        "setPlaytestCanvas", "enableEventTracking", "playtestSetCanvas",
        "playtestCaptureHtmlOnce"].forEach(function (name) { window.PokiSDK[name] = noop; });
})();
