import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:media_network/core/utils/app_error_log.dart';
import 'package:media_network/data/models/registration.dart';

abstract class RegistrationRepository {
  Future<bool> existsByEmail(String email);
  Future<void> submit(Registration registration);
  Stream<List<Registration>> watchAll();
}

class FirestoreRegistrationRepository implements RegistrationRepository {
  FirestoreRegistrationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const _tag = 'RegistrationRepo';

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('registrations');

  @override
  Future<bool> existsByEmail(String email) => AppErrorLog.guard(
        () async {
          final doc = await _collection.doc(email.trim().toLowerCase()).get();
          return doc.exists;
        },
        tag: _tag,
        op: 'existsByEmail',
      );

  @override
  Future<void> submit(Registration registration) => AppErrorLog.guard(
        () async {
          final email = registration.email.trim().toLowerCase();
          await _collection.doc(email).set(registration.toFirestore());
        },
        tag: _tag,
        op: 'submit',
      );

  @override
  Stream<List<Registration>> watchAll() {
    return AppErrorLog.guardStream(
      _collection.orderBy('createdAt', descending: true).snapshots().map(
            (snapshot) => snapshot.docs
                .map(Registration.fromFirestore)
                .toList(growable: false),
          ),
      tag: _tag,
      op: 'watchAll',
    );
  }
}
