import 'package:media_network/data/models/analytics_snapshot.dart';

class AnalyticsMockData {
  AnalyticsMockData._();

  static AnalyticsSnapshot get snapshot => AnalyticsSnapshot(
        kpis: const [
          (value: '120+', label: 'Total Creators'),
          (value: '300+', label: 'Resources'),
          (value: '12.4k', label: 'Downloads'),
          (value: '48', label: 'Active Projects'),
        ],
        growthData: const [
          (label: 'Jan', value: 42),
          (label: 'Feb', value: 58),
          (label: 'Mar', value: 65),
          (label: 'Apr', value: 72),
          (label: 'May', value: 88),
          (label: 'Jun', value: 95),
        ],
        categories: const [
          CategoryStat(name: 'Broadcast', percentage: 42),
          CategoryStat(name: 'Training', percentage: 28),
          CategoryStat(name: 'Worship', percentage: 18),
          CategoryStat(name: 'Podcast', percentage: 12),
        ],
        countries: const [
          CountryStat(country: 'Nigeria', count: 38),
          CountryStat(country: 'South Africa', count: 14),
          CountryStat(country: 'United Kingdom', count: 11),
          CountryStat(country: 'United States', count: 9),
          CountryStat(country: 'Kenya', count: 7),
          CountryStat(country: 'Ghana', count: 6),
        ],
        recentActivity: [
          ActivityItem(
            id: '1',
            message: 'New creator joined from Lagos Zone 1',
            timestamp: DateTime(2026, 6, 24, 9, 30),
          ),
          ActivityItem(
            id: '2',
            message: 'Resource "Worship Broadcast Pack" downloaded 24 times',
            timestamp: DateTime(2026, 6, 24, 8, 15),
          ),
          ActivityItem(
            id: '3',
            message: 'Project "Global Worship Live" went live',
            timestamp: DateTime(2026, 6, 23, 18, 0),
          ),
          ActivityItem(
            id: '4',
            message: 'New creator joined from Johannesburg Zone',
            timestamp: DateTime(2026, 6, 23, 14, 45),
          ),
          ActivityItem(
            id: '5',
            message: 'Media Training Masterclass reached 920 enrollments',
            timestamp: DateTime(2026, 6, 22, 11, 20),
          ),
        ],
      );
}
