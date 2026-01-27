import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/route_point_detail.dart';
import 'package:valdeiglesias/dtos/route_point_ref.dart';
import 'package:valdeiglesias/models/cellar_model.dart';
import 'package:valdeiglesias/models/eat_model.dart';
import 'package:valdeiglesias/models/experience_model.dart';
import 'package:valdeiglesias/models/guided_tours_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/models/schedule_model.dart';
import 'package:valdeiglesias/models/shop_model.dart';
import 'package:valdeiglesias/models/sleep_model.dart';
import 'package:valdeiglesias/models/visit_model.dart';
import 'package:valdeiglesias/screens/place_detail.dart';
import 'package:valdeiglesias/services/route_point_service.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';

class RoutePointsSection extends StatefulWidget {
  const RoutePointsSection({
    super.key,
    required this.points,
    required this.english,
    required this.accessible,
  });

  final List<RoutePointRef> points;
  final bool english;
  final bool accessible;

  @override
  State<RoutePointsSection> createState() => _RoutePointsSectionState();
}

class _RoutePointsSectionState extends State<RoutePointsSection> {
  late Future<List<RoutePointDetail>> _pointsFuture;

  @override
  void initState() {
    super.initState();
    _pointsFuture = RoutePointService().fetchPoints(widget.points);
  }

  @override
  Widget build(BuildContext context) {
    final sectionTitle = widget.english
        ? AppConstants.routePointsSectionTitleEn
        : AppConstants.routePointsSectionTitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacing,
          ),
          child: Text(
            sectionTitle,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: AppConstants.primary),
          ),
        ),
        FutureBuilder<List<RoutePointDetail>>(
          future: _pointsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: LoaderBuilder.getLoader());
            }

            if (snapshot.hasError) {
              return _buildEmptyMessage(context);
            }

            final points = snapshot.data ?? [];

            if (points.isEmpty) {
              return _buildEmptyMessage(context);
            }

            return Column(
              children: points
                  .map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppConstants.spacing,
                      ),
                      child: _RoutePointCard(
                        detail: point,
                        accessible: widget.accessible,
                        english: widget.english,
                        place: _resolvePlace(context, point),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyMessage(BuildContext context) {
    final emptyLabel = widget.english
        ? AppConstants.routePointsEmptyLabelEn
        : AppConstants.routePointsEmptyLabel;

    return Text(
      emptyLabel,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: AppConstants.lessContrast),
    );
  }

  Place? _resolvePlace(BuildContext context, RoutePointDetail detail) {
    if (detail.place != null) {
      return detail.place;
    }

    final nodeId = detail.id.toString();

    final candidates = <List<Place>>[
      context.read<VisitModel>().placesToVisit,
      context.read<EatModel>().placesToEat,
      context.read<SleepModel>().placesToRest,
      context.read<ShopModel>().placesToShop,
      context.read<ExperienceModel>().items,
      context.read<GuidedToursModel>().tours,
      context.read<RouteModel>().routes,
      context.read<ScheduleModel>().eventSchedule,
      context.read<CellarModel>().cellars,
    ];

    for (final list in candidates) {
      final match = _findById(list, nodeId);
      if (match != null) {
        return match;
      }
    }

    return null;
  }

  Place? _findById(List<Place> places, String id) {
    try {
      return places.firstWhere(
        (place) => place.placeId != null && '${place.placeId}' == id,
      );
    } catch (_) {
      return null;
    }
  }
}

class _RoutePointCard extends StatelessWidget {
  const _RoutePointCard({
    required this.detail,
    required this.accessible,
    required this.english,
    required this.place,
  });

  final RoutePointDetail detail;
  final bool accessible;
  final bool english;
  final Place? place;

  @override
  Widget build(BuildContext context) {
    return accessible
        ? _buildAccessibleCard(context)
        : _buildStandardCard(context);
  }

  Widget _buildStandardCard(BuildContext context) {
    final imageUrl = _imageUrl;
    final title = _buildTitle();
    final descriptionText = _buildDescription();

    final thumbnail = (imageUrl == null || imageUrl.isEmpty)
        ? const SizedBox(width: 0)
        : GestureDetector(
            onTap: () => _openPoint(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                AppConstants.thumbnailBorderRadius,
              ),
              child: SuperNetworkImage(
                url: imageUrl,
                width: AppConstants.thumbnailWidth,
                height: AppConstants.thumbnailHeight,
                fit: BoxFit.cover,
                placeholderBuilder: () => SizedBox(
                  width: AppConstants.thumbnailWidth,
                  height: AppConstants.thumbnailHeight,
                  child: Center(
                    child: LoaderBuilder.getLoader(),
                  ),
                ),
              ),
            ),
          );

    final descriptionWidget = (descriptionText == null ||
            descriptionText.isEmpty)
        ? const SizedBox()
        : Text(
            descriptionText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:
                Theme.of(context).textTheme.bodySmall,
          );

    return Card(
      color: AppConstants.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.cardSpacing),
        child: Row(
          children: [
            thumbnail,
            Expanded(
              child: GestureDetector(
                onTap: () => _openPoint(context),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppConstants.cardSpacing,
                    right: AppConstants.cardSpacing,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: AppConstants.primary),
                      ),
                      const SizedBox(height: AppConstants.shortSpacing),
                      descriptionWidget,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessibleCard(BuildContext context) {
    final title = _buildTitle();

    return Card(
      color: AppConstants.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.cardSpacing),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _openPoint(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.cardSpacing,
                  ),
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppConstants.primary),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 30.0,
                child: GestureDetector(
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppConstants.primary,
                  ),
                  onTap: () => _openPoint(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPoint(BuildContext context) async {
    if (place != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PlaceDetail(
            place: place!,
            placeEn: place!,
            accessible: accessible,
          ),
        ),
      );
      return;
    }

    try {
      final uri = Uri.parse(detail.url);
      if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  String _buildTitle() {
    if (place != null) {
      final title = english ? place!.placeNameEn : place!.placeName;
      if (title.trim().isNotEmpty) {
        return title;
      }
    }
    return detail.title;
  }

  String? _buildDescription() {
    if (place != null) {
      final shortDesc = english
          ? (place!.shortDescriptionEn ?? place!.shortDescription)
          : (place!.shortDescription ?? place!.shortDescriptionEn);

      if (shortDesc != null && shortDesc.isNotEmpty) {
        return shortDesc;
      }

      final longDesc = english
          ? (place!.longDescriptionEn ?? place!.longDescription)
          : (place!.longDescription ?? place!.longDescriptionEn);

      if (longDesc != null && longDesc.isNotEmpty) {
        return longDesc;
      }
    }

    return detail.shortDescription ?? AppConstants.routePointFallbackDescription;
  }

  String? get _imageUrl {
    if (place?.mainImageUrl != null && place!.mainImageUrl!.isNotEmpty) {
      return place!.mainImageUrl;
    }

    if (detail.imageUrl != null && detail.imageUrl!.isNotEmpty) {
      return detail.imageUrl;
    }

    return null;
  }
}

