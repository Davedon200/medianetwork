import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/data/models/analytics_snapshot.dart';
import 'package:media_network/shared/widgets/glass_card.dart';

class CountryBars extends StatelessWidget {
  const CountryBars({super.key, required this.countries});

  final List<CountryStat> countries;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final maxCount =
        countries.map((c) => c.count).reduce((a, b) => a > b ? a : b);

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Geographic Distribution',
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          for (final country in countries) ...[
            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    country.country,
                    style:
                        TextStyle(color: palette.textSecondary, fontSize: 13),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: country.count / maxCount,
                      minHeight: 8,
                      backgroundColor: palette.chipFill,
                      valueColor:
                          AlwaysStoppedAnimation(palette.accentPurple),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${country.count}',
                  style: TextStyle(
                    color: palette.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
