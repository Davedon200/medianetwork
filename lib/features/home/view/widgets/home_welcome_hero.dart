import 'package:flutter/material.dart';
import 'package:media_network/core/constants/app_colors.dart';
import 'package:media_network/core/constants/breakpoints.dart';
import 'package:media_network/features/home/view/widgets/welcome_hero_video_background.dart';
import 'package:media_network/shared/widgets/web_button.dart';

class HomeWelcomeHero extends StatelessWidget {
  const HomeWelcomeHero({
    super.key,
    required this.onBrowseResources,
    required this.onViewProjects,
  });

  final VoidCallback onBrowseResources;
  final VoidCallback onViewProjects;

  static const _horizontalPadding = 36.0;

  @override
  Widget build(BuildContext context) {
    final isMobile =
        !Breakpoints.isDesktop(MediaQuery.sizeOf(context).width);

    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const Positioned.fill(child: WelcomeHeroVideoBackground()),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              _horizontalPadding,
              32,
              _horizontalPadding,
              15,
            ),
            child: _TextOverlayPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _introContent(isMobile),
                  SizedBox(height: isMobile ? 24 : 28),
                  _ctaRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _introContent(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _liveBadge(),
        const SizedBox(height: 24),
        Text(
          'Welcome back to Rhapsody Media Network',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Your hub for creators, projects, resources, and network insights. Explore what\'s trending and stay connected.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.88),
            fontSize: isMobile ? 14 : 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _liveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: Color(0xFF2DD4BF)),
          SizedBox(width: 6),
          Text(
            'Network Active',
            style: TextStyle(
              color: Color(0xFF2DD4BF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ctaRow() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        WebButton(
          decoration: boxDecoration,
          textColor: Colors.white,
          bodytext: 'Browse Resources',
          onPressed: onBrowseResources,
        ),
        WebButton(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.white.withValues(alpha: 0.14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
          ),
          textColor: Colors.white,
          bodytext: 'View Projects',
          onPressed: onViewProjects,
        ),
      ],
    );
  }
}

class _TextOverlayPanel extends StatelessWidget {
  const _TextOverlayPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        child: child,
      ),
    );
  }
}
