import 'package:web/web.dart' as web;

import '../data/analytics_repository.dart';

const _visitLoggedKey = 'visitLogged';
const _hasVisitedKey = 'hasVisited';

/// Logs one visit per browser tab session, so reloads and route changes
/// don't inflate the count. A browser's first ever visit also counts towards
/// uniqueVisitors, same `hasVisited` flag the Flutter app kept.
void trackVisit() {
  try {
    final session = web.window.sessionStorage;
    if (session.getItem(_visitLoggedKey) != null) return;
    session.setItem(_visitLoggedKey, '1');

    final local = web.window.localStorage;
    final isFirstVisit = local.getItem(_hasVisitedKey) == null;
    if (isFirstVisit) local.setItem(_hasVisitedKey, '1');

    logVisit(isFirstVisit: isFirstVisit);
  } catch (_) {
    // Storage can throw (private mode, blocked cookies); analytics must
    // never break the page for a visitor.
  }
}
