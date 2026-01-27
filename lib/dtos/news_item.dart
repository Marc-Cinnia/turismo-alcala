class NewsItem {
  NewsItem({
    required this.mainImageUrl,
    required this.title,
    required this.subtitle,
    required this.shortDescription,
    required this.longDescription,
    required this.created,
    required this.websiteUrl,
    required this.pdfUrl,
    required this.imageUrls,
  });

  final String mainImageUrl;
  final String title;
  final String subtitle;
  final String shortDescription;
  final String longDescription;
  final String created;
  final String websiteUrl;
  final String pdfUrl;
  final List<String> imageUrls;
}
