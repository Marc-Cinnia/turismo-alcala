import 'package:flutter/material.dart';

/// A class representing a section in the application.
///
/// The [Section] class contains information about a specific section.
class Section {
  Section({
    required this.label,
    required this.backgroundImage,
    required this.routeName,
  });

  /// The name of this [Section]
  String label;

  /// The background image of this [Section].
  NetworkImage backgroundImage;

  /// The route name associated with this [Section].
  String routeName;
}
