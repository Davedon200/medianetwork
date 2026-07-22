import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/motion/staggered_entrance.dart';
import 'package:media_network/core/responsive/responsive.dart';
import 'package:media_network/data/models/home_snapshot.dart';
import 'package:media_network/shared/widgets/hero_chip.dart';
import 'package:media_network/shared/widgets/hover_widgets.dart';

class HomeTrendingCarousel extends StatelessWidget {
  const HomeTrendingCarousel({super.key, required this.items});

  final List<TrendingItem> items;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return SizedBox(
      height: isMobile ? 220 : 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: context.contentHorizontalPadding,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) => StaggeredEntrance(
          index: index,
          child: _TrendingCard(item: items[index]),
        ),
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  const _TrendingCard({required this.item});

  final TrendingItem item;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final width = MediaQuery.of(context).size.width;
    final cardWidth = Responsive.cardWidth(width, 260);

    final onDarkCard = context.isLightTheme;

    return HoverScale(
      child: Container(
        width: cardWidth,
        decoration: context.featuredSectionCardDecoration(),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: width < 600 ? 90 : 100,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: palette.surfaceElevated),
                errorWidget: (_, __, ___) => Container(
                  color: palette.surfaceElevated,
                  child: Icon(Icons.image, color: palette.textMuted),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeroChip(label: item.category, onDarkBackground: onDarkCard),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.featuredCardTextPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.engagement,
                    style: TextStyle(
                      color: context.featuredCardTextSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
