import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_network/core/motion/animated_dialog.dart';
import 'package:media_network/data/chat/chat_helpers.dart';
import 'package:media_network/data/models/conversation.dart';
import 'package:media_network/data/repositories/chat_repository.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';

class ChatNotificationService {
  ChatNotificationService({
    required AuthViewModel authViewModel,
    ChatRepository? chatRepository,
  })  : _authViewModel = authViewModel,
        _chatRepository = chatRepository ?? FirestoreChatRepository();

  final AuthViewModel _authViewModel;
  final ChatRepository _chatRepository;

  StreamSubscription<List<Conversation>>? _subscription;
  final Map<String, int> _lastUnread = {};
  String? _activeConversationId;
  GlobalKey<NavigatorState>? _navigatorKey;

  int totalUnread = 0;
  VoidCallback? onUnreadChanged;

  void attachNavigator(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
  }

  void setActiveConversation(String? conversationId) {
    _activeConversationId = conversationId;
  }

  void start() {
    _subscription?.cancel();
    final email = _authViewModel.email;
    if (email == null) {
      totalUnread = 0;
      onUnreadChanged?.call();
      return;
    }

    _subscription = _chatRepository.watchInbox(email).listen((conversations) {
      var sum = 0;
      for (final conv in conversations) {
        final unread = unreadForUser(conv, email);
        sum += unread;
        final prev = _lastUnread[conv.id] ?? unread;
        if (unread > prev &&
            conv.id != _activeConversationId &&
            conv.lastMessage.isNotEmpty) {
          _showNewMessageDialog(conv, email);
        }
        _lastUnread[conv.id] = unread;
      }
      totalUnread = sum;
      onUnreadChanged?.call();
    });
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
    _lastUnread.clear();
    totalUnread = 0;
    onUnreadChanged?.call();
  }

  void _showNewMessageDialog(Conversation conversation, String myEmail) {
    final context = _navigatorKey?.currentContext;
    if (context == null) return;

    final otherEmail = otherParticipantEmail(conversation, myEmail);
    if (otherEmail == null) return;

    final name = displayNameForEmail(conversation, otherEmail);
    showAnimatedDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New message'),
        content: Text('You have a new message from $name.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Dismiss'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.go('/messages/${conversation.id}');
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }

  void dispose() {
    stop();
  }
}
