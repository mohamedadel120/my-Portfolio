/// Maps a Material Icons codepoint (as stored in Firestore for the
/// `expertise` collection, same schema the Flutter app reads) to a Material
/// Symbols web-font ligature name, so it can be rendered as
/// `<span class="material-symbols-rounded">architecture</span>` — see
/// architecture decision #4 in the migration plan. Mirrors
/// lib/utils/icon_mapper.dart in the Flutter app (kept in sync manually;
/// add a case here and there if a new icon is introduced).
String iconKeyFromCodePoint(int codePoint) {
  switch (codePoint) {
    case 0xf56e:
      return 'architecture';
    case 0xf650:
      return 'cloud';
    case 0xf653:
      return 'code';
    case 0xf69c:
      return 'design_services';
    case 0xf005e:
      return 'people';
    case 0xf0078:
      return 'phone_android';
    case 0xf01b5:
      return 'speed';
    case 0xf01d4:
      return 'star';
    default:
      return 'star';
  }
}
