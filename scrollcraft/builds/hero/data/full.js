// Every project, in the live site's order, with the real content from
// data/projects.json (overview, stack, platforms, stores) plus what the
// prototype needs: the chosen screens, an inspector label set per screen
// ("Label@y%" = what is visible at that height), and the stage colour.
// mode: 'screens' (real app screens), 'art' (store artwork only, no device
// claims), 'video' (a screen recording).
const base = Object.fromEntries(require('./projects.json').map((p) => [p.slug, p]));
const S = (file, caption, notes = '') => [file, caption, notes];

const extra = {
  gomla: { name: 'Gomla', tint: '#F59E0B', mode: 'art', meta: { downloads: 10000 },
    shots: [S('gomla-1.webp', 'Store art 1'), S('gomla-2.webp', 'Store art 2'), S('gomla-3.webp', 'Store art 3'), S('gomla-4.webp', 'Store art 4')] },
  stock: { name: 'Stock', tint: '#E11D48', mode: 'screens', meta: { downloads: 10000 },
    shots: [
      S('stock-home.webp', 'Home', 'SearchAppBar@13|CategoryGrid@55|CartBar@93'),
      S('stock-list.webp', 'Product list', 'ProductCard@22|UnitSelector@37|SectionHeader@58'),
      S('stock-3.webp', 'Category', 'SearchField@15|ProductCard@52|CartBar@93'),
      S('stock-drawer.webp', 'Side menu', 'UserHeader@16|DrawerMenu@38|CartBar@86'),
      S('stock-orders.webp', 'My orders', 'TabBar@15|OrderTile@28|OrderList@62'),
      S('stock-login.webp', 'Sign in', 'BrandHeader@22|PhoneField@60|SignInButton@82'),
    ] },
  albatal: { name: 'Albatal', tint: '#D97706', mode: 'screens', meta: { downloads: 1000 },
    shots: [
      S('albatal.webp', 'Home', 'Companies@22|CategoryRail@46|BottomNavigationBar@95'),
      S('albatal-2.webp', 'Most sold', 'CategoryRail@15|ProductGrid@52|AddToCart@72'),
      S('albatal-3.webp', 'Cart', 'CartItem@19|OrderSummary@36|CheckoutButton@81'),
      S('albatal-4.webp', 'Checkout', 'ProductRail@17|CartItem@43|OrderSummary@61'),
    ] },
  palleta: { name: 'Palleta', tint: '#0B6B45', mode: 'screens', meta: { status: 'Active Development' },
    shots: [
      S('palleta-1.webp', 'Home', 'SearchBar@15|PromoBanner@40|CategoryRail@78'),
      S('palleta-2.webp', 'Categories', 'CategoryGrid@42|CartBar@96'),
      S('palleta-3.webp', 'Side menu', 'CategoryRail@74|DrawerMenu@36'),
      S('palleta-4.webp', 'Sign up', 'Logo@24|SignUpForm@62|SignUpButton@92'),
    ] },
  'to-let': { name: 'to-let', tint: '#F97316', mode: 'screens', meta: {},
    shots: [
      S('to-let-1.webp', 'My ads', 'TabBar@19|AdCard@33|BottomNavigationBar@95'),
      S('to-let-2.webp', 'Car details', 'ImageGallery@16|PriceHeader@40|ContractDetails@68'),
      S('to-let-3.webp', 'Rentals', 'FilterChips@16|ListingCard@32|BottomNavigationBar@95'),
      S('to-let-4.webp', 'Payment', 'PaymentMethod@17|CardForm@36|WalletOptions@68|PayButton@89'),
      S('to-let-5.webp', 'Fees paid', 'SuccessIcon@22|FeesSummary@52|ConfirmButton@89'),
      S('to-let-6.webp', 'Sign in', 'Logo@17|PhoneField@46|SignInButton@72'),
    ] },
  ureva: { name: 'Ureva', tint: '#CA8A04', mode: 'screens', meta: { status: 'Coming Soon' },
    shots: [
      S('ureva-1.webp', 'Welcome', 'OnboardingCopy@62|NextButton@93'),
      S('ureva-2.webp', 'Cart', 'CartItem@22|OrderSummary@70|PayButton@81'),
      S('ureva-3.webp', 'Wallet', 'BalanceCard@23|Transactions@52'),
      S('ureva-4.webp', 'Search', 'SearchBar@7|ProductCard@30|ActionRail@52'),
      S('ureva-5.webp', 'Product', 'ProductImages@20|ProductInfo@57|BuyButton@82'),
    ] },
  adruse: { name: 'Adruse', tint: '#2563EB', mode: 'screens', meta: { status: 'LMS Platform' },
    shots: [
      S('adruse-1.webp', 'Home', 'HeroBanner@17|StageCards@43|LessonRail@72|BottomNav@96'),
      S('adruse-2.webp', 'Schedule', 'ScheduleBanner@19|CalendarGrid@38|EventList@60'),
      S('adruse-3.webp', 'Lesson', 'VideoPlayer@20|LessonText@46|Attachments@72'),
      S('adruse-4.webp', 'Units', 'UnitsHeader@11|UnitList@46'),
      S('adruse-5.webp', 'Quiz', 'QuestionCard@26|AnswerOptions@42|QuestionNav@76'),
      S('adruse-6.webp', 'Results', 'ResultTable@36|ShowAnswers@62'),
    ] },
  'drugza-tagpharma': { name: 'DrugZa', tint: '#1D6FB8', mode: 'video', meta: {}, video: 'drugza_demo.mp4', shots: [] },
};

module.exports = Object.keys(extra).map((slug) => {
  const b = base[slug], e = extra[slug];
  return {
    slug, ...e,
    title: b.title, overview: b.overview, stack: b.stack,
    platforms: b.available ? b.available.replace(' and ', ' · ') : '',
  };
});
