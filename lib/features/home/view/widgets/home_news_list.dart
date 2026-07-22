import 'package:flutter/material.dart';
import 'package:media_network/core/constants/breakpoints.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/motion/staggered_entrance.dart';
import 'package:media_network/data/models/home_snapshot.dart';
import 'package:media_network/features/home/view/widgets/network_news_info_card.dart';

class HomeNewsList extends StatelessWidget {
  const HomeNewsList({super.key, required this.items});

  final List<NewsItem> items;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Breakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final newsList = _NewsListColumn(items: items);

    return Padding(
      padding: context.contentHorizontalPadding,
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: newsList),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: StaggeredEntrance(
                    index: items.length,
                    child: NetworkNewsInfoCard(items: items),
                  ),
                ),
              ],
            )
          : newsList,
    );
  }
}

class _NewsListColumn extends StatelessWidget {
  const _NewsListColumn({required this.items});

  final List<NewsItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          StaggeredEntrance(
            index: i,
            child: _NewsCard(item: items[i]),
          ),
          if (i < items.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.item});

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final dateLabel =
        '${months[item.date.month - 1]} ${item.date.day}, ${item.date.year}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: context.featuredSectionCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: context.isLightTheme
                  ? palette.accentTeal.withValues(alpha: 0.2)
                  : palette.accentPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              dateLabel,
              style: TextStyle(
                color: palette.accentTeal,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.headline,
            style: TextStyle(
              color: context.featuredCardTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.excerpt,
            style: TextStyle(
              color: context.featuredCardTextSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Read more →',
            style: TextStyle(
              color: palette.accentTeal,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
