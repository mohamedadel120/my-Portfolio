// Server-side (Dart VM pre-render) stub. `package:web`'s `dart:js_interop`
// extensions (`.toJS` etc.) only exist for the dart2js/dart2wasm web
// compile target, not the native VM used for static pre-rendering — same
// reason `cloud_firestore` needed a `.vm.dart`/`.web.dart` split (see
// lib/data/firestore_rest.dart's doc comment). No scroll events happen
// during pre-render, so this is a no-op.
void listenForScroll(void Function(bool scrolled) onChange) {}
void listenForActiveSection(List<String> ids, void Function(String?) onChange) {}
