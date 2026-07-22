class CreatorProfile {
  const CreatorProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.title,
    required this.nationality,
    required this.ceZone,
    required this.skills,
    this.photoUrl,
  });

  final String id;
  final String email;
  final String name;
  final String title;
  final String nationality;
  final String ceZone;
  final List<String> skills;
  final String? photoUrl;
}
