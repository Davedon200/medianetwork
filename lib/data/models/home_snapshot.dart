class TrendingItem {
  const TrendingItem({
    required this.id,
    required this.title,
    required this.category,
    required this.engagement,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String category;
  final String engagement;
  final String imageUrl;
}

class NewsItem {
  const NewsItem({
    required this.id,
    required this.headline,
    required this.excerpt,
    required this.date,
  });

  final String id;
  final String headline;
  final String excerpt;
  final DateTime date;
}

class HomeSnapshot {
  const HomeSnapshot({
    required this.stats,
    required this.trending,
    required this.news,
  });

  final List<({String value, String label})> stats;
  final List<TrendingItem> trending;
  final List<NewsItem> news;
}
