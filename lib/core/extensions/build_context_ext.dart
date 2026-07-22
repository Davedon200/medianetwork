import 'package:flutter/material.dart';

String convertToTitleCase(String? text) {
  if (text == null) {
    return 'null';
  }

  if (text.length <= 1) {
    return text.toUpperCase();
  }

  final List<String> words = text.split(RegExp(r'[-_\s]'));

  final capitalizedWords = words.map((word) {
    if (word.trim().isNotEmpty) {
      final String firstLetter = word.trim().substring(0, 1).toUpperCase();
      final String remainingLetters = word.trim().substring(1);
      return '$firstLetter$remainingLetters';
    }
    return '';
  });

  return capitalizedWords.join(' ');
}

extension MuleExStringManipulations on String {
  String toTitleCase() => convertToTitleCase(this);

  String removeUnderscores() => replaceAll(RegExp(r'_'), ' ');
}

extension BuildContextExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  Size get screenSize => MediaQuery.of(this).size;
  Orientation get orientation => MediaQuery.of(this).orientation;

  Future<T?> push<T extends Object?>(Route<T> route) {
    return Navigator.of(this).push(route);
  }

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  String restorablePopAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(this).restorablePopAndPushNamed(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  String restorablePushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).restorablePushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(this).popAndPushNamed(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  String restorablePushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(this).restorablePushReplacementNamed(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(this).pushReplacementNamed(
      routeName,
      result: result,
      arguments: arguments,
    );
  }
}

String safeText(String? value) {
  if (value == null) return '...';
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return '...';
  return trimmed;
}
