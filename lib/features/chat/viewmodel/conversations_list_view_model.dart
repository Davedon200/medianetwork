import 'package:flutter/material.dart';
import 'package:media_network/data/chat/chat_helpers.dart';
import 'package:media_network/data/models/conversation.dart';
import 'package:media_network/data/repositories/chat_repository.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';

class ConversationsListViewModel extends ChangeNotifier {
  ConversationsListViewModel({
    required AuthViewModel authViewModel,
    ChatRepository? chatRepository,
  })  : _authViewModel = authViewModel,
        _chatRepository = chatRepository ?? FirestoreChatRepository();

  final AuthViewModel _authViewModel;
  final ChatRepository _chatRepository;

  List<Conversation> conversations = [];
  bool isLoading = true;

  Future<void> load() async {
    final email = _authViewModel.email;
    if (email == null) {
      conversations = [];
      isLoading = false;
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    await for (final list in _chatRepository.watchInbox(email)) {
      conversations = list;
      isLoading = false;
      notifyListeners();
    }
  }

  String titleFor(Conversation conversation) {
    final email = _authViewModel.email;
    if (email == null) return 'Chat';
    final other = otherParticipantEmail(conversation, email);
    if (other == null) return 'Chat';
    return displayNameForEmail(conversation, other);
  }

  int unreadFor(Conversation conversation) {
    final email = _authViewModel.email;
    if (email == null) return 0;
    return unreadForUser(conversation, email);
  }
}
