import 'package:flutter/material.dart';
import 'package:valdeiglesias/constants/app_constants.dart';

/// Contains reusable loader implementation
/// for all screens and widgets of the app
class LoaderBuilder {
  static CircularProgressIndicator getLoader() {
    return const CircularProgressIndicator(color: AppConstants.primary);
  }
}
