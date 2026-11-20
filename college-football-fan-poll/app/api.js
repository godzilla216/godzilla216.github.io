const validToken = value => /^[a-f0-9]{8}(?:-[a-f0-9]{4}){3}-[a-f0-9]{12}$/.test(value ?? '');

export function createPollApi({apiBaseUrl = '', fetchImpl = globalThis.fetch, storage} = {}) {
  const base = apiBaseUrl ? new URL(apiBaseUrl).origin : '';
  const key = 'fan-poll:voter:' + base;
  const voterStorage = () => storage ?? globalThis.localStorage;
  return async function read(path, options = {}) {
    const remote = Boolean(base && path.startsWith('/api/'));
    const headers = new Headers(options.headers);
    if (remote) {
      let token;
      try { token = voterStorage().getItem(key); }
      catch { throw new Error('Allow site storage and reload to save your ballot.'); }
      if (validToken(token)) headers.set('Authorization', 'Bearer ' + token);
    }
    const response = await fetchImpl(remote ? base + path : path, {
      ...options, headers, ...(remote ? {credentials: 'omit'} : {})
    });
    let data;
    try { data = await response.json(); }
    catch { throw new Error('The voting service is unavailable. Please try again later.'); }
    if (!response.ok) throw new Error(data.error || 'The request could not be completed.');
    if (remote && data.token) {
      if (!validToken(data.token)) throw new Error('The voter session could not be created. Please reload.');
      try { voterStorage().setItem(key, data.token); }
      catch { throw new Error('Allow site storage and reload to save your ballot.'); }
    }
    return data;
  };
}
