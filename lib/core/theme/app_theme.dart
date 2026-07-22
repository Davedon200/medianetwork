import 'package:flutter/material.dart';
import 'package:media_network/core/theme/app_palette.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppPalette.oxfordBlue,
      brightness: Brightness.light,
      primary: AppPalette.oxfordBlue,
      surface: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: AppPalette.light.pageGradientStart,
      dialogTheme: DialogThemeData(
        backgroundColor: AppPalette.light.surfaceModal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      extensions: const [AppPalette.light],
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
      surface: const Color(0xFF020617),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: AppPalette.dark.pageGradientStart,
      dialogTheme: DialogThemeData(
        backgroundColor: AppPalette.dark.surfaceModal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      extensions: const [AppPalette.dark],
    );
  }
}
