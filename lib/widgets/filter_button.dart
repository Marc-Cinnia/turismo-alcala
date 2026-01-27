import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/filter_item.dart';
import 'package:valdeiglesias/dtos/section.dart';
import 'package:valdeiglesias/models/map_model.dart';
import 'package:valdeiglesias/models/section_model.dart';
import 'package:valdeiglesias/widgets/map_bottom_sheet.dart';

class FilterButton extends StatefulWidget {
  FilterButton({super.key});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  late RoundedRectangleBorder _buttonShape;
  late Widget _buttonChild;
  late Set<FilterItem> _filters;
  late List<Section> _sections;

  @override
  void initState() {
    _buttonShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(AppConstants.borderRadius),
      ),
    );
    _buttonChild = const Icon(
      Icons.filter_list_outlined,
      color: AppConstants.contrast,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filters = Provider.of<MapModel>(context).filters;
    _sections = Provider.of<SectionModel>(context).items;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppConstants.mapFloatingButtonPadding,
      ),
      child: FloatingActionButton(
        onPressed: _showFilterModal,
        shape: _buttonShape,
        backgroundColor: Colors.white,
        child: _buttonChild,
      ),
    );
  }

  /// Displays the filter modal bottom sheet.
  ///
  /// This method shows a modal bottom sheet that allows users to select
  /// filters for the map. It is called when the user interacts with the
  /// filter button in the map screen.
  void _showFilterModal() async {
    if (_filters.isNotEmpty && _sections.isNotEmpty) {
      await showModalBottomSheet<List<FilterItem>>(
        context: context,
        builder: (context) => MapBottomSheet(),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.borderRadius),
            topRight: Radius.circular(AppConstants.borderRadius),
          ),
        ),
        isDismissible: false,
      );
    }
  }
}
