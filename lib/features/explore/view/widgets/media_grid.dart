import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/motion/staggered_entrance.dart';
import 'package:media_network/data/models/media_item.dart';
import 'package:media_network/shared/widgets/media_card.dart';

class MediaGrid extends StatelessWidget {
  const MediaGrid({
    super.key,
    required this.items,
    required this.crossAxisCount,
    required this.childAspectRatio,
  });

  final List<MediaItem> items;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: context.contentHorizontalPadding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => StaggeredEntrance(
        index: index,
        child: MediaCard(item: items[index]),
      ),
    );
  }
}
