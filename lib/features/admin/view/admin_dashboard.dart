import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/theme/app_palette.dart';
import 'package:media_network/data/models/registration.dart';
import 'package:media_network/data/repositories/analytics_repository.dart';
import 'package:media_network/data/repositories/registration_repository.dart';
import 'package:media_network/features/admin/view/widgets/admin_group_picker_tile.dart';
import 'package:media_network/features/admin/view/widgets/registration_list_tile.dart';
import 'package:media_network/features/admin/viewmodel/admin_view_model.dart';
import 'package:media_network/shared/layout/app_scaffold.dart';
import 'package:media_network/shared/layout/light_panel_scope.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminViewModel(
        registrationRepository: context.read<RegistrationRepository>(),
        analyticsRepository: context.read<AnalyticsRepository>(),
      ),
      child: const _AdminDashboardView(),
    );
  }
}

class _AdminDashboardView extends StatefulWidget {
  const _AdminDashboardView();

  @override
  State<_AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<_AdminDashboardView> {
  static const skillAccents = [
    Color(0xFF6A5AE0),
    Color(0xFF2DD4BF),
    Color(0xFF4F46E5),
    Color(0xFF0EA5E9),
    Color(0xFF8B5CF6),
    Color(0xFF14B8A6),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AdminViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminViewModel>();
    final palette = context.palette;

    return AppScaffold(
      solidPageBackground: true,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      constrainWidth: false,
      child: LightPanelScope(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AdminHeader(),
            const SizedBox(height: 20),
            Row(
                  children: [
                    Expanded(
                      child: _AdminMetricCard(
                        icon: Icons.how_to_reg_outlined,
                        label: 'Registrations',
                        value: viewModel.registrationCount,
                        accent: palette.accentPurple,
                        isSelected:
                            viewModel.selectedTab == AdminMetricTab.registrations,
                        onTap: () =>
                            viewModel.selectTab(AdminMetricTab.registrations),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _AdminMetricCard(
                        icon: Icons.visibility_outlined,
                        label: 'Visits',
                        value: viewModel.visitCount,
                        accent: palette.accentTeal,
                        isSelected:
                            viewModel.selectedTab == AdminMetricTab.visits,
                        onTap: () => viewModel.selectTab(AdminMetricTab.visits),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _AdminMetricCard(
                        icon: Icons.public_outlined,
                        label: 'Countries',
                        value: viewModel.countriesCount,
                        accent: palette.aboutAccent,
                        isSelected:
                            viewModel.selectedTab == AdminMetricTab.countries,
                        onTap: () =>
                            viewModel.selectTab(AdminMetricTab.countries),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _AdminMetricCard(
                        icon: Icons.groups_outlined,
                        label: 'Creators',
                        value: viewModel.creatorsCount,
                        accent: palette.accentPurple,
                        isSelected:
                            viewModel.selectedTab == AdminMetricTab.creators,
                        onTap: () =>
                            viewModel.selectTab(AdminMetricTab.creators),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  style: TextStyle(color: context.contentPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search name, email, skill, or country...',
                    hintStyle: TextStyle(color: context.contentMuted),
                    prefixIcon: Icon(
                      Icons.search,
                      color: context.contentMuted,
                    ),
                    filled: true,
                    fillColor: context.raisedSurface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: palette.chipBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: palette.accentPurple.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                    ),
                  ),
                  onChanged: viewModel.setSearchQuery,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (viewModel.isShowingGroupDetail) ...[
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        onPressed: viewModel.clearGroupSelection,
                        icon: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: context.contentPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        viewModel.listTitle,
                        style: TextStyle(
                          color: context.contentPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppPalette.brandGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${viewModel.listCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _AdminListContent(
                  viewModel: viewModel,
                  skillAccents: skillAccents,
                ),
          ],
        ),
      ),
    );
  }
}

class _AdminHeader extends StatelessWidget {
  const _AdminHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 4,
          width: 48,
          decoration: BoxDecoration(
            gradient: AppPalette.brandGradient,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Admin Dashboard',
          style: TextStyle(
            color: context.contentPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tap a metric, then select a skill or country to view creators.',
          style: TextStyle(
            color: context.contentSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _AdminListContent extends StatelessWidget {
  const _AdminListContent({
    required this.viewModel,
    required this.skillAccents,
  });

  final AdminViewModel viewModel;
  final List<Color> skillAccents;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return switch (viewModel.loadState) {
      AdminLoadState.loading => const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: CircularProgressIndicator()),
        ),
      AdminLoadState.error => Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              viewModel.errorMessage ?? 'Failed to load registrations',
              style: TextStyle(color: context.contentMuted),
            ),
          ),
        ),
      AdminLoadState.loaded => switch (viewModel.selectedTab) {
          AdminMetricTab.visits => _VisitsPanel(
              visitCount: viewModel.visitCount,
              palette: palette,
            ),
          AdminMetricTab.creators =>
            viewModel.isShowingGroupDetail
                ? _FlatRegistrationList(
                    registrations: viewModel.selectedSkillCreators,
                    emptyMessage: viewModel.searchQuery.isEmpty
                        ? 'No creators for this skill.'
                        : 'No creators match your search.',
                  )
                : _GroupPickerList(
                    options: viewModel.skillOptions,
                    skillAccents: skillAccents,
                    emptyMessage: viewModel.searchQuery.isEmpty
                        ? 'No skills yet.'
                        : 'No skills match your search.',
                    onSelect: viewModel.selectSkill,
                  ),
          AdminMetricTab.countries =>
            viewModel.isShowingGroupDetail
                ? _FlatRegistrationList(
                    registrations: viewModel.selectedCountryCreators,
                    emptyMessage: viewModel.searchQuery.isEmpty
                        ? 'No creators for this country.'
                        : 'No creators match your search.',
                  )
                : _GroupPickerList(
                    options: viewModel.countryOptions,
                    skillAccents: skillAccents,
                    emptyMessage: viewModel.searchQuery.isEmpty
                        ? 'No country data yet.'
                        : 'No countries match your search.',
                    onSelect: viewModel.selectCountry,
                  ),
          AdminMetricTab.registrations => _FlatRegistrationList(
              registrations: viewModel.registrations,
              emptyMessage: viewModel.searchQuery.isEmpty
                  ? 'No registrations yet.'
                  : 'No registrations match your search.',
            ),
        },
    };
  }
}

class _VisitsPanel extends StatelessWidget {
  const _VisitsPanel({required this.visitCount, required this.palette});

  final int visitCount;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            palette.accentTeal.withValues(alpha: 0.12),
            palette.accentPurple.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.chipBorder),
      ),
      child: Column(
        children: [
          Icon(Icons.insights_outlined, size: 36, color: palette.accentTeal),
          const SizedBox(height: 12),
          Text(
            '$visitCount',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: context.contentPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Total landing page visits',
            style: TextStyle(color: context.contentSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _FlatRegistrationList extends StatelessWidget {
  const _FlatRegistrationList({
    required this.registrations,
    required this.emptyMessage,
  });

  final List<Registration> registrations;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (registrations.isEmpty) {
      return _EmptyState(message: emptyMessage);
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: registrations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => RegistrationListTile(
        registration: registrations[index],
      ),
    );
  }
}

class _GroupPickerList extends StatelessWidget {
  const _GroupPickerList({
    required this.options,
    required this.skillAccents,
    required this.emptyMessage,
    required this.onSelect,
  });

  final List<({String name, int count})> options;
  final List<Color> skillAccents;
  final String emptyMessage;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return _EmptyState(message: emptyMessage);
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final option = options[index];
        return AdminGroupPickerTile(
          label: option.name,
          count: option.count,
          accent: skillAccents[index % skillAccents.length],
          onTap: () => onSelect(option.name),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: context.contentMuted),
        ),
      ),
    );
  }
}

class _AdminMetricCard extends StatelessWidget {
  const _AdminMetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int value;
  final Color accent;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? context.raisedSurface
                : context.raisedSurface.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? accent.withValues(alpha: 0.65)
                  : context.raisedBorder,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: isSelected ? 0.16 : 0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: accent),
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: context.raisedTextPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: context.raisedTextSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
