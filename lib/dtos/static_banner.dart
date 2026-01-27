class StaticBanner {
  const StaticBanner({
    required this.imageUrl,
    required this.navigationUrl,
    required this.expirationDate,    
  });

  final String imageUrl;
  final String navigationUrl;
  final DateTime expirationDate;
}
