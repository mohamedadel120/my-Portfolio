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
Future<void> _increment(Map<String, int> incrementsByFieldPath) async {
  try {
    final url = Uri.parse(
      'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents:commit',
    );
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
          {
            'transform': {
              'document': 'projects/$_projectId/databases/(default)/documents/analytics/summary',
              'fieldTransforms': fieldTransforms,
            },
          },
        ],
      }),
    );
  } catch (_) {
    // Analytics must never break the page for a visitor.
  }
}

Future<void> logVisit({required bool isFirstVisit}) async {
  final today = DateTime.now().toUtc().toIso8601String().split('T').first;
  await _increment({
    'totalVisits': 1,
    'visitsOverTime.$today': 1,
    if (isFirstVisit) 'uniqueVisitors': 1,
  });
}

Future<void> logProjectClick(String projectTitle) async {
  await _increment({
    'totalClicks': 1,
    'topProjects.$projectTitle': 1,
    'interactionsPerSection.Projects': 1,
  });
}

/// Adds [seconds] of dwell time to [section] (e.g. 'Home', 'About').
Future<void> logSectionTime(String section, int seconds) async {
  if (seconds < 2) return;
  await _increment({'timeSpentPerSection.$section': seconds});
}

/// Records a meaningful interaction (click/submit) within [section].
Future<void> logInteraction(String section) async {
  await _increment({'interactionsPerSection.$section': 1});
}
