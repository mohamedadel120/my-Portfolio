import 'package:web/web.dart' as web;

/// Tablets and phones (the pinned showcase turns into stacked cards there).
bool isNarrowScreen() => web.window.innerWidth <= 1024;
