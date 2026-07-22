import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_network/features/home/viewmodel/home_view_model.dart';
import 'package:media_network/core/motion/staggered_entrance.dart';
import 'package:media_network/features/home/view/widgets/home_news_list.dart';
import 'package:media_network/features/home/view/widgets/home_trending_carousel.dart';
import 'package:media_network/features/home/view/widgets/home_welcome_hero.dart';
import 'package:media_network/shared/layout/app_scaffold.dart';
import 'package:media_network/shared/layout/light_panel_scope.dart';
import 'package:media_network/shared/widgets/section_header.dart';
import 'package:media_network/shared/widgets/stat_row.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final snapshot = viewModel.snapshot;

    return AppScaffold(
      solidPageBackground: true,
      padding: EdgeInsets.zero,
      applyResponsivePadding: false,
      constrainWidth: false,
      scrollable: true,
      child: LightPanelScope(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StaggeredEntrance(
              index: 0,
              child: HomeWelcomeHero(
                onBrowseResources: () => context.go('/resources'),
                onViewProjects: () => context.go('/projects'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 40, 36, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatRow(stats: snapshot.stats),
                  const SizedBox(height: 40),
                  const StaggeredEntrance(
                    index: 1,
                    child: SectionHeader(title: 'Trending Now'),
                  ),
                  const SizedBox(height: 16),
                  HomeTrendingCarousel(items: snapshot.trending),
                  const SizedBox(height: 40),
                  const StaggeredEntrance(
                    index: 2,
                    child: SectionHeader(title: 'Network News'),
                  ),
                  const SizedBox(height: 16),
                  HomeNewsList(items: snapshot.news),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
