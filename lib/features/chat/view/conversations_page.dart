import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/motion/staggered_entrance.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';
import 'package:media_network/features/chat/viewmodel/conversations_list_view_model.dart';
import 'package:media_network/shared/layout/app_page_shell.dart';
import 'package:media_network/shared/widgets/section_header.dart';
import 'package:provider/provider.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConversationsListViewModel(
        authViewModel: context.read<AuthViewModel>(),
      )..load(),
      child: const _ConversationsView(),
    );
  }
}

class _ConversationsView extends StatelessWidget {
  const _ConversationsView();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final vm = context.watch<ConversationsListViewModel>();

    return AppPageShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StaggeredEntrance(
            index: 0,
            child: SectionHeader(
              title: 'Messages',
              subtitle: 'Your conversations with creators',
            ),
          ),
          const SizedBox(height: 24),
          if (vm.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (vm.conversations.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'No messages yet. Start a chat from the Creators page.',
                  style: TextStyle(color: context.contentSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vm.conversations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final conv = vm.conversations[index];
                final unread = vm.unreadFor(conv);
                return StaggeredEntrance(
                  index: index,
                  child: ListTile(
                    onTap: () => context.go('/messages/${conv.id}'),
                    tileColor: context.raisedSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: context.raisedBorder),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: palette.accentPurple.withValues(alpha: 0.2),
                      child: Text(
                        vm.titleFor(conv).isNotEmpty
                            ? vm.titleFor(conv)[0].toUpperCase()
                            : '?',
                        style: TextStyle(color: palette.accentPurple),
                      ),
                    ),
                    title: Text(
                      vm.titleFor(conv),
                      style: TextStyle(
                        color: context.raisedTextPrimary,
                        fontWeight:
                            unread > 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      conv.lastMessage.isEmpty ? 'No messages yet' : conv.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: context.raisedTextSecondary),
                    ),
                    trailing: unread > 0
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: palette.accentTeal,
                            child: Text(
                              '$unread',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          )
                        : null,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
