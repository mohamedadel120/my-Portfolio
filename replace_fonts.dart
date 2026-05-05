import 'dart:io';

void main() {
  final dir = Directory('d:/my_web_site/lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  int count = 0;
  for (var file in files) {
    final content = file.readAsStringSync();
    if (content.contains('GoogleFonts.poppins')) {
      file.writeAsStringSync(content.replaceAll('GoogleFonts.poppins', 'GoogleFonts.jetBrainsMono'));
      print('Updated \${file.path}');
      count++;
    }
  }
  print('Total files updated: $count');
}
