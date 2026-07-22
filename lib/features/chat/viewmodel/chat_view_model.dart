import 'package:flutter/material.dart';
import 'package:media_network/data/models/chat_message.dart';
import 'package:media_network/data/repositories/chat_repository.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';
import 'package:media_network/features/chat/services/chat_notification_service.dart';

class ChatViewModel extends ChangeNotifier {
  ChatViewModel({
    required this.conversationId,
    required AuthViewModel authViewModel,
    required this.participantEmails,
    ChatRepository? chatRepository,
    ChatNotificationService? notificationService,
  })  : _authViewModel = authViewModel,
        _chatRepository = chatRepository ?? FirestoreChatRepository(),
        _notificationService = notificationService {
    _notificationService?.setActiveConversation(conversationId);
    _markRead();
    load();
  }

  final String conversationId;
  final List<String> participantEmails;
  final AuthViewModel _authViewModel;
  final ChatRepository _chatRepository;
  final ChatNotificationService? _notificationService;

  final textController = TextEditingController();
  List<ChatMessage> messages = [];
  bool isSending = false;

  Future<void> load() async {
    await for (final list
        in _chatRepository.watchMessages(conversationId)) {
      messages = list;
      notifyListeners();
    }
  }

  Future<void> send() async {
    final email = _authViewModel.email;
    if (email == null) return;
    final text = textController.text;
    if (text.trim().isEmpty) return;

    isSending = true;
    notifyListeners();

    try {
      await _chatRepository.sendMessage(
        conversationId: conversationId,
        senderEmail: email,
        text: text,
        participantEmails: participantEmails,
      );
      textController.clear();
    } finally {
      isSending = false;
      notifyListeners();
    }
  }

  Future<void> _markRead() async {
    final email = _authViewModel.email;
    if (email == null) return;
    await _chatRepository.markRead(
      conversationId: conversationId,
      myEmail: email,
    );
  }

  @override
  void dispose() {
    _notificationService?.setActiveConversation(null);
    textController.dispose();
    super.dispose();
  }
}
