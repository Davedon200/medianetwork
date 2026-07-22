import 'package:flutter/material.dart';
import 'package:media_network/core/constants/breakpoints.dart';
import 'package:media_network/features/analytics/viewmodel/analytics_view_model.dart';
import 'package:media_network/core/motion/staggered_entrance.dart';
import 'package:media_network/features/analytics/view/widgets/activity_feed.dart';
import 'package:media_network/features/analytics/view/widgets/category_bars.dart';
import 'package:media_network/features/analytics/view/widgets/country_bars.dart';
import 'package:media_network/features/analytics/view/widgets/growth_chart.dart';
import 'package:media_network/shared/layout/app_page_shell.dart';
import 'package:media_network/shared/widgets/section_header.dart';
import 'package:media_network/shared/widgets/stat_row.dart';
import 'package:provider/provider.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnalyticsViewModel(),
      child: const _AnalyticsView(),
    );
  }
}

class _AnalyticsView extends StatelessWidget {
  const _AnalyticsView();

  @override
  Widget build(BuildContext context) {
    final snapshot = context.watch<AnalyticsViewModel>().snapshot;
    final isMobile = !Breakpoints.isDesktop(MediaQuery.of(context).size.width);

    return AppPageShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StaggeredEntrance(
            index: 0,
            child: SectionHeader(
              title: 'Network Analytics',
              subtitle: 'Insights across creators, resources, and projects',
            ),
          ),
          const SizedBox(height: 24),
          StatRow(stats: snapshot.kpis),
          const SizedBox(height: 32),
          isMobile
              ? Column(
                  children: [
                    StaggeredEntrance(
                      index: 1,
                      child: GrowthChart(data: snapshot.growthData),
                    ),
                    const SizedBox(height: 16),
                    StaggeredEntrance(
                      index: 2,
                      child: CategoryBars(categories: snapshot.categories),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: StaggeredEntrance(
                        index: 1,
                        child: GrowthChart(data: snapshot.growthData),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: StaggeredEntrance(
                        index: 2,
                        child: CategoryBars(categories: snapshot.categories),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 24),
          StaggeredEntrance(
            index: 3,
            child: CountryBars(countries: snapshot.countries),
          ),
          const SizedBox(height: 32),
          const StaggeredEntrance(
            index: 4,
            child: SectionHeader(title: 'Recent Activity'),
          ),
          const SizedBox(height: 16),
          ActivityFeed(items: snapshot.recentActivity),
        ],
      ),
    );
  }
}
