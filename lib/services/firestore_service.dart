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

  /// Returns null when saved, or a short error the page can show.
  static Future<String?> submitSurvey({
    required String title,
    required String name,
    required String email,
    required String phone,
    required String kc,
    required List<String> platforms,
    required List<String> programs,
    required String satisfaction,
    required String newFeature,
    required String suggestions,
    required String discovery,
  }) async {
    final normalized = email.trim().toLowerCase();
    final ref = _db.collection('surveys').doc(normalized);
    final existing = await ref.get();
    if (existing.exists) {
      return 'You have already submitted this survey.';
    }

    await ref.set({
      'title': title,
      'name': name,
      'email': normalized,
      'phone': phone,
      'kc': kc,
      'platforms': platforms,
      'programs': programs,
      'satisfaction': satisfaction,
      'newFeature': newFeature,
      'suggestions': suggestions,
      'discovery': discovery,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return null;
  }
}