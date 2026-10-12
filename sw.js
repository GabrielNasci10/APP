// Service worker da Stoa: permite abrir a aplicação sem internet.
const CACHE = 'stoa-v1';
const ASSETS = [
  './',
  './index.html',
  './manifest.webmanifest',
  './icon/stoa.svg',
  './icon/stoa-192.png',
  './icon/stoa-512.png',
  './icon/stoa-maskable-512.png',
  './icon/apple-touch-icon.png'
];
// Recursos externos versionados (SDK do Firebase e fontes): guardados após o primeiro uso.
const EXTERNAL = ['www.gstatic.com', 'fonts.googleapis.com', 'fonts.gstatic.com'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(ASSETS)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(caches.keys()
    .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
    .then(() => self.clients.claim()));
});

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);

  // Página: rede primeiro (para receber atualizações), cópia guardada sem internet.
  if (req.mode === 'navigate' && url.origin === location.origin) {
    e.respondWith(fetch(req)
      .then(res => { const copy = res.clone(); caches.open(CACHE).then(c => c.put('./index.html', copy)); return res; })
      .catch(() => caches.match('./index.html')));
    return;
  }

  if (url.origin !== location.origin && !EXTERNAL.includes(url.hostname)) return;
  if (url.hostname === 'www.gstatic.com' && !url.pathname.startsWith('/firebasejs/')) return;

  // Restantes ficheiros: cópia guardada primeiro, rede como alternativa.
  e.respondWith(caches.match(req).then(hit => hit || fetch(req).then(res => {
    if (res.ok || res.type === 'opaque') { const copy = res.clone(); caches.open(CACHE).then(c => c.put(req, copy)); }
    return res;
  })));
});
