import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

class DownloadService {
  static void downloadFile(String url, String fileName) {
    if (kIsWeb) {
      final anchor = web.HTMLAnchorElement()
        ..href = url
        ..download = fileName;

      anchor.click();
    }
  }
}
