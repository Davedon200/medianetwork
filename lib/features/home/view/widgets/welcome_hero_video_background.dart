import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:video_player/video_player.dart';

class WelcomeHeroVideoBackground extends StatefulWidget {
  const WelcomeHeroVideoBackground({super.key});

  static const videoUrl =
      'https://res.cloudinary.com/ducae6fgl/video/upload/v1783007311/RHAPATHON_MEDIA_BOOST_website_pazsqu.mp4';

  @override
  State<WelcomeHeroVideoBackground> createState() =>
      _WelcomeHeroVideoBackgroundState();
}

class _WelcomeHeroVideoBackgroundState
    extends State<WelcomeHeroVideoBackground> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(WelcomeHeroVideoBackground.videoUrl),
    );
    _controller = controller;

    try {
      await controller.initialize();
      if (!mounted) return;
      await controller.setLooping(true);
      await controller.setVolume(0);
      await controller.play();
      setState(() => _initialized = true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    if (_failed || _controller == null || !_initialized) {
      return ColoredBox(color: palette.surfaceElevated);
    }

    final size = _controller!.value.size;

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }
}
