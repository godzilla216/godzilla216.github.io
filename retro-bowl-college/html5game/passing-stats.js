/* Passing counters belong to roster identities, independently of field roles. */
(function (r) {
    "use strict";
    var fields = ["attempts", "complete", "yards", "longest", "touchdowns", "int", "sacks"];
    function value(map, key) {
        return r.ds_map_exists(map, key) ? Number(r.ds_map_find_value(map, key)) || 0 : 0;
    }
    function key(map, field) {
        return "stat_" + (value(map, "position") === 1 ? "" : "pass_") + field;
    }
    function add(player, field, amount) {
        if (!player || !r.yyGetBool(player.gmlpmap)) return;
        var map = player.gmlpmap, name = key(map, field);
        r.ds_map_set(map, name, value(map, name) + amount);
    }
    function longest(player, yards) {
        if (!player || !r.yyGetBool(player.gmlpmap)) return;
        var name = key(player.gmlpmap, "longest");
        r.ds_map_set(player.gmlpmap, name, Math.max(value(player.gmlpmap, name), yards));
    }
    function passer(ball, fallback) {
        return ball && ball._passingPlayer !== undefined ? ball._passingPlayer : fallback;
    }
    function complete(ball) {
        var id = passer(ball, r.gml_Script_s_get_quarterback(ball, ball));
        add(r.GetWithArray(id)[0], "complete", 1);
    }
    function tally(map) {
        // Absent keys in older saves read as zero; receiving totals cannot be
        // retroactively separated into passing and receiving contributions.
        if (value(map, "position") === 1) return;
        ["season", "career"].forEach(function (scope) {
            fields.forEach(function (field) {
                var current = value(map, "stat_pass_" + field);
                if (!current && !r.ds_map_exists(map, scope + "_pass_" + field)) return;
                var name = scope + "_pass_" + field;
                r.ds_map_set(map, name, field === "longest" ? Math.max(value(map, name), current) : value(map, name) + current);
            });
        });
    }
    function reset(map, season) {
        fields.forEach(function (field) {
            ["stat"].concat(season ? ["season"] : []).forEach(function (scope) {
                var name = scope + "_pass_" + field;
                if (r.ds_map_exists(map, name)) r.ds_map_set(map, name, 0);
            });
        });
    }
    function eligible(map) { return [2, 3, 4].indexOf(value(map, "position")) >= 0; }
    function isNonQbSack(ball) {
        var p = ball.gmlstate === 11 && r.GetWithArray(ball.gmlholder)[0];
        return !!(p && r.yyGetBool(p.gmlpmap) && value(p.gmlpmap, "position") !== 1);
    }
    function select() {
        var c = r.GetWithArray(98)[0];
        c.gmlstat_view = 3;
        c.gmlco_stats_tab = 0;
        r.room_goto(r.asset_get_index("rm_stats_player"));
    }
    function button(inst, x, y) {
        var id = r.instance_create_layer(x, y, "Instances", r.asset_get_index("obj_button_9s"));
        var b = r.GetWithArray(id)[0], c = r.GetWithArray(98)[0];
        b.image_xscale = 2.35;
        b.gmltext = r.gml_Script_s_str(inst, inst, "ui_Passing");
        b.gmlonClickAction = select;
        if (c.gmlco_stats_tab === 0 && c.gmlstat_view === 3) b.gmlcolour = r.global.gmlc_primary;
    }
    function populate(inst, opponent, games) {
        var c = r.GetWithArray(98)[0];
        if (c.gmlstat_view !== 3 || !eligible(inst.gmlpmap)) return false;
        var scope = ["stat", "season", "career"][inst.gmlstat_type], map = inst.gmlpmap;
        function stat(field) { return value(map, scope + "_pass_" + field); }
        function line(label, number) {
            r.ds_list_add(inst.gmllines, r.gml_Script_s_str(inst, inst, label) + ": " + number);
        }
        r.ds_list_add(inst.gmllines, "shad_" + r.gml_Script_s_str(inst, inst, "ui_Passing"));
        if (opponent) r.ds_list_add(inst.gmllines, opponent);
        if (games !== "") line("ui_stat_games", games);
        line("ui_stat_attempts", stat("attempts"));
        line("ui_stat_complete", stat("complete") + (stat("attempts") ? " (" + Math.round(stat("complete") / stat("attempts") * 100) + "%)" : ""));
        line("ui_stat_yards", Math.round(stat("yards")));
        line("ui_stat_average", r.gml_Script_s_get_string_float(inst, inst, stat("complete") ? stat("yards") / stat("complete") : 0, 1));
        line("ui_stat_longest", Math.round(stat("longest")));
        line("ui_stat_touchdowns", stat("touchdowns"));
        line("ui_stat_int", stat("int"));
        line("ui_stat_sacks", stat("sacks"));
        return true;
    }
    r.RetroPassingStats = { add: add, longest: longest, passer: passer, complete: complete,
        tally: tally, reset: reset, eligible: eligible, isNonQbSack: isNonQbSack, button: button, populate: populate };
})(window);
