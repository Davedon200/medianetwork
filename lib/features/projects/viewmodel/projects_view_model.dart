import 'package:flutter/material.dart';
import 'package:media_network/data/mock/projects_mock_data.dart';
import 'package:media_network/data/models/project.dart';

class ProjectsViewModel extends ChangeNotifier {
  static const filters = ['All', 'Live', 'In Progress', 'Completed'];

  String _selectedFilter = 'All';

  String get selectedFilter => _selectedFilter;

  Project? get featuredProject {
    final featured = ProjectsMockData.projects.where((p) => p.featured);
    return featured.isEmpty ? null : featured.first;
  }

  List<Project> get projects {
    final all = ProjectsMockData.projects.where((p) => !p.featured).toList();
    return switch (_selectedFilter) {
      'Live' => all.where((p) => p.status == ProjectStatus.live).toList(),
      'In Progress' =>
        all.where((p) => p.status == ProjectStatus.inProgress).toList(),
      'Completed' =>
        all.where((p) => p.status == ProjectStatus.completed).toList(),
      _ => all,
    };
  }

  void setFilter(String filter) {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    notifyListeners();
  }
}
