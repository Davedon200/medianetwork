import 'package:flutter/material.dart';
import 'package:media_network/core/constants/breakpoints.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/data/repositories/creators_repository.dart';
import 'package:media_network/features/creators/viewmodel/creators_view_model.dart';
import 'package:media_network/core/motion/staggered_entrance.dart';
import 'package:media_network/features/creators/view/widgets/creator_card.dart';
import 'package:media_network/features/creators/view/widgets/filter_chip_row.dart';
import 'package:media_network/shared/layout/app_page_shell.dart';
import 'package:media_network/shared/widgets/section_header.dart';
import 'package:provider/provider.dart';

class CreatorsPage extends StatelessWidget {
  const CreatorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreatorsViewModel(
        repository: context.read<CreatorsRepository>(),
      )..init(),
      child: const _CreatorsView(),
    );
  }
}

class _CreatorsView extends StatelessWidget {
  const _CreatorsView();

  int _crossAxisCount(double width) {
    if (Breakpoints.isDesktop(width)) return 4;
    if (Breakpoints.isTablet(width)) return 3;
    if (width >= 400) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final viewModel = context.watch<CreatorsViewModel>();
    final width = MediaQuery.of(context).size.width;
    final creators = viewModel.creators;

    return AppPageShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StaggeredEntrance(
            index: 0,
            child: SectionHeader(
              title: 'Meet the Creators',
              subtitle:
                  '${viewModel.totalCount} creators in the network',
              action: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: palette.liveBadgeBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${creators.length} shown',
                  style: TextStyle(
                    color: palette.accentTeal,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilterChipRow(
            filters: CreatorsViewModel.filters,
            selected: viewModel.selectedFilter,
            onSelected: viewModel.setFilter,
          ),
          const SizedBox(height: 24),
          creators.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'No creators match this filter.',
                      style: TextStyle(color: context.contentSecondary),
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount(width),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: creators.length,
                  itemBuilder: (context, index) => StaggeredEntrance(
                    index: index,
                    child: CreatorCard(creator: creators[index]),
                  ),
                ),
        ],
      ),
    );
  }
}
