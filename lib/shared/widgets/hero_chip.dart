import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';

class HeroChip extends StatelessWidget {
  const HeroChip({
    super.key,
    required this.label,
    this.onDarkBackground = false,
  });

  final String label;
  final bool onDarkBackground;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: onDarkBackground ? Colors.white : palette.chipFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.chipBorder),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: onDarkBackground
              ? palette.textPrimary
              : palette.textSecondary,
          fontSize: 12,
          fontWeight:onDarkBackground ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
