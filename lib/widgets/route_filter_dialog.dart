import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/route_filter_type.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/route_type_filter.dart';

class RouteFilterDialog extends StatefulWidget {
  const RouteFilterDialog({super.key});

  @override
  State<RouteFilterDialog> createState() => _RouteFilterDialogState();
}

class _RouteFilterDialogState extends State<RouteFilterDialog> {
  late LanguageModel _language;
  late Set<RouteFilterType> _routeTypes;
  late Set<RouteFilterType> _routeTypesEn;

  late bool _routesReady;

  @override
  void initState() {
    super.initState();
    _routesReady = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _language = Provider.of<LanguageModel>(context);
    _routeTypes = Provider.of<RouteModel>(context).selectedRouteTypes;
    _routeTypesEn = Provider.of<RouteModel>(context).selectedRouteTypesEn;

    _routesReady = _routeTypes.isNotEmpty && _routeTypesEn.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final spacer = const SizedBox(height: AppConstants.spacing);

    final titleLabel = (_language.english)
        ? AppConstants.serviceFilterLabelEn
        : AppConstants.serviceFilterLabelEs;

    final title = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppConstants.spacing,
            left: AppConstants.spacing,
            right: AppConstants.spacing,
          ),
          child: Text(
            titleLabel,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppConstants.primary,
                ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.close_outlined,
            color: AppConstants.primary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    final routeTypeFilter = RouteTypeFilter();
    final applyFiltersLabel = (_language.english)
        ? AppConstants.applyFiltersLabelEn
        : AppConstants.applyFiltersLabel;
    final filterButtons = OverflowBar(
      alignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
              context.read<RouteModel>().filterRoutes();
              Navigator.of(context).pop();
            },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.contrast,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacing * 2,
              vertical: AppConstants.spacing,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadius,
                ),
            ),
                ),
                child: Text(
                  applyFiltersLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );

    Widget mainContent = Padding(
      padding: const EdgeInsets.all(AppConstants.shortSpacing),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: AppConstants.carouselHeight,
            child: Center(
              child: LoaderBuilder.getLoader(),
            ),
          ),
        ],
      ),
    );

    if (_routesReady) {
      mainContent = SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                title,
                spacer,
                routeTypeFilter,
                spacer,
                filterButtons,
              ],
            ),
          ),
        ),
      );
    }

    return Dialog(child: mainContent);
  }
}
