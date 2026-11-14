/* Harden the browser loader for the bundled Unity build. */
(function () {
  "use strict";

  var failed = false;
  var requests = new Set();
  var fullscreen = document.getElementById("fullscreen");

  function showError(message, detail) {
    if (failed) return;
    failed = true;
    fullscreen.disabled = true;
    document.getElementById("gameErrorMessage").textContent = message;
    document.getElementById("gameError").hidden = false;
    requests.forEach(function (request) { request.abort(); });
    requests.clear();
    if (detail) console.error(detail);
  }

  function runtimeError(message) {
    var memoryError = /memory|array buffer|typed array/i.test(String(message));
    showError(memoryError
      ? "The game ran out of memory. Close other game tabs, then reload."
      : "The game stopped unexpectedly. Reload to try again.", message);
    return true;
  }

  document.getElementById("retry").addEventListener("click", function () {
    window.location.reload();
  });
  fullscreen.addEventListener("click", function () {
    if (!failed && window.gameInstance) window.gameInstance.SetFullscreen(1);
  });

  // The compiled game opens mobile-store promotions through ExternalEval.
  // Advertising and tracking requests are also restricted by the page CSP.
  window.open = function () { return null; };

  if (window.location.protocol === "file:") {
    showError("Start the local server with node server.cjs, then open http://localhost:8080. The game cannot load by opening index.html directly.");
    return;
  }
  if (!window.UnityLoader) {
    showError("The game loader is missing. Restore Build/UnityLoader.js, then reload.");
    return;
  }

  UnityLoader.Error.handler = function (event) {
    runtimeError(event.message || "Unity runtime error");
  };
  window.addEventListener("unhandledrejection", function (event) {
    runtimeError(event.reason);
  });
  window.addEventListener("error", function (event) {
    if (event.target && event.target.tagName === "SCRIPT") {
      showError("A game script could not load. Check your connection and reload.", event.target.src);
    }
  }, true);

  // The original loader never checks HTTP status, empty files, or timeouts.
  UnityLoader.downloadJob = function (module, job) {
    if (failed) return;

    function download(url, onProgress, onLoad) {
      var request = new XMLHttpRequest();
      request.open("GET", url, true);
      request.responseType = "arraybuffer";
      request.timeout = 120000;
      requests.add(request);

      function downloadError(reason) {
        requests.delete(request);
        showError("A game file could not load. Check your connection and reload.", reason + ": " + url);
      }
      request.onerror = function () { downloadError("Network error"); };
      request.ontimeout = function () { downloadError("Download timed out"); };
      request.onabort = function () {
        requests.delete(request);
        if (!failed) downloadError("Download interrupted");
      };
      request.onprogress = function (event) {
        if (!failed && onProgress) onProgress(event);
      };
      request.onload = function (event) {
        requests.delete(request);
        if (failed) return;
        if (request.status !== 200 || !request.response || !request.response.byteLength) {
          downloadError("Missing or empty file (HTTP " + request.status + ")");
          return;
        }
        try {
          onLoad(new Uint8Array(request.response), event);
        } catch (error) {
          downloadError(String(error));
        }
      };
      request.send();
    }

    function decompress(bytes, event) {
      try {
        UnityLoader.Compression.decompress(bytes, function (data) {
          if (failed) return;
          if (!data || !data.byteLength) {
            showError("A game file is damaged. Restore the Build folder, then reload.");
            return;
          }
          job.complete(data);
        });
        if (job.parameters.onload) job.parameters.onload(event);
      } catch (error) {
        showError("A game file is damaged. Restore the Build folder, then reload.", error);
      }
    }

    if (module.dataParts && job.parameters.url === module.resolveBuildUrl(module.dataUrl)) {
      // Download parts in order into one buffer. No LFS client or server-side
      // assembly is required, and only one part request is in flight at a time.
      try {
        var parts = module.dataParts;
        if (!Array.isArray(parts) || !parts.length) throw new Error("Missing game data parts");
        var total = parts.reduce(function (sum, part) {
          if (!part || typeof part.url !== "string" || !Number.isSafeInteger(part.size) || part.size <= 0) {
            throw new Error("Invalid game data part");
          }
          return sum + part.size;
        }, 0);
        if (!Number.isSafeInteger(total)) throw new Error("Invalid game data size");
        var combined = new Uint8Array(total);
        var completed = 0;
        var index = 0;
        function progress(loaded) {
          return { lengthComputable: true, loaded: loaded, total: total };
        }
        function next() {
          if (failed) return;
          var part = parts[index];
          download(module.resolveBuildUrl(part.url), function (event) {
            if (job.parameters.onprogress) job.parameters.onprogress(progress(completed + event.loaded));
          }, function (bytes) {
            if (bytes.length !== part.size) throw new Error("Incomplete game data part: " + part.url);
            combined.set(bytes, completed);
            completed += bytes.length;
            index++;
            if (index < parts.length) next();
            else {
              var archive = combined;
              combined = null;
              decompress(archive, progress(total));
            }
          });
        }
        next();
      } catch (error) {
        showError("The game data parts could not load. Restore the Build folder, then reload.", error);
      }
    } else {
      download(job.parameters.url, job.parameters.onprogress, decompress);
    }
  };

  // Validate the entire directory before mounting files into Unity's filesystem.
  // The stock loader's header comparison has a misplaced negation.
  var processData = UnityLoader.processDataJob;
  UnityLoader.processDataJob = function (module, job) {
    if (failed) return;
    try {
      var data = UnityLoader.Job.result(module, "downloadData");
      var magic = "UnityWebData1.0\0";
      if (!data || data.length < magic.length + 4) throw new Error("Game data is empty or truncated");
      for (var i = 0; i < magic.length; i++) {
        if (data[i] !== magic.charCodeAt(i)) throw new Error("Invalid game data header");
      }
      var view = new DataView(data.buffer, data.byteOffset, data.byteLength);
      var end = view.getUint32(magic.length, true);
      var offset = magic.length + 4;
      if (end < offset || end > data.length) throw new Error("Invalid game data directory");
      while (offset < end) {
        if (offset + 12 > end) throw new Error("Truncated game data entry");
        var start = view.getUint32(offset, true);
        var length = view.getUint32(offset + 4, true);
        var nameLength = view.getUint32(offset + 8, true);
        offset += 12 + nameLength;
        if (!nameLength || offset > end || start < end || start + length > data.length) {
          throw new Error("Invalid game data entry");
        }
      }
      processData(module, job);
    } catch (error) {
      showError("The game data is damaged or incomplete. Restore the Build folder, then reload.", error);
    }
  };

  try {
    window.gameInstance = UnityLoader.instantiate("gameContainer", "Build/ItchIO.json", {
      onProgress: function (instance, progress) {
        if (!failed) UnityProgress(instance, progress);
      },
      Module: {
        errorhandler: runtimeError,
        postRun: [function () {
          var module = window.gameInstance.Module;
          // Finished download jobs otherwise retain large buffers for the full session.
          ["downloadData", "downloadAsmCode", "downloadAsmFramework", "downloadAsmMemory"].forEach(function (name) {
            if (module.Jobs[name] && module.Jobs[name].result) module.Jobs[name].result.value = null;
          });
          if (module.memoryInitializerRequest) module.memoryInitializerRequest.response = null;
          fullscreen.disabled = failed;
        }]
      }
    });
    window.gameInstance.Module.canvas.addEventListener("webglcontextlost", function (event) {
      event.preventDefault();
      showError("The graphics connection was lost. Reload the game to continue.");
    });
  } catch (error) {
    runtimeError(error);
  }
}());
