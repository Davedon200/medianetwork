import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_network/app/app.dart';
import 'package:media_network/app/router.dart';
import 'package:media_network/core/theme/theme_view_model.dart';
import 'package:media_network/core/utils/app_error_log.dart';
import 'package:media_network/features/auth/data/auth_repository.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';
import 'package:media_network/features/chat/services/chat_notification_service.dart';
import 'package:media_network/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    print(
      '[MediaNetwork] Error logging active — failures print as '
      'APP_ERROR | tag | operation | details',
    );
  }

  final themeViewModel = ThemeViewModel();
  await themeViewModel.init();

  final authViewModel = AuthViewModel(
    authRepository: FirebaseAuthRepository(),
  );
  await authViewModel.init();

  AppRouter.configure(authViewModel);

  final chatNotificationService = ChatNotificationService(
    authViewModel: authViewModel,
  );
  authViewModel.addListener(() {
    if (authViewModel.isLoggedIn) {
      chatNotificationService.start();
    } else {
      chatNotificationService.stop();
    }
  });
  if (authViewModel.isLoggedIn) {
    chatNotificationService.start();
  }

  runApp(
    AppProviders(
      themeViewModel: themeViewModel,
      authViewModel: authViewModel,
      chatNotificationService: chatNotificationService,
      child: const RhapsodyMediaNetworkApp(),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final uri = Uri.base;
    if (authViewModel.isEmailLink(uri)) {
      try {
        await authViewModel.completeEmailLink(uri);
      } catch (e, st) {
        AppErrorLog.log(e, st, tag: 'Main', op: 'completeEmailLink');
      }
    }
  });
}
