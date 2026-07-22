import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:media_network/core/constants/auth_constants.dart';
import 'package:media_network/core/utils/app_error_log.dart';
import 'package:media_network/data/repositories/profile_repository.dart';
import 'package:media_network/features/auth/data/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SignInOutcome { emailLinkSent, sessionStarted }

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({
    required AuthRepository authRepository,
    ProfileRepository? profileRepository,
    SharedPreferences? prefs,
  })  : _authRepository = authRepository,
        _profileRepository = profileRepository ?? FirestoreProfileRepository(),
        _prefs = prefs;

  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;
  SharedPreferences? _prefs;

  User? _user;
  String? _localEmail;
  String? _localUid;
  bool _initialized = false;
  StreamSubscription<User?>? _subscription;

  User? get user => _user;
  bool get isLoggedIn => _user != null || _localEmail != null;
  bool get isLocalSession => _user == null && _localEmail != null;
  bool get isInitialized => _initialized;
  String? get email => _user?.email?.toLowerCase() ?? _localEmail;
  String? get displayName => _user?.displayName ?? _localEmail?.split('@').first;
  String? get uid => _user?.uid ?? _localUid;

  static bool isAuthUnavailable(Object error) {
    if (error is FirebaseAuthException) {
      return _isAuthUnavailableCode(error.code);
    }
    if (error is FirebaseException) {
      return _isAuthUnavailableCode(error.code);
    }
    return error.toString().contains('configuration-not-found');
  }

  static bool _isAuthUnavailableCode(String code) {
    return code == 'configuration-not-found' ||
        code == 'operation-not-allowed';
  }

  Future<SharedPreferences> get _preferences async =>
      _prefs ??= await SharedPreferences.getInstance();

  static String localUidForEmail(String email) {
    return 'local_${email.trim().toLowerCase().hashCode.abs()}';
  }

  Future<void> init() async {
    _user = _authRepository.currentUser;
    final prefs = await _preferences;
    _localEmail = prefs.getString(AuthConstants.localSessionEmailKey);
    if (_localEmail != null) {
      _localUid = localUidForEmail(_localEmail!);
    }

    _subscription = _authRepository.authStateChanges().listen((user) async {
      _user = user;
      if (user != null) {
        await _clearLocalSession(silent: true);
        await _profileRepository.ensureUserDoc(user);
      }
      notifyListeners();
    });
    _initialized = true;
    notifyListeners();
  }

  Future<SignInOutcome> sendSignInLink(String email) async {
    try {
      await _authRepository.sendSignInLink(email);
      return SignInOutcome.emailLinkSent;
    } catch (e, st) {
      if (!isAuthUnavailable(e)) rethrow;
      await signInWithLocalSession(email);
      AppErrorLog.log(
        e,
        st,
        tag: 'AuthViewModel',
        op: 'sendSignInLink',
        context: {'fallback': 'localSession'},
      );
      return SignInOutcome.sessionStarted;
    }
  }

  Future<void> signInWithLocalSession(String email) async {
    final normalized = email.trim().toLowerCase();
    final prefs = await _preferences;
    await prefs.setString(AuthConstants.localSessionEmailKey, normalized);
    _localEmail = normalized;
    _localUid = localUidForEmail(normalized);
    try {
      await _profileRepository.ensureUserDocForEmail(
        uid: _localUid!,
        email: normalized,
      );
    } catch (e, st) {
      AppErrorLog.log(
        e,
        st,
        tag: 'AuthViewModel',
        op: 'ensureUserDocForEmail',
      );
    }
    notifyListeners();
    print(
      'APP_INFO | AuthViewModel | localSessionStarted | '
      'isLoggedIn=$isLoggedIn uid=$_localUid',
    );
    // #region agent log
    _emitDebugIngest(
      message: 'localSessionStarted',
      data: {'isLoggedIn': isLoggedIn, 'hasUid': _localUid != null},
    );
    // #endregion
  }

  static void _emitDebugIngest({
    required String message,
    Map<String, dynamic>? data,
  }) {
    final payload = <String, dynamic>{
      'sessionId': 'd3f316',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'location': 'auth_view_model.dart',
      'message': message,
      'hypothesisId': 'B',
      'data': data ?? {},
    };
    if (kIsWeb) {
      http
          .post(
            Uri.parse(
              'http://127.0.0.1:7905/ingest/1b0592ac-e32e-44d5-9cde-064f8d4c0cf6',
            ),
            headers: {
              'Content-Type': 'application/json',
              'X-Debug-Session-Id': 'd3f316',
            },
            body: jsonEncode(payload),
          )
          .catchError((_) => http.Response('', 500));
    }
  }

  Future<void> _clearLocalSession({bool silent = false}) async {
    final prefs = await _preferences;
    await prefs.remove(AuthConstants.localSessionEmailKey);
    _localEmail = null;
    _localUid = null;
    if (!silent) notifyListeners();
  }

  bool isEmailLink(Uri uri) => _authRepository.isEmailLink(uri);

  Future<bool> completeEmailLink(Uri uri) async {
    if (!_authRepository.isEmailLink(uri)) return false;
    await _authRepository.completeEmailLinkSignIn(uri);
    return true;
  }

  Future<void> signOut() async {
    await _clearLocalSession(silent: true);
    await _authRepository.signOut();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
