# retro-bowl-college

This local GameMaker HTML5 export includes real team and competition names, live defensive gameplay and the previously restored Sim Game option. Advertising remains disabled.

## Play locally

With Node.js installed, run:

```powershell
node scripts/serve.cjs
```

Open **http://127.0.0.1:8080/**. Serve the game over HTTP so its text files, textures and audio can load. Stop the server with Ctrl+C. No dependencies need to be installed.

## Real names

All 261 college teams use their real school identities and abbreviations. The conference, division, bowl and championship labels have been replaced across all 32 conference records and 112 competition records, including retired entries and the three playoff rotations. Examples include Durham → Duke, Annapolis → Navy, Waco → Baylor, Large X → Big Ten and Lilac Bowl → Rose Bowl. Pro draft destinations use the full names of all 32 NFL teams. Award messages now name real awards such as the Heisman Trophy, Davey O'Brien Award and Doak Walker Award.

The naming follows the bundled 2023-era roster and bowl locations. IDs, affiliations, scheduling, playoff structure, uniforms and gameplay rules retain their existing values; this is a naming update rather than a conference realignment. Complete longer names scale down to fit existing screen columns. FBS/FCS labels are separate from the academic MAJOR/MINOR fields.

Existing careers migrate names and abbreviations that match the original defaults when loaded. This also covers uniform files, save-slot labels and default names rebuilt by the native editor. Distinct custom team, conference, bowl and subdivision names remain intact. The migration adds no save keys. `html5game/real-names.js` contains the mappings and compatibility hooks; `node scripts/update-real-names.cjs` reproduces the display fields in the text data files.

Identity references: [Bowl Season's 2023–24 schedule](https://bowlseason.com/sports/bowl/schedule/2023-24), [CAA's 2023 name announcement](https://caasports.com/news/2023/7/20/football-caa-changes-official-conference-name-to-coastal-athletic-association.aspx), [Southland's 2023 teams](https://www.southland.org/news/2023/7/20/football-southland-announces-2023-all-conference-team.aspx), [NEC's 2023 football report](https://s3.amazonaws.com/sidearm.sites/northeastconference.org/documents/2023/10/16/NECFB_Weekly_Release_Week_7.pdf), [NCFAA awards](https://vault.ncfaa.org/awards/list), [Shaun Alexander Award](https://shaunalexander.com/the-shaun-alexander-award/) and [NFL team directory](https://support.nfl.com/hc/en-us/articles/40080288031380-What-are-the-official-websites-of-all-NFL-teams).

Verified with:

```powershell
node --check html5game/RetroBowl.js
node --check html5game/real-names.js
node --test tests/real-names.test.cjs tests/defense.test.cjs
node tests/real-names.browser.cjs
node tests/defense.browser.cjs
```

Results: **19 unit checks and 39 browser checks passed**, with no runtime errors or external requests. Naming checks load every identity through the native engine, save/reload legacy names while preserving custom names and career records, verify award/subdivision text, and render the league screens. The ACC and SWAC screenshots were visually reviewed, including the full Mississippi Valley State label. The touch regression fixture waits for a native stick anchor and separates other defenders from the carrier so an unrelated tackle cannot end the movement check.

## Defensive gameplay and controls

In a normal coaching career, opposing possessions now enter the field instead of simulating through commentary. A yellow ring identifies your defender. Choose a formation and call before snapping; play ends and the next down or possession follows the existing football rules.

| Action | Keyboard | Mouse / touch | Controller |
| --- | --- | --- | --- |
| Move | WASD or arrow keys | Hold and drag on the field | Left stick |
| Switch defender | Q | SWITCH | X / square |
| Snap / attempt tackle | Space or Enter | SNAP / TACKLE | A / cross |
| Cycle formation before snap | F | Formation button | Left shoulder |
| Cycle call before snap | C | Call button | Y / triangle |

Formations: Auto, 4-3, 3-4, nickel and dime. Calls: balanced, run, pass and blitz. Auto uses distance, field position and available receivers. Uncontrolled linemen pressure the quarterback, linebackers cover gaps or blitz, corners cover receivers, and safeties protect deep zones. Defenders pursue runs and pass landing positions, separate from teammates, and react to turnovers. Opponent quarterbacks drop back, choose receivers, throw through the existing ball physics, hand off, or scramble.

Contact tackles require a live opposing ball carrier within range. Space offers a larger but limited tackle range with a missed-attempt cooldown. Native stiff arms can break tackles. Rating-based, reproducible fumble opportunities feed the original loose-ball system. Existing catch validation determines receptions, tips and interceptions; position, distance, height and field bounds still apply. Interception returners become controllable, and native rules handle touchdowns, safeties, spots, downs, possession, clock and quarter transitions. Named defenders receive existing tackle, sack and interception statistics.

## Architecture and files changed

The project contains an exported JavaScript GameMaker runner and game code, four texture atlases, audio, text-based rosters/strings/schedules, and editor configuration. It has canvas-based rendering, native player acceleration/friction, role-specific AI, ball physics, catch tests, and centralized play-result/possession functions. There is no original GameMaker project, package manifest, build pipeline, linter or type-checker configuration.

| File | Purpose |
| --- | --- |
| `html5game/defense.js` | Separate defensive controls, assignments, AI, CPU offense, contact handling, stat credit and temporary play state. Also exports pure logic for unit tests. |
| `html5game/opponent-rosters.js` | Career-owned opponent offensive stars, native field placement, save/reload and annual graduation/recruitment. |
| `html5game/RetroBowl.js` | Small integration hooks at live-possession selection, play setup/reset, movement, tackling, ball control, catches, draw events and offensive record credit. Native football rules remain responsible for results. |
| `index.html` | Loads the defense module before GameMaker starts. |
| `scripts/serve.cjs` | Dependency-free local HTTP server. |
| `tests/defense.test.cjs` | Unit tests for assignments, eligibility, pursuit, spacing, tackle validity, passing physics and reproducible fumbles. |
| `tests/browser-harness.cjs` | Isolated Chrome/Chromium session, local asset server, real input dispatch, error/network capture and optional screenshots. |
| `tests/defense.browser.cjs` | Native-engine integration, gameplay, controls, resets, transitions and offensive regression checks. |
| `README.md` | Controls, implementation notes, validation and limitations. |

Defensive control state belongs to the current match controller and is replaced for each play. Opponent offensive stars belong to the career and are saved in the optional `opponent_rosters_v1` key in the native save file, including backups. Existing careers generate each school's roster when first encountered. Each opponent has a QB, RB, TE, two WRs and two OL, using native names, ratings, appearances and field assignment. School UID identifies returning opponents even after name edits or home/away changes. Returning players age each season; seniors graduate at the same native age limit as the user's players and are replaced by freshmen. Tracked schools advance even during seasons without a matchup. Each save slot owns its own opponent rosters, and new careers start fresh. Existing offensive controls and gameplay remain on their original paths. Quarterback career mode, practice, pass-and-play exhibition, and Sim Game retain their existing possession behavior.

Opponent roster validation: **38 defensive browser checks passed** with no runtime errors or external requests, including all seven stars on the field, repeat matchups, native career save/reload, native season rollover and graduation across skipped matchup seasons. The combined defense and naming unit suite also passed all **19 checks**.

## Verification performed

Commands run with Node.js **v24.19.0**:

```powershell
node --check html5game/RetroBowl.js
node --check html5game/defense.js
node --check scripts/serve.cjs
node --test tests/defense.test.cjs
node tests/defense.browser.cjs --screenshots
node scripts/serve.cjs
```

Results: all three syntax checks passed, **13 unit tests passed**, and **33 browser integration checks passed** with no game runtime errors or external requests. The local server returned HTTP 200 for the page and defense module. The browser harness loaded and launched the actual game and captured pre-snap/live screenshots for visual review. There is no additional compilation command for this static export; a GameMaker editor rebuild cannot be performed without its original project.

Integration checks include real keyboard movement and switching, real emulated touch snapping/dragging, mocked controller input (including the browser fallback), live opponent entry from ordinary commentary, actual AI pursuit and an unforced CPU play outcome. Constructed native-engine situations verify one-time tackles, rejection of non-carriers, sacks/losses, first downs, completions, incompletions, interception validation/returns, fumble recovery, stiff arms, both touchdown directions, safety points, field-goal makes/misses, turnovers on downs, ticking clocks, quarter/halftime transitions, match completion and restart, and rapid inputs. The end-of-game fixture includes the native quarter score ledger and the existing Continue action.

The offensive regression check compares seeded human offensive placements, acceleration values and twenty frames of native passing physics with the defense hooks inert versus enabled; the snapshots match exactly. It is a focused regression check, not a claim that every career/season situation has been exhaustively played.

## Review fixes and limitations

Review and testing corrected:

- CPU passes initially reached receivers too low; they now cross at a native catchable height before landing.
- Offensive audible/kickoff controls could survive defensive setup; cleanup now runs after button creation, and opponent routes are hidden.
- Touch-to-mouse transitions could lose a press edge; per-device pointer handling and held-drag recovery prevent a stalled virtual stick.
- A pending play-result alarm could reference a ball destroyed by a reset; defensive cleanup cancels it.
- CPU touchdowns could inflate the user's touchdown counter/records; offensive credit is suppressed during live opposing plays.
- The fourth-down CPU kick path initially selected the PAT commentary state; field goals now use the native three-point path.

Opponent punts, field goals, point conversions and kickoff decisions use the original simulation/commentary system; special teams are not a new manually controlled defensive mode. Formation roles use the existing generic/player roster attributes and animations rather than introducing a new college depth chart or substitutions system. Defense is added to coaching gameplay, not quarterback career or practice. A physical controller and real mobile hardware were not available: controller reads were tested with mocked native APIs, and touch was tested with Chromium touch emulation. Full-season balance, every overtime scenario and all browsers/devices remain unverified. The original GameMaker project is unavailable, so this is an extension of the readable HTML5 export, not an editor-source rebuild.
