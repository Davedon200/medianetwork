enum ProjectStatus { live, inProgress, completed }

class Project {
  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.creatorName,
    required this.thumbnailUrl,
    required this.assetCount,
    required this.startedAt,
    this.featured = false,
  });

  final String id;
  final String title;
  final String description;
  final ProjectStatus status;
  final String creatorName;
  final String thumbnailUrl;
  final int assetCount;
  final DateTime startedAt;
  final bool featured;
}
