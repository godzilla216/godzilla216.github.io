const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {openGame} = require('./browser-harness.cjs');
async function main() {
    const game=await openGame(), ev=game.evaluate;
    const folder=fs.mkdtempSync(path.join(require('node:os').tmpdir(),'retro-real-names-'));
    let checks=0;
    const pass=name=>{checks++;console.log('PASS: '+name);};
    try {
        assert.equal(await ev(`(function(){var m=GetWithArray(98)[0];return ds_list_size(m.gmlteamlist)===293&&m.gmlconferences.every(function(c){return c.gmlname===RetroNames.data.conferences[c.gmluid].name[1]})&&m.gmlcompetitions.every(function(c){return c.gmlname===RetroNames.data.competitions[c.gmluid].name[1]})&&Array.from({length:293},function(_,id){var t=gml_Script_s_get_team_by_id(m,m,id);return ds_map_find_value(t,'name')===RetroNames.data.teams[id].name[1]}).every(Boolean);})()`),true);
        pass('all real team, conference and competition names load into native game data');
        assert.deepEqual(await ev(`(function(){var m=GetWithArray(98)[0];return [gml_Script_s_get_subdiv_name(m,m,1),gml_Script_s_get_subdiv_name(m,m,2),gml_Script_s_str(m,m,'ui_Major'),gml_Script_s_str(m,m,'ui_Minor'),gml_Script_s_str(m,m,'cv_OutstandingPOTY'),gml_Script_s_str(m,m,'cvMilitary_QuarterbackPOTY')];})()`),['FBS','FCS','MAJOR','MINOR','Winner of the Heisman Trophy',"Winner of the Davey O'Brien Award"]);
        pass('subdivisions and award titles are real while academic major/minor labels work');
        await ev('(function(){var c=GetWithArray(98)[0];gml_Script_s_msg_clear(c,c);gml_Script_btn_click_Details_Continue(c,c);return true;})()');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_home"');
        const saved=await ev(`(function(){var m=GetWithArray(98)[0],navy=gml_Script_s_get_team_by_id(m,m,50),duke=gml_Script_s_get_team_by_id(m,m,34);m.gmlintro=0;m.gmlfirst_load=false;m.gmlfname_coach='NamesTest';ds_map_set(navy,'name','Annapolis');ds_map_set(navy,'tla','ANN');ds_map_set(navy,'wins',7);ds_map_set(duke,'name','Custom Blue Devils');ds_map_set(duke,'tla','XYZ');gml_Script_s_savegame(m,m);return {save:gml_Script_s_get_savename(m,m),team:Number(m.gmlmyteam_id),week:m.gmlweek,year:m.gmlyear,credits:m.gmlcoach_credit};})()`);
        await ev(`(function(){var m=GetWithArray(98)[0];gml_Script_s_loadgame(m,m,${JSON.stringify(saved.save)});return true;})()`);
        assert.deepEqual(await ev(`(function(){var m=GetWithArray(98)[0],n=gml_Script_s_get_team_by_id(m,m,50),d=gml_Script_s_get_team_by_id(m,m,34);return {navy:ds_map_find_value(n,'name'),tla:ds_map_find_value(n,'tla'),wins:ds_map_find_value(n,'wins'),custom:ds_map_find_value(d,'name'),customTla:ds_map_find_value(d,'tla'),team:Number(m.gmlmyteam_id),week:m.gmlweek,year:m.gmlyear,credits:m.gmlcoach_credit};})()`),{navy:'Navy',tla:'NAV',wins:7,custom:'Custom Blue Devils',customTla:'XYZ',team:saved.team,week:saved.week,year:saved.year,credits:saved.credits});
        pass('native save/reload upgrades old team aliases and preserves custom names, records and career progress');
        const editor=await ev(`(function(){var m=GetWithArray(98)[0],c=m.gmlconferences.find(function(c){return Number(c.gmluid)===5}),p=m.gmlcompetitions.find(function(c){return Number(c.gmluid)===1001});c.gmlname='Large X';c.gmltla='L.X';p.gmlname='Lilac Bowl';m.gmlcustom_data.gmlsubdivisions[1].gmlname='MAJOR';RetroNames.apply(m);var migrated=[c.gmlname,c.gmltla,p.gmlname,m.gmlcustom_data.gmlsubdivisions[1].gmlname];c.gmlname='My Conference';p.gmlname='My Bowl';m.gmlcustom_data.gmlsubdivisions[2].gmlname='My Division';RetroNames.apply(m);return {migrated:migrated,custom:[c.gmlname,p.gmlname,m.gmlcustom_data.gmlsubdivisions[2].gmlname]};})()`);
        assert.deepEqual(editor,{migrated:['Big Ten','B1G','Rose Bowl','FBS'],custom:['My Conference','My Bowl','My Division']});
        pass('legacy editor aliases migrate and custom conference, bowl and subdivision titles survive');
        await ev('(function(){var m=GetWithArray(98)[0];m.gmlcustom_data.gmlsubdivisions[2].gmlname="FCS";gml_Script_s_custom_data_patch(m,m);gml_Script_btn_click_League(m,m);return true;})()');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_league_college"');
        await game.sleep(250);await game.screenshot(path.join(folder,'league.png'));
        pass('native league screen renders real conferences and schools');
        // Show the longest school names in the bundled SWAC data.
        await ev(`(function(){var m=GetWithArray(98)[0],conf=m.gmlconferences.find(function(c){return Number(c.gmluid)===33}),params=__yy_gml_object_create(m,__yy_method(m,gml_Script____struct___21_s_btn_league_next_conference_gml_GlobalScript_s_college_league),0,2,conf);gml_Script_s_goto_room(m,m,g_pBuiltIn.room,params);return true;})()`);
        await game.until('GetWithArray(global.gmlrm)[0].gmlconfd.gmluid==33 && GetWithArray(global.gmlrm)[0].gmltier==2');
        await game.sleep(250);await game.screenshot(path.join(folder,'long-names.png'));
        const fit=await ev(`(function(){var text='Mississippi Valley State',w=string_width(text)*(global.gmlhd_fonts?0.25:1),scale=RetroNames.textScale(text,w);return w*scale<=96.001;})()`);
        assert(fit);
        pass('long school names render in the league screen');
        assert.equal(game.errors.length,0,JSON.stringify(game.errors));assert.deepEqual(game.external,[]);
        console.log(`${checks} real-name browser checks passed; no runtime errors or external requests.`);
        console.log('Screenshots: '+folder);
    } finally {await game.close();}
}
main().catch(error=>{console.error(error);process.exitCode=1;});


