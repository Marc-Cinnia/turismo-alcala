import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/filter_item.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/map_model.dart';

class BottomSheetActions extends StatefulWidget {
  const BottomSheetActions({super.key});

  @override
  State<BottomSheetActions> createState() => _BottomSheetActionsState();
}

class _BottomSheetActionsState extends State<BottomSheetActions> {
  late String _clearFiltersLabel;
  late String _applyFiltersLabel;
  late bool _english;

  late Set<FilterItem> _selectedFilters;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _english = Provider.of<LanguageModel>(context).english;
    _selectedFilters = Provider.of<MapModel>(context).selectedFilters;

    _clearFiltersLabel = (_english)
        ? AppConstants.clearFiltersLabelEn
        : AppConstants.clearFiltersLabel;
    _applyFiltersLabel = (_english)
        ? AppConstants.applyFiltersLabelEn
        : AppConstants.applyFiltersLabel;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OverflowBar(
        alignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _clearFilters,
            child: Text(_clearFiltersLabel),
          ),
          const SizedBox(width: AppConstants.spacing),
          GestureDetector(
            onTap: _applyFilters,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadius,
                ),
                color: AppConstants.contrast,
              ),
              padding: const EdgeInsets.all(AppConstants.spacing),
              child: Text(
                _applyFiltersLabel,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    if (_selectedFilters.isNotEmpty) {
      context.read<MapModel>().applyFilters();
      Navigator.of(context).pop();
    }
  }

  void _clearFilters() => context.read<MapModel>().clearFilters();
}
