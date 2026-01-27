import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/route_filter_type.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';

class RouteTypeFilter extends StatefulWidget {
  RouteTypeFilter({super.key});

  @override
  State<RouteTypeFilter> createState() => _RouteTypeFilterState();
}

class _RouteTypeFilterState extends State<RouteTypeFilter> {
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
          ? AppConstants.routeTypeLabelEn
          : AppConstants.routeTypeLabel;

      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          shortSpacer,
          LayoutBuilder(
            builder: (context, constraints) {
              return DropdownMenu(
                initialSelection: _routeTypeSelected,
                dropdownMenuEntries: entries,
                width: constraints.maxWidth,
                onSelected: (value) {
                  if (value != null) {
                    context.read<RouteModel>().setRouteTypeSelection(value);
                  }
                },
              );
            },
          ),
        ],
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
    // Filtro todo rutas
    /*_entries.insert(
      0,
      DropdownMenuEntry<int>(
        value: 0,
        label: AppConstants.allItemsLabelEs,
      ),
    );*/
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
