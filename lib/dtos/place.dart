import 'package:flutter/material.dart';
import 'package:valdeiglesias/dtos/offer.dart';

class Place {
  Place({
    required this.placeName,
    required this.placeNameEn,
    this.placeType,
    this.placeTypeEn,
    this.placeId,
    this.thumbnailImage,
    this.mainImageUrl,
    this.subtitle,
    this.shortDescription,
    this.shortDescriptionEn,
    this.longDescription,
    this.longDescriptionEn,
    this.phoneNumber,
    this.phoneNumber2,
    this.websiteUrl,
    this.email,
    this.address,
    this.latitude,
    this.longitude,
    this.imageUrls,
    this.videoUrl,
    this.categoryId,
    this.schedule,
    this.scheduleEn,
    this.holidays,
    this.holidaysEn,
    this.requiresPayment,
    this.canReserve,
    this.placeCapacity,
    this.freePlaces,
    this.activeOffers,
    this.bookingUrl,
    this.instagramUrl,
    this.facebookUrl,
    this.twitterUrl,
  });

  final NetworkImage? thumbnailImage;
  final String? mainImageUrl;
  final int? placeId;
  final String placeName;
  final String placeNameEn;
  final String? subtitle;
  final String? shortDescription;
  final String? shortDescriptionEn;
  final String? longDescription;
  final String? longDescriptionEn;
  final String? phoneNumber;
  final String? phoneNumber2;
  final String? websiteUrl;
  final String? email;
  final String? address;
  final String? bookingUrl;
  final String? instagramUrl;
  final String? facebookUrl;
  final String? twitterUrl;
  final double? latitude;
  final double? longitude;
  final List<String>? imageUrls;
  final String? videoUrl;
  final int? categoryId;
  String? placeType;
  String? placeTypeEn;
  final Map<String, dynamic>? schedule;
  final Map<String, dynamic>? scheduleEn;
  final String? holidays;
  final String? holidaysEn;
  final bool? requiresPayment;
  final bool? canReserve;
  final int? placeCapacity;
  final int? freePlaces;
  final List<Offer>? activeOffers;
}
