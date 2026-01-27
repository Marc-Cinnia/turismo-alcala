import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/filter_item.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/map_model.dart';
import 'package:valdeiglesias/widgets/filter_tile.dart';

class FilterList extends StatefulWidget {
  const FilterList({super.key});

  @override
  State<FilterList> createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
  late Widget _divider;
  late Set<FilterItem> _filters;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filters = Provider.of<MapModel>(context).filters;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: AppConstants.spacing),
            Column(
              children: List.generate(
                _filters.length,
                (index) {
                  final filter = _filters.toList().elementAt(index);

                  _divider = const Divider(color: AppConstants.label);

                  if (index == (_filters.length - 1)) {
                    _divider = const SizedBox();
                  }

                  return Column(
                    children: [
                      FilterTile(filter: filter),
                      _divider,
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
