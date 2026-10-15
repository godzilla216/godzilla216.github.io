# retro-bowl-college

This local GameMaker HTML5 export includes real team and competition names, live defensive gameplay, playable fourth-down punts and the previously restored Sim Game option. Advertising remains disabled.

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

CPU field goals now use the native kicking formation, approach, kick animation and ball physics. The camera shows the kick and uprights; longer attempts follow the ball. Makes award three points once and lead into a playable kickoff return in normal coaching careers, including when simulated kickoffs are selected. Misses give the human team first down. Simulation and quarterback careers retain their commentary flow. Run `node tests/cpu-field-goals.browser.cjs` to verify makes, misses, scoring, possession, kickoff launches and camera framing in both directions.

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

## Playable punts

Fourth down offers **Go for it**, **Field Goal**, and **Punt** through the native game dialog. Punt starts at the current line of scrimmage. The kicking team has seven players on the line, three protectors behind it, and a punter 14.5 yards deep. Near the kicking team's end line, the punter's depth shortens to fit inside the field.

| Action | Keyboard | Mouse / touch |
| --- | --- | --- |
| Aim punt | Time the sweeping arrow; Up / Down or W / S adjusts it | Time the sweeping arrow or hold and drag vertically on the field |
| Set aim, then lock power and snap | Space or Enter, twice | Tap the bottom button twice, or release a field drag |
| Move after receiving | WASD or arrows | Hold and drag on the field |
| Call fair catch while punt is airborne | F | Tap FAIR CATCH |
| Dive during return | Space or Enter | Tap DIVE |

Punt aiming uses the field-goal arrowhead sprite, white aiming line, and translucent triangle. The arrow sweeps up and down at the field-goal skill/difficulty speed. Set aim to lock the direction while selecting power; the guide disappears when the snap sequence begins. The guide mirrors with the kicking direction.

The power meter starts after aiming. Locking power starts one ordered sequence: bend, backward airborne long snap, catch, short approach, drop, and kick at foot contact. Aim and power lock before the snap; subsequent input cannot restart the animation or launch a second ball. Every player uses existing game sprites through the normal renderer, including body variants and team uniforms. The snapper reuses the standing/crouching and placement frames, and the punter reuses standing, running and `spr_kick2` frames. There are no custom sprite drawings or new sprite assets. The export has no dedicated long-snap sprite, so its existing crouch/placement poses represent the snap while the actual ball travels backward to the punter. The receiving players and coverage reuse kickoff roles, AI, acceleration, blocking and return sprites. CPU punt commentary also enters this live sequence, allowing user returns.

Career direction follows possession relative to the human team's field orientation; exhibition uses the native possession/quarter direction. Native end-zone switches therefore mirror the punt. Punt horizontal launch speed uses the normal kickoff calculation at the same power and kicker attribute. Flight and ground movement reuse the native kickoff air drag, gravity, bounce energy loss, tumbling and bounce sounds. The punt arc remains adjusted for punt distance, and small bounces settle into a slowing roll.

A grounded punt stays live while bouncing, rolling or resting. A coverage player (the defensive-role/kicking team) must touch it to down it. Any receiving player (the offensive-role team) can scoop it before it is downed and run; human control switches to that actual carrier. Both teams pursue a loose punt, and a fair-catch call expires when the ball hits the ground. Fair catches start at the catch spot, sidelines use the crossing spot, downed punts use the coverage touch spot, and punt touchbacks start on the **20-yard line**. Return touchdowns and safeties use native scoring. The result alarm transfers possession once, sets first down and the distance, restores the normal field orientation, and prevents commentary from adding a simulated second return. The clock runs from the snap through flight, loose-ball pursuit and the return. No career save fields are added.

Implementation: `html5game/punts.js`, narrow integration hooks in `html5game/RetroBowl.js`, and the script include in `index.html`. Tests are `tests/punts.test.cjs` and `tests/punts.browser.cjs`. Browser screenshots of both formations and every animation stage are written to `artifacts/punts/`; these frames were visually reviewed, including backward snap travel and foot-contact launch in both directions.

Run the checks with:

```powershell
node --check html5game/RetroBowl.js
node --check html5game/punts.js
node --check tests/browser-harness.cjs
node --check tests/punts.browser.cjs
node --test tests/real-names.test.cjs tests/defense.test.cjs tests/punts.test.cjs
node tests/punts.browser.cjs
node tests/defense.browser.cjs
node tests/real-names.browser.cjs
```

The punt suite covers native fourth-down choices, both formation directions, animation order, continuous airborne snap travel, launch count under rapid input, actual controlled returns and fair catches, actual sideline/touchback flights, spotting/possession, running clocks, mouse/touch controls, opponent commentary, native end-zone switching, return scoring, and kickoff/field-goal/go-for-it regressions. It compares actual native kickoff speed and thirty frames of horizontal flight with punts at three power levels in both directions. Ground scenarios verify rising/repeated bounces, energy loss, resting without auto-downing, coverage touches, rejection of pickups after downing, and controllable pickups by receiving blockers in both directions. Some spotting/scoring/ground checks use constructed native-engine situations; live flight and controls are also exercised separately. Touch is tested with Chromium emulation, not a physical phone. Blocked punts and muffed returns are not simulated. Original GameMaker source, a build pipeline and a lint configuration are unavailable; syntax checks and the executable unit/browser suites validate the static export. Full-season balance and every overtime/device combination remain unverified.

The fourth-down dialog passes its callback IDs directly from the native game script. These exported IDs are global lexical constants, not properties of `window`; reading them from `window` previously supplied `undefined` and crashed `script_execute` on a menu click. Regression checks now click **Go for it**, **Field Goal**, and **Punt** using actual browser input and assert valid callbacks and resulting game states, rather than only invoking the action functions directly.

After the callback and sprite fixes, syntax checks passed, **22 unit tests passed**, **27 punt browser checks passed**, and **33 defense browser checks passed**. The browser suites reported no runtime errors or external requests. The punt suite also verifies that the custom player renderer is absent and that the contact frame uses the existing `spr_kick2` asset in both directions. Formation, punt direction, backward airborne snap and the entire catch/approach/drop/kick sequence were visually reviewed again from captured game frames in both directions using only the existing sprites. The crouch/placement poses approximate the snapper's motion because a dedicated long-snap asset is not present.

After the kickoff-speed and live-ground-ball update, all four syntax checks, **22 unit tests**, and **34 punt browser checks** passed. The browser suite reported no runtime errors or external requests, and retained its kickoff, field-goal and go-for-it checks. Bounces and receiving-blocker pickup returns were visually reviewed from captured game frames in both directions. Ground tests keep a ball live through 600 simulated movement steps without any player touching it, then verify that a coverage touch resolves it once or that a receiving player can pick it up and move under real keyboard input. The browser harness also cleans up its temporary browser/server if startup fails.

## Architecture and files changed

The project contains an exported JavaScript GameMaker runner and game code, four texture atlases, audio, text-based rosters/strings/schedules, and editor configuration. It has canvas-based rendering, native player acceleration/friction, role-specific AI, ball physics, catch tests, and centralized play-result/possession functions. There is no original GameMaker project, package manifest, build pipeline, linter or type-checker configuration.

| File | Purpose |
| --- | --- |
| `html5game/defense.js` | Separate defensive controls, assignments, AI, CPU offense, contact handling, stat credit and temporary play state. Also exports pure logic for unit tests. |
| `html5game/RetroBowl.js` | Small integration hooks at live-possession selection, play setup/reset, movement, tackling, ball control, catches, draw events and offensive record credit. Native football rules remain responsible for results. |
| `index.html` | Loads the defense module before GameMaker starts. |
| `scripts/serve.cjs` | Dependency-free local HTTP server. |
| `tests/defense.test.cjs` | Unit tests for assignments, eligibility, pursuit, spacing, tackle validity, passing physics and reproducible fumbles. |
| `tests/browser-harness.cjs` | Isolated Chrome/Chromium session, local asset server, real input dispatch, error/network capture and optional screenshots. |
| `tests/defense.browser.cjs` | Native-engine integration, gameplay, controls, resets, transitions and offensive regression checks. |
| `README.md` | Controls, implementation notes, validation and limitations. |

Defensive state belongs to the current match controller and is replaced for each play. It does not add keys to the career save format. Existing offensive controls and gameplay remain on their original paths. Quarterback career mode, practice, pass-and-play exhibition, and Sim Game retain their existing possession behavior.

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

Opponent field goals and punts play out on the field, and opponent scores lead into playable kickoff returns. Point conversions retain the existing commentary system. Formation roles use the existing generic/player roster attributes rather than introducing a new college depth chart or substitutions system. Defense and playable punts are added to coaching gameplay, not quarterback career or practice. A physical controller and real mobile hardware were not available: defensive controller reads were tested with mocked native APIs, and touch was tested with Chromium touch emulation. Full-season balance, every overtime scenario and all browsers/devices remain unverified. The original GameMaker project is unavailable, so this is an extension of the readable HTML5 export, not an editor-source rebuild.
