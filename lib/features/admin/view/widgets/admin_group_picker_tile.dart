import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';

class AdminGroupPickerTile extends StatelessWidget {
  const AdminGroupPickerTile({
    super.key,
    required this.label,
    required this.count,
    required this.accent,
    required this.onTap,
    this.icon = Icons.chevron_right,
  });

  final String label;
  final int count;
  final Color accent;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: context.raisedSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.raisedBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 32,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: context.raisedTextPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: accent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Icon(icon, size: 20, color: context.raisedTextSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
