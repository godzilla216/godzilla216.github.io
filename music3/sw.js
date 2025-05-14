const CACHE_NAME = 'music-cache-v1';
const FILES_TO_CACHE = [
  '/',
  'music3/index.html',
  'music3/script.js',
  'music3/Audio/song1.m4a',
  'music3/Audio/song2.mp3'
];

self.addEventListener('install', (e) => {
  e.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(FILES_TO_CACHE);
    })
  );
});

self.addEventListener('fetch', (e) => {
  e.respondWith(
    caches.match(e.request).then((response) => {
      return response || fetch(e.request);
    })
  );
});
