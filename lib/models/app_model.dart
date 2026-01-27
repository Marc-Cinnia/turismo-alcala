import 'package:valdeiglesias/dtos/interest_place.dart';
import 'package:valdeiglesias/dtos/place.dart';

abstract class AppModel {
  /// Retrieves a list of interest places from a dynamic list of places.
  ///
  /// This method takes a list of dynamic places and converts it into a list
  /// of [InterestPlace] instances. It is used to extract and manage the
  /// interest places data within the map screen.
  ///
  /// Args:
  ///   places (List<dynamic>): The list of dynamic places to be converted.
  ///
  /// Returns:
  ///   List<InterestPlace>: A list of interest places.
  List<InterestPlace> getInterestPlaces(List<dynamic> places);

  /// Retrieves a place from a dynamic place object.
  ///
  /// This method takes a dynamic place object and converts it into a [Place]
  /// instance. It is used to extract and manage the place data within the map
  /// screen.
  ///
  /// Args:
  ///   place (dynamic): The dynamic place object to be converted.
  ///
  /// Returns:
  ///   Place: The extracted place instance.
  Place getPlace(dynamic place);
}
