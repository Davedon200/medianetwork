import 'package:file_saver/file_saver.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class DownloadService {
  static Future<void> downloadFile(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;

      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: Uint8List.fromList(bytes),
        ext: _getExtension(url),
        mimeType: MimeType.other,
      );
    }
  }

  static String _getExtension(String url) {
    if (url.contains('.mp4')) return 'mp4';
    if (url.contains('.png')) return 'png';
    if (url.contains('.jpg') || url.contains('.jpeg')) return 'jpg';
    return 'bin';
  }
}
