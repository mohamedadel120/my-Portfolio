// Fake html_stub.dart to prevent compilation errors during `flutter test`
class DivElement {
  String id = '';
  dynamic style = _Style();
  
  void remove() {}
  void setAttribute(String name, String value) {}
}

class _Style {
  String position = '';
  String width = '';
  String height = '';
  String top = '';
  String left = '';
  String visibility = '';
  String pointerEvents = '';
}

class _Document {
  _Body? body = _Body();
  DivElement? getElementById(String id) => null;
}

class _Body {
  void append(dynamic element) {}
}

class _Window {
  void addEventListener(String type, dynamic listener) {}
  void removeEventListener(String type, dynamic listener) {}
}

final document = _Document();
final window = _Window();
