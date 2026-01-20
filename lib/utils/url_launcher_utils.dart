import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class UrlLauncherUtils {
  static Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  static Future<void> downloadFile(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      // For web, externalApplication mode often triggers a download or opens in a new tab
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not download from $url');
    }
  }
}
