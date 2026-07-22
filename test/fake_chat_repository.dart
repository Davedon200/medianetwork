import 'package:media_network/data/models/chat_message.dart';
import 'package:media_network/data/models/conversation.dart';
import 'package:media_network/data/repositories/chat_repository.dart';

class FakeChatRepository implements ChatRepository {
  @override
  Future<String> getOrCreateConversation({
    required String myEmail,
    required String myName,
    required String otherEmail,
    required String otherName,
  }) async =>
      'fake-conversation';

  @override
  Stream<List<Conversation>> watchInbox(String myEmail) =>
      const Stream.empty();

  @override
  Stream<List<ChatMessage>> watchMessages(String conversationId) =>
      const Stream.empty();

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String senderEmail,
    required String text,
    required List<String> participantEmails,
  }) async {}

  @override
  Future<void> markRead({
    required String conversationId,
    required String myEmail,
  }) async {}
}
