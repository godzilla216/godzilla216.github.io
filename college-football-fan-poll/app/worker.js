const teams = JSON.parse(ASSETS['/teams.json'].body);
const teamById = new Map(teams.map(team => [team.id, team]));
const json = (value, status = 200) => Response.json(value, {
  status,
  headers: {'Cache-Control': 'no-store', 'X-Content-Type-Options': 'nosniff'}
});

async function handleApi(request, env, path) {
  const tokenMode = env.BROWSER_VOTERS_ONLY === true;
  const secure = new URL(request.url).protocol === 'https:';
  const cookieName = secure ? '__Host-fan-ballot' : 'fan-ballot';
  const accountId = tokenMode ? null : request.headers.get('oai-authenticated-user-id');
  const guestId = request.headers.get('Cookie')
    ?.split(';').map(cookie => cookie.trim()).find(cookie => cookie.startsWith(cookieName + '='))
    ?.slice(cookieName.length + 1);
  const validGuestId = /^[a-f0-9]{8}(?:-[a-f0-9]{4}){3}-[a-f0-9]{12}$/.test(guestId ?? '');
  const token = request.headers.get('Authorization')?.match(/^Bearer ([a-f0-9]{8}(?:-[a-f0-9]{4}){3}-[a-f0-9]{12})$/)?.[1];
  const voter = tokenMode ? (token && 'guest:' + token) : accountId || (validGuestId && 'guest:' + guestId);

  if (path === '/api/ballot' && request.method === 'GET') {
    if (!voter) {
      if (tokenMode) return json({teams: [], token: crypto.randomUUID()});
      const response = json({teams: []});
      response.headers.set('Set-Cookie',
        cookieName + '=' + crypto.randomUUID() + '; Path=/; Max-Age=31536000; HttpOnly; SameSite=Lax' + (secure ? '; Secure' : ''));
      return response;
    }
    const row = await env.DB.prepare('SELECT teams FROM ballots WHERE user_id = ?').bind(voter).first();
    return json({teams: row ? JSON.parse(row.teams) : []});
  }

  if (path === '/api/ballot' && request.method === 'PUT') {
    if (!voter) return json({error: 'Reload the poll to create a voter session before saving.'}, 400);
    const origin = request.headers.get('Origin');
    if (origin && origin !== (tokenMode ? env.ALLOWED_ORIGIN : new URL(request.url).origin)) {
      return json({error: 'Submit the ballot from the poll site.'}, 403);
    }
    if (!request.headers.get('Content-Type')?.toLowerCase().startsWith('application/json')) {
      return json({error: 'Send the ballot as JSON.'}, 415);
    }
    let picks;
    try {
      const body = await request.text();
      if (body.length > 4096) return json({error: 'The ballot is too large.'}, 413);
      picks = JSON.parse(body)?.teams;
    } catch {
      return json({error: 'The ballot could not be read.'}, 400);
    }
    if (!Array.isArray(picks) || picks.length !== 25 || new Set(picks).size !== 25 ||
        !picks.every(id => teamById.has(id))) {
      return json({error: 'Choose 25 different FBS teams.'}, 400);
    }
    await env.DB.prepare(`
      INSERT INTO ballots (user_id, teams) VALUES (?, ?)
      ON CONFLICT(user_id) DO UPDATE SET teams = excluded.teams, updated_at = CURRENT_TIMESTAMP
    `).bind(voter, JSON.stringify(picks)).run();
    return json({teams: picks});
  }

  if (path === '/api/rankings' && request.method === 'GET') {
    const {results} = await env.DB.prepare(`
      SELECT picks.value AS id,
             SUM(25 - picks.key) AS points,
             SUM(picks.key = 0) AS firsts,
             (SELECT COUNT(*) FROM ballots) AS count
      FROM ballots, json_each(ballots.teams) AS picks
      GROUP BY picks.value
    `).all();
    const rankings = results.filter(entry => teamById.has(entry.id))
      .sort((a, b) => b.points - a.points || b.firsts - a.firsts ||
        teamById.get(a.id).name.localeCompare(teamById.get(b.id).name))
      .slice(0, 25)
      .map(({id, points, firsts}) => ({id, points, firsts}));
    return json({count: results[0]?.count ?? 0, rankings});
  }

  if (path === '/api/ballot' || path === '/api/rankings') {
    return json({error: 'Method not allowed.'}, 405);
  }
  return json({error: 'Not found.'}, 404);
}

export default {
  async fetch(request, env) {
    const path = new URL(request.url).pathname;
    if (path.startsWith('/api/')) {
      const origin = request.headers.get('Origin');
      const tokenMode = env.BROWSER_VOTERS_ONLY === true;
      if (tokenMode && !env.ALLOWED_ORIGIN) {
        return json({error: 'The poll frontend origin has not been configured.'}, 503);
      }
      if (tokenMode && origin && origin !== env.ALLOWED_ORIGIN) {
        return json({error: 'Submit the ballot from the poll site.'}, 403);
      }
      let response;
      try {
        if (tokenMode && request.method === 'OPTIONS') {
          const method = request.headers.get('Access-Control-Request-Method');
          const headers = (request.headers.get('Access-Control-Request-Headers') || '').toLowerCase().split(',').map(value => value.trim()).filter(Boolean);
          response = !origin || !['GET', 'PUT'].includes(method) || headers.some(name => !['authorization', 'content-type'].includes(name))
            ? json({error: 'Method or headers not allowed.'}, 403)
            : new Response(null, {status: 204});
        } else {
          response = await handleApi(request, env, path);
        }
      } catch (error) {
        console.error('Poll database request failed', error);
        response = json({error: 'The poll database is unavailable. Please try again.'}, 503);
      }
      if (tokenMode) {
        response.headers.set('Vary', 'Origin');
        if (origin === env.ALLOWED_ORIGIN) {
          response.headers.set('Access-Control-Allow-Origin', origin);
          response.headers.set('Access-Control-Allow-Methods', 'GET, PUT, OPTIONS');
          response.headers.set('Access-Control-Allow-Headers', 'Authorization, Content-Type');
          response.headers.set('Access-Control-Max-Age', '600');
        }
      }
      return response;
    }
    const asset = Object.hasOwn(ASSETS, path) && ASSETS[path];
    if (!asset) return new Response('Not found', {status: 404});
    if (request.method !== 'GET' && request.method !== 'HEAD') {
      return new Response('Method not allowed', {status: 405});
    }
    const body = asset.binary ? Uint8Array.from(atob(asset.body), value => value.charCodeAt(0)) : asset.body;
    return new Response(request.method === 'HEAD' ? null : body, {
      headers: {
        'Content-Type': asset.type,
        'Cache-Control': asset.binary ? 'public, max-age=86400' : 'no-cache',
        'X-Content-Type-Options': 'nosniff'
      }
    });
  }
};
