import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/data/models/analytics_snapshot.dart';
import 'package:media_network/shared/widgets/glass_card.dart';

class CategoryBars extends StatelessWidget {
  const CategoryBars({super.key, required this.categories});

  final List<CategoryStat> categories;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Categories',
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          for (final category in categories) ...[
            _CategoryRow(stat: category),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.stat});

  final CategoryStat stat;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stat.name,
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            ),
            Text(
              '${stat.percentage.toInt()}%',
              style: TextStyle(
                color: palette.accentTeal,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: stat.percentage / 100,
            minHeight: 6,
            backgroundColor: palette.chipFill,
            valueColor: AlwaysStoppedAnimation(palette.accentTeal),
          ),
        ),
      ],
    );
  }
}
