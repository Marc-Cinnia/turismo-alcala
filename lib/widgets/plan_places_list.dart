import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/journey_point.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/dtos/user_auth.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/cellar_model.dart';
import 'package:valdeiglesias/models/eat_model.dart';
import 'package:valdeiglesias/models/experience_model.dart';
import 'package:valdeiglesias/models/guided_tours_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/plan_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/models/schedule_model.dart';
import 'package:valdeiglesias/models/session_model.dart';
import 'package:valdeiglesias/models/shop_model.dart';
import 'package:valdeiglesias/models/sleep_model.dart';
import 'package:valdeiglesias/models/visit_model.dart';
import 'package:valdeiglesias/screens/place_detail.dart';

class PlanPlacesList extends StatefulWidget {
  const PlanPlacesList({
    super.key,
  });

  @override
  State<PlanPlacesList> createState() => _PlanPlacesListState();
}

class _PlanPlacesListState extends State<PlanPlacesList> {
  late LanguageModel _language;
  late AccessibleModel _accessible;
  late SessionModel _session;

  // Places used for PlaceDetail:
  late List<Place> _cellars;
  late List<Place> _restaurants;
  late List<Place> _experiences;
  late List<Place> _guidedTours;
  late List<Place> _places;
  late List<Place> _routes;
  late List<Place> _events;
  late List<Place> _stores;
  late List<Place> _hotels;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PlanModel>();
    final places = model.journeyPoints;

    _language = context.watch<LanguageModel>();
    _accessible = context.watch<AccessibleModel>();
    _session = context.watch<SessionModel>();

    _cellars = context.watch<CellarModel>().cellars;
    _restaurants = context.watch<EatModel>().placesToEat;
    _experiences = context.watch<ExperienceModel>().items;
    _guidedTours = context.watch<GuidedToursModel>().tours;
    _places = context.watch<VisitModel>().placesToVisit;
    _routes = context.watch<RouteModel>().routes;
    _events = context.watch<ScheduleModel>().eventSchedule;
    _stores = context.watch<ShopModel>().placesToShop;
    _hotels = context.watch<SleepModel>().placesToRest;

    final content = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120.0),
        child: Column(
          children: List.generate(
            places.length,
            (index) {
              final journeyPoint = places[index];
              String month = '';
              String hour = '';
              String minute = '';
              String dateTimeFormatted = '';

              if (journeyPoint != null) {
                month = (journeyPoint.visitDate.month <= 9)
                    ? '0${journeyPoint.visitDate.month}'
                    : '${journeyPoint.visitDate.month}';

                hour = (journeyPoint.visitDate.hour <= 9)
                    ? '0${journeyPoint.visitDate.hour}'
                    : '${journeyPoint.visitDate.hour}';

                minute = (journeyPoint.visitDate.minute <= 9)
                    ? '0${journeyPoint.visitDate.minute}'
                    : '${journeyPoint.visitDate.minute}';

                dateTimeFormatted =
                    '${journeyPoint.visitDate.day}/$month - $hour:$minute';
                journeyPoint.placeIndex = index + 1;
              }

              final placeType = (_language.english)
                  ? AppConstants.placeTypesEn[places[index]!.placeType]!
                  : AppConstants.placeTypes[places[index]!.placeType]!;

              int placeIndex =
                  (journeyPoint != null && journeyPoint.placeIndex != null)
                      ? journeyPoint.placeIndex!
                      : 0;

              return Card(
                color: AppConstants.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.cardBorderRadius),
                ),
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.cardSpacing),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(                          
                          '$placeIndex',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppConstants.contrast),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: AppConstants.cardSpacing,
                              right: AppConstants.cardSpacing,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  journeyPoint!.placeName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppConstants.primary,
                                      ),
                                ),
                                const SizedBox(
                                    height: AppConstants.shortSpacing),
                                Text(
                                  placeType,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppConstants.lessContrast),
                                ),
                                Text(
                                  dateTimeFormatted,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: OverflowBar(
                              alignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    final placeId = journeyPoint.id;
                                    final type = journeyPoint.placeType;

                                    final placeFiltered = _filter(
                                      placeId,
                                      type,
                                    );

                                    if (placeFiltered != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlaceDetail(
                                            place: placeFiltered,
                                            placeEn: placeFiltered,
                                            accessible: _accessible.enabled,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.visibility_outlined,
                                    color: AppConstants.lessContrast,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _showDatePicker(
                                    journeyPoint,
                                  ),
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: AppConstants.lessContrast,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final snackbarMsg = (_language.english)
                                        ? AppConstants.removedFromMyPlanLabel
                                        : AppConstants.removedFromMyPlanLabel;
                                    UserAuth? userAuth;

                                    if (_session.isActive) {
                                      userAuth = _session.credentials;
                                    }

                                    await context
                                        .read<PlanModel>()
                                        .removeFromPlan(
                                          journeyPoint.placeName,
                                          userAuth,
                                        );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(snackbarMsg),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline_outlined,
                                    color: AppConstants.lessContrast,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    return content;
  }

  void _showDatePicker(JourneyPoint journeyPoint) {
    final editHelpText = (_language.english)
        ? AppConstants.planEditHelpTextEn
        : AppConstants.planEditHelpText;

    showDatePicker(
      helpText: editHelpText,
      context: context,
      currentDate: journeyPoint.visitDate,
      firstDate: journeyPoint.visitDate,
      barrierDismissible: false,
      lastDate: journeyPoint.visitDate.add(
        const Duration(days: 30),
      ),
    ).then(
      (newVisitDate) {
        final dateRequiredMsg = (_language.english)
            ? AppConstants.planDateRequiredMsgEn
            : AppConstants.planDateRequiredMsg;

        final timeRequiredMsg = (_language.english)
            ? AppConstants.planTimeRequiredMsgEn
            : AppConstants.planTimeRequiredMsg;

        if (newVisitDate != null) {
          if (mounted) {
            showTimePicker(
              context: context,
              barrierDismissible: false,
              initialTime: TimeOfDay.now(),
            ).then(
              (newVisitTime) {
                if (newVisitTime != null) {
                  final dateTime = DateTime(
                    newVisitDate.year,
                    newVisitDate.month,
                    newVisitDate.day,
                    newVisitTime.hour,
                    newVisitTime.minute,
                  );
                  final newJP = JourneyPoint(
                    id: journeyPoint.id,
                    placeName: journeyPoint.placeName,
                    placeLatitude: journeyPoint.placeLatitude,
                    placeLongitude: journeyPoint.placeLongitude,
                    visitDate: dateTime,
                    placeType: journeyPoint.placeType,
                  );
                  final editResultMessage = (_language.english)
                      ? AppConstants.planEditMsgEn
                      : AppConstants.planEditMsg;

                  if (mounted) {
                    UserAuth? credentials = null;

                    if (_session.isActive) {
                      credentials = _session.credentials;
                    }

                    context.read<PlanModel>().updateJourneyPoint(
                          journeyPoint,
                          newJP,
                          credentials,
                        );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(editResultMessage),
                      ),
                    );
                  }
                } else {
                  _showErrorMessage(
                    timeRequiredMsg,
                  );
                }
              },
            );
          }
        } else {
          _showErrorMessage(
            dateRequiredMsg,
          );
        }
      },
    );
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
        ),
      );
    }
  }

  Place? _filter(int placeId, String placeType) {
    Place? placeFiltered;

    switch (placeType) {
      case AppConstants.placeApiType:
        placeFiltered = _filterPlace(placeId);
        break;

      case AppConstants.experienceApiType:
        placeFiltered = _filterExperience(placeId);
        break;

      case AppConstants.eventApiType:
        placeFiltered = _filterEvent(placeId);
        break;

      case AppConstants.routeApiType:
        placeFiltered = _filterRoute(placeId);
        break;

      case AppConstants.eatApiType:
        placeFiltered = _filterRestaurant(placeId);
        break;

      case AppConstants.sleepApiType:
        placeFiltered = _filterHotel(placeId);
        break;

      case AppConstants.shopApiType:
        placeFiltered = _filterShop(placeId);
        break;

      case AppConstants.cellarApiType:
        placeFiltered = _filterCellar(placeId);
        break;

      case AppConstants.tourApiType:
        placeFiltered = _filterTour(placeId);
        break;
    }

    return placeFiltered;
  }

  Place? _filterPlace(int id) {
    if (_places.isNotEmpty) {
      return _places.firstWhere(
        (place) {
          if (place.placeId != null) {
            return place.placeId! == id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterExperience(int id) {
    if (_experiences.isNotEmpty) {
      return _experiences.firstWhere(
        (place) {
          if (place.placeId != null) {
            return place.placeId! == id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterEvent(int id) {
    if (_events.isNotEmpty) {
      return _events.firstWhere(
        (event) {
          if (event.placeId != null) {
            return event.placeId! == id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterRoute(int id) {
    if (_routes.isNotEmpty) {
      return _routes.firstWhere(
        (route) {
          if (route.placeId != null) {
            return route.placeId! == id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterRestaurant(int id) {
    if (_restaurants.isNotEmpty) {
      return _restaurants.firstWhere(
        (restaurant) {
          if (restaurant.placeId != null) {
            return restaurant.placeId! == id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterHotel(int id) {
    if (_hotels.isNotEmpty) {
      return _hotels.firstWhere(
        (hotel) {
          if (hotel.placeId != null) {
            return hotel.placeId! == id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterShop(int id) {
    if (_stores.isNotEmpty) {
      return _stores.firstWhere(
        (store) {
          if (store.placeId != null) {
            return store.placeId! == id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterCellar(int id) {
    if (_cellars.isNotEmpty) {
      return _cellars.firstWhere(
        (cellar) {
          if (cellar.placeId != null) {
            return cellar.placeId! == id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterTour(int id) {
    if (_guidedTours.isNotEmpty) {
      return _guidedTours.firstWhere(
        (tour) {
          if (tour.placeId != null) {
            return tour.placeId! == id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }
}
