class CategoryStat {
  const CategoryStat({
    required this.name,
    required this.percentage,
  });

  final String name;
  final double percentage;
}

class CountryStat {
  const CountryStat({
    required this.country,
    required this.count,
  });

  final String country;
  final int count;
}

class ActivityItem {
  const ActivityItem({
    required this.id,
    required this.message,
    required this.timestamp,
  });

  final String id;
  final String message;
  final DateTime timestamp;
}

class AnalyticsSnapshot {
  const AnalyticsSnapshot({
    required this.kpis,
    required this.growthData,
    required this.categories,
    required this.countries,
    required this.recentActivity,
  });

  final List<({String value, String label})> kpis;
  final List<({String label, double value})> growthData;
  final List<CategoryStat> categories;
  final List<CountryStat> countries;
  final List<ActivityItem> recentActivity;
}
