/// Helper class to ensure correct asset paths in production builds
/// Especially important for GitHub Pages with base-href
class AssetHelper {
  /// Normalizes asset paths to work correctly in both development and production
  /// 
  /// When pubspec.yaml has `assets: - assets/images/`, Flutter expects
  /// paths like `images/gomla/logo.webp` (without `assets/` prefix)
  /// 
  /// However, in production builds with base-href, we need to ensure
  /// the paths are correctly resolved
  static String getAssetPath(String path) {
    // Remove 'assets/' prefix if present, as Flutter handles it automatically
    // when declared in pubspec.yaml
    if (path.startsWith('assets/')) {
      return path.substring(7); // Remove 'assets/' (7 characters)
    }
    return path;
  }
  
  /// Alternative: Use full path with assets/ prefix
  /// This works when assets are declared correctly in pubspec.yaml
  static String getFullAssetPath(String path) {
    // Add 'assets/' prefix if not present
    if (!path.startsWith('assets/')) {
      return 'assets/$path';
    }
    return path;
  }
}
