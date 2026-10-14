/* Career-owned opponent stars, using native player maps and field placement. */
(function (root) {
    "use strict";
    var POSITIONS = [1, 2, 3, 4, 4, 5, 5];
    function enabled(c) {
        return c && !root.global.gmlexhibition && !c.gmlgamepractice && !c.gmlqb_mode && root.gml_Script_s_is_co_mode(c, c);
    }
    function clear(c) {
        Object.values(c._opponentRosterMaps || {}).forEach(function (entry) {
            entry.players.forEach(root.ds_map_destroy);
        });
        if (c._opponentActiveMatch) root.ds_list_destroy(c._opponentActiveMatch.match.gmlteam_roster[c._opponentActiveMatch.side]);
        c._opponentActiveMatch = null;
        c._opponentRosterMaps = {};
        c._opponentRosters = { version: 1, teams: {} };
    }
    function load(c) {
        clear(c);
        var saved = root.ini_read_string("savegame", "opponent_rosters_v1", "");
        if (!saved) return;
        try {
            var data = JSON.parse(saved);
            if (data.version === 1 && data.teams && typeof data.teams === "object") c._opponentRosters = data;
        } catch (e) { /* Legacy or damaged optional data starts with fresh opponents. */ }
    }
    function recruit(c, position, age, rating) {
        var p = root.gml_Script_s_create_player(c, c, position, age, Math.max(2, rating - 1), Math.min(10, rating + 1));
        // Opponent starters are available; the user's academic/injury systems own only their roster.
        root.ds_map_set(p, "percent_grade", 85);
        root.ds_map_set(p, "suspended", 0);
        root.ds_map_set(p, "resting", 0);
        return p;
    }
    function entryFor(c, id, rating) {
        if (!c._opponentRosters) clear(c);
        var records = c._opponentRosters.teams, cache = c._opponentRosterMaps;
        var entry = cache[id], record = records[id];
        if (!entry) {
            entry = cache[id] = { players: [] };
            if (record) {
                record.players.forEach(function (serialized) {
                    var p = root.ds_map_create();
                    root.ds_map_read(p, serialized);
                    entry.players.push(p);
                });
            } else {
                record = records[id] = { year: Number(c.gmlyear), rating: rating, players: [] };
                POSITIONS.forEach(function (pos, i) {
                    entry.players.push(recruit(c, pos, 18 + i % 4, rating));
                });
            }
        }
        // Advance every elapsed season, even if this school was not played that year.
        while (record.year < Number(c.gmlyear)) {
            entry.players = entry.players.map(function (p) {
                var age = Number(root.ds_map_find_value(p, "age")) + 1;
                if (age > root.gml_Script_s_get_max_age(c, c, p)) {
                    var pos = root.ds_map_find_value(p, "position");
                    root.ds_map_destroy(p);
                    return recruit(c, pos, root.gml_Script_s_rookie_age_internal(c, c), record.rating);
                }
                root.ds_map_set(p, "age", age);
                return p;
            });
            record.year++;
        }
        return entry;
    }
    function advance(c) {
        if (!enabled(c) || !c._opponentRosters) return;
        Object.keys(c._opponentRosters.teams).forEach(function (id) {
            entryFor(c, id, c._opponentRosters.teams[id].rating);
        });
    }
    function save(c) {
        if (!enabled(c)) return;
        advance(c);
        Object.keys(c._opponentRosterMaps || {}).forEach(function (id) {
            c._opponentRosters.teams[id].players = c._opponentRosterMaps[id].players.map(root.ds_map_write);
        });
        root.ini_write_string("savegame", "opponent_rosters_v1", JSON.stringify(c._opponentRosters || { version: 1, teams: {} }));
    }
    function prepare(m) {
        var c = root.GetWithArray(98)[0];
        if (!enabled(c)) return;
        var side = Number(m.gmlhuman_team) === 0 ? 1 : 0;
        var id = String(root.ds_map_find_value(m.gmlteam[side], "uid"));
        var rating = Math.max(2, Math.min(10, Number(m.gmlteam_offense[side]) || 5));
        if (m._opponentRosterId === id && c._opponentActiveMatch && c._opponentActiveMatch.match === m) return;
        var entry = entryFor(c, id, rating);
        if (c._opponentActiveMatch) root.ds_list_destroy(c._opponentActiveMatch.match.gmlteam_roster[c._opponentActiveMatch.side]);
        var list = root.ds_list_create();
        entry.players.forEach(function (p) { root.ds_list_add(list, p); });
        m.gmlteam_roster[side] = list;
        m._opponentRosterId = id;
        c._opponentActiveMatch = { match: m, side: side };
    }
    root.RetroOpponentRosters = { prepare: prepare, save: save, load: load, clear: clear, advance: advance };
})(window);
