import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/theme/app_palette.dart';
import 'package:media_network/shared/widgets/glass_card.dart';

class GrowthChart extends StatelessWidget {
  const GrowthChart({super.key, required this.data});

  final List<({String label, double value})> data;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final maxValue = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Creator Growth',
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final item in data) ...[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            item.value.toInt().toString(),
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: item.value / maxValue,
                                widthFactor: 1,
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 600),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    gradient: AppPalette.brandGradient,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
