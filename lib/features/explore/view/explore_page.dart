import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/motion/staggered_entrance.dart';
import 'package:media_network/data/repositories/media_repository.dart';
import 'package:media_network/features/explore/view/widgets/media_grid.dart';
import 'package:media_network/features/explore/viewmodel/explore_view_model.dart';
import 'package:media_network/shared/layout/app_page_shell.dart';
import 'package:media_network/shared/widgets/section_header.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          ExploreViewModel(mediaRepository: context.read<MediaRepository>()),
      child: const _ExploreView(),
    );
  }
}

class _ExploreView extends StatefulWidget {
  const _ExploreView();

  @override
  State<_ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<_ExploreView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ExploreViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExploreViewModel>();
    final width = MediaQuery.of(context).size.width;

    return AppPageShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StaggeredEntrance(
            index: 0,
            child: SectionHeader(
              title: 'Resource Library',
              subtitle:
                  'Browse media assets, training materials, and creative resources',
            ),
          ),
          const SizedBox(height: 24),
          switch (viewModel.loadState) {
            ExploreLoadState.loading => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
            ExploreLoadState.error => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    viewModel.errorMessage ?? 'Failed to load media',
                    style: TextStyle(color: context.contentSecondary),
                  ),
                ),
              ),
            ExploreLoadState.loaded => MediaGrid(
                items: viewModel.items,
                crossAxisCount: viewModel.crossAxisCountForWidth(width),
                childAspectRatio: viewModel.childAspectRatioForWidth(width),
              ),
          },
        ],
      ),
    );
  }
}
