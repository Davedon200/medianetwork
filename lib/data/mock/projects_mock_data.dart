import 'package:media_network/data/models/project.dart';

class ProjectsMockData {
  ProjectsMockData._();

  static final List<Project> projects = [
    Project(
      id: '1',
      title: 'Global Worship Live',
      description:
          'A cross-continental live worship broadcast connecting churches worldwide every Sunday.',
      status: ProjectStatus.live,
      creatorName: 'Sarah Johnson',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1501386761578-4d12ad3d3c8b?w=600',
      assetCount: 48,
      startedAt: DateTime(2025, 9, 1),
      featured: true,
    ),
    Project(
      id: '2',
      title: 'Creator Podcast Network',
      description:
          'Weekly podcast series featuring creator stories, media tips, and ministry insights.',
      status: ProjectStatus.live,
      creatorName: 'David Okonkwo',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1590602847861-f357a9332bbc?w=600',
      assetCount: 32,
      startedAt: DateTime(2025, 11, 15),
    ),
    Project(
      id: '3',
      title: 'Youth Media Training',
      description:
          'Hands-on training program equipping young creators with video and audio production skills.',
      status: ProjectStatus.inProgress,
      creatorName: 'Grace Mbeki',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=600',
      assetCount: 18,
      startedAt: DateTime(2026, 2, 1),
    ),
    Project(
      id: '4',
      title: 'Social Impact Campaign',
      description:
          'Multi-platform campaign sharing stories of transformation across the network.',
      status: ProjectStatus.live,
      creatorName: 'Emily Chen',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1611162617474-5b21e939e988?w=600',
      assetCount: 56,
      startedAt: DateTime(2025, 7, 20),
    ),
    Project(
      id: '5',
      title: 'Documentary Series: Voices',
      description:
          'A documentary series highlighting creator journeys across different continents.',
      status: ProjectStatus.inProgress,
      creatorName: 'James Williams',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=600',
      assetCount: 12,
      startedAt: DateTime(2026, 3, 10),
    ),
    Project(
      id: '6',
      title: 'Worship Album Production',
      description:
          'Studio production of a collaborative worship album featuring network creators.',
      status: ProjectStatus.completed,
      creatorName: 'Faith Akintola',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=600',
      assetCount: 24,
      startedAt: DateTime(2025, 4, 1),
    ),
    Project(
      id: '7',
      title: 'Media Summit 2026',
      description:
          'Annual gathering with live streams, workshops, and project showcases.',
      status: ProjectStatus.inProgress,
      creatorName: 'Michael Adeyemi',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=600',
      assetCount: 8,
      startedAt: DateTime(2026, 1, 15),
    ),
    Project(
      id: '8',
      title: 'Children\'s Animation Series',
      description:
          'Animated Bible stories produced for young audiences across the network.',
      status: ProjectStatus.live,
      creatorName: 'Rachel Kim',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1533750516457-a7f992a4b77a?w=600',
      assetCount: 36,
      startedAt: DateTime(2025, 10, 5),
    ),
    Project(
      id: '9',
      title: 'Regional News Bulletin',
      description:
          'Weekly news roundup covering network events and creator achievements.',
      status: ProjectStatus.completed,
      creatorName: 'Thomas Brown',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1504711434969-e33886168f1c?w=600',
      assetCount: 64,
      startedAt: DateTime(2024, 12, 1),
    ),
    Project(
      id: '10',
      title: 'Photography Exhibition',
      description:
          'Virtual gallery showcasing photography from creators around the world.',
      status: ProjectStatus.completed,
      creatorName: 'Laura Martinez',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1452587925148-ce544e77e70d?w=600',
      assetCount: 42,
      startedAt: DateTime(2025, 6, 1),
    ),
  ];
}
