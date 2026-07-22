import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';

class HeroStat extends StatelessWidget {
  final String value;
  final String label;

  const HeroStat({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: context.raisedCardDecoration(radius: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: context.contentPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: context.contentSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
