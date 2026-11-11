class MediaItem {
  final String title;
  final String url;
  final String thumbnail;
  final String type; // "video" or "image"

  MediaItem({
    required this.title,
    required this.url,
    required this.thumbnail,
    required this.type,
  });
}