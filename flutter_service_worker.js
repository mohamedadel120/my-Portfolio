'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "bf0967bb001e89cefc8ad868f0cb5116",
"assets/AssetManifest.bin.json": "6fb26c8cd1ad449fe3398f013768bcb2",
"assets/AssetManifest.json": "525330e07fea0a2f5b832ac81af781bd",
"assets/assets/images/3.png": "b57cd8d911871a6fbafc43b37c6dc7d4",
"assets/assets/images/4.png": "db10701892b263b88154d354994fdad1",
"assets/assets/images/adruse/Calendar%2520-1.png": "bdd43a78bb0122c294d56a4691f4a6b9",
"assets/assets/images/adruse/Calendar%2520-5.png": "2ff3f06d2dff2468acfa71a8c87eafbf",
"assets/assets/images/adruse/Downloads%2520-1.png": "9a5bb233c910b5bb86eeccf9c6fa7636",
"assets/assets/images/adruse/Downloads%2520-6.png": "897dd6527baa2ffd3d856553526247e9",
"assets/assets/images/adruse/Home.png": "1c05cea100b1d7ce91f97dd461b6f4c8",
"assets/assets/images/adruse/image1.png": "dbc41c08f2be18b6d951e5826889ba5c",
"assets/assets/images/adruse/image2.png": "b954b902c8523675eaa9a88f0f0feaea",
"assets/assets/images/adruse/image3.png": "0b4147f5f7b25bd14db93002720c7532",
"assets/assets/images/adruse/image4.png": "72ec091ba7d5b7344cdc9062e4f73e88",
"assets/assets/images/adruse/image5.png": "9393c0a1d84c990528e8cd8d5985176d",
"assets/assets/images/adruse/Login-1.png": "173bfceb8971a3971d9ffabfce012d5c",
"assets/assets/images/adruse/Login-2.png": "2100bf5ec7b4129a516ce1b74fb500ed",
"assets/assets/images/adruse/Login-3.png": "90522c92df89bdfefe0fef8af37a55ae",
"assets/assets/images/adruse/Login.png": "cc1d36f304897ab809c727f25aed7f20",
"assets/assets/images/adruse/logo.png": "05279f63d26e44c2bd1d96cb00a2ac20",
"assets/assets/images/adruse/Primary%2520-%25203%2520-%2520Subjects%25201.png": "5184e42e9db7aa2fc2558f541b2d5ef8",
"assets/assets/images/adruse/Primary%2520-%25204%2520-%2520Subject%2520Cource%2520Page%25205.png": "62d95a8ec3054f7c90b243abd539a318",
"assets/assets/images/adruse/Primary%2520-1-1.png": "e014d49d468731142fc83ab02f6ba0a4",
"assets/assets/images/adruse/Primary%2520-1-2.png": "5d6076d72b72405cabab0eb06570359c",
"assets/assets/images/adruse/Primary%2520-1-3.png": "b4579ab913de1a22c97768229d2f301f",
"assets/assets/images/adruse/Primary%2520-1-4.png": "a1cb4387de2689a73c19a259c3ea5684",
"assets/assets/images/adruse/Primary%2520-1-5.png": "f5b4296c5229dfb6ac8f1204e84ed2aa",
"assets/assets/images/adruse/Primary%2520-1.png": "2d0cc204cbc2a406c4898653d0524e44",
"assets/assets/images/adruse/Primary-%25204%2520-%2520Subject%2520Cource%2520Page%25201.png": "b18948a50b6f4fc5eb5c52716b80375f",
"assets/assets/images/adruse/Profile.png": "5e1df0703bec680b0182c39e07dbbb1a",
"assets/assets/images/adruse/Side%2520Menu.png": "e38311417fedc227e69b8b7e5f8c2650",
"assets/assets/images/adruse/Subscribe-1.png": "7adca054cb244b0a1fb32505e9c503e7",
"assets/assets/images/adruse/Subscribe.png": "cb87e113d3592e7bd55f92c8cced1ff2",
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
"assets/fonts/MaterialIcons-Regular.otf": "5e8cf3b3b04b3722bd35c0a2f2fed8a9",
"assets/NOTICES": "be18a8a5af1bd03c1223cce11f06d760",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "8f147a1e2231fc0682dd85859d7c3738",
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
"flutter_bootstrap.js": "b1a65d748c1c689b956232d9ff1b4945",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "780e7cf6c37959f3ae997b85bb2b1d76",
"/": "780e7cf6c37959f3ae997b85bb2b1d76",
"main.dart.js": "9a654b6cf3263b73cae59c3b6660920e",
"manifest.json": "8fbfb271e927000657e5560100b3dc58",
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
