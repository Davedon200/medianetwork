import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_network/core/constants/breakpoints.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/motion/animated_dialog.dart';
import 'package:media_network/core/theme/app_palette.dart';
import 'package:media_network/data/models/media_item.dart';
import 'package:media_network/shared/widgets/download_button.dart';
import 'package:media_network/shared/widgets/preview_modal.dart';

class MediaCard extends StatelessWidget {
  final MediaItem item;

  const MediaCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final palette = context.palette;
    final isMobile = Breakpoints.isMobile(width);

    final cardDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(32),
      gradient: AppPalette.brandGradient,
      boxShadow: [
        BoxShadow(
          color: Colors.deepPurpleAccent.withValues(alpha: 0.35),
          blurRadius: 18,
          offset: const Offset(0, 10),
        ),
      ],
    );

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: cardDecoration,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 10 : 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isMobile
                ? SizedBox(
                    height: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: item.thumbnail,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        fadeInDuration: const Duration(milliseconds: 300),
                        placeholder: (context, url) =>
                            Container(color: palette.surfaceElevated),
                        errorWidget: (context, url, error) => Container(
                          color: palette.surfaceCard,
                          child: Icon(Icons.error, color: palette.textMuted),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: item.thumbnail,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        fadeInDuration: const Duration(milliseconds: 300),
                        placeholder: (context, url) =>
                            Container(color: palette.surfaceElevated),
                        errorWidget: (context, url, error) => Container(
                          color: palette.surfaceCard,
                          child: Icon(Icons.error, color: palette.textMuted),
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: isMobile ? 6 : 10),
            Text(
              item.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 18 : 14,
              ),
            ),
            SizedBox(height: isMobile ? 6 : 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 6 : 12,
                        vertical: isMobile ? 6 : 10,
                      ),
                      textStyle: TextStyle(fontSize: isMobile ? 16 : 12),
                      minimumSize: isMobile
                          ? const Size(0, 44)
                          : Size.zero,
                    ),
                    onPressed: () {
                      showAnimatedDialog(
                        context: context,
                        barrierColor: palette.scrim,
                        builder: (_) => PreviewModal(item: item),
                      );
                    },
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'View',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isMobile ? 6 : 12),
                DownloadButton(
                  url: item.url,
                  title: item.title,
                  isMobile: isMobile,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
