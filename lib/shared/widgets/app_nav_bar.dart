import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_network/core/constants/breakpoints.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/responsive/responsive.dart';
import 'package:media_network/core/theme/text_styles.dart';
import 'package:media_network/core/theme/theme_view_model.dart';
import 'package:media_network/data/models/user_profile.dart';
import 'package:media_network/data/repositories/profile_repository.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';
import 'package:media_network/features/chat/services/chat_notification_service.dart';
import 'package:media_network/features/profile/view/widgets/profile_avatar.dart';
import 'package:media_network/shared/widgets/theme_toggle_button.dart';
import 'package:provider/provider.dart';

class AppNavBar extends StatefulWidget {
  const AppNavBar({super.key, required this.currentPath});

  final String currentPath;

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  int _unreadCount = 0;
  ChatNotificationService? _chatService;

  static const _routes = <String, String>{
    'Home': '/home',
    'Resources': '/resources',
    'Creators': '/creators',
    'Projects': '/projects',
    'Analytics': '/analytics',
    'Messages': '/messages',
  };

  @override
  void initState() {
    super.initState();
    _chatService = context.read<ChatNotificationService>();
    _unreadCount = _chatService!.totalUnread;
    _chatService!.onUnreadChanged = _onUnreadChanged;
  }

  @override
  void dispose() {
    _chatService?.onUnreadChanged = null;
    super.dispose();
  }

  void _onUnreadChanged() {
    if (!mounted) return;
    setState(() {
      _unreadCount = _chatService?.totalUnread ?? 0;
    });
  }

  String _normalizedPath(String path) {
    if (path == '/explore' || path == '/explorepage') return '/resources';
    return path;
  }

  bool _isActive(String route) {
    final normalized = _normalizedPath(widget.currentPath);
    if (route == '/resources') {
      return normalized == '/resources';
    }
    if (route == '/messages') {
      return normalized == '/messages' || normalized.startsWith('/messages/');
    }
    return normalized == route;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final width = MediaQuery.of(context).size.width;
    final isMobile = !Breakpoints.isDesktop(width);
    final hPad = Responsive.horizontalPadding(width);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: isMobile ? 12 : 20,
      ),
      decoration: BoxDecoration(color: palette.surfaceNav),
      child: isMobile ? _mobileLayout(context) : _webLayout(context),
    );
  }

  Widget _brand(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/home'),
        child: Row(
          children: [
            Image.asset(
              'assets/images/rnm.png',
              fit: BoxFit.scaleDown,
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    const LinearGradient(
                      colors: [Colors.deepPurpleAccent, Colors.cyanAccent],
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                child: Text(
                  'Rhapsody Media Network',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: WebTextStyles.heading(context).copyWith(
                    fontSize:
                        Breakpoints.isDesktop(MediaQuery.of(context).size.width)
                        ? 19
                        : 14,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mobileLayout(BuildContext context) {
    final palette = context.palette;
    final themeVm = context.read<ThemeViewModel>();
    final authVm = context.watch<AuthViewModel>();

    return Row(
      children: [
        Expanded(child: _brand(context)),
        if (authVm.isLoggedIn) ...[
          _MessagesIcon(
            isActive: _isActive('/messages'),
            unreadCount: _unreadCount,
          ),
          const SizedBox(width: 4),
          _NavUserAvatar(onTap: () => context.go('/profile')),
        ],
        ThemeToggleButton(iconColor: palette.textSecondary),
        PopupMenuButton<String>(
          icon: Icon(Icons.menu, color: palette.textPrimary),
          color: palette.surfaceNav,
          onSelected: (value) {
            if (value == '__theme__') {
              themeVm.toggle();
              return;
            }
            if (value == '__profile__') {
              context.go('/profile');
              return;
            }
            final route = _routes[value];
            if (route != null) context.go(route);
          },
          itemBuilder: (context) => [
            for (final entry in _routes.entries)
              PopupMenuItem(
                value: entry.key,
                child: Text(
                  entry.key,
                  style: TextStyle(
                    color: _isActive(entry.value)
                        ? palette.accentTeal
                        : palette.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (authVm.isLoggedIn)
              PopupMenuItem(
                value: '__profile__',
                child: Text(
                  'Profile',
                  style: TextStyle(color: palette.textPrimary),
                ),
              ),
            PopupMenuItem(
              value: '__theme__',
              child: Text(
                themeVm.isDark ? 'Light mode' : 'Dark mode',
                style: TextStyle(color: palette.textPrimary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _webLayout(BuildContext context) {
    final palette = context.palette;
    final authVm = context.watch<AuthViewModel>();

    return Row(
      children: [
        Flexible(child: _brand(context)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final entry in _routes.entries)
              _NavItem(
                title: entry.key,
                route: entry.value,
                isActive: _isActive(entry.value),
                badgeCount: entry.value == '/messages' ? _unreadCount : 0,
              ),
            const SizedBox(width: 8),
            ThemeToggleButton(iconColor: palette.textSecondary),
            const SizedBox(width: 12),
            Icon(Icons.search, color: palette.textSecondary),
            const SizedBox(width: 20),
            if (authVm.isLoggedIn)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => context.go('/profile'),
                  child: _NavUserAvatar(onTap: () => context.go('/profile')),
                ),
              )
            else
              CircleAvatar(
                radius: 14,
                backgroundColor: palette.surfaceElevated,
              ),
          ],
        ),
      ],
    );
  }
}

class _NavUserAvatar extends StatelessWidget {
  const _NavUserAvatar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final uid = authVm.uid;
    if (uid == null) {
      return GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: 14,
          backgroundColor: context.palette.surfaceElevated,
        ),
      );
    }

    return StreamBuilder<UserProfile?>(
      stream: context.read<ProfileRepository>().watchProfile(uid),
      builder: (context, snapshot) {
        final profile = snapshot.data;
        return GestureDetector(
          onTap: onTap,
          child: ProfileAvatar(profile: profile, radius: 14),
        );
      },
    );
  }
}

class _MessagesIcon extends StatelessWidget {
  const _MessagesIcon({required this.isActive, required this.unreadCount});

  final bool isActive;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return IconButton(
      onPressed: () => context.go('/messages'),
      icon: Badge(
        isLabelVisible: unreadCount > 0,
        label: Text('$unreadCount'),
        child: Icon(
          Icons.mail_outline,
          color: isActive ? palette.accentTeal : palette.textSecondary,
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.title,
    required this.route,
    required this.isActive,
    this.badgeCount = 0,
  });

  final String title;
  final String route;
  final bool isActive;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isActive
                          ? palette.accentTeal
                          : palette.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (badgeCount > 0) ...[
                    const SizedBox(width: 6),
                    CircleAvatar(
                      radius: 9,
                      backgroundColor: palette.accentTeal,
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: isActive ? 24 : 0,
                decoration: BoxDecoration(
                  color: palette.accentTeal,
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: palette.accentTeal.withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
