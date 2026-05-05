'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"splash_video.mp4": "49b5e776aee6e3020fbdcd94ecbe66b7",
"assets/assets/videos/README.md": "81d53494edd8692c26de9930350cfc9c",
"assets/assets/videos/x_d_a_d_c_f_e_a_c_camp_.mp4": "49b5e776aee6e3020fbdcd94ecbe66b7",
"assets/assets/videos/drugza_demo.mp4": "787ca29d3e12f4336d689a9ae63a1d9c",
"assets/assets/images/self_image.jpeg": "5d9ed13943119e3da21f55944ecdc71b",
"assets/assets/images/adruse/Calendar%2520-5.png": "2ff3f06d2dff2468acfa71a8c87eafbf",
"assets/assets/images/adruse/Login.png": "cc1d36f304897ab809c727f25aed7f20",
"assets/assets/images/adruse/Side%2520Menu.png": "e38311417fedc227e69b8b7e5f8c2650",
"assets/assets/images/adruse/image2.png": "b954b902c8523675eaa9a88f0f0feaea",
"assets/assets/images/adruse/Downloads%2520-1.png": "9a5bb233c910b5bb86eeccf9c6fa7636",
"assets/assets/images/adruse/Downloads%2520-6.png": "897dd6527baa2ffd3d856553526247e9",
"assets/assets/images/adruse/Primary%2520-1.png": "2d0cc204cbc2a406c4898653d0524e44",
"assets/assets/images/adruse/Primary%2520-1-3.png": "b4579ab913de1a22c97768229d2f301f",
"assets/assets/images/adruse/Login-2.png": "2100bf5ec7b4129a516ce1b74fb500ed",
"assets/assets/images/adruse/Primary%2520-%25203%2520-%2520Subjects%25201.png": "5184e42e9db7aa2fc2558f541b2d5ef8",
"assets/assets/images/adruse/Primary%2520-1-4.png": "a1cb4387de2689a73c19a259c3ea5684",
"assets/assets/images/adruse/Primary%2520-1-5.png": "f5b4296c5229dfb6ac8f1204e84ed2aa",
"assets/assets/images/adruse/image4.png": "72ec091ba7d5b7344cdc9062e4f73e88",
"assets/assets/images/adruse/logo.png": "05279f63d26e44c2bd1d96cb00a2ac20",
"assets/assets/images/adruse/Primary%2520-%25204%2520-%2520Subject%2520Cource%2520Page%25205.png": "62d95a8ec3054f7c90b243abd539a318",
"assets/assets/images/adruse/Primary%2520-1-1.png": "e014d49d468731142fc83ab02f6ba0a4",
"assets/assets/images/adruse/image3.png": "0b4147f5f7b25bd14db93002720c7532",
"assets/assets/images/adruse/Calendar%2520-1.png": "bdd43a78bb0122c294d56a4691f4a6b9",
"assets/assets/images/adruse/Profile.png": "5e1df0703bec680b0182c39e07dbbb1a",
"assets/assets/images/adruse/Subscribe.png": "cb87e113d3592e7bd55f92c8cced1ff2",
"assets/assets/images/adruse/image1.png": "dbc41c08f2be18b6d951e5826889ba5c",
"assets/assets/images/adruse/Primary%2520-1-2.png": "5d6076d72b72405cabab0eb06570359c",
"assets/assets/images/adruse/Login-3.png": "90522c92df89bdfefe0fef8af37a55ae",
"assets/assets/images/adruse/Primary-%25204%2520-%2520Subject%2520Cource%2520Page%25201.png": "b18948a50b6f4fc5eb5c52716b80375f",
"assets/assets/images/adruse/Subscribe-1.png": "7adca054cb244b0a1fb32505e9c503e7",
"assets/assets/images/adruse/Login-1.png": "173bfceb8971a3971d9ffabfce012d5c",
"assets/assets/images/adruse/image5.png": "9393c0a1d84c990528e8cd8d5985176d",
"assets/assets/images/adruse/Home.png": "1c05cea100b1d7ce91f97dd461b6f4c8",
"assets/assets/images/stock/image1.webp": "82c7eff7d2fee4855e2263fc327085b6",
"assets/assets/images/stock/image6.webp": "3be85f1006491d1b93fa6267fe513fd2",
"assets/assets/images/stock/logo.webp": "01b51b9e4372005e0fb0bfef4577c4ce",
"assets/assets/images/stock/image5.webp": "6264976343af07cc347c797bd374ee36",
"assets/assets/images/stock/image7.webp": "1b865809428a57a7c75b74e75d20835d",
"assets/assets/images/stock/image8.webp": "5ffb7478939cfed957fbcc9caa6cbd97",
"assets/assets/images/stock/image2.webp": "419624f0aef4d2ce9b5906daf15ac583",
"assets/assets/images/stock/image3.webp": "a451595521c0ae6115ab596f85507a37",
"assets/assets/images/stock/image4.webp": "3081ff4cb8cb1f6296b2c03e49867118",
"assets/assets/images/hi_gold/image6.png": "5b96b8516ebf1e26e7fc8c4017a86b74",
"assets/assets/images/hi_gold/image2.png": "2a3087d4e89d3ea77032d9555b299492",
"assets/assets/images/hi_gold/image7.png": "04e41c8e2aabdaa3c14346b52536e6be",
"assets/assets/images/hi_gold/image4.png": "f0b034df92be51077fb4883fedac2347",
"assets/assets/images/hi_gold/image3.png": "683e246304afe01a792c03d76e731773",
"assets/assets/images/hi_gold/image1.png": "7f3a1cb86ee43a37f3527c1af52dba7d",
"assets/assets/images/hi_gold/image8.png": "33b53a2bb78d8271e61ee80aeeadada8",
"assets/assets/images/hi_gold/image5.png": "3f6de71d2772a74fa799304df388f317",
"assets/assets/images/logo.png": "07598ec46d61ff976edd4fb054fbbdac",
"assets/assets/images/paletta/image1.webp": "8213eb0314a20388ac72b68972aab62b",
"assets/assets/images/paletta/image6.webp": "a4f484aab8c032ae338647b2859162ba",
"assets/assets/images/paletta/logo.webp": "8213eb0314a20388ac72b68972aab62b",
"assets/assets/images/paletta/image5.webp": "a75d1e81ff269b13a70aaaa9ef0fa622",
"assets/assets/images/paletta/image7.webp": "808b6e322bade237a8d17c312d1bb03e",
"assets/assets/images/paletta/image2.webp": "649e27b26c62d15315534d30af6e71a8",
"assets/assets/images/paletta/image3.webp": "919633e24333053db45ff9ecc3505c39",
"assets/assets/images/paletta/image4.webp": "8c121950bd9481a5653cbad044307d58",
"assets/assets/images/albatal/image1.webp": "fb5484640b0c930aeeb466767e001a16",
"assets/assets/images/albatal/image17.webp": "1e9927d8b9f2022c6e2a6098be14f5d1",
"assets/assets/images/albatal/image6.webp": "8760e600981a29449072d197dee9e351",
"assets/assets/images/albatal/image5.webp": "b05cd6af8503050d3ff2bb40014265f1",
"assets/assets/images/albatal/image7.webp": "2a08d8a7a2e380436dbccac957a580f2",
"assets/assets/images/albatal/image2.webp": "3934d91f7abbe17499be6ba4dc55dbc7",
"assets/assets/images/albatal/image3.webp": "a00e6d4878e9cc50a6d48947ba4ad3a2",
"assets/assets/images/albatal/image4.webp": "a13a1b87d787abfdf330db3205fe5f48",
"assets/assets/images/4.png": "db10701892b263b88154d354994fdad1",
"assets/assets/images/3.png": "b57cd8d911871a6fbafc43b37c6dc7d4",
"assets/assets/images/gomla/image1.webp": "6e1928d1998b203b90024ac14661c686",
"assets/assets/images/gomla/logo.webp": "0820bec7e0bd29cb3c3edb5cf0d6aba1",
"assets/assets/images/gomla/image2.webp": "5cec752e1241c6e7d5d90f1d83d3358f",
"assets/assets/images/gomla/image3.webp": "0c5be4abc60652bea627756d16925e77",
"assets/assets/images/gomla/image4.webp": "148762cc6445590f5d987f475ee93b90",
"assets/assets/images/logo1.png": "4799be466691a22a7c652e61de696d88",
"assets/assets/images/Gemini_Generated_Image_w1p5b6w1p5b6w1p5.jpg": "f8e1f8e71e4d355b1a92801574deb5bf",
"assets/AssetManifest.json": "50a7d0bf93addb9a8bdd9bc0353b9e5d",
"assets/AssetManifest.bin.json": "b44ae62bd9d9664c251f84b19e8e56e4",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "262525e2081311609d1fdab966c82bfc",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "269f971cec0d5dc864fe9ae080b19e23",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "15d54d142da2f2d6f2e90ed1d55121af",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b93248a553f9e8bc17f1065929d5934b",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/AssetManifest.bin": "36a468c27086b42ade1c32bbbf759cb9",
"assets/NOTICES": "b582f35af8ba531f699a95b69187864f",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"favicon.png": "4799be466691a22a7c652e61de696d88",
"manifest.json": "2053d2e01b8e06c785d9671da5e1d7a7",
"robots.txt": "941161074c8616074422242fad8863f6",
"index.html": "8cc404d5bc0e6a068b783677ee0a1919",
"/": "8cc404d5bc0e6a068b783677ee0a1919",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"flutter_bootstrap.js": "9c4255ff04e55e61847244b9bf80837f",
"splash_logo.png": "4799be466691a22a7c652e61de696d88",
"main.dart.js": "bc84c548d252e588216ffb00154b0222",
"loading_logo.jpg": "f8e1f8e71e4d355b1a92801574deb5bf",
"version.json": "a32cbe89d51a3e073bba58946809702f",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "5d9ed13943119e3da21f55944ecdc71b",
"icons/Icon-192.png": "5d9ed13943119e3da21f55944ecdc71b",
"google7711970be51fab83.html": "8dc15beb52cc0c9017a7f2980ab1b6f7",
"sitemap.xml": "5d9c7c7ef494920d5267cd1185e306ca"};
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
