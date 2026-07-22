import 'dart:async';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:media_network/core/utils/app_error_log.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/motion/animated_dialog.dart';
import 'package:media_network/core/theme/app_palette.dart';
import 'package:media_network/core/theme/text_styles.dart';

class DownloadService {
  static Future<void> downloadFile(
    String url,
    String fileName,
    void Function(double progress)? onProgress,
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
          fileExtension: _getExtension(url),
          mimeType: MimeType.other,
        );
        client.close();
        completer.complete();
      },
      onError: (Object e) {
        AppErrorLog.log(e, StackTrace.current, tag: 'Download', op: 'downloadStream');
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

class DownloadButton extends StatefulWidget {
  final String url;
  final String title;
  final bool isMobile;

  const DownloadButton({
    super.key,
    required this.url,
    required this.title,
    required this.isMobile,
  });

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  double progress = 0;
  bool isDownloading = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          textStyle: TextStyle(fontSize: widget.isMobile ? 16 : 12),
        ),
        onPressed: isDownloading
            ? null
            : () async {
                setState(() {
                  isDownloading = true;
                  progress = 0;
                });

                try {
                  await DownloadService.downloadFile(
                    widget.url,
                    widget.title,
                    (p) => setState(() => progress = p),
                  );

                  if (!mounted) return;
                  setState(() => isDownloading = false);
                  await showAnimatedDialog<void>(
                    context: context,
                    builder: (dialogContext) {
                      final palette = context.palette;
                      return AlertDialog(
                        backgroundColor: palette.surfaceModal,
                        title: Text(
                          'Download Complete',
                          style: WebTextStyles.onModal(context).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: Text(
                          '${widget.title} has been saved.',
                          style: WebTextStyles.onModalMuted(context),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } catch (e, st) {
                  AppErrorLog.log(e, st, tag: 'Download', op: 'downloadFile');
                  if (!mounted) return;
                  setState(() => isDownloading = false);
                  await showAnimatedDialog<void>(
                    context: context,
                    builder: (dialogContext) {
                      final palette = context.palette;
                      return AlertDialog(
                        backgroundColor: palette.surfaceModal,
                        title: Text(
                          'Download Failed',
                          style: WebTextStyles.onModal(context).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: Text(
                          'Unable to download this file. Please try again.',
                          style: WebTextStyles.onModalMuted(context),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned.fill(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: isDownloading ? progress : 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: AppPalette.brandGradient,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: palette.surfaceCard.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isMobile ? 6 : 12,
                  vertical: widget.isMobile ? 6 : 10,
                ),
                child: Text(
                  isDownloading ? '${(progress * 100).toInt()}%' : 'Download',
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: widget.isMobile ? 14 : 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
