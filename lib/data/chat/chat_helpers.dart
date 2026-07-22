import 'package:media_network/data/models/chat_message.dart';
import 'package:media_network/data/models/conversation.dart';

/// Builds a stable conversation id from two participant emails.
String buildConversationId(String emailA, String emailB) {
  final sorted = [emailA.trim().toLowerCase(), emailB.trim().toLowerCase()]
    ..sort();
  return '${sorted[0]}__${sorted[1]}';
}

/// Firestore-safe field key for per-user unread counts.
String unreadFieldKey(String email) {
  return 'unread_${email.trim().toLowerCase().replaceAll('@', '_at_').replaceAll('.', '_dot_')}';
}

String? otherParticipantEmail(Conversation conversation, String myEmail) {
  final me = myEmail.trim().toLowerCase();
  for (final email in conversation.participantEmails) {
    if (email != me) return email;
  }
  return null;
}

String displayNameForEmail(Conversation conversation, String email) {
  return conversation.participantNames[email] ??
      email.split('@').first;
}

int unreadForUser(Conversation conversation, String email) {
  return conversation.unreadCounts[unreadFieldKey(email)] ?? 0;
}

/// Pure helper for tests — parse message from map.
ChatMessage messageFromMap(String id, Map<String, dynamic> data) {
  return ChatMessage.fromMap(id, data);
}
