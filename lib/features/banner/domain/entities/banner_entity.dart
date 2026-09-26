class BannerEntity {
  final String id;
  final String imageUrl;
  final bool active;
  final String targetScreen;

  const BannerEntity({
    this.id = '',
    required this.imageUrl,
    required this.active,
    required this.targetScreen,
  });
}
