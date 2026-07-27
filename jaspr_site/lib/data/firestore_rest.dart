import 'dart:convert';
import 'package:http/http.dart' as http;

/// Reads Firestore collections over the public REST API instead of the
/// `cloud_firestore` package, because `cloud_firestore`'s web implementation
/// depends on browser JS APIs and cannot run during Jaspr's server-side
/// static pre-render — see the `flutter_plugin_interop` example in Jaspr's
/// own repo, where the same package is only ever called from a `.web.dart`
/// file compiled in for the browser target, never from the server entrypoint.
/// This client runs in the plain Dart VM process that does the pre-render,
/// so build-time fetches actually work.
class FirestoreRest {
  final String projectId;

  const FirestoreRest(this.projectId);

  Future<List<Map<String, dynamic>>> getCollection(String collection) async {
    final url = Uri.parse(
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$collection',
    );
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception(
        'Firestore REST fetch of "$collection" failed (${response.statusCode}): ${response.body}',
      );
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final documents = (body['documents'] as List?) ?? const [];
    return documents
        .cast<Map<String, dynamic>>()
        .map((doc) => _decodeFields(doc['fields'] as Map<String, dynamic>? ?? const {}))
        .toList();
  }

  Future<Map<String, dynamic>> getDocument(String collection, String docId) async {
    final url = Uri.parse(
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$collection/$docId',
    );
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception(
        'Firestore REST fetch of "$collection/$docId" failed (${response.statusCode}): ${response.body}',
      );
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return _decodeFields(body['fields'] as Map<String, dynamic>? ?? const {});
  }

  Map<String, dynamic> _decodeFields(Map<String, dynamic> fields) {
    return fields.map((key, value) => MapEntry(key, _decodeValue(value as Map<String, dynamic>)));
  }

  dynamic _decodeValue(Map<String, dynamic> value) {
    if (value.containsKey('stringValue')) return value['stringValue'] as String;
    if (value.containsKey('integerValue')) return int.parse(value['integerValue'] as String);
    if (value.containsKey('doubleValue')) return (value['doubleValue'] as num).toDouble();
    if (value.containsKey('booleanValue')) return value['booleanValue'] as bool;
    if (value.containsKey('nullValue')) return null;
    if (value.containsKey('timestampValue')) return value['timestampValue'] as String;
    if (value.containsKey('arrayValue')) {
      final values = (value['arrayValue'] as Map<String, dynamic>)['values'] as List?;
      return (values ?? const [])
          .cast<Map<String, dynamic>>()
          .map(_decodeValue)
          .toList();
    }
    if (value.containsKey('mapValue')) {
      final mapFields = (value['mapValue'] as Map<String, dynamic>)['fields'] as Map<String, dynamic>?;
      return _decodeFields(mapFields ?? const {});
    }
    return null;
  }
}
