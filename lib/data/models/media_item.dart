class MediaItem {
  final String title;
  final String url;
  final String thumbnail;
  final String type;

  const MediaItem({
    required this.title,
    required this.url,
    required this.thumbnail,
    required this.type,
  });

  factory MediaItem.fromFirestore(Map<String, dynamic> data) {
    return MediaItem(
      title: data['title'] as String? ?? '',
      url: data['url'] as String? ?? '',
      thumbnail: data['thumbnail'] as String? ?? '',
      type: data['type'] as String? ?? 'image',
    );
  }
}
