import 'package:flutter/material.dart';
import 'package:media_network/core/constants/breakpoints.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';

class ExploreHeroSection extends StatelessWidget {
  const ExploreHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isMobile = !Breakpoints.isDesktop(MediaQuery.of(context).size.width);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: palette.surfaceCard,
        border: Border.all(color: palette.borderSubtle),
      ),
      child: isMobile
          ? _mobileLayout(context)
          : _webLayout(context),
    );
  }

  Widget _mobileLayout(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _liveBadge(context, fontSize: 14),
        const SizedBox(height: 51),
        Center(child: _heroVisual(context)),
        const SizedBox(height: 36),
        Text(
          'A Global Media Network for Creators',
          style: TextStyle(
            color: palette.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Connect, collaborate, and distribute creative content across a living ecosystem of media professionals, studios, and independent creators worldwide.',
          style: TextStyle(
            color: palette.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ExploreHeroStat(title: 'Creators', value: '100+'),
            _ExploreHeroStat(title: 'Assets', value: '300+'),
            _ExploreHeroStat(title: 'Countries', value: '124'),
            _ExploreHeroStat(title: 'Live Projects', value: '100+'),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _webLayout(BuildContext context) {
    final palette = context.palette;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _liveBadge(context, fontSize: 12),
              const SizedBox(height: 16),
              Text(
                'A Global Media Network for Creators',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Connect, collaborate, and distribute creative content across a living ecosystem of media professionals, studios, and independent creators worldwide.',
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              const Row(
                children: [
                  _ExploreHeroStat(title: 'Creators', value: '100+'),
                  SizedBox(width: 24),
                  _ExploreHeroStat(title: 'Assets', value: '300+'),
                  SizedBox(width: 24),
                  _ExploreHeroStat(title: 'Countries', value: '124'),
                  SizedBox(width: 24),
                  _ExploreHeroStat(title: 'Live Projects', value: '100+'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        _heroVisual(context),
      ],
    );
  }

  Widget _liveBadge(BuildContext context, {required double fontSize}) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: palette.liveBadgeBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.liveBadgeBorder),
      ),
      child: Text(
        '● Global Network Active',
        style: TextStyle(
          color: palette.accentTeal,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _heroVisual(BuildContext context) {
    final palette = context.palette;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: palette.accentPurple.withValues(alpha: 0.15),
            boxShadow: [
              BoxShadow(
                color: palette.accentPurple.withValues(alpha: 0.25),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: palette.accentTeal.withValues(alpha: 0.10),
          ),
        ),
        Icon(Icons.play_circle_fill, size: 100, color: palette.textSecondary),
      ],
    );
  }
}

class _ExploreHeroStat extends StatelessWidget {
  const _ExploreHeroStat({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: palette.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(color: palette.textMuted, fontSize: 12),
        ),
      ],
    );
  }
}
