import 'package:cloud_firestore/cloud_firestore.dart';

class Registration {
  final String id;
  final String? title;
  final String name;
  final String email;
  final String phone;
  final String? nationality;
  final String kc;
  final String ceZone;
  final List<String> skills;
  final DateTime? createdAt;

  const Registration({
    required this.id,
    this.title,
    required this.name,
    required this.email,
    required this.phone,
    this.nationality,
    required this.kc,
    required this.ceZone,
    required this.skills,
    this.createdAt,
  });

  factory Registration.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Registration(
      id: doc.id,
      title: data['title'] as String?,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? doc.id,
      phone: data['phone'] as String? ?? '',
      nationality: data['nationality'] as String?,
      kc: data['kc'] as String? ?? '',
      ceZone: data['ceZone'] as String? ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'name': name,
      'email': email.toLowerCase(),
      'phone': phone,
      'nationality': nationality,
      'kc': kc,
      'ceZone': ceZone,
      'skills': skills,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
