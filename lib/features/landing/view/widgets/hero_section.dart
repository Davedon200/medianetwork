import 'package:flutter/material.dart';
import 'package:media_network/core/constants/app_colors.dart';
import 'package:media_network/core/motion/staggered_entrance.dart';
import 'package:media_network/core/responsive/responsive.dart';
import 'package:media_network/core/theme/text_styles.dart';
import 'package:media_network/shared/widgets/floating_card.dart';
import 'package:media_network/shared/widgets/hero_chip.dart';
import 'package:media_network/shared/widgets/hero_stat.dart';
import 'package:media_network/shared/widgets/web_button.dart';

class LandingHeroSection extends StatelessWidget {
  const LandingHeroSection({
    super.key,
    required this.isMobile,
    required this.scrollController,
    required this.onRegister,
    required this.onExplore,
  });

  final bool isMobile;
  final ScrollController scrollController;
  final VoidCallback onRegister;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final headlineSize = Responsive.headlineSize(width, 58);

    return Container(
      height: Responsive.heroHeight(size.height),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(width),
        vertical: isMobile ? 60 : 80,
      ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: isMobile ? 0 : 1,
            child: StaggeredEntrance(
              index: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.deepPurpleAccent, Colors.cyanAccent],
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: Text(
                      'Rhapsody Media Network',
                      textAlign: isMobile ? TextAlign.center : TextAlign.left,
                      style: WebTextStyles.heading(context).copyWith(
                        fontSize: isMobile ? headlineSize : headlineSize,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'A global network of creative professionals and media innovators '
                    'dedicated to shaping the future of digital content, storytelling, '
                    'and global media distribution.',
                    textAlign: isMobile ? TextAlign.center : TextAlign.left,
                    style: WebTextStyles.subheading(context).copyWith(
                      fontSize: isMobile ? 15 : 19,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    alignment: isMobile
                        ? WrapAlignment.center
                        : WrapAlignment.start,
                    children: const [
                      HeroChip(label: 'Media Production'),
                      HeroChip(label: 'Global Network'),
                      HeroChip(label: 'Creators Hub'),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    alignment: isMobile
                        ? WrapAlignment.center
                        : WrapAlignment.start,
                    children: const [
                      HeroStat(value: '12+', label: 'Countries'),
                      HeroStat(value: '50+', label: 'Creators'),
                      HeroStat(value: '100+', label: 'Reach'),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    alignment: isMobile
                        ? WrapAlignment.center
                        : WrapAlignment.start,
                    children: [
                      WebButton(
                        decoration: boxDecoration,
                        textColor: Colors.white,
                        onPressed: onRegister,
                      ),
                      WebButton(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        textColor: Colors.black,
                        onPressed: onExplore,
                        bodytext: 'Explore Network',
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        Text(
                          'Scroll to About',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 30),
            Expanded(
              flex: 1,
              child: StaggeredEntrance(
                index: 1,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=900&q=80',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: floatingCard(context, 'Live', 'Broadcast Active'),
                    ),
                    Positioned(
                      bottom: 30,
                      right: 20,
                      child: floatingCard(context, 'New', 'Creator Joined'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
