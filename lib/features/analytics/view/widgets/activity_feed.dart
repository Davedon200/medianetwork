import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/motion/staggered_entrance.dart';
import 'package:media_network/data/models/analytics_snapshot.dart';

class ActivityFeed extends StatelessWidget {
  const ActivityFeed({super.key, required this.items});

  final List<ActivityItem> items;

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.contentHorizontalPadding,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            StaggeredEntrance(
              index: i,
              child: _ActivityRow(
                item: items[i],
                isLast: i == items.length - 1,
                formatTime: _formatTime,
              ),
            ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.item,
    required this.isLast,
    required this.formatTime,
  });

  final ActivityItem item;
  final bool isLast;
  final String Function(DateTime) formatTime;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.accentTeal,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: palette.borderSubtle,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: context.raisedCardDecoration(radius: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.message,
                        style: TextStyle(
                          color: context.contentPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      formatTime(item.timestamp),
                      style: TextStyle(
                        color: palette.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
