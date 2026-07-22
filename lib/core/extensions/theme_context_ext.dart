import 'package:flutter/material.dart';
import 'package:media_network/core/theme/app_palette.dart';
import 'package:media_network/shared/layout/light_panel_scope.dart';

extension ThemeContextExt on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.dark;

  bool get onLightPanel => LightPanelScope.isInside(this);

  Color get contentPrimary => palette.textPrimary;

  Color get contentSecondary => palette.textSecondary;

  Color get contentMuted => palette.textMuted;

  /// Card / elevated panel surface — lighter than page in dark, white in light.
  Color get raisedSurface => palette.surfaceElevated;

  Color get raisedBorder => palette.statBorder;

  Color get raisedTextPrimary => palette.textPrimary;

  Color get raisedTextSecondary => palette.textSecondary;

  bool get isLightTheme => Theme.of(this).brightness == Brightness.light;

  /// Trending / news cards: Oxford blue in light theme, raised card in dark.
  BoxDecoration featuredSectionCardDecoration({double radius = 20}) {
    if (isLightTheme) {
      return BoxDecoration(
        color: AppPalette.oxfordBlue,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: palette.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      );
    }
    return raisedCardDecoration(radius: radius);
  }

  Color get featuredCardTextPrimary =>
      isLightTheme ? Colors.white : palette.textPrimary;

  Color get featuredCardTextSecondary =>
      isLightTheme ? Colors.white.withValues(alpha: 0.72) : palette.textSecondary;

  BoxDecoration raisedCardDecoration({
    double radius = 20,
    EdgeInsetsGeometry? padding,
  }) {
    return BoxDecoration(
      color: raisedSurface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: raisedBorder),
      boxShadow: [
        BoxShadow(
          color: palette.shadowColor,
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  EdgeInsets get contentHorizontalPadding =>
      EdgeInsets.symmetric(horizontal: onLightPanel ? 0 : 16);
}
