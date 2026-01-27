//Funcionalidad de estrella para añadir al plan deshabilitada

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/event.dart';
import 'package:valdeiglesias/dtos/journey_point.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/user_auth.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/plan_model.dart';
import 'package:valdeiglesias/models/session_model.dart';

class WishlistButton extends StatefulWidget {
  const WishlistButton({
    super.key,
    required this.place,
    required this.isTextButton,
  });

  final Place place;
  final bool isTextButton;

  @override
  State<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton> {
  late bool _placeAdded;
  late IconData _icon;
  late PlanModel _model;
  late LanguageModel _language;
  late SessionModel _session;
  late DateTime _first;
  late DateTime _last;

  List<JourneyPoint?> _journeyPoints = [];

  @override
  void initState() {
    super.initState();
    _first = DateTime.now();
    _last = DateTime.now().add(Duration(days: 7300));
  }

  @override
  Widget build(BuildContext context) {
    _model = context.watch<PlanModel>();
    _language = context.watch<LanguageModel>();
    _placeAdded = context.watch<PlanModel>().placeAdded(widget.place.placeName);
    _icon = (_placeAdded) ? Icons.star_sharp : Icons.star_outline_sharp;
    _session = context.watch<SessionModel>();

    _journeyPoints = context.watch<PlanModel>().journeyPoints;

    String buttonLabel = (_placeAdded)
        ? AppConstants.addedToMyPlanLabel
        : AppConstants.addToMyPlanLabel;

    if (_language.english) {
      buttonLabel = (_placeAdded)
          ? AppConstants.addedToMyPlanLabelEn
          : AppConstants.addToMyPlanLabelEn;
    }

    if (widget.isTextButton) {
      return Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton.icon(
          onPressed: () async {
            await _toggleFavoritePlace();
          },
          icon: Icon(
            _icon,
            color: AppConstants.contrast,
          ),
          label: Text(
            buttonLabel,
            style: GoogleFonts.dmSans().copyWith(
              color: AppConstants.contrast,
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () async {
          await _toggleFavoritePlace();
        },
        child: Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            width: 30.0,
            child: Icon(
              _icon,
              color: AppConstants.contrast,
            ),
          ),
        ),
      );
    }
  }

  Future<void> _toggleFavoritePlace() async {
    final dateHelperText = (_language.english)
        ? AppConstants.selectPlanDateLabelEn
        : AppConstants.selectPlanDateLabel;
    final timeHelperText = (_language.english)
        ? AppConstants.selectPlanTimeLabelEn
        : AppConstants.selectPlanTimeLabel;
    JourneyPoint? journeyPointFiltered;
    bool isNewPlace = false;

    if (_journeyPoints.isNotEmpty) {
      try {
        journeyPointFiltered = _journeyPoints.firstWhere(
          (point) {
            bool namesMatch = point?.placeName == widget.place.placeName;
            return namesMatch;
          },
          orElse: null,
        );
      } catch (e) {
        journeyPointFiltered = null;
        isNewPlace = true;
      }
    } else {
      isNewPlace = true;
    }

    if (isNewPlace) {
      TimeOfDay? lastTime;
      DateTime? lastDate;

      if (_journeyPoints.isNotEmpty) {
        lastTime = TimeOfDay.fromDateTime(_journeyPoints.last!.visitDate);
        lastDate = _journeyPoints.last!.visitDate;
      } else {
        lastTime = TimeOfDay.now();
        lastDate = DateTime.now();
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  dateHelperText,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeHelperText,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppConstants.spacing),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: lastDate!,
                                firstDate: _first,
                                lastDate: _last,
                              );

                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: lastTime!,
                                );

                                if (time != null) {
                                  final visitDate = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    time.hour,
                                    time.minute,
                                  );

                                  await _addToPlan(visitDate);
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: Text(
                              (_language.english)
                                  ? AppConstants.selectPlanDateLabelEn
                                  : AppConstants.selectPlanDateLabel,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      (_language.english)
                          ? AppConstants.cancelEn
                          : AppConstants.cancel,
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      await _requestDeleteConfirmation();
    }
  }

  Future<void> _addToPlan(DateTime? visitDate) async {
    if (visitDate != null && widget.place.placeType != null) {
      if (mounted) {
        final journeyPoint = JourneyPoint(
          id: widget.place.placeId!,
          placeLatitude: widget.place.latitude!,
          placeLongitude: widget.place.longitude!,
          visitDate: visitDate,
          placeName: widget.place.placeName,
          placeType: widget.place.placeType!,
        );

        await context.read<PlanModel>().addToPlan(
              journeyPoint,
              _session.credentials,
            );
        _placeAdded = context.read<PlanModel>().placeAdded(
              journeyPoint.placeName,
            );

        if (mounted && _placeAdded) {
          setState(() {
            final planStatusMsg = (_language.english)
                ? AppConstants.placeAddedMsgEn
                : AppConstants.placeAddedMsg;
            _icon = Icons.star_sharp;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(planStatusMsg),
                duration: Duration(seconds: 2),
              ),
            );
          });
        }
      }
    }
  }

  Future<void> _requestDeleteConfirmation() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final title = (_language.english)
            ? AppConstants.planRemoveTitleEn
            : AppConstants.planRemoveTitle;

        final confirmationMsg = (_language.english)
            ? AppConstants.planRemoveConfirmationEn
            : AppConstants.planRemoveConfirmation;

        return AlertDialog(
          title: Text(title),
          content: Text(
            confirmationMsg,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'No',
                textAlign: TextAlign.end,
              ),
            ),
            TextButton(
              onPressed: () async {
                UserAuth? userAuth;

                if (_session.isActive) {
                  userAuth = _session.credentials;
                }
                await _model.removeFromPlan(widget.place.placeName, userAuth);

                final currentPlaceAdded = _model.placeAdded(
                  widget.place.placeName,
                );

                setState(
                  () {
                    if (!currentPlaceAdded) {
                      _icon = Icons.star_outline_sharp;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Has eliminado "${widget.place.placeName}" de tu plan'),
                        ),
                      );
                    }

                    Navigator.pop(context);
                  },
                );
              },
              child: const Text(
                'Si',
                textAlign: TextAlign.end,
              ),
            ),
          ],
        );
      },
    );
  }
}
