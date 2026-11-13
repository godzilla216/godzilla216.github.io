"use strict";

(() => {
    const loading = document.getElementById("loading");
    const progress = document.getElementById("loading-progress");
    const message = document.getElementById("loading-message");

    // The bundled Unity loader uses these sizes when downloads omit Content-Length.
    window.config = {
        cachedDecompressedFileSizes: {
            "Gladihoppers.data.unityweb": 17409938,
            "Gladihoppers.wasm.code.unityweb": 6410659,
            "Gladihoppers.wasm.framework.unityweb": 91463
        }
    };

    // Keep the compiled game's bridge contract without loading an advertising SDK.
    // Defer replies until Unity has returned from the JavaScript call.
    window.initPokiBridge = function (objectName) {
        function reply(method, value) {
            window.setTimeout(() => {
                if (value === undefined) {
                    window.unityGame.SendMessage(objectName, method);
                } else {
                    window.unityGame.SendMessage(objectName, method, value);
                }
            }, 0);
        }

        window.commercialBreak = function () {
            reply("commercialBreakCompleted");
        };
        window.rewardedBreak = function () {
            reply("rewardedBreakCompleted", "true");
        };
        reply("ready");
    };

    try {
        window.unityGame = window.UnityLoader.instantiate("game", "Build/Gladihoppers.json", {
            onProgress(instance, amount) {
                progress.value = amount;
                if (amount >= 1) {
                    message.textContent = "Starting Gladihoppers...";
                }
            },
            Module: {
                onRuntimeInitialized() {
                    loading.hidden = true;
                },
                onAbort() {
                    loading.hidden = false;
                    message.textContent = "The game could not start. Reload the page to try again.";
                    progress.hidden = true;
                }
            }
        });
    } catch (error) {
        message.textContent = "The game could not load. Reload the page to try again.";
        progress.hidden = true;
        console.error(error);
    }
})();
