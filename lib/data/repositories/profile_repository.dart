import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:media_network/core/utils/app_error_log.dart';
import 'package:media_network/data/models/registration.dart';
import 'package:media_network/data/models/user_profile.dart';

abstract class ProfileRepository {
  Future<void> ensureUserDoc(User user);
  Future<void> ensureUserDocForEmail({
    required String uid,
    required String email,
  });
  Stream<UserProfile?> watchProfile(String uid);
  Future<void> updatePhotoUrl(String uid, String photoUrl);
  Future<String> uploadAvatar(String uid, List<int> bytes);
}

class FirestoreProfileRepository implements ProfileRepository {
  FirestoreProfileRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  static const _tag = 'ProfileRepo';

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _registrations =>
      _firestore.collection('registrations');

  @override
  Future<void> ensureUserDoc(User user) => AppErrorLog.guard(
        () async {
          final email = user.email?.trim().toLowerCase() ?? '';
          await ensureUserDocForEmail(uid: user.uid, email: email);
          final photo = user.photoURL;
          if (photo != null) {
            await _users.doc(user.uid).update({'photoUrl': photo});
          }
        },
        tag: _tag,
        op: 'ensureUserDoc',
      );

  @override
  Future<void> ensureUserDocForEmail({
    required String uid,
    required String email,
  }) =>
      AppErrorLog.guard(
        () async {
          final normalized = email.trim().toLowerCase();
          if (normalized.isEmpty) return;

          final userRef = _users.doc(uid);
          final existing = await userRef.get();
          if (existing.exists) return;

          final regDoc = await _registrations.doc(normalized).get();
          final reg = regDoc.exists
              ? Registration.fromFirestore(regDoc)
              : Registration(
                  id: normalized,
                  name: normalized.split('@').first,
                  email: normalized,
                  phone: '',
                  kc: '',
                  ceZone: '',
                  skills: const [],
                );

          await userRef.set({
            'uid': uid,
            'email': normalized,
            'name': reg.name,
            'title': reg.title,
            'phone': reg.phone,
            'nationality': reg.nationality,
            'kc': reg.kc,
            'ceZone': reg.ceZone,
            'skills': reg.skills,
            'photoUrl': null,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        },
        tag: _tag,
        op: 'ensureUserDocForEmail',
      );

  @override
  Stream<UserProfile?> watchProfile(String uid) {
    return AppErrorLog.guardStream(
      _users.doc(uid).snapshots().map((doc) {
        if (!doc.exists) return null;
        return UserProfile.fromFirestore(doc);
      }),
      tag: _tag,
      op: 'watchProfile',
    );
  }

  @override
  Future<void> updatePhotoUrl(String uid, String photoUrl) => AppErrorLog.guard(
        () => _users.doc(uid).update({
          'photoUrl': photoUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        }),
        tag: _tag,
        op: 'updatePhotoUrl',
      );

  @override
  Future<String> uploadAvatar(String uid, List<int> bytes) => AppErrorLog.guard(
        () async {
          final ref = _storage.ref().child('avatars/$uid.jpg');
          await ref.putData(
            Uint8List.fromList(bytes),
            SettableMetadata(contentType: 'image/jpeg'),
          );
          return ref.getDownloadURL();
        },
        tag: _tag,
        op: 'uploadAvatar',
      );
}
