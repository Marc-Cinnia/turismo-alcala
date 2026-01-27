import 'package:flutter/material.dart';
import 'package:valdeiglesias/constants/app_constants.dart';

class Reward extends StatelessWidget {
  const Reward({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final unlockedColor = AppConstants.primary.withValues(alpha: 0.3);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.shortSpacing),
        child: ListTile(
          leading: Icon(
            icon,
            size: 40.0,
            color: (unlocked) ? AppConstants.lessContrast : unlockedColor,
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: (unlocked) ? AppConstants.primary : unlockedColor,
                ),
          ),
          subtitle: Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: (unlocked) ? AppConstants.primary : unlockedColor,
                ),
          ),
          trailing: Icon(
            (unlocked) ? Icons.check_circle : Icons.lock,
            color: (unlocked) ? AppConstants.lessContrast : unlockedColor,
          ),
        ),
      ),
    );
  }
}
