import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  const UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    this.title,
    this.phone,
    this.nationality,
    this.kc,
    this.ceZone,
    this.skills = const [],
    this.photoUrl,
    this.updatedAt,
  });

  final String uid;
  final String email;
  final String name;
  final String? title;
  final String? phone;
  final String? nationality;
  final String? kc;
  final String? ceZone;
  final List<String> skills;
  final String? photoUrl;
  final DateTime? updatedAt;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserProfile(
      uid: doc.id,
      email: data['email'] as String? ?? '',
      name: data['name'] as String? ?? '',
      title: data['title'] as String?,
      phone: data['phone'] as String?,
      nationality: data['nationality'] as String?,
      kc: data['kc'] as String?,
      ceZone: data['ceZone'] as String?,
      skills: List<String>.from(data['skills'] ?? []),
      photoUrl: data['photoUrl'] as String?,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email.toLowerCase(),
      'name': name,
      'title': title,
      'phone': phone,
      'nationality': nationality,
      'kc': kc,
      'ceZone': ceZone,
      'skills': skills,
      'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  UserProfile copyWith({
    String? photoUrl,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      name: name,
      title: title,
      phone: phone,
      nationality: nationality,
      kc: kc,
      ceZone: ceZone,
      skills: skills,
      photoUrl: photoUrl ?? this.photoUrl,
      updatedAt: updatedAt,
    );
  }
}
