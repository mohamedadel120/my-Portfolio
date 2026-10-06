// Server-side stubs; see shot_strip.web.dart for the real implementations.
// The static pre-render never scrolls anything, so every strip starts at its
// left edge.
void listenElementScroll(String id, void Function() callback) {}
({bool atStart, bool atEnd}) scrollEdges(String id) => (atStart: true, atEnd: false);
void scrollElementBy(String id, double fraction) {}
void scheduleTick(void Function() callback) {}
