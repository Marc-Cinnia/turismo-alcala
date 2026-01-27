class Offer {
  Offer({
    required this.offerId,
    required this.name,
    required this.nameEn,
    required this.shortDesc,
    required this.shortDescEn,
    required this.longDesc,
    required this.longDescEn,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.singleUse,
  });

  final int offerId;
  final String name;
  final String nameEn;
  final String shortDesc;
  final String shortDescEn;
  final String longDesc;
  final String longDescEn;
  final String imageUrl;
  final String startDate;
  final String endDate;
  final bool singleUse;
}
