import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/data/models/registration.dart';

class RegistrationListTile extends StatelessWidget {
  const RegistrationListTile({
    super.key,
    required this.registration,
    this.compact = false,
  });

  final Registration registration;
  final bool compact;

  String get _initials {
    final parts = registration.name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.raisedSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.raisedBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: compact ? 18 : 22,
            backgroundColor: palette.accentPurple.withValues(alpha: 0.12),
            child: Text(
              _initials,
              style: TextStyle(
                color: palette.accentPurple,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  registration.name,
                  style: TextStyle(
                    color: context.raisedTextPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  registration.email,
                  style: TextStyle(
                    color: context.raisedTextSecondary,
                    fontSize: 13,
                  ),
                ),
                if (registration.phone.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    registration.phone,
                    style: TextStyle(
                      color: context.raisedTextSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
                if (registration.nationality != null &&
                    registration.nationality!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: context.raisedTextSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        registration.nationality!,
                        style: TextStyle(
                          color: context.raisedTextSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
                if (!compact && registration.skills.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final skill in registration.skills)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: palette.aboutLabelBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            skill,
                            style: TextStyle(
                              color: palette.aboutAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
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
