import 'package:flutter/material.dart';
import 'package:media_network/core/constants/breakpoints.dart';
import 'package:media_network/shared/widgets/hero_stat.dart';

class StatRow extends StatelessWidget {
  const StatRow({super.key, required this.stats});

  final List<({String value, String label})> stats;

  @override
  Widget build(BuildContext context) {
    final isMobile = !Breakpoints.isDesktop(MediaQuery.of(context).size.width);

    if (isMobile) {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final stat in stats)
            HeroStat(value: stat.value, label: stat.label),
        ],
      );
    }

    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          Expanded(
            child: HeroStat(value: stats[i].value, label: stats[i].label),
          ),
          if (i < stats.length - 1) const SizedBox(width: 16),
        ],
      ],
    );
  }
}
