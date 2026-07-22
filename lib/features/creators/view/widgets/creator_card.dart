import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/theme/app_palette.dart';
import 'package:media_network/data/models/creator_profile.dart';
import 'package:media_network/data/repositories/chat_repository.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';
import 'package:media_network/shared/widgets/hero_chip.dart';
import 'package:media_network/shared/widgets/hover_widgets.dart';
import 'package:provider/provider.dart';

class CreatorCard extends StatelessWidget {
  const CreatorCard({super.key, required this.creator});

  final CreatorProfile creator;

  Future<void> _startChat(BuildContext context) async {
    final authVm = context.read<AuthViewModel>();
    if (!authVm.isLoggedIn || authVm.email == null) return;

    final chatRepo = context.read<ChatRepository>();
    final myEmail = authVm.email!;
    final myName = authVm.displayName ?? myEmail.split('@').first;

    final conversationId = await chatRepo.getOrCreateConversation(
      myEmail: myEmail,
      myName: myName,
      otherEmail: creator.email,
      otherName: creator.name,
    );

    if (context.mounted) {
      context.go('/messages/$conversationId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isLoggedIn = context.watch<AuthViewModel>().isLoggedIn;

    return HoverScale(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: context.raisedCardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppPalette.brandGradient,
                  border: Border.all(color: palette.borderSubtle, width: 2),
                ),
                child: Center(
                  child: Text(
                    creator.name.isNotEmpty
                        ? creator.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              creator.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: palette.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              creator.title,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.public, size: 12, color: palette.textMuted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    creator.nationality,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: palette.textMuted, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 12, color: palette.textMuted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    creator.ceZone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: palette.textMuted, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final skill in creator.skills.take(3))
                  HeroChip(label: skill),
              ],
            ),
            if (isLoggedIn) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _startChat(context),
                  icon: const Icon(Icons.mail_outline, size: 16),
                  label: const Text('Message'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: palette.accentTeal,
                    side: BorderSide(color: palette.accentTeal.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
