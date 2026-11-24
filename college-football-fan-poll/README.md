# College Football Fan Poll

Requires Node.js 24 or newer. Local use needs no packages or database service.

## Run on localhost

Double-click `start.cmd`, or run `npm.cmd start` in this folder. Keep the server
running and open http://localhost:4173. On macOS/Linux, use `npm start`.

The local server serves both the app and its voting API. A static preview such
as Live Server cannot save ballots by itself. Opening the top-level `index.html`
locally sends you to http://localhost:4173, so start the server first.
Local ballots are saved in `.data/ballots.sqlite`.

## Your configured deployment

The voting API is deployed at
https://college-football-fan-poll-api.saturday-top25.workers.dev.
It uses your Cloudflare D1 database `college-football-fan-poll`, bound as `DB`.
Browser requests are allowed from `https://godzilla216.github.io` (including
repository sites hosted beneath that origin). This is a new poll database;
the original ChatGPT Sites ballots were not imported.

The Pages API URL is saved in `pages.config.json`. Run `npm.cmd run build:pages`
to regenerate `github-pages/`. The files in that folder are the frontend to
upload to GitHub Pages; `fan-poll-github-pages.zip` also contains those files.
Extract the ZIP before uploading. GitHub Pages does not extract ZIP uploads.

For a manual upload, upload the contents of `github-pages/` to your repository
root (or `docs/`). Then select that branch/folder in **Settings > Pages > Deploy
from a branch**. `index.html` must be directly inside the selected publishing
folder. The frontend files have also been uploaded to
[`fan-poll/` on your repository's main branch](https://github.com/godzilla216/godzilla216.github.io/tree/main/fan-poll)
in commit `41f2308ead6708d82006c555e82fa4ff37bd12fe`.
GitHub Pages is enabled and serves https://godzilla216.github.io/fan-poll/.
It also serves your uploaded source app at
https://godzilla216.github.io/college-football-fan-poll/app/.
The source configuration selects the deployed API on `godzilla216.github.io`
and keeps same-origin API requests for local development and Sites. Both Pages
entry points use the same browser voter token and shared Cloudflare database.
The source folder's top-level `index.html` directs hosted visitors to the built
poll and local visitors to the local server.
If you change the Pages domain, update `ALLOWED_ORIGIN` in `wrangler.jsonc`
and the direct-upload hostname in `app/config.js` before publishing again.

Local `npm.cmd start` continues to use its local SQLite database and same-origin
API; it does not send local votes to the deployed poll.

## Publish with GitHub Pages + Cloudflare D1

GitHub Pages serves the frontend. A separate Cloudflare Worker stores all visitors'
ballots in D1 and returns the shared rankings. The database binding is named `DB`;
the database itself is named `college-football-fan-poll`.

### 1. Create the database and deploy the API

These are setup instructions for a new Cloudflare account. This checkout's
Cloudflare deployment is already configured as described above.

In this project folder, run these PowerShell commands:

```powershell
npm.cmd ci
npx.cmd wrangler login
npx.cmd wrangler d1 create college-football-fan-poll
```

Use your existing database instead if you already have one. Creating a new D1
database does not import any ballots from the original hosted Site or local SQLite.

Edit `wrangler.jsonc`:

- Set `database_id` to the ID returned by the create command.
  Keep `binding` as `DB` and `migrations_dir` as `drizzle`. If Wrangler offers to
  add a binding, update this existing entry rather than adding a second one.
- Set `ALLOWED_ORIGIN` to your Pages origin, such as `https://yourname.github.io`.
  Leave out the repository path and trailing slash. Use your custom domain's
  origin instead if applicable.

Then run:

```powershell
npm.cmd run db:migrate
npm.cmd run deploy:api
```

The migration creates the `ballots` table. Copy the deployed Worker URL shown by
Wrangler, such as `https://college-football-fan-poll-api.example.workers.dev`.
Cloudflare sign-in and creation/deployment happen in your own account.

### 2. Publish the frontend

Choose either upload method:

**Upload files manually:** set `apiBaseUrl` in `pages.config.json` to your Worker
URL, then run `npm.cmd run build:pages`. Upload the **contents** of `github-pages/`
to your repository root (or its `docs/` folder). Include `index.html`, all JS/CSS
and JSON files, and the `assets/` folder. In repository **Settings > Pages**, select
**Deploy from a branch**, your branch, and the folder you uploaded into.
The generated `.nojekyll` file can be included when uploading with Git.

**Upload the source project:** upload this project's source to your repository,
including `.github/workflows/pages.yml`, `package.json`, and `package-lock.json`.
In **Settings > Secrets and variables > Actions > Variables**, add the repository
variable `POLL_API_URL` with your Worker URL, or use the saved URL in
`pages.config.json`. This URL is public configuration, not a secret. In
**Settings > Pages**, choose **GitHub Actions**. Push to `main`
or `master`, or run **Deploy GitHub Pages frontend** in the Actions tab. An empty
API URL in both places makes the build fail with a setup message, avoiding a broken deployment.

Do not upload `.data/`, `.wrangler/`, `node_modules/`, or credentials to Pages.
The `dist/` Worker bundle is for the API, not your Pages publishing folder.

### Voting behavior

Each browser receives an anonymous voter token stored on the Pages origin. It
can submit one editable ballot; updates replace its previous vote in D1. Requests
use that token so voting works without third-party cookies. The API accepts browser
requests only from the configured Pages origin. This is **not account sign-in**:
clearing browser storage or using a different browser creates another voter.
The original Sites deployment's trusted account header is ignored by the public
Cloudflare API. Weekly history and sign-in are not implemented.

Deployment references: [GitHub Pages workflows](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages),
[Cloudflare D1 setup](https://developers.cloudflare.com/d1/get-started/), and
[D1 migrations](https://developers.cloudflare.com/d1/wrangler-commands/#d1-migrations-apply).

## Run on Windows

Double-click `start.cmd` in this folder, keep its window open, and open
http://localhost:4173 in your browser.

From PowerShell, you can also run:

```powershell
npm.cmd start
```

Use `npm.cmd` on Windows if PowerShell blocks `npm.ps1`. On macOS/Linux, use `npm start`.
Stop the server with Ctrl+C. Run the start command again after editing source files.
Opening `app/index.html` directly will not work: voting needs the local server.

## Vote

Every team shows an independent 1-to-5-star resume rating in the directory,
ballot, rankings, and playoff bracket. Ratings use 2026 ESPN records and completed
game scores: 50% team win percentage, 30% opponents' average win percentage, and
20% performance against strong opponents. Stars equal `1 + 4 * weighted score`,
rounded to one decimal place. They do not change fan-poll points or seeds.

Opponent records exclude every head-to-head game against the team being rated.
A strong opponent has a win percentage of at least two-thirds across at least
three other games. Performance against those opponents combines 75% win
percentage and 25% scoring margin, with each margin capped at +/-21 and scaled
to 0–1. That component is 50% when no strong opponents have been faced; opponents
with no other games also count as 50%. Ties count as half a win. Both FBS and FCS
opponent records are included. Regular-season and postseason results count.

Ratings load independently of voting and are cached in the browser for one hour.
The voting API proxies only the allowed ESPN standings and team schedules, so
browser CORS restrictions do not block ratings. Successful source responses are
also cached by the server for an hour.
Use **Refresh ratings** to fetch fresh data. Missing, inconsistent, or unavailable
data shows **Rating unavailable**, and teams with no completed games show
**Not rated yet**. Expand **How team stars are calculated** for the formula or
hover over a team's stars for its breakdown.

Search or filter the directory, choose 25 teams, reorder them by dragging or using
the arrows, then submit. Fan Rankings awards 25 points for first place through
1 point for 25th. Updating a ballot replaces that visitor's previous vote.

The top 12 are highlighted on your ballot and in Fan Rankings. The Playoff
Bracket tab seeds the current fan-poll top 12, with first-round byes for seeds
1–4 and opening games of 8 vs. 9, 5 vs. 12, 6 vs. 11, and 7 vs. 10. This is a
fan-poll projection based on ranking order; later rounds show the advancing
game's winner as a placeholder.

Each browser profile keeps its own ballot using an HTTP-only cookie. Submitted
ballots are saved in `.data/ballots.sqlite` and survive server restarts. Keep this
folder to preserve the poll. Clearing cookies or using another browser creates
a new voter. Local voting does not provide account sign-in or enforce one vote
per person across browsers.

## Commands

```powershell
npm.cmd run dev
npm.cmd test
npm.cmd run build
npm.cmd run build:pages
npm.cmd run build:api
npm.cmd start -- --port 8080
```

The server defaults to `127.0.0.1:4173`. `PORT`, `HOST`, and `POLL_DB_PATH`
environment variables can override the port, listening address, and database
file. `--host` accepts an address; passing it without a value listens on all
interfaces. Build output is generated in `dist/`. The existing hosted Worker
configuration and D1 database migration remain available for Sites hosting;
local SQLite data is not uploaded by a build.
