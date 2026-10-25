/// Which structure the home page uses. Both read the same Firestore data.
/// `v1` is the current page and stays the default until the owner chooses;
/// `v2` is the phase 2 structure from docs/plans/portfolio-v3-plan.md.
enum HomeLayout {
  /// Hero, About, Expertise, Why Choose Me, Experience, Projects,
  /// Testimonials, Contact: the page exactly as it is today.
  v1,

  /// Hero (new headline), Projects, Experience, one short About (summary and
  /// skills grouped by area, no percentages), Contact.
  v2,
}

/// Chosen at launch with `--dart-define=HOME_LAYOUT=v2` (see
/// `.claude/launch.json`). Without it the current page is used.
const _requestedLayout = String.fromEnvironment('HOME_LAYOUT');

/// v2 is the chosen structure (owner, 18 Oct 2026); `HOME_LAYOUT=v1` brings
/// back the previous page.
const homeLayout = _requestedLayout == 'v1' ? HomeLayout.v1 : HomeLayout.v2;

/// One hero headline option: what Mohamed builds plus the proof, and a short
/// sub-line. Only confirmed facts: Flutter developer, 3+ years, Cairo/Egypt,
/// Android and iOS, Gomla and Stock 10,000+ downloads each, Albatal 1,000+.
typedef HeroCopy = ({String headline, String subline});

/// The options the owner chooses from. Neither uses "I" or "we", since that
/// choice is still open (plan, phase 1).
const heroCopies = <HeroCopy>[
  (
    headline: 'Flutter apps people actually download: Gomla and Stock, 10,000+ each.',
    subline: '3+ years shipping Android and iOS apps from Cairo, Egypt. Albatal: 1,000+ downloads.',
  ),
  (
    headline: 'Android and iOS apps, built in Flutter. Two have 10,000+ downloads.',
    subline: 'Gomla and Stock: 10,000+ downloads each. Albatal: 1,000+. 3+ years, based in Cairo, Egypt.',
  ),
  (
    headline: '3+ years shipping Flutter apps to Google Play and the App Store.',
    subline: 'Gomla and Stock: 10,000+ downloads each. Albatal: 1,000+. Based in Cairo, Egypt.',
  ),
];

/// Chosen with `--dart-define=HERO_COPY=2` (1, 2 or 3; anything else is 1).
/// Only read by the v2 layout; v1 keeps today's hero text.
const _requestedCopy = int.fromEnvironment('HERO_COPY', defaultValue: 1);

const heroCopyIndex = _requestedCopy >= 1 && _requestedCopy <= 3 ? _requestedCopy - 1 : 0;
