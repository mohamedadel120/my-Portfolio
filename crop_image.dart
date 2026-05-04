import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final inputPath = 'assets/images/logo1.png';
  final outputPath = 'web/favicon.png';

  final bytes = File(inputPath).readAsBytesSync();
  final image = img.decodeImage(bytes);

  if (image == null) {
    print('Failed to decode image');
    return;
  }

  // Find the bounding box of non-transparent pixels
  int minX = image.width;
  int minY = image.height;
  int maxX = 0;
  int maxY = 0;

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, y);
      if (pixel.a > 0) {
        // Check alpha channel
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;
      }
    }
  }

  if (minX > maxX || minY > maxY) {
    print('Image is completely transparent.');
    return;
  }

  // Determine crop dimensions
  int cropWidth = maxX - minX + 1;
  int cropHeight = maxY - minY + 1;

  // Make it square so it fits nicely in a tab icon without stretching
  int size = cropWidth > cropHeight ? cropWidth : cropHeight;

  // ZOOM IN by 15% to make it appear even bigger!
  size = (size * 0.85).toInt();

  int cx = minX + cropWidth ~/ 2;
  int cy = minY + cropHeight ~/ 2;

  int startX = cx - size ~/ 2;
  int startY = cy - size ~/ 2;

  // Pad if startX or startY is negative
  startX = startX < 0 ? 0 : startX;
  startY = startY < 0 ? 0 : startY;

  if (startX + size > image.width) size = image.width - startX;
  if (startY + size > image.height) size = image.height - startY;

  final cropped =
      img.copyCrop(image, x: startX, y: startY, width: size, height: size);

  // Resize to a standard large favicon size for sharpness
  final resized = img.copyResize(cropped,
      width: 256, height: 256, interpolation: img.Interpolation.average);

  File(outputPath).writeAsBytesSync(img.encodePng(resized));
  print(
      'Cropped successfully. Original size: \${image.width}x\${image.height}, new bounding box size: \${cropWidth}x\${cropHeight}');
}
