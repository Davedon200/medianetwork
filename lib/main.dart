import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:media_network/firebase_options.dart';
import 'package:media_network/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RhapsodyMediaNetworkApp());
}

class RhapsodyMediaNetworkApp extends StatelessWidget {
  const RhapsodyMediaNetworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rhapsody Media Network',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark, // ✅ FIX
        ),
        fontFamily: 'Inter',
      ),
      initialRoute: WebRoutes.home,
      onGenerateRoute: WebRoutes.instance.generateRoute,
    );
  }
}
