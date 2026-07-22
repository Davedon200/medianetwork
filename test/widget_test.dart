import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:media_network/app/router.dart';
import 'package:media_network/core/theme/app_palette.dart';
import 'package:media_network/core/theme/app_theme.dart';
import 'package:media_network/core/theme/theme_view_model.dart';
import 'package:media_network/data/repositories/profile_repository.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';
import 'package:media_network/features/chat/services/chat_notification_service.dart';
import 'package:media_network/features/home/view/home_page.dart';
import 'package:media_network/features/landing/view/widgets/landing_footer.dart';
import 'package:media_network/shared/widgets/app_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_view_model_test.dart' show FakeAuthRepository, FakeProfileRepository;
import 'fake_chat_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  late AuthViewModel shellAuthVm;
  late ChatNotificationService shellChatService;

  setUp(() async {
    final fakeAuth = FakeAuthRepository();
    shellAuthVm = AuthViewModel(
      authRepository: fakeAuth,
      profileRepository: FakeProfileRepository(),
    );
    await shellAuthVm.init();
    shellChatService = ChatNotificationService(
      authViewModel: shellAuthVm,
      chatRepository: FakeChatRepository(),
    );
  });

  Widget wrapWithTheme({
    required Widget child,
    ThemeMode themeMode = ThemeMode.dark,
    ThemeViewModel? themeViewModel,
  }) {
    final vm = themeViewModel ?? ThemeViewModel();
    return ChangeNotifierProvider<ThemeViewModel>.value(
      value: vm,
      child: MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        home: Scaffold(body: child),
      ),
    );
  }

  Widget wrapWithShellProviders({
    required Widget child,
    ThemeViewModel? themeViewModel,
    ThemeMode themeMode = ThemeMode.dark,
    GoRouter? router,
  }) {
    final themeVm = themeViewModel ?? ThemeViewModel();
    final app = router != null
        ? MaterialApp.router(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: router,
          )
        : MaterialApp(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            home: Scaffold(body: child),
          );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeViewModel>.value(value: themeVm),
        ChangeNotifierProvider<AuthViewModel>.value(value: shellAuthVm),
        Provider<ChatNotificationService>.value(value: shellChatService),
        Provider<ProfileRepository>(create: (_) => FakeProfileRepository()),
      ],
      child: router != null ? app : app,
    );
  }

  testWidgets('redirects logged-in user from / to /home', (tester) async {
    final themeVm = ThemeViewModel();
    await themeVm.init();

    final fakeAuth = FakeAuthRepository();
    final authVm = AuthViewModel(
      authRepository: fakeAuth,
      profileRepository: FakeProfileRepository(),
    );
    fakeAuth.setUser(_TestUser('uid-1', 'user@rnm.test'));
    await authVm.init();
    AppRouter.configure(authVm);

    final chatService = ChatNotificationService(
      authViewModel: authVm,
      chatRepository: FakeChatRepository(),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeViewModel>.value(value: themeVm),
          ChangeNotifierProvider<AuthViewModel>.value(value: authVm),
          Provider<ChatNotificationService>.value(value: chatService),
          Provider<ProfileRepository>(
            create: (_) => FakeProfileRepository(),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          routerConfig: AppRouter.router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(AppRouter.router.state.uri.path, '/home');
  });

  testWidgets('landing footer renders title', (tester) async {
    final themeVm = ThemeViewModel();
    await themeVm.init();

    await tester.pumpWidget(
      wrapWithTheme(
        themeViewModel: themeVm,
        child: const LandingFooter(),
      ),
    );

    expect(find.text('Rhapsody Media Network'), findsOneWidget);
  });

  testWidgets('home page renders in dark theme', (tester) async {
    final themeVm = ThemeViewModel();
    await themeVm.init();

    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, __) => const HomePage(),
        ),
      ],
    );

    await tester.pumpWidget(
      wrapWithShellProviders(
        themeViewModel: themeVm,
        themeMode: ThemeMode.dark,
        router: router,
        child: const HomePage(),
      ),
    );
    await tester.pump();

    expect(find.text('Welcome back to Rhapsody Media Network'), findsOneWidget);
    expect(find.text('Trending Now'), findsOneWidget);
    expect(find.text('Network News'), findsOneWidget);
    expect(find.text('Browse Resources'), findsOneWidget);
    expect(find.text('View Projects'), findsOneWidget);
  });

  testWidgets('home page renders in light theme', (tester) async {
    final themeVm = ThemeViewModel();
    await themeVm.init();

    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, __) => const HomePage(),
        ),
      ],
    );

    await tester.pumpWidget(
      wrapWithShellProviders(
        themeViewModel: themeVm,
        themeMode: ThemeMode.light,
        router: router,
        child: const HomePage(),
      ),
    );
    await tester.pump();

    expect(find.text('Welcome back to Rhapsody Media Network'), findsOneWidget);
    expect(find.text('Trending Now'), findsOneWidget);
  });

  testWidgets('app nav bar navigates between routes on desktop', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final themeVm = ThemeViewModel();
    await themeVm.init();

    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, __) => const Scaffold(
            body: AppNavBar(currentPath: '/home'),
          ),
        ),
        GoRoute(
          path: '/resources',
          builder: (_, __) => const Scaffold(
            body: AppNavBar(currentPath: '/resources'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      wrapWithShellProviders(
        themeViewModel: themeVm,
        themeMode: ThemeMode.dark,
        router: router,
        child: const SizedBox.shrink(),
      ),
    );
    await tester.pump();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Resources'), findsOneWidget);

    await tester.tap(find.text('Resources'));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, '/resources');
  });

  testWidgets('alert dialog uses white modal surface in dark theme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final palette = Theme.of(context).extension<AppPalette>()!;
              return AlertDialog(
                backgroundColor: palette.surfaceModal,
                title: Text(
                  'Test Modal',
                  style: TextStyle(color: palette.textOnModal),
                ),
              );
            },
          ),
        ),
      ),
    );

    final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
    expect(dialog.backgroundColor, Colors.white);
  });
}

class _TestUser implements User {
  _TestUser(this._uid, this._email);

  final String _uid;
  final String _email;

  @override
  String? get email => _email;

  @override
  String get uid => _uid;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
