import 'package:media_network/data/models/home_snapshot.dart';

class HomeMockData {
  HomeMockData._();

  static HomeSnapshot get snapshot => HomeSnapshot(
        stats: const [
          (value: '120+', label: 'Creators'),
          (value: '48', label: 'Active Projects'),
          (value: '300+', label: 'Resources'),
          (value: '32', label: 'Countries'),
        ],
        trending: const [
          TrendingItem(
            id: '1',
            title: 'Global Worship Broadcast',
            category: 'Broadcast',
            engagement: '2.4k views',
            imageUrl:
                'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=400',
          ),
          TrendingItem(
            id: '2',
            title: 'Creator Podcast Series',
            category: 'Podcast',
            engagement: '1.8k listens',
            imageUrl:
                'https://images.unsplash.com/photo-1590602847861-f357a9332bbc?w=400',
          ),
          TrendingItem(
            id: '3',
            title: 'Sunday Service Highlights',
            category: 'Worship',
            engagement: '3.1k views',
            imageUrl:
                'https://images.unsplash.com/photo-1501386761578-4d12ad3d3c8b?w=400',
          ),
          TrendingItem(
            id: '4',
            title: 'Media Training Masterclass',
            category: 'Training',
            engagement: '920 enrolled',
            imageUrl:
                'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400',
          ),
          TrendingItem(
            id: '5',
            title: 'Social Impact Campaign',
            category: 'Social',
            engagement: '5.2k shares',
            imageUrl:
                'https://images.unsplash.com/photo-1611162617474-5b21e939e988?w=400',
          ),
        ],
        news: [
          NewsItem(
            id: '1',
            headline: 'Rhapsody Media Network Expands to 12 New Regions',
            excerpt:
                'The network welcomes media creators from across Africa, Europe, and the Americas.',
            date: DateTime(2026, 6, 20),
          ),
          NewsItem(
            id: '2',
            headline: 'Creator Spotlight: Excellence in Broadcast Media',
            excerpt:
                'Meet the team behind this month\'s most-watched worship broadcast series.',
            date: DateTime(2026, 6, 18),
          ),
          NewsItem(
            id: '3',
            headline: 'New Resource Library Categories Now Live',
            excerpt:
                'Training materials, worship assets, and podcast templates are now available.',
            date: DateTime(2026, 6, 15),
          ),
          NewsItem(
            id: '4',
            headline: 'Annual Media Summit Registration Opens',
            excerpt:
                'Join creators worldwide for workshops, networking, and live project showcases.',
            date: DateTime(2026, 6, 10),
          ),
          NewsItem(
            id: '5',
            headline: '100+ Live Projects Milestone Reached',
            excerpt:
                'The network celebrates a growing ecosystem of collaborative media projects.',
            date: DateTime(2026, 6, 5),
          ),
        ],
      );
}
