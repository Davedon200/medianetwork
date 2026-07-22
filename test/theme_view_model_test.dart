import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_network/core/theme/theme_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('defaults to dark mode when no preference is stored', () async {
    final viewModel = ThemeViewModel();
    await viewModel.init();

    expect(viewModel.mode, ThemeMode.dark);
    expect(viewModel.isDark, isTrue);
    expect(viewModel.isInitialized, isTrue);
  });

  test('loads light mode from shared preferences', () async {
    SharedPreferences.setMockInitialValues({'theme_mode': 'light'});

    final viewModel = ThemeViewModel();
    await viewModel.init();

    expect(viewModel.mode, ThemeMode.light);
    expect(viewModel.isDark, isFalse);
  });

  test('toggle switches between dark and light and persists', () async {
    final viewModel = ThemeViewModel();
    await viewModel.init();

    await viewModel.toggle();
    expect(viewModel.mode, ThemeMode.light);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('theme_mode'), 'light');

    await viewModel.toggle();
    expect(viewModel.mode, ThemeMode.dark);
    expect(prefs.getString('theme_mode'), 'dark');
  });

  test('setMode updates mode and persists', () async {
    final viewModel = ThemeViewModel();
    await viewModel.init();

    await viewModel.setMode(ThemeMode.light);
    expect(viewModel.mode, ThemeMode.light);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('theme_mode'), 'light');
  });

  test('setMode is a no-op when mode is unchanged', () async {
    final viewModel = ThemeViewModel();
    await viewModel.init();

    var notifyCount = 0;
    viewModel.addListener(() => notifyCount++);

    await viewModel.setMode(ThemeMode.dark);
    expect(notifyCount, 0);
  });
}
