import poll from '../dist/cloudflare/poll.js';

// A public Worker must never trust the Sites proxy's account-identity header.
export default {
  fetch(request, env) {
    return poll.fetch(request, {...env, BROWSER_VOTERS_ONLY: true});
  }
};
