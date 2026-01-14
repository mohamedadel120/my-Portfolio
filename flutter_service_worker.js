'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "04de67cea1464e7dad0346eb06facb7f",
".git/config": "741adfb8c3818efaa8f81a3b8034b2c2",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/FETCH_HEAD": "cc9d709e9b158ca3ec7fa2f125e974db",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "28fb208bc1015c73d30a6bc47168c5c5",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "773a5fdd2a452aebfdb96c4dd5bb52f5",
".git/logs/refs/heads/main": "773a5fdd2a452aebfdb96c4dd5bb52f5",
".git/logs/refs/remotes/origin/HEAD": "312d59ecad0bdea3ff5104d2ad5b4acf",
".git/logs/refs/remotes/origin/main": "680b7b09763347dc50de40f4ec10e723",
".git/objects/04/4d8c4cfce7e861aadf2e77bf2c9506f92ed911": "4ae67208f7199b585412c20d06e051e7",
".git/objects/08/bd19d4dbf75eb279c4ba909a37934517d42479": "39c69b5c430b80fffe909464b0c6d31f",
".git/objects/10/aec05d7056bd8e2f9501586773cf2b3e45816e": "8a9296f9d801a03a56479147725e6e50",
".git/objects/13/5a3edfa09382f745124837f93b64d60cbc5b70": "4e3bc01c0484d903ddbad86782a90984",
".git/objects/20/25a3134176f2e518fc1ff41baf8a95a7a5c18b": "556660a318feba90fcd727565d8e14db",
".git/objects/28/34d49f3754d0164e44535054faf92b383ac7be": "28ba92db8e3a2e93763e545b9782b88b",
".git/objects/2e/aef7403dfacefaf0cd81585ecad3c6241e4c1a": "60022afd6d5a35e31892719026c90da8",
".git/objects/2e/c7e2ef3ac88762b746a414f17d988b81296db5": "ab499b723d817fdb149281a112102b15",
".git/objects/35/65a36f3ed4a188e50072231a8e72d43758122f": "fc14466f4fac56f8db4ec22c302b8a98",
".git/objects/3b/ca68f18acb7b9b9cb1052207984c3cfae82953": "415effc4273e8e20ab98492f1ca80837",
".git/objects/59/04d8eb2f1136b7cf672246fd143d5c477fdc7e": "ea29a05dc7fc4f861bfa5203b3d682e2",
".git/objects/60/1b0a68283f1747dc0ed23bbc5471060791780c": "67e3875008593d6a8b412a6347db7138",
".git/objects/61/12656d1f17e76cccef3b0e3af37f008ee412a5": "d60b0a589de13b0f0116aee264c97ad2",
".git/objects/79/2367f33f63852487d6623437ea3064c6faa5e8": "205d3ed61a5d56ce66e9403c6ffc8724",
".git/objects/7c/e1bcab73c29a7ba8ae5eb4eef1b1bce8fa65f0": "bb78b26e3041d18e71f8952d4cb16513",
".git/objects/8a/38c5a52b175d3e62ef3befae4dd18ffa104c63": "815be55fdceabb32c19fbe2ff4af569e",
".git/objects/91/7bbb5eea2512fbe075c54dd2265e4e1628c72c": "7dd0399b36befd75e6043b29ae92e17a",
".git/objects/91/edb27af511a7fa05694432f3757400f5b0fd57": "5eacf9691290254a6506b11e499e689d",
".git/objects/94/5b86e9d619c810bf2275ac99a7d91dc5740e2d": "cf0b86aa8a33918a83babff7db0f43bb",
".git/objects/9b/6ee4f6c833f96062bbe4ed182efc4a3e7b15d2": "bbbdb733bf5cdf299667d3a0c0a4d65c",
".git/objects/ac/7faacc529a683729afb3b98bb5bd2a55d5b13c": "521e689030acb39740be5bead75112c4",
".git/objects/b3/f1f5bda5eb686354efcb5d29b9cd5f68c07968": "9f2cc1bd81cf78e0358b17ba375454c7",
".git/objects/bf/5323142639775fad92cdb2b0d535f251510b84": "bd7208a05a30cd42cc39aecd5f491cdf",
".git/objects/c8/97674439c0a3074a9b911c707f15645d6149cc": "15b2bac48b5834ad5b4b4b32b7d82be1",
".git/objects/e3/be8468cfb22e62b1e73e8c2dc756f992ff481d": "c09754a308e4d151e52b86372e722493",
".git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391": "c70c34cbeefd40e7c0149b7a0c2c64c2",
".git/objects/f6/d8fb442326e156385aa181010a193e65b38852": "0850984c631ff7d161f0906ad8baf5d3",
".git/objects/pack/pack-6cf1c343cee52d353501a632b2ae2fda412c0b49.idx": "253587f737cfc1bec4446adb61643066",
".git/objects/pack/pack-6cf1c343cee52d353501a632b2ae2fda412c0b49.pack": "f85cd235a36bd854b4336f3ccee2fda4",
".git/objects/pack/pack-6cf1c343cee52d353501a632b2ae2fda412c0b49.rev": "2247c29804613c0e8c9fea172fce5ac7",
".git/ORIG_HEAD": "f3ffb491975ac24348d199ce473b4d94",
".git/packed-refs": "6af21c61b93016ec538d1694002d37df",
".git/refs/heads/main": "f3ffb491975ac24348d199ce473b4d94",
".git/refs/remotes/origin/HEAD": "98b16e0b650190870f1b40bc8f4aec4e",
".git/refs/remotes/origin/main": "f3ffb491975ac24348d199ce473b4d94",
"assets/AssetManifest.bin": "ac69e0e48c418d7d445598717377568f",
"assets/AssetManifest.bin.json": "fd7dc27a95feece05e9e20128eb8cf4d",
"assets/AssetManifest.json": "06c626bf6215c36c421672af121fff0c",
"assets/assets/images/3.png": "b57cd8d911871a6fbafc43b37c6dc7d4",
"assets/assets/images/4.png": "db10701892b263b88154d354994fdad1",
"assets/assets/images/adruse/image1.png": "dbc41c08f2be18b6d951e5826889ba5c",
"assets/assets/images/adruse/image2.png": "b954b902c8523675eaa9a88f0f0feaea",
"assets/assets/images/adruse/image3.png": "0b4147f5f7b25bd14db93002720c7532",
"assets/assets/images/adruse/image4.png": "72ec091ba7d5b7344cdc9062e4f73e88",
"assets/assets/images/adruse/image5.png": "9393c0a1d84c990528e8cd8d5985176d",
"assets/assets/images/adruse/logo.png": "05279f63d26e44c2bd1d96cb00a2ac20",
"assets/assets/images/albatal/image1.webp": "fb5484640b0c930aeeb466767e001a16",
"assets/assets/images/albatal/image10.webp": "6e737eb988033bfb78f0f3ba180a1d72",
"assets/assets/images/albatal/image11.webp": "5dce55812602c9cb820fafd16121d6ed",
"assets/assets/images/albatal/image12.webp": "f23c542a3cfd58840126bf31f8ec134e",
"assets/assets/images/albatal/image13.webp": "c42763559aab5872b8a23655fcebc47c",
"assets/assets/images/albatal/image14.webp": "56f47b8e6c1ff2c6b16c3778c048cff3",
"assets/assets/images/albatal/image15.webp": "f4ee5e7655236a41bcbcb1f9141d1680",
"assets/assets/images/albatal/image16.webp": "b3df493e7042607bb52fdd734e5ab4a9",
"assets/assets/images/albatal/image17.webp": "1e9927d8b9f2022c6e2a6098be14f5d1",
"assets/assets/images/albatal/image2.webp": "3934d91f7abbe17499be6ba4dc55dbc7",
"assets/assets/images/albatal/image3.webp": "a00e6d4878e9cc50a6d48947ba4ad3a2",
"assets/assets/images/albatal/image4.webp": "a13a1b87d787abfdf330db3205fe5f48",
"assets/assets/images/albatal/image5.webp": "b05cd6af8503050d3ff2bb40014265f1",
"assets/assets/images/albatal/image6.webp": "8760e600981a29449072d197dee9e351",
"assets/assets/images/albatal/image7.webp": "2a08d8a7a2e380436dbccac957a580f2",
"assets/assets/images/albatal/image8.webp": "49400f3a6981c43caf2dcaf6dc2da3b5",
"assets/assets/images/albatal/image9.webp": "b3df493e7042607bb52fdd734e5ab4a9",
"assets/assets/images/gomla/image1.webp": "6e1928d1998b203b90024ac14661c686",
"assets/assets/images/gomla/image2.webp": "5cec752e1241c6e7d5d90f1d83d3358f",
"assets/assets/images/gomla/image3.webp": "0c5be4abc60652bea627756d16925e77",
"assets/assets/images/gomla/image4.webp": "148762cc6445590f5d987f475ee93b90",
"assets/assets/images/gomla/logo.webp": "0820bec7e0bd29cb3c3edb5cf0d6aba1",
"assets/assets/images/paletta/image1.webp": "8213eb0314a20388ac72b68972aab62b",
"assets/assets/images/paletta/image2.webp": "649e27b26c62d15315534d30af6e71a8",
"assets/assets/images/paletta/image3.webp": "919633e24333053db45ff9ecc3505c39",
"assets/assets/images/paletta/image4.webp": "8c121950bd9481a5653cbad044307d58",
"assets/assets/images/paletta/image5.webp": "a75d1e81ff269b13a70aaaa9ef0fa622",
"assets/assets/images/paletta/image6.webp": "a4f484aab8c032ae338647b2859162ba",
"assets/assets/images/paletta/image7.webp": "808b6e322bade237a8d17c312d1bb03e",
"assets/assets/images/paletta/logo.webp": "8213eb0314a20388ac72b68972aab62b",
"assets/assets/images/stock/image1.webp": "82c7eff7d2fee4855e2263fc327085b6",
"assets/assets/images/stock/image2.webp": "419624f0aef4d2ce9b5906daf15ac583",
"assets/assets/images/stock/image3.webp": "a451595521c0ae6115ab596f85507a37",
"assets/assets/images/stock/image4.webp": "3081ff4cb8cb1f6296b2c03e49867118",
"assets/assets/images/stock/image5.webp": "6264976343af07cc347c797bd374ee36",
"assets/assets/images/stock/image6.webp": "3be85f1006491d1b93fa6267fe513fd2",
"assets/assets/images/stock/image7.webp": "1b865809428a57a7c75b74e75d20835d",
"assets/assets/images/stock/image8.webp": "5ffb7478939cfed957fbcc9caa6cbd97",
"assets/assets/images/stock/logo.webp": "01b51b9e4372005e0fb0bfef4577c4ce",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "f1c760987a9b101aed3fe9ee8c76853a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b93248a553f9e8bc17f1065929d5934b",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "15d54d142da2f2d6f2e90ed1d55121af",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "262525e2081311609d1fdab966c82bfc",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "269f971cec0d5dc864fe9ae080b19e23",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "fdf7364d3a25b769c99bd2209327c4c7",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "b4ed8c0b2710f8d6d450e92dcd3757c2",
"/": "b4ed8c0b2710f8d6d450e92dcd3757c2",
"main.dart.js": "1391e84f6d3c78cd270902a2f2beb57c",
"manifest.json": "3ea79447129c8f52f0ac2adbc1138549",
"version.json": "a32cbe89d51a3e073bba58946809702f"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
