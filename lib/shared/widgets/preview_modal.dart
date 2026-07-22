import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/motion/app_motion.dart';
import 'package:media_network/data/models/media_item.dart';
import 'package:video_player/video_player.dart';

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
    _animationController = AnimationController(
      vsync: this,
      duration: AppMotion.fast,
    );
    _scale = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _fade = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();

    if (widget.item.type == 'video') {
      WidgetsBinding.instance.addPostFrameCallback((_) => _initVideo());
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
    setState(() => _videoReady = true);
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

  Future<void> closeModal() async {
    await _animationController.reverse();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isMobile = width < 600;

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
                  Center(
                    child: widget.item.type == 'video'
                        ? !_videoReady
                              ? const CircularProgressIndicator()
                              : AspectRatio(
                                  aspectRatio: controller!.value.aspectRatio,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayer(controller!),
                                      Positioned.fill(
                                        child: GestureDetector(
                                          onTap: togglePlayPause,
                                          behavior: HitTestBehavior.opaque,
                                        ),
                                      ),
                                      ValueListenableBuilder<VideoPlayerValue>(
                                        valueListenable: controller!,
                                        builder: (context, value, child) {
                                          if (value.isBuffering) {
                                            return const CircularProgressIndicator();
                                          }
                                          if (value.isPlaying) {
                                            return const SizedBox.shrink();
                                          }
                                          return Icon(
                                            Icons.play_circle_fill,
                                            size: 70,
                                            color: palette.textSecondary,
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
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: closeModal,
                      icon: Icon(Icons.close, color: palette.textPrimary),
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
