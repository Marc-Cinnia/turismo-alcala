import 'package:flutter/material.dart';
import 'package:valdeiglesias/constants/app_constants.dart';

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppConstants.primary,
              ),
        ),
        IconButton(
          icon: const Icon(
            Icons.close_outlined,
            color: AppConstants.primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
