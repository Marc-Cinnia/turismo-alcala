import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/rating_model.dart';

class RatingStarsBar extends StatefulWidget {
  const RatingStarsBar({
    super.key,
  });

  @override
  State<RatingStarsBar> createState() => _RatingStarsBarState();
}

class _RatingStarsBarState extends State<RatingStarsBar> {
  int _userRating = 0;

  @override
  Widget build(BuildContext context) {
    const maxRate = 5;
    const iconSize = 40.0;
    _userRating = context.watch<RatingModel>().userRating;

    return OverflowBar(
      alignment: MainAxisAlignment.center,
      children: List.generate(
        maxRate,
        (index) {
          return IconButton(
            onPressed: () {
              int rating = index + 1;
              context.read<RatingModel>().setRating(rating);
            },
            icon: Icon(
              (index < _userRating)
                  ? Icons.star_sharp
                  : Icons.star_outline_sharp,
              color: AppConstants.contrast,
              size: iconSize,
            ), // if index < _userRating
          );
        },
      ),
    );
  }
}
