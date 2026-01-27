import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';

class NoResultsPlaceholder extends StatelessWidget {
  const NoResultsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final spacer = const SizedBox(height: AppConstants.spacing);

    final language = context.watch<LanguageModel>();

    final title = (language.english)
        ? AppConstants.noResultsLabelEn
        : AppConstants.noResultsLabel;

    final description = (language.english)
        ? AppConstants.noResultsDescLabelEn
        : AppConstants.noResultsDescLabel;

    return Padding(
      padding: const EdgeInsets.only(top: 150.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: AppConstants.spacing,
              left: AppConstants.spacing,
              right: AppConstants.spacing,
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppConstants.primary,
                  ),
            ),
          ),
          spacer,
          Padding(
            padding: const EdgeInsets.only(
              top: AppConstants.spacing,
              left: AppConstants.spacing,
              right: AppConstants.spacing,
            ),
            child: Text(
              description,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
