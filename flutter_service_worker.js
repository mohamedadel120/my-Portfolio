'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/AUTO_MERGE": "4c97a27b0d1a9ff9b89ed9dd555fd151",
".git/COMMIT_EDITMSG": "ae33975c335aa5963944106621df9512",
".git/config": "67b9a5a0dbeade1f5a451b0660ec7678",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/FETCH_HEAD": "96ee305264981148732ed6090e5d03d0",
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
".git/index": "bf455c23516647af48b080eed54afa08",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "52e3be808efca2f9e8c7d6e763ea7c5e",
".git/logs/refs/heads/main": "52e3be808efca2f9e8c7d6e763ea7c5e",
".git/logs/refs/remotes/origin/HEAD": "047689f59f2add65e89d6ec12dca2730",
".git/logs/refs/remotes/origin/main": "b82ed2bfbeca4dfda6523b390888bc97",
".git/MERGE_HEAD": "b136a65345b701f0c9ba6576c3f1ed8f",
".git/MERGE_MODE": "d41d8cd98f00b204e9800998ecf8427e",
".git/MERGE_MSG": "7bbf8789ad1cf9fc55214d5c135859ed",
".git/objects/01/0db47ccdf4df42c17c339757a4844238e85875": "7eef75e4e00cd0de245af7ec01369d92",
".git/objects/03/d287dde74a4cfb8648dbe334ec72f70c2f645a": "3af69a687cce079cac01ce544566441d",
".git/objects/04/4d8c4cfce7e861aadf2e77bf2c9506f92ed911": "4ae67208f7199b585412c20d06e051e7",
".git/objects/05/66b7354d774cccdc2df43cfc852060e37af6c0": "099336e89cd05fa1679cc122101a21c0",
".git/objects/05/f357fe24e9af019991af8368fd37e0ac08f233": "b4ddeebf0c6da93484f5861cc9749056",
".git/objects/06/1f05b37615b722276dfdb7361881df460202a8": "25876fa74c59e4f3b122bbd8d54249f6",
".git/objects/06/1f3a00b4d1a0695ac5c6fd879cea3a3990dd5c": "d394442be347d9d897ba454e13378d54",
".git/objects/07/20644ebf5b6f903bc16b5f1882eeb1807f92ff": "b02b8db0a8b21cb792b556c3d64cef85",
".git/objects/07/294988a88b924b276f921339e867435ec40990": "94f82ad0dfb6273e7a640f181c7e20dc",
".git/objects/08/bd19d4dbf75eb279c4ba909a37934517d42479": "39c69b5c430b80fffe909464b0c6d31f",
".git/objects/08/ef5b29d4ca1402809a08177598ed1ce1ee4160": "88fa8d70208d2896241ab1022663fccb",
".git/objects/0a/09aaa91a4587bdfe29e6d9e04a5470b630299e": "3cfb45b617dc8c9bc0135f25749c5fb6",
".git/objects/0a/7c6d1a402c37c0560e22bdef98c84c2fe7c9b6": "62212765457b96e9c61d1e5a2d4490eb",
".git/objects/0d/5ba7c877f9c8a2077dc8773436536b434a6198": "0f2acb3bb6cd406459a78783d8481eb2",
".git/objects/10/aec05d7056bd8e2f9501586773cf2b3e45816e": "8a9296f9d801a03a56479147725e6e50",
".git/objects/13/5a3edfa09382f745124837f93b64d60cbc5b70": "4e3bc01c0484d903ddbad86782a90984",
".git/objects/17/8dbacc8b23806c3d0e6aa00d24b8019e204efc": "84c9b8e880426bc362f14ef8c6b4b094",
".git/objects/18/6cee6589d344fc8b5032de98ca1bf0238b529b": "003ab372f5f1316e783148944c95d775",
".git/objects/19/aa3361916b7e43e58114c239a03225e50e09da": "f2abedbaeee0aa102a08014300ff6a85",
".git/objects/1a/7ba9aedb0e58aae61affb3ebea521670a1621d": "52bfa3889a7d688d51369ee50893ef46",
".git/objects/1b/2d28c4ea52ff6cc3ab4a1fde7241f497272d92": "f4897ac321c277864667b2fee0d0762f",
".git/objects/1e/9d0737e5566ea1c0aecf78d3a0e59c7463eb19": "fd6a35cb7f7a2c55630e9e67a6b4988a",
".git/objects/20/25a3134176f2e518fc1ff41baf8a95a7a5c18b": "556660a318feba90fcd727565d8e14db",
".git/objects/21/e1760a339dfe0bb3ee0addc294a3b4f69c9e76": "3f31c2102627ab459937b5095f19e6f8",
".git/objects/22/e14fe7b45c86fb21ac610d215d45e0d129deb9": "297d2994927ab97c9f926c3e65369bee",
".git/objects/28/2d2a282062a088f0b65443f1843bf2f2bb4f90": "e91b421b708aebd808bb6a9ccd148fcf",
".git/objects/28/34d49f3754d0164e44535054faf92b383ac7be": "28ba92db8e3a2e93763e545b9782b88b",
".git/objects/29/07cacb0bac1a16717b531b8e3885771f51b539": "8c551bd279c00209fe2f947a7f05c590",
".git/objects/2a/5f80a85378c2894804949881b2ac86cce7edb1": "ef52672e7d05871e41934109742da667",
".git/objects/2a/e02411b61048050c197a1bba2fbe757300ca0f": "0d9608402727198cdf094f48b5107441",
".git/objects/2b/1f0444aed8abfbb6b56645fd52a278cd6f6f2a": "a2f6549b9e13eb1710439bc85c7963ee",
".git/objects/2c/3ad241bcf086cfb9cd46b39d04f97bd444ea71": "087dd0dfb7648f5ae8f0e7558eff081e",
".git/objects/2c/dd77daa0c9c2425610f2b809d02ee8e38947fc": "e649bef16d12e421ca0c32dd1f93f7c5",
".git/objects/2e/aef7403dfacefaf0cd81585ecad3c6241e4c1a": "60022afd6d5a35e31892719026c90da8",
".git/objects/2e/b175fa39a108e283928a13d42169d6b505c753": "88684e835b273375673d3bf1a380cd19",
".git/objects/2e/c7e2ef3ac88762b746a414f17d988b81296db5": "ab499b723d817fdb149281a112102b15",
".git/objects/2f/7c51ec455f310db955e7deface88956d2d7b3a": "225ea0c52cc8f3d4fd70015b427ddf9b",
".git/objects/31/19e55bfa28b5cfb7841d37e91abea09d155d53": "7f21823a75eb9a8c6d5990bdfe44282f",
".git/objects/31/33a6aa90983d5a5fb93ef2c0f6c623cca06db1": "86499a65db8de725799a9eaf9dae3e3f",
".git/objects/32/5595b12e49613223d02b397a9b3850fd8a572d": "27b45fa401a8aac6353f0ab55aaa9287",
".git/objects/33/b0c9be520485aeede65178d6a63dd41c2486fd": "2929e429b556a2473a29ecc9ed7f8367",
".git/objects/34/d1f3ac052776be0ca77dba679f5d0595540187": "52a84580df840275351c33ff27c1307d",
".git/objects/35/65a36f3ed4a188e50072231a8e72d43758122f": "fc14466f4fac56f8db4ec22c302b8a98",
".git/objects/3a/10c666a7b0b84955a64127aaf62d7c5ac5035c": "5a159592cf96dc7aeb33a908a42bc38e",
".git/objects/3a/1ff4460c2f196219bda444f9ab5443d0ae5bb4": "533ebbc49f82d38a4d955da618de1c6a",
".git/objects/3b/ca68f18acb7b9b9cb1052207984c3cfae82953": "415effc4273e8e20ab98492f1ca80837",
".git/objects/3f/0306208216518cce49abde8a3ac31d0f043b82": "c16d95f16f39a6de8d875db155608062",
".git/objects/41/1c111b7b9334bc308a64eb62356f31ab9c9d26": "b87e7d92f011a3bb5fca88317e9cbfb3",
".git/objects/41/5c059c8094b888b0159fdedfd4e3cb08a8028e": "86914685ccd40e82a7fe5b70459fb9f7",
".git/objects/46/1108ce9f7f3ed87d109cf0cad016313aaaeb9c": "2ed95d861365b3e1273ed865bc26904e",
".git/objects/48/14d5e9820cc63f5ac981b4e638b627498877e0": "060a8ea65c655e9311592c4cdd59f0e7",
".git/objects/48/b3b5372c63588393bb68974e398ce098dba86a": "373e687b184076e138184d173ce4fb03",
".git/objects/4a/2e49d4092ab4a219cf481f0a6ab095be6365d6": "a833f21ba64299e4bdd34feccd7bfa27",
".git/objects/4a/4bf2f2a680225c79eeba276dbbcfc64576ac1f": "7cf6bedb40f94028834c8d50e32f8178",
".git/objects/4a/c75e9f7ac9ca77b89a5c1755d6e354b16ceef8": "e41e2ac7a59f1ff9f6db899b595e2adf",
".git/objects/4e/7380adf1c024b7f49ae0de60db394ee00a5d71": "723ad7b9af5e8c517ed42e3e662a851e",
".git/objects/50/3b4fb36e1012c500d5d035eedb88a8b43a6f33": "210ce5008675bd21e46c08ac9b774e79",
".git/objects/52/14f83a4f510045342eb794911ea4461ebd8984": "c2db52a9b97518642c85ad293b144e85",
".git/objects/52/4bb5fe1295c628e9e8783d4bd5bb80625cad67": "3373b2f8041b8c8335d5d664eba8dfed",
".git/objects/58/e3bbcb329c4cb3671719293ec79a0d64ba38ad": "4cd0aac9373ed208f8063d5f44a4ffc9",
".git/objects/59/04d8eb2f1136b7cf672246fd143d5c477fdc7e": "ea29a05dc7fc4f861bfa5203b3d682e2",
".git/objects/5c/46511c18bc8c58106faee5847986de2d5b5e44": "cc96fe72b4876fbaa425352fde35da3b",
".git/objects/5d/de6bc0091ad6be702991a66f19a5c3c983096e": "d84b02bfe35e8e4ff8175c3594b313a9",
".git/objects/5e/18443a83156e0a511033a12dc8ad27641dc20f": "064b660775570bc95d4f121c131e5ba2",
".git/objects/5f/57ef6f2a6efd3fcaec2e1856a6721f140546b7": "8e7e96bfe51a4366b48a3f3298018a27",
".git/objects/60/1b0a68283f1747dc0ed23bbc5471060791780c": "67e3875008593d6a8b412a6347db7138",
".git/objects/61/12656d1f17e76cccef3b0e3af37f008ee412a5": "d60b0a589de13b0f0116aee264c97ad2",
".git/objects/61/1ad0f6f03041acc2fd08151a5288a0b33105a5": "0b40f38b74c298cada22fff1b22657f9",
".git/objects/65/083ef609774d4147ac8a4a2a8aa6ebebdfc76d": "99d03061d63264d7c7a966535505cc5c",
".git/objects/67/55aa91716a62c363bbd1bd850713e5870c7719": "997745676b7534a977290139c4bf42ae",
".git/objects/6a/f2a23c9ed757341affe598d42665fc80387ffc": "60ae5e6757bc01123fe159c140f021bd",
".git/objects/6f/a0234dca1900b3266d1c9e41f1f2152d60393f": "e514959ed3429b21b407f4bfade54e13",
".git/objects/72/fb61e011139393b3ea4cc4d4663d1f89201621": "5bf206520be86ed5bf9284f9fa59d911",
".git/objects/76/0ff6af40e4946e3b2734c0e69a6e186ab4d8f4": "009b8f1268bb6c384d233bd88764e6f8",
".git/objects/76/edba290e29167bbddeab6fc3e9a48783cdd4a3": "17e1bd9824158cd85948c86eb91e7256",
".git/objects/77/6a086423d364e31afded1a31864dbcdd09db78": "82fe5f35898ad7788b83270ccac86e1f",
".git/objects/79/2367f33f63852487d6623437ea3064c6faa5e8": "205d3ed61a5d56ce66e9403c6ffc8724",
".git/objects/7c/a48337d130d52102d8beac6badd002f2098a5e": "164258a1f27a17ad7c1d880d155e4724",
".git/objects/7c/e1bcab73c29a7ba8ae5eb4eef1b1bce8fa65f0": "bb78b26e3041d18e71f8952d4cb16513",
".git/objects/82/89f63700ee00fc6b7935feca6dbe75168eae30": "38862f9183dfdce13e5a3b0aa2bcd891",
".git/objects/83/f7ae73fe903d4c8a9c61d99243361d12785305": "b35c85191b94d7d2244950583146728b",
".git/objects/84/2d5d25f579e239d881682686788c7925ea7384": "13f42db9508c256e64f1603ef30ef0b0",
".git/objects/86/86af58a4acff9ea636ec24016cba2c3f864932": "f974e453716eccd016815488b823dc9b",
".git/objects/87/4a032444023120ad061b7567ceb8de3ccd55e3": "55ad15ccbbbc65fd009ca3defc89bfc4",
".git/objects/87/e3088bd121d39f8f41bf56217d49413758696f": "911503ad8198df0ce811adb1ec6a1c0e",
".git/objects/87/edf5d48dfe74121a7f44a7f6d687c20a8ffbc1": "0ef204e52c35b9fc07f1ff7317deeb82",
".git/objects/88/a38e3371cd8818ff2a2140332a63e1c6e75c5a": "556a3185a9e17727d1d5b4bb3dea5c2d",
".git/objects/88/abed6f48f6959565ef9ece9ad908c94a0758c6": "924e6ac878a744fa06eee653f4975ae9",
".git/objects/89/45863de04f8b991b256746adbd93eeea8e7918": "9be2ff6e0ee352ddee5a69ba0775956e",
".git/objects/8a/38c5a52b175d3e62ef3befae4dd18ffa104c63": "815be55fdceabb32c19fbe2ff4af569e",
".git/objects/8b/3747f4e9d48be8b80f3ff5b220f7e531857dcd": "a1aaaac8a6fda93148749e8b32787cd5",
".git/objects/8b/84b80878ec4ae6bf0b5ab3ae53f921011d02c9": "da76e4932a8ea0f5b336bdd80d8f23f8",
".git/objects/8c/99266130a89547b4344f47e08aacad473b14e0": "41375232ceba14f47b99f9d83708cb79",
".git/objects/8d/75ddaae998209a0faa329a2bb3a44e9a9daf0b": "f6f2e907caba72d8d8b7b99379bf62a2",
".git/objects/8e/aa683ef73d73654f7c86ca5e9ae41ff32fecbb": "3fe8a1d1b439498e99f58fa3c3aa24a8",
".git/objects/8f/79c26894b946bd9c93906dae06aec020e425e4": "611cbf008debc43eb96f64bd6e34f673",
".git/objects/90/021498a9b6c1887cfeda0878233bfe42959646": "1f0342aa7ebdf4052f8202d418b5d387",
".git/objects/90/33e68788744992c5516455a657fc407addf8dc": "c616a022d3b7b21afe93ad3b5935821c",
".git/objects/91/7bbb5eea2512fbe075c54dd2265e4e1628c72c": "7dd0399b36befd75e6043b29ae92e17a",
".git/objects/91/ba8d72d4cd1a415408d70f1ab7dd2d0d0d3812": "018e754c62ca203ce9bb91a5c63e4428",
".git/objects/91/edb27af511a7fa05694432f3757400f5b0fd57": "5eacf9691290254a6506b11e499e689d",
".git/objects/94/5b86e9d619c810bf2275ac99a7d91dc5740e2d": "cf0b86aa8a33918a83babff7db0f43bb",
".git/objects/94/7d3606c9898ccc7c4d0b445f4c068c33ce2aa3": "e2bab8ba613b15cde25753c0114ea1cb",
".git/objects/95/31c1376b8ece676434d3b7746a5c255355fdad": "f8f300813ccdd725c8016ff645656870",
".git/objects/97/d79c9795ac954d30293488b667602ba0544880": "1e767047c4ee3c81e613581523af24f1",
".git/objects/9a/5bc03ff4b3028f310bdcf2c24e8941f0b2eafe": "43c2f606f653500d1e54b561ed93572d",
".git/objects/9a/8d71d6762b44c5246ca6c612d466a40fd12d91": "df06d5d01fb848a3b680b6d0b692b2b3",
".git/objects/9a/9c2b987ebe40c556145ffb49f3890b40dd5440": "0c12a6d66c3af272f4053a4cbedfd03a",
".git/objects/9b/6ee4f6c833f96062bbe4ed182efc4a3e7b15d2": "bbbdb733bf5cdf299667d3a0c0a4d65c",
".git/objects/a5/fe469bd4acc87aac3e5caeb0af0cd76e58d195": "f0f5d6ed37fe7bc7bf28003e86b597f7",
".git/objects/a6/9181f3363234159449bd1395faf5c1089fa4de": "bc002ad573e07fce0c8ef10e80044399",
".git/objects/a7/44aed5e35f10af1ee88a5ed392a3efa40dffab": "2638f8629e609012fdc5f234d474b045",
".git/objects/a8/bbf070d3365aec7e29b60795c6329c1c28301c": "90133cec97ec974d06941d2f7547f20a",
".git/objects/a9/a9f9675d9cdcec672a21a3a265c9b141327c18": "2f34b6dae80da86cd497d607ad6ab016",
".git/objects/ac/7faacc529a683729afb3b98bb5bd2a55d5b13c": "521e689030acb39740be5bead75112c4",
".git/objects/ad/4c0ba9842f4de544316a62269732d33f652961": "d2648c4f7ac6a01d24dedabffef3980b",
".git/objects/b3/f1f5bda5eb686354efcb5d29b9cd5f68c07968": "9f2cc1bd81cf78e0358b17ba375454c7",
".git/objects/b7/e9b261f4c2f62ada9847ca4875eb9591b0b520": "004565fc0df02e5a0b9ef7e519c02bd7",
".git/objects/b8/a6cd39ea142a86d83376285b5cc77af2042756": "36a9441cabd0678dad768af58b63d517",
".git/objects/b8/ff88e5ae8c5cd5467e05a7a95e0b9b6876169b": "df84fbfdcfecd7fc89ba4db63d535021",
".git/objects/b9/d94307caa925b4a68b127d54eb6badd2a1c946": "4bf672c59326f83313a5bc26e22af20d",
".git/objects/bc/65fbbee227ebd7d535d8e8ae546db02f28305d": "312673cdbddd67dcbcb5c079faca28dc",
".git/objects/bf/37a2bacc1d354ca43c6364d51ae79c0eb8be93": "160e901e39e73ad48224211ec9c03b45",
".git/objects/bf/41900750b6b8289b2fc5e7c7f59f582a1dea77": "5c7e0a844f91825fabad9a5d106295c5",
".git/objects/bf/5323142639775fad92cdb2b0d535f251510b84": "bd7208a05a30cd42cc39aecd5f491cdf",
".git/objects/bf/9902aa97afbdf271decde147cb8a971cdf6291": "6ba7b1cbc1e0b3544397685392fbfc18",
".git/objects/c0/cf4d23d37e745f0f03007f322ad8f6fa0293c9": "553093541264fb1afffbbaf9da6ca536",
".git/objects/c2/89d30b10befd8f3b016d548a709f8ea481b5b2": "2a5a99ac3566f653396446ef4117ce61",
".git/objects/c5/a984901a535eea7c11a9f519e93e395828c175": "7e26b6de81c5a241371a678b707173d6",
".git/objects/c8/97674439c0a3074a9b911c707f15645d6149cc": "15b2bac48b5834ad5b4b4b32b7d82be1",
".git/objects/c9/95e11d415777835e53021c6ea1aea74c6d7601": "1a9ea259a4f0791c51b7cc713a833a64",
".git/objects/c9/cf3eb1c0b04cbed527e0b75a7b1aea9a165b2d": "8ad3cc6cf9c0fb4bd265d0c74890af4f",
".git/objects/ca/490ea3a8f5bf13a1e911f1bea2d333d546c959": "955aedc9ad7817d35c8b2a18e4d2d568",
".git/objects/ce/79ee3efab3848a5843b652edbccd3d301c20d7": "27d0b4431c12b0ef899541b7022a92a3",
".git/objects/d5/49b6654f3fa82318c7ca156207ecd5809aea7a": "b5060acef013927b234c59bba1af53fe",
".git/objects/d5/80ce749ea55b12b92f5db7747290419c975070": "8b0329dbc6565154a5434e6a0f898fdb",
".git/objects/d8/03224b3f5e8dc3f824c7083eb89d73f9419bcd": "594b7381e5f32a070f5ec2bdad719df5",
".git/objects/d8/9fe9fe53baa30270b470f118faa00f33731fd4": "11cfba29d857f8773cc5caaa968b78a2",
".git/objects/da/a41d77cd2e2782e2bc99ee97283b72f11bad6f": "82a66ce040db6df969c7ed774159a608",
".git/objects/da/f7e610471a77c9a9e292756e258aadf5ce806d": "3d29377319e4cde1f342974b07919411",
".git/objects/df/958db420168c1509f1ab7f0a77de958d21d277": "ce19c3b2feef99a7459e09200a44ca96",
".git/objects/e3/8d223354517f60434c4f081d69cfdd282565f9": "9daaa82839ac1aab2b8e35c5b0ea312b",
".git/objects/e3/be8468cfb22e62b1e73e8c2dc756f992ff481d": "c09754a308e4d151e52b86372e722493",
".git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391": "c70c34cbeefd40e7c0149b7a0c2c64c2",
".git/objects/e9/a5840a665212f5fabee1361485cbbd61244dd9": "338f9b916a191fdc5e8ad702dfdfa933",
".git/objects/e9/bc7ca29d0ef3a42abd088315e1c0610dc858ee": "1460e514c63f7e876bc2890eb7903582",
".git/objects/f2/5ee33faa9352d6a1cc264077b64d9108173dbe": "3f92c911682b71870141faf634273eb4",
".git/objects/f6/d8fb442326e156385aa181010a193e65b38852": "0850984c631ff7d161f0906ad8baf5d3",
".git/objects/f9/7204937b4d7dff9852feede6b2ef557df9c201": "edc1574fe80a847739fd8761f383191b",
".git/objects/fa/6a333bb83cc2008be1f1cad5e24b63d91f7627": "fea2ce9ca26fbda1e9d8536266c5db89",
".git/objects/fa/a9a36f5bead421c5a4fe1b9fa046c3de1dfeac": "3c84e83ae86cb97b43a958a2d22c32b9",
".git/objects/fa/ce163b88f82c14db9099e70c42dfde5c55c8b1": "a8f596a50d2b3197c20f0a82a4e51095",
".git/objects/fb/b97f8c689d2b95a998b1449d24224b89469f94": "ecab3e148daa478902c4b9a271b5b862",
".git/objects/fc/5f7a9d6b12d7e2fd67a1e56a3660d56ed3dc6a": "61db215c1db409f0bc2c376fc3e391cb",
".git/objects/ff/21f281a85506b42dba0e545499c8991fdf556e": "0e9184cebd426e163bd96081ab612ea7",
".git/objects/pack/pack-6cf1c343cee52d353501a632b2ae2fda412c0b49.idx": "253587f737cfc1bec4446adb61643066",
".git/objects/pack/pack-6cf1c343cee52d353501a632b2ae2fda412c0b49.pack": "f85cd235a36bd854b4336f3ccee2fda4",
".git/objects/pack/pack-6cf1c343cee52d353501a632b2ae2fda412c0b49.rev": "2247c29804613c0e8c9fea172fce5ac7",
".git/ORIG_HEAD": "a24c208041f4c998fbf05cf0176f8a6c",
".git/packed-refs": "6af21c61b93016ec538d1694002d37df",
".git/refs/heads/main": "a24c208041f4c998fbf05cf0176f8a6c",
".git/refs/remotes/origin/HEAD": "98b16e0b650190870f1b40bc8f4aec4e",
".git/refs/remotes/origin/main": "b136a65345b701f0c9ba6576c3f1ed8f",
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
"assets/fonts/MaterialIcons-Regular.otf": "7adb9067199e3d5387c67fa26dfbb544",
"assets/NOTICES": "be18a8a5af1bd03c1223cce11f06d760",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
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
"flutter_bootstrap.js": "0575616a9c37d174fe6de80e899fc6ac",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "3cfecbea50ebc44c96fbbc277083530b",
"/": "3cfecbea50ebc44c96fbbc277083530b",
"main.dart.js": "9695ba89f921803b0d521be14389e9ce",
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
