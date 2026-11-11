import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:file_saver/file_saver.dart';

class DownloadService {
  static Future<void> downloadFile(
    String url,
    String fileName,
    Function(double progress)? onProgress,
  ) async {
    final client = http.Client();
    final request = http.Request('GET', Uri.parse(url));
    final response = await client.send(request);

    final contentLength = response.contentLength ?? 0;
    final List<int> bytes = [];

    int received = 0;

    final completer = Completer<void>();

    response.stream.listen(
      (chunk) {
        bytes.addAll(chunk);
        received += chunk.length;

        if (contentLength != 0 && onProgress != null) {
          onProgress(received / contentLength);
        }
      },
      onDone: () async {
        await FileSaver.instance.saveFile(
          name: fileName,
          bytes: Uint8List.fromList(bytes),
          ext: _getExtension(url),
          mimeType: MimeType.other,
        );

        client.close();
        completer.complete();
      },
      onError: (e) {
        client.close();
        completer.completeError(e);
      },
      cancelOnError: true,
    );

    return completer.future;
  }

  static String _getExtension(String url) {
    if (url.contains('.mp4')) return 'mp4';
    if (url.contains('.png')) return 'png';
    if (url.contains('.jpg') || url.contains('.jpeg')) return 'jpg';
    return 'bin';
  }
}
