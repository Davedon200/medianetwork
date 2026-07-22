import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';

Widget floatingCard(BuildContext context, String title, String subtitle) {
  final palette = context.palette;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: palette.scrim.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: palette.borderSubtle),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: palette.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(color: palette.textSecondary, fontSize: 11),
        ),
      ],
    ),
  );
}
