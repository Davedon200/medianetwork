import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/utils/app_error_log.dart';
import 'package:media_network/data/chat/chat_helpers.dart';
import 'package:media_network/data/models/conversation.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';
import 'package:media_network/features/chat/services/chat_notification_service.dart';
import 'package:media_network/features/chat/viewmodel/chat_view_model.dart';
import 'package:media_network/shared/layout/app_page_shell.dart';
import 'package:provider/provider.dart';

class ChatThreadPage extends StatelessWidget {
  const ChatThreadPage({super.key, required this.conversationId});

  final String conversationId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: AppErrorLog.guard(
        () => FirebaseFirestore.instance
            .collection('conversations')
            .doc(conversationId)
            .get(),
        tag: 'ChatThreadPage',
        op: 'loadConversation',
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppPageShell(
            scrollable: false,
            child: Center(
              child: TextButton(
                onPressed: () => context.go('/messages'),
                child: const Text('Unable to load conversation'),
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const AppPageShell(
            scrollable: false,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final data = snapshot.data!.data();
        if (data == null) {
          return AppPageShell(
            scrollable: false,
            child: Center(
              child: TextButton(
                onPressed: () => context.go('/messages'),
                child: const Text('Conversation not found'),
              ),
            ),
          );
        }

        final conversation = Conversation.fromFirestore(snapshot.data!);
        final participantEmails = conversation.participantEmails;
        final authVm = context.read<AuthViewModel>();
        final myEmail = authVm.email ?? '';
        final otherEmail = otherParticipantEmail(conversation, myEmail);
        final title = otherEmail != null
            ? displayNameForEmail(conversation, otherEmail)
            : 'Chat';

        return ChangeNotifierProvider(
          create: (context) => ChatViewModel(
            conversationId: conversationId,
            authViewModel: authVm,
            participantEmails: participantEmails,
            notificationService: context.read<ChatNotificationService>(),
          ),
          child: _ChatThreadView(title: title),
        );
      },
    );
  }
}

class _ChatThreadView extends StatelessWidget {
  const _ChatThreadView({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final authVm = context.watch<AuthViewModel>();
    final vm = context.watch<ChatViewModel>();
    final myEmail = authVm.email?.toLowerCase() ?? '';

    return AppPageShell(
      scrollable: false,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.go('/messages'),
                icon: Icon(Icons.arrow_back, color: context.contentPrimary),
              ),
              Text(
                title,
                style: TextStyle(
                  color: context.contentPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: vm.messages.length,
              itemBuilder: (context, index) {
                final msg = vm.messages[index];
                final isMine = msg.senderEmail.toLowerCase() == myEmail;
                return Align(
                  alignment:
                      isMine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isMine
                          ? palette.accentPurple
                          : context.raisedSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: isMine
                          ? null
                          : Border.all(color: palette.chipBorder),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: isMine ? Colors.white : context.raisedTextPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: vm.textController,
                    style: TextStyle(color: context.raisedTextPrimary),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    filled: true,
                    fillColor: context.raisedSurface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: palette.chipBorder),
                    ),
                  ),
                  onSubmitted: (_) => vm.send(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: vm.isSending ? null : vm.send,
                icon: vm.isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.send, color: palette.accentTeal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
