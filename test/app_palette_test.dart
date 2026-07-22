import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_network/core/theme/app_palette.dart';
import 'package:media_network/core/theme/app_theme.dart';

void main() {
  test('AppPalette.lerp interpolates between light and dark', () {
    const t = 0.5;
    final result = AppPalette.light.lerp(AppPalette.dark, t);

    expect(result.pageGradientStart, isNot(AppPalette.light.pageGradientStart));
    expect(result.pageGradientStart, isNot(AppPalette.dark.pageGradientStart));
    expect(result.textPrimary, isNot(AppPalette.light.textPrimary));
    expect(result.accentTeal, AppPalette.light.accentTeal);
    expect(result.accentPurple, AppPalette.light.accentPurple);
  });

  test('AppPalette.lerp returns self for non-AppPalette extension', () {
    final result = AppPalette.dark.lerp(null, 0.5);
    expect(result, AppPalette.dark);
  });

  test('AppPalette.copyWith overrides selected fields', () {
    final updated = AppPalette.light.copyWith(textPrimary: Colors.red);
    expect(updated.textPrimary, Colors.red);
    expect(updated.textSecondary, AppPalette.light.textSecondary);
  });

  test('modal tokens are white with dark text in both themes', () {
    expect(AppPalette.light.surfaceModal, Colors.white);
    expect(AppPalette.dark.surfaceModal, Colors.white);
    expect(AppPalette.light.textOnModal, AppPalette.dark.textOnModal);
    expect(AppPalette.oxfordBlue, const Color(0xFF0F172A));
  });

  test('light theme primary is oxford blue', () {
    expect(AppTheme.light.colorScheme.primary, AppPalette.oxfordBlue);
  });

  test('dark theme dialog background is white', () {
    expect(AppTheme.dark.dialogTheme.backgroundColor, Colors.white);
  });
}
