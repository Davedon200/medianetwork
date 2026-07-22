import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.senderEmail,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String senderEmail;
  final String text;
  final DateTime? createdAt;

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ChatMessage.fromMap(doc.id, data);
  }

  factory ChatMessage.fromMap(String id, Map<String, dynamic> data) {
    return ChatMessage(
      id: id,
      senderEmail: data['senderEmail'] as String? ?? '',
      text: data['text'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderEmail': senderEmail,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
