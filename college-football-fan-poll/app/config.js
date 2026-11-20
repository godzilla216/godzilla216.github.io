// Direct uploads of app/ on this Pages host need the separate voting API.
// Local development and Sites continue to use their same-origin API.
// The dedicated Pages build reads its URL from pages.config.json.
export const API_BASE_URL = globalThis.location?.hostname === 'godzilla216.github.io'
  ? 'https://college-football-fan-poll-api.saturday-top25.workers.dev'
  : '';
