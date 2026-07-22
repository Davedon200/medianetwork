import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  const Conversation({
    required this.id,
    required this.participantEmails,
    required this.participantNames,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCounts,
  });

  final String id;
  final List<String> participantEmails;
  final Map<String, String> participantNames;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final Map<String, int> unreadCounts;

  factory Conversation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final unread = <String, int>{};
    for (final entry in data.entries) {
      if (entry.key.startsWith('unread_') && entry.value is num) {
        unread[entry.key] = (entry.value as num).toInt();
      }
    }
    return Conversation(
      id: doc.id,
      participantEmails: List<String>.from(data['participantEmails'] ?? []),
      participantNames: Map<String, String>.from(
        (data['participantNames'] as Map<String, dynamic>? ?? {})
            .map((k, v) => MapEntry(k, v.toString())),
      ),
      lastMessage: data['lastMessage'] as String? ?? '',
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
      unreadCounts: unread,
    );
  }
}
