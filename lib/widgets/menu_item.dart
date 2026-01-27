import 'package:flutter/material.dart';

import 'package:valdeiglesias/constants/app_constants.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.accessible,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool? accessible;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final color = Colors.white; // Siempre blanco sobre fondo rojo

    return Expanded(
      child: InkWell(
        splashColor: AppConstants.minimumContrast,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            color: (selected) ? Colors.white.withOpacity(0.2) : null, // Fondo sutil para seleccionado
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
              ),
              const SizedBox(height: AppConstants.shortSpacing),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
