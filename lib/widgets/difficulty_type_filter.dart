import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/route_filter_type.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';

class DifficultyTypeFilter extends StatefulWidget {
  DifficultyTypeFilter({super.key});

  @override
  State<DifficultyTypeFilter> createState() => _DifficultyTypeFilterState();
}

class _DifficultyTypeFilterState extends State<DifficultyTypeFilter> {
  late bool _english;
  late int _difficultyTypeSelected;
  late Set<RouteFilterType> _difficultyTypes;
  late Set<RouteFilterType> _difficultyTypesEn;
  List<DropdownMenuEntry> _entries = [];
  List<DropdownMenuEntry> _entriesEn = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _difficultyTypes = Provider.of<RouteModel>(context).selectedDifficultyTypes;
    _difficultyTypesEn =
        Provider.of<RouteModel>(context).selectedDifficultyTypesEn;
    _english = Provider.of<LanguageModel>(context).english;
    _difficultyTypeSelected =
        Provider.of<RouteModel>(context).difficultyTypeSelected;
  }

  @override
  Widget build(BuildContext context) {
    final shortSpacer = const SizedBox(height: AppConstants.shortSpacing);

    Widget content = Center(child: LoaderBuilder.getLoader());

    if (_entries.isEmpty && _difficultyTypes.isNotEmpty) {
      _setEntries(_difficultyTypes.toList());
    }

    if (_entriesEn.isEmpty && _difficultyTypesEn.isNotEmpty) {
      _setEntriesEn(_difficultyTypesEn.toList());
    }

    if (_difficultyTypes.isNotEmpty && _difficultyTypesEn.isNotEmpty) {
      final entries = (_english) ? _entriesEn : _entries;
      final label = (_english)
          ? AppConstants.routeDifficultyLabelEn
          : AppConstants.routeDifficultyLabel;

      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          shortSpacer,
          LayoutBuilder(
            builder: (context, constraints) {
              return DropdownMenu(
                initialSelection: _difficultyTypeSelected,
                dropdownMenuEntries: entries,
                width: constraints.maxWidth,
                onSelected: (value) {
                  if (value != null) {
                    context
                        .read<RouteModel>()
                        .setDifficultyTypeSelection(value);
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
    _entries = _difficultyTypes.map(
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
    _entriesEn = _difficultyTypesEn.map(
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
