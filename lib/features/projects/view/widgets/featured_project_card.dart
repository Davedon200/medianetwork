import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_network/core/constants/breakpoints.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/data/models/project.dart';
import 'package:media_network/features/projects/view/projects_page.dart';
import 'package:media_network/shared/widgets/glass_card.dart';

class FeaturedProjectCard extends StatelessWidget {
  const FeaturedProjectCard({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final isMobile = !Breakpoints.isDesktop(MediaQuery.of(context).size.width);

    return GlassCard(
      padding: const EdgeInsets.all(0),
      child: isMobile ? _mobileLayout(context) : _desktopLayout(context),
    );
  }

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: projectStatusColor(project.status).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        projectStatusLabel(project.status),
        style: TextStyle(
          color: projectStatusColor(project.status),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _image(BuildContext context) {
    final palette = context.palette;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CachedNetworkImage(
        imageUrl: project.thumbnailUrl,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          height: 200,
          color: palette.surfaceElevated,
        ),
        errorWidget: (_, __, ___) => Container(
          height: 200,
          color: palette.surfaceElevated,
          child: Icon(Icons.image, color: palette.textMuted, size: 48),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _statusBadge(),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: palette.accentPurple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Featured',
                  style: TextStyle(
                    color: palette.accentPurple,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            project.title,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            project.description,
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.person_outline, size: 14, color: palette.textMuted),
              const SizedBox(width: 4),
              Text(
                project.creatorName,
                style: TextStyle(color: palette.textMuted, fontSize: 13),
              ),
              const SizedBox(width: 16),
              Icon(Icons.folder_outlined, size: 14, color: palette.textMuted),
              const SizedBox(width: 4),
              Text(
                '${project.assetCount} assets',
                style: TextStyle(color: palette.textMuted, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _image(context),
        _content(context),
      ],
    );
  }

  Widget _desktopLayout(BuildContext context) {
    final palette = context.palette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: project.thumbnailUrl,
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 280,
                  color: palette.surfaceElevated,
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 280,
                  color: palette.surfaceElevated,
                  child: Icon(Icons.image, color: palette.textMuted, size: 48),
                ),
              ),
            ),
          ),
        ),
        Expanded(flex: 3, child: _content(context)),
      ],
    );
  }
}
