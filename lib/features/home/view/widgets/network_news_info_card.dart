import 'package:flutter/material.dart';
import 'package:media_network/core/constants/app_colors.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/data/models/home_snapshot.dart';
import 'package:media_network/shared/widgets/web_button.dart';

class NetworkNewsInfoCard extends StatelessWidget {
  const NetworkNewsInfoCard({super.key, required this.items});

  final List<NewsItem> items;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final latest = items.isEmpty ? null : items.first;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: context.featuredSectionCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stay Updated',
            style: TextStyle(
              color: context.featuredCardTextPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Announcements, creator spotlights, and network milestones from across Rhapsody Media Network.',
            style: TextStyle(
              color: context.featuredCardTextSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          _InfoRow(
            icon: Icons.article_outlined,
            label: '${items.length} stories this month',
          ),
          if (latest != null) ...[
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.schedule_outlined,
              label: _formatDate(latest.date),
            ),
          ],
          if (latest != null) ...[
            const SizedBox(height: 20),
            Text(
              'Latest',
              style: TextStyle(
                color: palette.accentTeal,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              latest.headline,
              style: TextStyle(
                color: context.featuredCardTextPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: 24),
          WebButton(
            decoration: context.isLightTheme
                ? boxDecoration
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.white.withValues(alpha: 0.12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.28),
                    ),
                  ),
            textColor: Colors.white,
            bodytext: 'View All News',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return 'Updated ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: context.palette.accentTeal,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: context.featuredCardTextSecondary,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
