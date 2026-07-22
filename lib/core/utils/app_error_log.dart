import 'dart:convert';
import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:media_network/core/utils/logger.dart';

/// Terminal-only error logging for Firebase, HTTP, and other API failures.
abstract final class AppErrorLog {
  static const _debugEndpoint =
      'http://127.0.0.1:7905/ingest/1b0592ac-e32e-44d5-9cde-064f8d4c0cf6';
  static const _debugSessionId = 'd3f316';

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

    // #region agent log
    _emitDebugIngest(
      location: 'app_error_log.dart:log',
      message: line,
      hypothesisId: 'A',
      data: {
        'tag': tag,
        'op': op,
        'errorType': error.runtimeType.toString(),
        if (error is FirebaseAuthException) 'code': error.code,
        if (error is FirebaseException) 'code': error.code,
      },
    );
    // #endregion
  }

  static void debugEvent({
    required String location,
    required String message,
    required String hypothesisId,
    Map<String, dynamic>? data,
    String runId = 'pre-fix',
  }) {
    _emitDebugIngest(
      location: location,
      message: message,
      hypothesisId: hypothesisId,
      data: {...?data, 'runId': runId},
    );
  }

  static void _emitDebugIngest({
    required String location,
    required String message,
    required String hypothesisId,
    Map<String, dynamic>? data,
  }) {
    final payload = <String, dynamic>{
      'sessionId': _debugSessionId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'location': location,
      'message': message,
      'hypothesisId': hypothesisId,
      'data': data ?? {},
    };
    if (kIsWeb) {
      http
          .post(
            Uri.parse(_debugEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'X-Debug-Session-Id': _debugSessionId,
            },
            body: jsonEncode(payload),
          )
          .catchError((_) => http.Response('', 500));
    }
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
