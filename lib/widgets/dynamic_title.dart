import 'package:flutter/material.dart';
import 'package:valdeiglesias/constants/app_constants.dart';

/// A widget that knows how to render an accesible or
/// non-accessible design from itself according its state.
///
/// Used as part of application [AppBar]s
class DynamicTitle extends StatelessWidget {
  const DynamicTitle({
    super.key,
    required this.value,
    required this.accessible,
  });

  final String value;
  final bool accessible;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).appBarTheme.titleTextStyle;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.shortSpacing,
        right: AppConstants.shortSpacing,
      ),
      child: Text(
        value,
        style: (accessible)
            ? style?.copyWith(
                color: AppConstants.primary,
              )
            : style,
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
