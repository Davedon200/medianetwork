import 'package:flutter/material.dart';
import 'package:media_network/app/router.dart';
import 'package:media_network/core/motion/app_motion.dart';
import 'package:media_network/core/theme/app_theme.dart';
import 'package:media_network/core/theme/theme_view_model.dart';
import 'package:media_network/data/repositories/analytics_repository.dart';
import 'package:media_network/data/repositories/chat_repository.dart';
import 'package:media_network/data/repositories/creators_repository.dart';
import 'package:media_network/data/repositories/media_repository.dart';
import 'package:media_network/data/repositories/profile_repository.dart';
import 'package:media_network/data/repositories/registration_repository.dart';
import 'package:media_network/features/auth/data/auth_repository.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';
import 'package:media_network/features/chat/services/chat_notification_service.dart';
import 'package:provider/provider.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({
    super.key,
    required this.child,
    required this.themeViewModel,
    required this.authViewModel,
    required this.chatNotificationService,
  });

  final Widget child;
  final ThemeViewModel themeViewModel;
  final AuthViewModel authViewModel;
  final ChatNotificationService chatNotificationService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeViewModel>.value(value: themeViewModel),
        ChangeNotifierProvider<AuthViewModel>.value(value: authViewModel),
        Provider<ChatNotificationService>.value(
          value: chatNotificationService,
        ),
        Provider<AuthRepository>(
          create: (_) => FirebaseAuthRepository(),
        ),
        Provider<RegistrationRepository>(
          create: (_) => FirestoreRegistrationRepository(),
        ),
        Provider<MediaRepository>(
          create: (_) => FirestoreMediaRepository(),
        ),
        Provider<AnalyticsRepository>(
          create: (_) => FirestoreAnalyticsRepository(),
        ),
        Provider<ProfileRepository>(
          create: (_) => FirestoreProfileRepository(),
        ),
        Provider<ChatRepository>(
          create: (_) => FirestoreChatRepository(),
        ),
        Provider<CreatorsRepository>(
          create: (_) => FirestoreCreatorsRepository(),
        ),
      ],
      child: child,
    );
  }
}

class RhapsodyMediaNetworkApp extends StatefulWidget {
  const RhapsodyMediaNetworkApp({super.key});

  @override
  State<RhapsodyMediaNetworkApp> createState() => _RhapsodyMediaNetworkAppState();
}

class _RhapsodyMediaNetworkAppState extends State<RhapsodyMediaNetworkApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatService = context.read<ChatNotificationService>();
      chatService.attachNavigator(rootNavigatorKey);
      chatService.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();

    return MaterialApp.router(
      title: 'Rhapsody Media Network',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeViewModel.mode,
      themeAnimationDuration: AppMotion.normal,
      routerConfig: AppRouter.router,
    );
  }
}
