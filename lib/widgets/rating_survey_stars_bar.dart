import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/survey_model.dart';

class RatingSurveyStarsBar extends StatefulWidget {
  RatingSurveyStarsBar({
    super.key,
    required this.aspectKey,
  });

  final String aspectKey;

  @override
  State<RatingSurveyStarsBar> createState() => _RatingSurveyStarsBarState();
}

class _RatingSurveyStarsBarState extends State<RatingSurveyStarsBar> {
  int _userRating = 0;

  late bool _surveyCleared;

  @override
  void initState() {
    _surveyCleared = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _surveyCleared = Provider.of<SurveyModel>(context).surveyCleared;

    if (_surveyCleared) {
      WidgetsBinding.instance.addPostFrameCallback((_) => clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    const maxRate = 5;
    const iconSize = 22.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        maxRate,
        (index) {
          return GestureDetector(
            onTap: () => setState(
              () {
                int rating = index + 1;
                _userRating = rating;
                context
                    .read<SurveyModel>()
                    .evaluateAspect(widget.aspectKey, rating);
              },
            ),
            child: Icon(
              (index < _userRating)
                  ? Icons.star_sharp
                  : Icons.star_outline_sharp,
              color: AppConstants.contrast,
              size: iconSize,
              // if index < _userRating
            ),
          );
        },
      ),
    );
  }

  void clear() {
    setState(() {
      _userRating = 0;
    });
  }
}
