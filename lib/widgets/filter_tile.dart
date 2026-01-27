import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/filter_item.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/map_model.dart';

class FilterTile extends StatefulWidget {
  const FilterTile({
    super.key,
    required this.filter,
  });

  final FilterItem filter;

  @override
  State<FilterTile> createState() => _FilterTileState();
}

class _FilterTileState extends State<FilterTile> {
  final _spacer = const SizedBox(height: AppConstants.spacing);

  late String _name;
  late bool _english;
  late bool _selected;

  late Set<FilterItem> _selectedFilters;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _english = Provider.of<LanguageModel>(context).english;
    _selectedFilters = Provider.of<MapModel>(context).selectedFilters;
    _name = (_english) ? widget.filter.nameEn : widget.filter.nameEs;
    _selected = _isSelected(widget.filter);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            _name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppConstants.primary,
                ),
          ),
          trailing: (_selected)
              ? const Icon(
                  Icons.check_outlined,
                  color: AppConstants.primary,
                )
              : null,
          onTap: () {
            context.read<MapModel>().toggleSelectFilter(widget.filter);
            setState(() => _selected = !_selected);
          },
        ),
        _spacer,
      ],
    );
  }

  bool _isSelected(FilterItem filter) {
    FilterItem? filtered;

    if (_selectedFilters.isNotEmpty) {
      filtered = _selectedFilters
          .where(
            (selectedFilter) => selectedFilter.nameEs == filter.nameEs,
          )
          .firstOrNull;
    }

    return filtered != null;
  }
}
