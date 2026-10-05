import 'dart:convert';
import 'package:http/http.dart' as http;

const _projectId = 'my-website-bf9e6';

/// Firestore only exposes atomic `FieldValue.increment()` semantics through
/// the Commit API's field-transform writes, not a plain PATCH — this
/// mirrors what the Flutter app's `AnalyticsService` does via the
/// `cloud_firestore` SDK, just expressed as the equivalent raw REST call.
/// `package:http` works the same in the browser as it does server-side (see
/// `firestore_rest.dart`'s comment on why reads use it directly), so no
/// `.vm.dart`/`.web.dart` split is needed here either — callers just need to
/// make sure they only trigger this from genuine client-side interaction
/// (event handlers / post-hydration `initState`), not during SSR pre-render.
Future<void> _increment(
  Map<String, int> incrementsByFieldPath, {
  Map<String, String> alsoSet = const {},
}) async {
  try {
    final url = Uri.parse(
      'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents:commit',
    );
    const document = 'projects/$_projectId/databases/(default)/documents/analytics/summary';
    final fieldTransforms = incrementsByFieldPath.entries
        .map((e) => {
              'fieldPath': e.key,
              'increment': {'integerValue': e.value.toString()},
            })
        .toList();
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'writes': [
          // A bare transform when there's nothing to set; otherwise an
          // update masked to just those fields, with the increments riding
          // along as updateTransforms so it all lands as one atomic event.
          if (alsoSet.isEmpty)
            {
              'transform': {'document': document, 'fieldTransforms': fieldTransforms},
            }
          else
            {
              'update': {
                'name': document,
                'fields': {
                  for (final e in alsoSet.entries) e.key: {'stringValue': e.value},
                },
              },
              'updateMask': {'fieldPaths': alsoSet.keys.toList()},
              'updateTransforms': fieldTransforms,
            },
        ],
      }),
    );
  } catch (_) {
    // Analytics must never break the page for a visitor.
  }
}

/// Builds a Firestore field path, backtick-quoting any segment that isn't a
/// plain identifier -- dates like `2026-10-05` and project titles with
/// spaces are rejected by the API unquoted.
String _path(String parent, String key) {
  final simple = RegExp(r'^[A-Za-z_][A-Za-z_0-9]*$').hasMatch(key);
  if (simple) return '$parent.$key';
  final escaped = key.replaceAll(r'\', r'\\').replaceAll('`', r'\`');
  return '$parent.`$escaped`';
}

Future<void> logVisit({required bool isFirstVisit}) async {
  final today = DateTime.now().toUtc().toIso8601String().split('T').first;
  await _increment({
    'totalVisits': 1,
    _path('visitsOverTime', today): 1,
    if (isFirstVisit) 'uniqueVisitors': 1,
  });
}

Future<void> logProjectClick(String projectTitle) async {
  // firestore.rules can't see which topProjects key changed on its own, so
  // the title is also written to lastClickedProject for it to check against.
  await _increment(
    {
      'totalClicks': 1,
      _path('topProjects', projectTitle): 1,
      'interactionsPerSection.Projects': 1,
    },
    alsoSet: {'lastClickedProject': projectTitle},
  );
}

/// Adds [seconds] of dwell time to [section] (e.g. 'Home', 'About').
Future<void> logSectionTime(String section, int seconds) async {
  if (seconds < 2) return;
  await _increment({_path('timeSpentPerSection', section): seconds});
}

/// Records a meaningful interaction (click/submit) within [section].
Future<void> logInteraction(String section) async {
  await _increment({_path('interactionsPerSection', section): 1});
}
