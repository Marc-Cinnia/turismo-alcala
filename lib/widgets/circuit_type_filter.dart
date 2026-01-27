import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/route_filter_type.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';

class CircuitTypeFilter extends StatefulWidget {
  CircuitTypeFilter({super.key});

  @override
  State<CircuitTypeFilter> createState() => _CircuitTypeFilterState();
}

class _CircuitTypeFilterState extends State<CircuitTypeFilter> {
  late bool _english;
  late int _circuitTypeSelected;
  late Set<RouteFilterType> _circuitTypes;
  late Set<RouteFilterType> _circuitTypesEn;
  List<DropdownMenuEntry> _entries = [];
  List<DropdownMenuEntry> _entriesEn = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _circuitTypes = Provider.of<RouteModel>(context).selectedCircuitTypes;
    _circuitTypesEn = Provider.of<RouteModel>(context).selectedCircuitTypesEn;
    _english = Provider.of<LanguageModel>(context).english;
    _circuitTypeSelected = Provider.of<RouteModel>(context).circuitTypeSelected;
  }

  @override
  Widget build(BuildContext context) {
    final shortSpacer = const SizedBox(height: AppConstants.shortSpacing);

    Widget content = Center(child: LoaderBuilder.getLoader());

    if (_entries.isEmpty && _circuitTypes.isNotEmpty) {
      _setEntries(_circuitTypes.toList());
    }

    if (_entriesEn.isEmpty && _circuitTypesEn.isNotEmpty) {
      _setEntriesEn(_circuitTypesEn.toList());
    }

    if (_circuitTypes.isNotEmpty && _circuitTypesEn.isNotEmpty) {
      final entries = (_english) ? _entriesEn : _entries;
      final label = (_english)
          ? AppConstants.routeCircuitTypeLabelEn
          : AppConstants.routeCircuitTypeLabel;

      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          shortSpacer,
          LayoutBuilder(
            builder: (context, constraints) {
              return DropdownMenu(
                initialSelection: _circuitTypeSelected,
                dropdownMenuEntries: entries,
                width: constraints.maxWidth,
                onSelected: (value) {
                  if (value != null) {
                    context.read<RouteModel>().setCircuitTypeSelection(value);
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
    _entries = _circuitTypes.map(
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
    _entriesEn = _circuitTypesEn.map(
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
