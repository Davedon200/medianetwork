import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:media_network/model/web_models.dart';
import 'package:media_network/services/dio_service.dart';
import 'package:video_player/video_player.dart';

class MediaCard extends StatelessWidget {
  final MediaItem item;

  const MediaCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;

    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(32),
      gradient: const LinearGradient(
        colors: [Color(0xFF6A5AE0), Color(0xFF2DD4BF)],
      ),
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
      decoration: boxDecoration,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 10 : 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
          children: [
            /// IMAGE
            isMobile
                ? Flexible(
                    flex: 3, // 🔥 controlled mobile image height
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: item.thumbnail,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        fadeInDuration: const Duration(milliseconds: 300),
                        placeholder: (context, url) =>
                            Container(color: const Color(0xFF1E293B)),
                        errorWidget: (context, url, error) => Container(
                          color: const Color(0xFF0F172A),
                          child: const Icon(Icons.error, color: Colors.white54),
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
                            Container(color: const Color(0xFF1E293B)),
                        errorWidget: (context, url, error) => Container(
                          color: const Color(0xFF0F172A),
                          child: const Icon(Icons.error, color: Colors.white54),
                        ),
                      ),
                    ),
                  ),

            SizedBox(height: isMobile ? 4 : 10),

            /// TITLE
            Text(
              item.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 14 : 14,
              ),
            ),

            SizedBox(height: isMobile ? 6 : 10),

            /// BUTTON ROW (FIXED: NO WRAP, NO OVERFLOW)
            Row(
              children: [
                /// VIEW BUTTON
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 6 : 12,
                        vertical: isMobile ? 6 : 10,
                      ),
                      textStyle: TextStyle(fontSize: isMobile ? 16 : 12),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierColor: Colors.black.withValues(alpha: 0.8),
                        builder: (_) => PreviewModal(item: item),
                      );
                    },
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "View",
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

                /// DOWNLOAD BUTTON
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
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero, // required for full fill effect
          textStyle: TextStyle(fontSize: widget.isMobile ? 16 : 12),
        ),
        onPressed: isDownloading
            ? null
            : () async {
                setState(() {
                  isDownloading = true;
                  progress = 0;
                });

                await DownloadService.downloadFile(widget.url, widget.title, (
                  p,
                ) {
                  setState(() {
                    progress = p;
                  });
                });

                setState(() {
                  isDownloading = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Download completed")),
                );
              },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              /// 🔵 PROGRESS FILL BACKGROUND
              Positioned.fill(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: isDownloading ? progress : 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2DD4BF), Color(0xFF6A5AE0)],
                      ),
                    ),
                  ),
                ),
              ),

              /// 🔤 TEXT LAYER
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF020617).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),

                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isMobile ? 6 : 12,
                  vertical: widget.isMobile ? 6 : 10,
                ),
                child: Text(
                  isDownloading ? "${(progress * 100).toInt()}%" : "Download",
                  style: TextStyle(
                    color: Colors.white,
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

class PreviewModal extends StatefulWidget {
  final MediaItem item;

  const PreviewModal({super.key, required this.item});

  @override
  State<PreviewModal> createState() => _PreviewModalState();
}

class _PreviewModalState extends State<PreviewModal>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? controller;

  late AnimationController _animationController;
  late Animation<double> _scale;
  late Animation<double> _fade;

  bool _videoReady = false;

  @override
  void initState() {
    super.initState();

    /// FAST ANIMATION INIT ONLY
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scale = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _fade = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _animationController.forward();

    /// DEFER VIDEO INIT (IMPORTANT SPEED FIX)
    if (widget.item.type == "video") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initVideo();
      });
    }
  }

  Future<void> _initVideo() async {
    final uri = Uri.tryParse(widget.item.url);
    if (uri == null) return;

    controller = VideoPlayerController.networkUrl(uri);

    await controller!.initialize();

    controller!
      ..setLooping(true)
      ..setVolume(1.0);

    if (!mounted) return;

    setState(() {
      _videoReady = true;
    });

    /// SMALL DELAY = HUGE SMOOTHNESS IMPROVEMENT
    await Future.delayed(const Duration(milliseconds: 200));

    controller!.play();
  }

  @override
  void dispose() {
    controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void togglePlayPause() {
    if (controller == null || !_videoReady) return;

    setState(() {
      controller!.value.isPlaying ? controller!.pause() : controller!.play();
    });
  }

  void closeModal() async {
    await _animationController.reverse();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final bool isMobile = width < 600;

    return FadeTransition(
      opacity: _fade,
      child: Center(
        child: ScaleTransition(
          scale: _scale,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: isMobile ? width * 0.95 : width * 0.7,
              height: isMobile ? height * 0.6 : height * 0.7,
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  /// CONTENT
                  Center(
                    child: widget.item.type == "video"
                        ? !_videoReady
                              ? const CircularProgressIndicator()
                              : AspectRatio(
                                  aspectRatio: controller!.value.aspectRatio,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      /// VIDEO (never rebuilds)
                                      VideoPlayer(controller!),

                                      /// TAP LAYER
                                      Positioned.fill(
                                        child: GestureDetector(
                                          onTap: togglePlayPause,
                                          behavior: HitTestBehavior.opaque,
                                        ),
                                      ),

                                      /// LIGHTWEIGHT LISTENER (ICON ONLY)
                                      ValueListenableBuilder<VideoPlayerValue>(
                                        valueListenable: controller!,
                                        builder: (context, value, child) {
                                          if (value.isBuffering) {
                                            return const CircularProgressIndicator();
                                          }

                                          if (value.isPlaying) {
                                            return const SizedBox.shrink(); // 🔥 nothing rendered
                                          }

                                          return const Icon(
                                            Icons.play_circle_fill,
                                            size: 70,
                                            color: Colors.white70,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              widget.item.url,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                  ),

                  /// CLOSE BUTTON
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: closeModal,
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WebButton extends StatelessWidget {
  final Function()? onPressed;
  final Decoration decoration;
  final String bodytext;
  final Color textColor;
  const WebButton({
    super.key,
    this.onPressed,
    required this.decoration,
    required this.textColor,
    this.bodytext = "Get Started",
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 16),
          decoration: decoration,
          child: Text(
            bodytext,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class HoverScale extends StatefulWidget {
  final Widget child;
  const HoverScale({super.key, required this.child});

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedScale(
        scale: hovered ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: widget.child,
      ),
    );
  }
}

class HoverIcon extends StatefulWidget {
  final IconData icon;
  const HoverIcon({super.key, required this.icon});

  @override
  State<HoverIcon> createState() => _HoverIconState();
}

class _HoverIconState extends State<HoverIcon> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedScale(
        scale: hovered ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Icon(widget.icon, color: Colors.white38, size: 18),
      ),
    );
  }
}

class HeroChip extends StatelessWidget {
  final String label;

  const HeroChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
}

class HeroStat extends StatelessWidget {
  final String value;
  final String label;

  const HeroStat({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

Widget floatingCard(String title, String subtitle) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
        ),
      ],
    ),
  );
}

class WebUtils {
  /// Returns a logger instance for the given class name.
  ///
  /// [className] is the name of the class where the logger is to be used.
  static Logger getLogger(String className) {
    final logger = Logger(printer: SimpleLogPrinter(className));
    return logger;
  }
}

/// A printer for logging events with emojis and colored text.
///
/// It extends the [LogPrinter] to provide a custom format for logged messages,
/// which includes an emoji based on the log level, and coloring the output
/// depending on the log level as well.
class SimpleLogPrinter extends LogPrinter {
  /// The name of the class where the log is being called.
  final String className;

  /// Constructor that takes the [className] where the log is being called.
  SimpleLogPrinter(this.className);

  /// Logs the given [event] with formatted output.
  ///
  /// The function uses ANSI escape codes for terminal colors and prepends
  /// an appropriate emoji to the message based on the log level.
  /// The format is `emoji :::: <className> :::: message`.
  ///
  /// Returns an empty list as it outputs directly to the console.
  @override
  List<String> log(LogEvent event) {
    // Mapping of log levels to ANSI color codes.
    final levelColors = {
      Level.trace: 37, // Gray color for trace log level.
      Level.debug: 36, // Cyan color for debug log level.
      Level.info: 32, // Green color for info log level.
      Level.warning: 33, // Yellow color for warning log level.
      Level.error: 45, // Red color for error log level.
      Level.fatal: 35, // Magenta color for fatal log level.
    };

    // Mapping of log levels to emojis.
    final levelEmojis = {
      Level.trace: '🔍', // Magnifying glass emoji for verbose.
      Level.debug: '🛠️', // Hammer and wrench emoji for debug.
      Level.info: 'ℹ️', // Information source emoji for info.
      Level.warning: '⚠️', // Warning emoji for warning.
      Level.error: '❌', // Cross mark emoji for error.
      Level.fatal: '🤷', // Shrugging person emoji for wtf.
    };

    // Get the emoji for the current log level, defaulting to empty if not found.
    final emoji = levelEmojis[event.level] ?? '';
    // Get the color code for the current log level, defaulting to no color if not found.
    final color = levelColors[event.level] ?? 0;
    // Format the message with the color code and class name.
    final coloredMessage =
        '\x1B[38;5;${color}m :::: <$className> :::: ${event.message}\x1B[0m';

    // Print the formatted message to the console.
    print('$emoji $coloredMessage');

    // Return an empty list as the function is meant for printing to console.
    return [];
  }
}
