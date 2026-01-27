import 'package:flutter/material.dart';

class RatingModel extends ChangeNotifier {
  int _userRating = 0;

  int get userRating => _userRating;

  void setRating(int rating) {
    _userRating = rating;
    notifyListeners();
  }

  void clear() {
    _userRating = 0;
    notifyListeners();
  }
}
