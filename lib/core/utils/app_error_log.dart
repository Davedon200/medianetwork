import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:rhapsody_media_network/core/utils/logger.dart';

/// Terminal-only error logging for Firebase, HTTP, and other API failures.
abstract final class AppErrorLog {
  static final _loggers = <String, Logger>{};

  static Logger _logger(String tag) =>
      _loggers.putIfAbsent(tag, () => WebUtils.getLogger(tag));

  static String summarize(Object error) {
    if (error is FirebaseAuthException) {
      return '${error.code}: ${error.message ?? 'no message'}';
    }
    if (error is FirebaseException) {
      return '${error.plugin}/${error.code}: ${error.message ?? 'no message'}';
    }
    return error.toString();
  }

  static void log(
    Object error,
    StackTrace stackTrace, {
    required String tag,
    required String op,
    Map<String, dynamic>? context,
  }) {
    final summary = summarize(error);
    final ctx = context != null && context.isNotEmpty ? ' | $context' : '';
    final line = 'APP_ERROR | $tag | $op | $summary$ctx';

    // Plain ASCII — visible in flutter run terminal and Chrome DevTools.
    print(line);
    print(stackTrace);

    developer.log(
      line,
      name: tag,
      error: error,
      stackTrace: stackTrace,
    );

    _logger(tag).e('$op failed — $summary$ctx');
  }

  static Future<T> guard<T>(
    Future<T> Function() action, {
    required String tag,
    required String op,
    Map<String, dynamic>? context,
  }) async {
    try {
      return await action();
    } catch (e, st) {
      log(e, st, tag: tag, op: op, context: context);
      rethrow;
    }
  }

  static Stream<T> guardStream<T>(
    Stream<T> stream, {
    required String tag,
    required String op,
  }) {
    return stream.handleError((Object e, StackTrace st) {
      log(e, st, tag: tag, op: op);
    });
  }
}
