import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:media_network/core/utils/app_error_log.dart';
import 'package:media_network/data/chat/chat_helpers.dart';
import 'package:media_network/data/models/chat_message.dart';
import 'package:media_network/data/models/conversation.dart';

abstract class ChatRepository {
  Future<String> getOrCreateConversation({
    required String myEmail,
    required String myName,
    required String otherEmail,
    required String otherName,
  });
  Stream<List<Conversation>> watchInbox(String myEmail);
  Stream<List<ChatMessage>> watchMessages(String conversationId);
  Future<void> sendMessage({
    required String conversationId,
    required String senderEmail,
    required String text,
    required List<String> participantEmails,
  });
  Future<void> markRead({
    required String conversationId,
    required String myEmail,
  });
}

class FirestoreChatRepository implements ChatRepository {
  FirestoreChatRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const _tag = 'ChatRepo';

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _conversations =>
      _firestore.collection('conversations');

  @override
  Future<String> getOrCreateConversation({
    required String myEmail,
    required String myName,
    required String otherEmail,
    required String otherName,
  }) =>
      AppErrorLog.guard(
        () async {
          final id = buildConversationId(myEmail, otherEmail);
          final ref = _conversations.doc(id);
          final doc = await ref.get();
          if (!doc.exists) {
            final emails =
                [myEmail, otherEmail].map((e) => e.toLowerCase()).toList()
                  ..sort();
            await ref.set({
              'participantEmails': emails,
              'participantNames': {
                myEmail.toLowerCase(): myName,
                otherEmail.toLowerCase(): otherName,
              },
              'lastMessage': '',
              'lastMessageAt': FieldValue.serverTimestamp(),
              unreadFieldKey(myEmail): 0,
              unreadFieldKey(otherEmail): 0,
            });
          }
          return id;
        },
        tag: _tag,
        op: 'getOrCreateConversation',
      );

  @override
  Stream<List<Conversation>> watchInbox(String myEmail) {
    final email = myEmail.toLowerCase();
    return AppErrorLog.guardStream(
      _conversations
          .where('participantEmails', arrayContains: email)
          .snapshots()
          .map((snapshot) {
            final list =
                snapshot.docs.map(Conversation.fromFirestore).toList();
            list.sort((a, b) {
              final aTime =
                  a.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              final bTime =
                  b.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              return bTime.compareTo(aTime);
            });
            return list;
          }),
      tag: _tag,
      op: 'watchInbox',
    );
  }

  @override
  Stream<List<ChatMessage>> watchMessages(String conversationId) {
    return AppErrorLog.guardStream(
      _conversations
          .doc(conversationId)
          .collection('messages')
          .orderBy('createdAt', descending: false)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map(ChatMessage.fromFirestore)
                .toList(growable: false),
          ),
      tag: _tag,
      op: 'watchMessages',
    );
  }

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String senderEmail,
    required String text,
    required List<String> participantEmails,
  }) =>
      AppErrorLog.guard(
        () async {
          final convRef = _conversations.doc(conversationId);
          final messagesRef = convRef.collection('messages');
          final trimmed = text.trim();
          if (trimmed.isEmpty) return;

          final batch = _firestore.batch();
          batch.set(messagesRef.doc(), {
            'senderEmail': senderEmail.toLowerCase(),
            'text': trimmed,
            'createdAt': FieldValue.serverTimestamp(),
          });

          final updates = <String, dynamic>{
            'lastMessage': trimmed,
            'lastMessageAt': FieldValue.serverTimestamp(),
            unreadFieldKey(senderEmail): 0,
          };

          for (final email in participantEmails) {
            final normalized = email.toLowerCase();
            if (normalized != senderEmail.toLowerCase()) {
              updates[unreadFieldKey(normalized)] = FieldValue.increment(1);
            }
          }

          batch.update(convRef, updates);
          await batch.commit();
        },
        tag: _tag,
        op: 'sendMessage',
      );

  @override
  Future<void> markRead({
    required String conversationId,
    required String myEmail,
  }) =>
      AppErrorLog.guard(
        () => _conversations.doc(conversationId).update({
          unreadFieldKey(myEmail): 0,
        }),
        tag: _tag,
        op: 'markRead',
      );
}
