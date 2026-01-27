import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/route_filter_type.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';

class RouteCategoryFilter extends StatefulWidget {
  const RouteCategoryFilter({super.key});

  @override
  State<RouteCategoryFilter> createState() => _RouteCategoryFilterState();
}

class _RouteCategoryFilterState extends State<RouteCategoryFilter> {
  late bool _english;
  late int _routeTypeSelected;
  late Set<RouteFilterType> _routeTypes;
  late Set<RouteFilterType> _routeTypesEn;
  List<DropdownMenuEntry<int>> _entries = [];
  List<DropdownMenuEntry<int>> _entriesEn = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeTypes = Provider.of<RouteModel>(context).selectedRouteTypes;
    _routeTypesEn = Provider.of<RouteModel>(context).selectedRouteTypesEn;
    _english = Provider.of<LanguageModel>(context).english;
    _routeTypeSelected = Provider.of<RouteModel>(context).routeTypeSelected;
    
    // Asegurar que el estado se actualice cuando cambie la selección
    /*if (mounted) {
      setState(() {});
    }*/
  }

  @override
  Widget build(BuildContext context) {
    final shortSpacer = const SizedBox(height: AppConstants.shortSpacing);

    Widget content = Center(child: LoaderBuilder.getLoader());

    if (_entries.isEmpty && _routeTypes.isNotEmpty) {
      _setEntries(_routeTypes.toList());
    }

    if (_entriesEn.isEmpty && _routeTypesEn.isNotEmpty) {
      _setEntriesEn(_routeTypesEn.toList());
    }

    if (_routeTypes.isNotEmpty && _routeTypesEn.isNotEmpty) {
      final entries = (_english) ? _entriesEn : _entries;
      final label = (_english)
          ? AppConstants.routeCategoryFilterLabelEn
          : AppConstants.routeCategoryFilterLabel;

      content = Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacing),
          padding: const EdgeInsets.all(AppConstants.spacing * 1.5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            border: Border.all(
              color: AppConstants.primary.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: AppConstants.spacing,
                  left: AppConstants.spacing,
                  right: AppConstants.spacing,
                ),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppConstants.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppConstants.spacing),
              LayoutBuilder(
                builder: (context, constraints) {
                  return DropdownMenu<int>(
                    initialSelection: _routeTypeSelected,
                    dropdownMenuEntries: entries,
                    width: constraints.maxWidth,
                     menuStyle: const MenuStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                        surfaceTintColor: WidgetStatePropertyAll(Colors.white),
                      ),
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        borderSide: BorderSide(
                          color: AppConstants.primary.withOpacity(0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        borderSide: BorderSide(
                          color: AppConstants.primary.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        borderSide: BorderSide(
                          color: AppConstants.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacing,
                        vertical: AppConstants.spacing,
                      ),
                    ),
                    onSelected: (value) {
                      if (value != null) {
                        context.read<RouteModel>().setRouteTypeSelection(value);
                        // Aplicar filtro automáticamente
                        context.read<RouteModel>().filterRoutes();
                        // Marcar que se han aplicado filtros
                        context.read<RouteModel>().setFiltersApplied(true);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    return content;
  }

  void _setEntries(List<RouteFilterType> types) {
    _entries = _routeTypes.map(
      (type) {
        return DropdownMenuEntry<int>(
          value: type.id,
          label: type.name,
        );
      },
    ).toList();
    _entries.insert(
      0,
      DropdownMenuEntry<int>(
        value: 0,
        label: AppConstants.allItemsLabelEs,
      ),
    );
  }

  void _setEntriesEn(List<RouteFilterType> types) {
    _entriesEn = _routeTypesEn.map(
      (type) {
        return DropdownMenuEntry<int>(
          value: type.id,
          label: type.name,
        );
      },
    ).toList();
    _entriesEn.insert(
      0,
      DropdownMenuEntry<int>(
        value: 0,
        label: AppConstants.allItemsLabel,
      ),
    );
  }
}
