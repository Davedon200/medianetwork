import 'package:flutter/material.dart';
import 'package:media_network/core/constants/breakpoints.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/theme/app_palette.dart';
import 'package:media_network/data/models/project.dart';
import 'package:media_network/features/creators/view/widgets/filter_chip_row.dart';
import 'package:media_network/features/projects/viewmodel/projects_view_model.dart';
import 'package:media_network/features/projects/view/widgets/featured_project_card.dart';
import 'package:media_network/core/motion/staggered_entrance.dart';
import 'package:media_network/features/projects/view/widgets/project_card.dart';
import 'package:media_network/shared/layout/app_page_shell.dart';
import 'package:media_network/shared/widgets/section_header.dart';
import 'package:provider/provider.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProjectsViewModel(),
      child: const _ProjectsView(),
    );
  }
}

class _ProjectsView extends StatelessWidget {
  const _ProjectsView();

  int _crossAxisCount(double width) {
    if (Breakpoints.isDesktop(width)) return 3;
    if (Breakpoints.isTablet(width)) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProjectsViewModel>();
    final width = MediaQuery.of(context).size.width;
    final featured = viewModel.featuredProject;
    final projects = viewModel.projects;

    return AppPageShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StaggeredEntrance(
            index: 0,
            child: const SectionHeader(
              title: 'Live Projects',
              subtitle: 'Collaborative media initiatives across the network',
            ),
          ),
          const SizedBox(height: 20),
          FilterChipRow(
            filters: ProjectsViewModel.filters,
            selected: viewModel.selectedFilter,
            onSelected: viewModel.setFilter,
          ),
          const SizedBox(height: 24),
          if (featured != null && viewModel.selectedFilter == 'All') ...[
            StaggeredEntrance(
              index: 1,
              child: FeaturedProjectCard(project: featured),
            ),
            const SizedBox(height: 24),
          ],
          projects.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'No projects match this filter.',
                      style: TextStyle(
                        color: context.contentSecondary,
                      ),
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
                    childAspectRatio: 0.9,
                  ),
                  itemCount: projects.length,
                  itemBuilder: (context, index) => StaggeredEntrance(
                    index: index,
                    child: ProjectCard(project: projects[index]),
                  ),
                ),
        ],
      ),
    );
  }
}

String projectStatusLabel(ProjectStatus status) {
  return switch (status) {
    ProjectStatus.live => 'Live',
    ProjectStatus.inProgress => 'In Progress',
    ProjectStatus.completed => 'Completed',
  };
}

Color projectStatusColor(ProjectStatus status) {
  return switch (status) {
    ProjectStatus.live => AppStatusColors.live,
    ProjectStatus.inProgress => AppStatusColors.inProgress,
    ProjectStatus.completed => AppStatusColors.completed,
  };
}
