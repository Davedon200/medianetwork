import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_network/data/models/user_profile.dart';
import 'package:media_network/data/repositories/profile_repository.dart';
import 'package:media_network/features/auth/data/auth_repository.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({User? user}) : _user = user;

  User? _user;
  final _controller = StreamController<User?>.broadcast();
  bool signOutCalled = false;

  void setUser(User? user) {
    _user = user;
    _controller.add(user);
  }

  @override
  User? get currentUser => _user;

  @override
  Stream<User?> authStateChanges() => _controller.stream;

  @override
  Future<void> sendSignInLink(String email) async {
    if (_throwConfigurationNotFound) {
      throw FirebaseAuthException(code: 'configuration-not-found');
    }
  }

  bool _throwConfigurationNotFound = false;

  void setThrowConfigurationNotFound(bool value) {
    _throwConfigurationNotFound = value;
  }

  @override
  bool isEmailLink(Uri link) => false;

  @override
  Future<UserCredential> completeEmailLinkSignIn(Uri link) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
    setUser(null);
  }
}

class FakeProfileRepository implements ProfileRepository {
  @override
  Future<void> ensureUserDoc(User user) async {}

  @override
  Future<void> ensureUserDocForEmail({
    required String uid,
    required String email,
  }) async {}

  @override
  Stream<UserProfile?> watchProfile(String uid) => const Stream.empty();

  @override
  Future<void> updatePhotoUrl(String uid, String photoUrl) async {}

  @override
  Future<String> uploadAvatar(String uid, List<int> bytes) async => '';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('signOut clears logged-in state', () async {
    final fakeAuth = FakeAuthRepository();
    final vm = AuthViewModel(
      authRepository: fakeAuth,
      profileRepository: FakeProfileRepository(),
    );

    fakeAuth.setUser(_FakeUser('uid-1', 'test@example.com'));
    await vm.init();

    expect(vm.isLoggedIn, isTrue);

    await vm.signOut();

    expect(fakeAuth.signOutCalled, isTrue);
    expect(vm.isLoggedIn, isFalse);
    expect(vm.user, isNull);
  });

  test('sendSignInLink falls back to local session when Auth unavailable',
      () async {
    final fakeAuth = FakeAuthRepository()..setThrowConfigurationNotFound(true);
    final vm = AuthViewModel(
      authRepository: fakeAuth,
      profileRepository: FakeProfileRepository(),
    );
    await vm.init();

    final outcome = await vm.sendSignInLink('user@rnm.test');

    expect(outcome, SignInOutcome.sessionStarted);
    expect(vm.isLoggedIn, isTrue);
    expect(vm.isLocalSession, isTrue);
    expect(vm.email, 'user@rnm.test');
  });
}

class _FakeUser implements User {
  _FakeUser(this._uid, this._email);

  final String _uid;
  final String _email;

  @override
  String? get email => _email;

  @override
  String get uid => _uid;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
