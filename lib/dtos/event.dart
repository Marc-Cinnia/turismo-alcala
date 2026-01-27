import 'package:flutter/material.dart';
import 'package:valdeiglesias/dtos/place.dart';

/// Contains data for all schedule parametrized in backend
class Event extends Place {
  Event({
    required super.placeName,
    required super.placeNameEn,
    required super.latitude,
    required super.placeType,
    required super.placeTypeEn,
    required super.longitude,
    super.shortDescription,
    super.longDescription,
    super.placeId,
    required this.eventAddress,
    required this.startDate,
    required this.startDay,
    required this.endDate,
    required this.mainImageUrl,
    required this.imageGallery,
    required this.pdfUrl,
    this.startDt,
    this.endDt,
    this.startTime,
    this.endTime,
  });

  final String eventAddress;
  final String startDate;
  final String startDay;
  final String endDate;
  final String mainImageUrl;
  final List<String> imageGallery;
  final String pdfUrl;
  final DateTime? startDt;
  final DateTime? endDt;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
}
