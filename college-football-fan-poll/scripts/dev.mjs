import './build.mjs';
import {startServer, readOptions} from './server.mjs';

try {
  const server = await startServer(readOptions(process.argv.slice(2)));
  const address = server.address();
  const host = address.address.includes(':') ? '[' + address.address + ']' : address.address;
  console.log('Fan poll ready at http://' + host + ':' + address.port);
  for (const signal of ['SIGINT', 'SIGTERM']) {
    process.once(signal, () => server.close());
  }
} catch (error) {
  console.error('Could not start the fan poll: ' + error.message);
  process.exitCode = 1;
}
