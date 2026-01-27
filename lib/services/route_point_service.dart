import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/route_point_detail.dart';
import 'package:valdeiglesias/dtos/route_point_ref.dart';
import 'package:valdeiglesias/utils/content_validator.dart';

class RoutePointService {
  RoutePointService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<RoutePointDetail>> fetchPoints(List<RoutePointRef> refs) async {
    final futures = refs.map(_fetchWithFallback).toList();
    return Future.wait(futures);
  }

  Future<RoutePointDetail> _fetchWithFallback(RoutePointRef ref) async {
    final detail = await fetchPoint(ref);
    if (detail != null) {
      return detail;
    }
    return _buildFallbackDetail(ref);
  }

  Future<RoutePointDetail?> fetchPoint(RoutePointRef ref) async {
    final pageUrl = _normalizePageUrl(ref.url);

    if (pageUrl.isEmpty) {
      return _buildFallbackDetail(ref);
    }

    final endpoint = _buildJsonEndpoint(pageUrl);

    if (endpoint.isEmpty) {
      return _buildFallbackDetail(ref);
    }

    try {
      final response = await _client.get(Uri.parse(endpoint));

      if (response.statusCode != AppConstants.success) {
          return _buildFallbackDetail(ref);
      }

      final dynamic raw = jsonDecode(response.body);

      final title = _readValue(raw[AppConstants.titleKey]) ??
          AppConstants.routePointFallbackTitle;

      final shortDescription =
          _readValue(raw[AppConstants.placeShortDescription]) ??
              _readValue(raw[AppConstants.routeShortDesc]);

      final imageUrl = _readImageUrl(raw[AppConstants.placeMainImage]) ??
          _readImageUrl(raw[AppConstants.routeMainImage]) ??
          _readImageUrl(raw[AppConstants.newsImage]);

      final coordinates = _readCoordinates(raw);
      final place = _mapPlace(raw, pageUrl);

      return RoutePointDetail(
        id: ref.targetId,
        title: title,
        shortDescription: shortDescription,
        imageUrl: imageUrl,
        latitude: coordinates.$1,
        longitude: coordinates.$2,
        url: pageUrl,
        place: place,
      );
    } catch (_) {
      return _buildFallbackDetail(ref);
    }
  }

  String? _readValue(dynamic field) {
    if (field == null) return null;

    if (field is List && field.isNotEmpty) {
      final candidate = field.first;
      if (candidate is Map && candidate.containsKey(AppConstants.valueKey)) {
        final value = candidate[AppConstants.valueKey];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }

    if (field is Map && field.containsKey(AppConstants.valueKey)) {
      final value = field[AppConstants.valueKey];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    if (field is String && field.trim().isNotEmpty) {
      return field.trim();
    }

    return null;
  }

  String? _readImageUrl(dynamic field) {
    if (field is List && field.isNotEmpty) {
      final candidate = field.first;
      if (candidate is Map && candidate[AppConstants.urlKey] is String) {
        final url = candidate[AppConstants.urlKey] as String;
        if (url.isNotEmpty) {
          return url;
        }
      }
    }
    return null;
  }

  (double?, double?) _readCoordinates(dynamic raw) {
    final placeLocation = raw[AppConstants.placeLocation];
    final routeLocation = raw[AppConstants.routeLocation];

    double? lat = _extractCoordinate(placeLocation, AppConstants.placeLatitude) ??
        _extractCoordinate(routeLocation, AppConstants.placeLatitude);

    double? lng = _extractCoordinate(placeLocation, AppConstants.placeLongitude) ??
        _extractCoordinate(placeLocation, AppConstants.placeLongitude2) ??
        _extractCoordinate(routeLocation, AppConstants.placeLongitude) ??
        _extractCoordinate(routeLocation, AppConstants.placeLongitude2);

    return (lat, lng);
  }

  double? _extractCoordinate(dynamic field, String key) {
    if (field is List && field.isNotEmpty) {
      final candidate = field.first;
      if (candidate is Map && candidate[key] is num) {
        return (candidate[key] as num).toDouble();
      }
    }
    return null;
  }

  RoutePointDetail _buildFallbackDetail(RoutePointRef ref) {
    final pageUrl = _normalizePageUrl(ref.url);
    return RoutePointDetail(
      id: ref.targetId,
      title: AppConstants.routePointFallbackTitle,
      shortDescription: AppConstants.routePointFallbackDescription,
      url: pageUrl.isEmpty ? ref.url : pageUrl,
      place: null,
    );
  }

  Place? _mapPlace(dynamic raw, String fallbackUrl) {
    if (raw is! Map<String, dynamic>) {
      return null;
    }

    final name = _readValue(raw[AppConstants.titleKey]) ??
        AppConstants.routePointFallbackTitle;

    final description =
        _readValue(raw[AppConstants.placeLongDescription]) ??
            _readValue(raw[AppConstants.routeLongDesc]) ??
            AppConstants.routePointFallbackDescription;

    final shortDescription =
        _readValue(raw[AppConstants.placeShortDescription]) ??
            _readValue(raw[AppConstants.routeShortDesc]) ??
            AppConstants.routePointFallbackDescription;

    final imageUrl = _readImageUrl(raw[AppConstants.placeMainImage]) ??
        _readImageUrl(raw[AppConstants.routeMainImage]);

    final gallery = _readGallery(raw);

    final coords = _readCoordinates(raw);

    final placeId = _parseIdFromList(raw[AppConstants.nIdKey]);

    return Place(
      placeName: name,
      placeNameEn: name,
      placeId: placeId,
      mainImageUrl: imageUrl,
      shortDescription: shortDescription,
      shortDescriptionEn: shortDescription,
      longDescription: description,
      longDescriptionEn: description,
      websiteUrl: _readValue(raw[AppConstants.placeWebsite]) ?? fallbackUrl,
      phoneNumber: _readValue(raw[AppConstants.placePhoneNumber]),
      address: _readValue(raw[AppConstants.placeAddress]),
      latitude: coords.$1,
      longitude: coords.$2,
      imageUrls: gallery.isEmpty ? null : gallery,
      videoUrl: _readValue(raw[AppConstants.placeVideo]) ?? '',
      placeType: AppConstants.routeApiType,
      placeTypeEn: AppConstants.routeApiType,
    );
  }

  List<String> _readGallery(dynamic raw) {
    if (raw is List) {
      return ContentValidator.imageUrls(raw);
    }

    return const [];
  }

  int? _parseIdFromList(dynamic field) {
    if (field is List && field.isNotEmpty) {
      final candidate = field.first;
      final value = candidate[AppConstants.valueKey];
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
    }
    return null;
  }

  String _normalizePageUrl(String rawUrl) {
    if (rawUrl.isEmpty) {
      return '';
    }

    if (rawUrl.startsWith('http')) {
      return rawUrl;
    }

    final sanitized = rawUrl.startsWith('/') ? rawUrl : '/$rawUrl';
    return '${AppConstants.drupalBaseUrl}$sanitized';
  }

  String _buildJsonEndpoint(String rawUrl) {
    if (rawUrl.isEmpty) {
      return '';
    }

    if (rawUrl.contains('_format=json')) {
      return rawUrl;
    }

    final separator = rawUrl.contains('?') ? '&' : '?';
    return '$rawUrl${separator}_format=json';
  }
}

