import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> submitRegistration({
    required String name,
    required String email,
    required String phone,
    required String kc,
    required String social,
    required String ceZone,
    required List<String> skills,
  }) async {
    await _db.collection('registrations').add({
      'name': name,
      'email': email,
      'phone': phone,
      'kc': kc,
      'social': social,
      'ceZone': ceZone,
      'skills': skills,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}