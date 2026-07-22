import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/responsive/responsive.dart';
import 'package:media_network/core/theme/app_palette.dart';

class LandingAboutSection extends StatelessWidget {
  const LandingAboutSection({super.key, required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    const aboutText = AppPalette.light;
    final width = MediaQuery.of(context).size.width;
    final titleSize = Responsive.headlineSize(width, 44);

    return Container(
      width: double.infinity,
      color: palette.surfaceAbout,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(width),
        vertical: isMobile ? 60 : 100,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: isMobile
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: palette.aboutLabelBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'ABOUT RHAPSODY MEDIA NETWORK',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                      color: palette.aboutAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'A Global Creative Engine\nPowering Rhapsody of Realities',
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    color: aboutText.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Rhapsody Media Network is the official creative ecosystem responsible for designing, producing, and distributing Rhapsody of Realities across digital platforms worldwide. '
                  'We unify creatives, designers, video editors, writers, and media professionals into one structured global system focused on excellence, consistency, and impact.',
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.7,
                    color: aboutText.textSecondary,
                  ),
                ),
                const SizedBox(height: 80),
                Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: const [
                    _AboutCard(
                      icon: Icons.public,
                      title: 'Global Distribution',
                      desc: 'Delivering content across nations.',
                    ),
                    _AboutCard(
                      icon: Icons.auto_awesome,
                      title: 'Creative Excellence',
                      desc: 'High-quality media production.',
                    ),
                    _AboutCard(
                      icon: Icons.groups,
                      title: 'Unified Network',
                      desc: 'Connected global creatives.',
                    ),
                    _AboutCard(
                      icon: Icons.rocket_launch,
                      title: 'Digital Impact',
                      desc: 'Expanding global reach.',
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!isMobile) const Expanded(flex: 3, child: _AboutMediaPanel()),
        ],
      ),
    );
  }
}

class _AboutMediaPanel extends StatelessWidget {
  const _AboutMediaPanel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 620,
        width: 620,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset('assets/images/rnm.png', fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({
    required this.icon,
    required this.title,
    required this.desc,
  });

  final IconData icon;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    const aboutText = AppPalette.light;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: isMobile ? double.infinity : 270,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: aboutText.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: palette.shadowColor,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: aboutText.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: palette.aboutAccent, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: aboutText.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.5,
              color: aboutText.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
