import 'package:firebase_auth/firebase_auth.dart';
import 'package:media_network/core/constants/auth_constants.dart';
import 'package:media_network/core/utils/app_error_log.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRepository {
  Stream<User?> authStateChanges();
  User? get currentUser;
  Future<void> sendSignInLink(String email);
  Future<UserCredential> completeEmailLinkSignIn(Uri link);
  bool isEmailLink(Uri link);
  Future<void> signOut();
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    FirebaseAuth? auth,
    SharedPreferences? prefs,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _prefs = prefs;

  static const _tag = 'AuthRepo';

  final FirebaseAuth _auth;
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async =>
      _prefs ??= await SharedPreferences.getInstance();

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<void> sendSignInLink(String email) async {
    final normalized = email.trim().toLowerCase();
    final continueUrl = AuthConstants.emailLinkContinueUrl;
    final settings = ActionCodeSettings(
      url: continueUrl,
      handleCodeInApp: true,
      androidPackageName: 'com.example.media_network',
      androidInstallApp: true,
      androidMinimumVersion: '21',
      iOSBundleId: 'com.example.mediaNetwork',
    );
    try {
      await _auth.sendSignInLinkToEmail(
        email: normalized,
        actionCodeSettings: settings,
      );
      final prefs = await _preferences;
      await prefs.setString(AuthConstants.pendingEmailKey, normalized);
    } catch (e, st) {
      AppErrorLog.log(
        e,
        st,
        tag: _tag,
        op: 'sendSignInLink',
        context: {'continueUrl': continueUrl},
      );
      rethrow;
    }
  }

  @override
  bool isEmailLink(Uri link) =>
      _auth.isSignInWithEmailLink(link.toString());

  @override
  Future<UserCredential> completeEmailLinkSignIn(Uri link) async {
    final prefs = await _preferences;
    final email = prefs.getString(AuthConstants.pendingEmailKey);
    if (email == null || email.isEmpty) {
      final error = FirebaseAuthException(
        code: 'missing-email',
        message: 'No pending sign-in email found. Request a new link.',
      );
      AppErrorLog.log(
        error,
        StackTrace.current,
        tag: _tag,
        op: 'completeEmailLinkSignIn',
        context: {'hasPendingEmail': false},
      );
      throw error;
    }
    try {
      final credential = await _auth.signInWithEmailLink(
        email: email,
        emailLink: link.toString(),
      );
      await prefs.remove(AuthConstants.pendingEmailKey);
      return credential;
    } catch (e, st) {
      AppErrorLog.log(
        e,
        st,
        tag: _tag,
        op: 'completeEmailLinkSignIn',
        context: {'hasPendingEmail': true},
      );
      rethrow;
    }
  }

  @override
  Future<void> signOut() => AppErrorLog.guard(
        () => _auth.signOut(),
        tag: _tag,
        op: 'signOut',
      );
}
