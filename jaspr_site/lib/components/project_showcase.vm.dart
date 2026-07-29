// Server-side stub — see header_scroll.vm.dart for why this split exists.
double scrollY() => 0;
double elementOffsetTop(String id) => 0;
void listenScroll(void Function() callback) {}
void smoothScrollTo(double y) {}

// No-op on the server: the static pre-render pass is a one-shot build with
// no live event loop backing it, so a Timer firing after that build has
// "finished" and calling setState crashes with a
// `_debugCurrentBuildTarget != null` assertion. Only the browser build
// (project_showcase.web.dart) should ever actually schedule this.
void scheduleTimeout(Duration duration, void Function() callback) {}
bool isMediaLoaded(String id) => false;
