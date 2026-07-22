import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/motion/staggered_entrance.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';
import 'package:media_network/features/profile/view/widgets/profile_avatar.dart';
import 'package:media_network/features/profile/viewmodel/profile_view_model.dart';
import 'package:media_network/shared/layout/app_page_shell.dart';
import 'package:media_network/shared/widgets/hero_chip.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(
        authViewModel: context.read<AuthViewModel>(),
      )..load(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final profileVm = context.watch<ProfileViewModel>();
    final profile = profileVm.profile;

    return AppPageShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StaggeredEntrance(
            index: 0,
            child: Center(
              child: ProfileAvatar(
                profile: profile,
                radius: 56,
                showEditBadge: true,
                isLoading: profileVm.isUploading,
                onTap: profileVm.isUploading
                    ? null
                    : () => profileVm.pickAndUploadAvatar(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          StaggeredEntrance(
            index: 1,
            child: Center(
              child: Text(
                profile?.name ?? authVm.displayName ?? 'User',
                style: TextStyle(
                  color: context.contentPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              profile?.email ?? authVm.email ?? '',
              style: TextStyle(color: context.contentSecondary),
            ),
          ),
          if (profileVm.errorMessage != null) ...[
            const SizedBox(height: 12),
            Center(
              child: Text(
                profileVm.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
          const SizedBox(height: 32),
          if (profile != null) ...[
            _InfoRow(label: 'Title', value: profile.title ?? '—'),
            _InfoRow(label: 'Phone', value: profile.phone ?? '—'),
            _InfoRow(label: 'Nationality', value: profile.nationality ?? '—'),
            _InfoRow(label: 'CE Zone', value: profile.ceZone ?? '—'),
            _InfoRow(label: 'KingsChat', value: profile.kc ?? '—'),
            const SizedBox(height: 16),
            Text(
              'Skills',
              style: TextStyle(
                color: context.contentPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final skill in profile.skills) HeroChip(label: skill),
              ],
            ),
          ],
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await authVm.signOut();
                if (context.mounted) context.go('/');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(color: context.contentMuted, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: context.contentPrimary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
