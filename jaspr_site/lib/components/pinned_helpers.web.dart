import 'package:web/web.dart' as web;

/// Phones (narrower than a tablet, or too short to pin a full stage, such as
/// a phone held sideways): the pinned showcase turns into stacked cards there.
/// Tablets and small laptop windows keep the pinned, scroll-to-switch stage.
bool isNarrowScreen() => web.window.innerWidth < 768 || web.window.innerHeight < 520;
