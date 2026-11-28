// SimulaBr - service worker: deixa instalar o jogo no celular e abrir mais rápido.
//  - página e código (html, manifesto, ajustes): rede primeiro, para nunca prender uma versão velha; sem internet, a cópia;
//  - arquivos pesados (ônibus, texturas, sons, a biblioteca 3D): sai na hora da cópia do aparelho e a cópia é
//    atualizada por trás (quando um ônibus muda, a versão nova aparece na abertura seguinte).
const CACHE = 'simulabr-v2', PESADOS = 'simulabr-arquivos-v2';
self.addEventListener('install', (e) => { self.skipWaiting(); e.waitUntil(caches.open(CACHE).then((c) => c.addAll(['./', './index.html', './manifest.webmanifest']).catch(() => {}))); });
self.addEventListener('activate', (e) => {
  e.waitUntil(caches.keys().then((ks) => Promise.all(ks.filter((k) => k !== CACHE && k !== PESADOS).map((k) => caches.delete(k)))).then(() => self.clients.claim()));
});
const ehPesado = (url, cdn) => /\.(glb|webp|png|jpe?g|mp3|woff2?)$/i.test(url.pathname) || cdn;
self.addEventListener('fetch', (e) => {
  const req = e.request, url = new URL(req.url);
  if (req.method !== 'GET' || req.headers.has('range')) return;
  const mesmoSite = url.origin === self.location.origin, cdn = url.hostname === 'cdnjs.cloudflare.com';
  if (!mesmoSite && !cdn) return;
  if (ehPesado(url, cdn)) {
    e.respondWith(caches.open(PESADOS).then(async (c) => {
      const guardado = await c.match(req);
      const rede = fetch(req).then((resp) => { if (resp.ok) c.put(req, resp.clone()); return resp; }).catch(() => guardado);
      if (guardado) { e.waitUntil(rede.catch(() => {})); return guardado; }
      return rede;
    }));
    return;
  }
  e.respondWith(fetch(req).then((resp) => {
    if (resp.ok) { const copia = resp.clone(); caches.open(CACHE).then((c) => c.put(req, copia)); }
    return resp;
  }).catch(() => caches.match(req, { ignoreSearch: true }).then((r) => r || caches.match('./index.html'))));
});
