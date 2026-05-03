// Fake js_stub.dart to prevent compilation errors during `flutter test`
class _Context {
  void callMethod(String method, [List<dynamic>? args]) {}
}

final context = _Context();
