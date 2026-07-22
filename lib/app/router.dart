import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_network/app/animated_page.dart';
import 'package:media_network/core/motion/app_motion.dart';
import 'package:media_network/core/utils/logger.dart';
import 'package:media_network/features/admin/view/admin_dashboard.dart';
import 'package:media_network/features/analytics/view/analytics_page.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';
import 'package:media_network/features/chat/view/chat_thread_page.dart';
import 'package:media_network/features/chat/view/conversations_page.dart';
import 'package:media_network/features/creators/view/creators_page.dart';
import 'package:media_network/features/explore/view/explore_page.dart';
import 'package:media_network/features/home/view/home_page.dart';
import 'package:media_network/features/landing/view/landing_page.dart';
import 'package:media_network/features/profile/view/profile_page.dart';
import 'package:media_network/features/projects/view/projects_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._();

  static final _logger = WebUtils.getLogger('AppRouter');

  static const _protectedPrefixes = [
    '/home',
    '/resources',
    '/creators',
    '/projects',
    '/analytics',
    '/profile',
    '/messages',
  ];

  static late final GoRouter router;

  static void configure(AuthViewModel authViewModel) {
    router = GoRouter(
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: true,
      refreshListenable: authViewModel,
      redirect: (context, state) {
        _logger.d('Route: ${state.uri.path}');
        final path = state.uri.path;

        if (path == '/explorepage' || path == '/explore') {
          return '/resources';
        }

        final loggedIn = authViewModel.isLoggedIn;
        final isProtected = _protectedPrefixes.any(
          (prefix) => path == prefix || path.startsWith('$prefix/'),
        );

        if (loggedIn && path == '/') return '/home';
        if (!loggedIn && isProtected) return '/';

        if (loggedIn && authViewModel.isEmailLink(state.uri)) {
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => animatedPage<void>(
            key: state.pageKey,
            duration: AppMotion.slow,
            child: LandingPage(initialPath: state.uri.path),
          ),
        ),
        GoRoute(
          path: '/register',
          pageBuilder: (context, state) => animatedPage<void>(
            key: state.pageKey,
            child: const LandingPage(initialPath: '/register'),
          ),
        ),
        GoRoute(
          path: '/resource',
          pageBuilder: (context, state) => animatedPage<void>(
            key: state.pageKey,
            child: const LandingPage(initialPath: '/resource'),
          ),
        ),
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => animatedPage<void>(
            key: state.pageKey,
            child: const HomePage(),
          ),
        ),
        GoRoute(
          path: '/resources',
          pageBuilder: (context, state) => animatedPage<void>(
            key: state.pageKey,
            child: const ExplorePage(),
          ),
        ),
        GoRoute(
          path: '/creators',
          pageBuilder: (context, state) => animatedPage<void>(
            key: state.pageKey,
            child: const CreatorsPage(),
          ),
        ),
        GoRoute(
          path: '/projects',
          pageBuilder: (context, state) => animatedPage<void>(
            key: state.pageKey,
            child: const ProjectsPage(),
          ),
        ),
        GoRoute(
          path: '/analytics',
          pageBuilder: (context, state) => animatedPage<void>(
            key: state.pageKey,
            child: const AnalyticsPage(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => animatedPage<void>(
            key: state.pageKey,
            child: const ProfilePage(),
          ),
        ),
        GoRoute(
          path: '/messages',
          pageBuilder: (context, state) => animatedPage<void>(
            key: state.pageKey,
            child: const ConversationsPage(),
          ),
        ),
        GoRoute(
          path: '/messages/:conversationId',
          pageBuilder: (context, state) => animatedPage<void>(
            key: state.pageKey,
            child: ChatThreadPage(
              conversationId: state.pathParameters['conversationId']!,
            ),
          ),
        ),
        GoRoute(
          path: '/admin',
          pageBuilder: (context, state) => animatedPage<void>(
            key: state.pageKey,
            child: const AdminDashboard(),
          ),
        ),
      ],
    );
  }
}
