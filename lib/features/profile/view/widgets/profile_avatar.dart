import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/data/models/user_profile.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.profile,
    this.radius = 48,
    this.onTap,
    this.showEditBadge = false,
    this.isLoading = false,
  });

  final UserProfile? profile;
  final double radius;
  final VoidCallback? onTap;
  final bool showEditBadge;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final photoUrl = profile?.photoUrl;
    final initials = profile?.initials ?? '?';

    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: palette.surfaceElevated,
      backgroundImage:
          photoUrl != null ? CachedNetworkImageProvider(photoUrl) : null,
      child: photoUrl == null
          ? Text(
              initials,
              style: TextStyle(
                color: palette.textPrimary,
                fontSize: radius * 0.45,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );

    if (isLoading) {
      avatar = Stack(
        alignment: Alignment.center,
        children: [
          avatar,
          const CircularProgressIndicator(strokeWidth: 2),
        ],
      );
    }

    if (showEditBadge) {
      avatar = Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              radius: radius * 0.28,
              backgroundColor: palette.accentPurple,
              child: Icon(
                Icons.camera_alt,
                size: radius * 0.3,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: avatar);
    }
    return avatar;
  }
}
