import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/survey_value.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/survey_model.dart';

class ValueSelector extends StatefulWidget {
  const ValueSelector({
    super.key,
    required this.values,
    required this.valueKey,
    required this.controller,
    required this.enabled,
  });

  final List<String> values;
  final String valueKey;
  final TextEditingController controller;
  final bool enabled;

  @override
  State<ValueSelector> createState() => _ValueSelectorState();
}

class _ValueSelectorState extends State<ValueSelector> {
  final fontWeight = FontWeight.w300;

  late List<DropdownMenuEntry> entries;
  late TextStyle labelStyle;
  late LanguageModel language;
  late SurveyModel surveyModel;
  late String surveyNoValue;
  late String surveyYesValue;

  @override
  void initState() {
    labelStyle = TextStyle(
      color: AppConstants.primary,
      fontWeight: fontWeight,
      fontSize: AppConstants.selectorFontSize,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    language = context.watch<LanguageModel>();
    surveyModel = context.watch<SurveyModel>();

    surveyNoValue = (language.english)
        ? AppConstants.surveyYesNoValuesEn[1]
        : AppConstants.surveyYesNoValues[1];
    surveyYesValue = (language.english)
        ? AppConstants.surveyYesNoValuesEn[0]
        : AppConstants.surveyYesNoValues[0];

    entries = List.generate(
      widget.values.length,
      (index) {
        final valueDescription = widget.values[index];

        return DropdownMenuEntry<SurveyValue>(
          value: SurveyValue(
            key: widget.valueKey,
            valueIndex: index,
            valueDescription: valueDescription,
          ),
          label: valueDescription,
          labelWidget: SizedBox(
            width: 100.0,
            child: Text(
              valueDescription,
              textAlign: TextAlign.start,
              style: labelStyle,
            ),
          ),
        );
      },
    );

    final hintText = (language.english)
        ? AppConstants.surveySelectHintEn
        : AppConstants.surveySelectHint;

    return Expanded(
      flex: 2,
      child: DropdownMenu(
        width: double.infinity,
        enabled: widget.enabled,
        controller: widget.controller,
        dropdownMenuEntries: entries,
        hintText: hintText,
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          labelStyle: const TextStyle(
            color: AppConstants.primary,
          ),
        ),
        textStyle: TextStyle(
          color: AppConstants.primary,
          fontWeight: fontWeight,
        ),
        trailingIcon: Icon(
          Icons.arrow_drop_down_outlined,
          color: AppConstants.primary,
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return Color.from(
                  alpha: 0.5,
                  red: AppConstants.primary.r,
                  green: AppConstants.primary.g,
                  blue: AppConstants.primary.b,
                );
              }
              return Colors.white;
            },
          ),
        ),
        onSelected: (selection) => _handleSurveySelection(selection),
      ),
    );
  }

  void _handleSurveySelection(SurveyValue selection) {
    switch (selection.key) {
      case AppConstants.surveyAgeKey:
        _handleAge(selection);
        break;

      case AppConstants.surveyGenderKey:
        _handleGenderSelection(selection);
        break;

      case AppConstants.surveyResidentKey:
        _handleResidentSelection(selection);
        break;

      case AppConstants.surveyCountryKey:
        _handleCountrySelection(selection);
        break;

      case AppConstants.surveyAutCommunityKey:
        _handleCommunitySelection(selection);
        break;

      case AppConstants.surveyTravelWithKey:
        _handleTravelWithSelection(selection);
        break;

      case AppConstants.surveyArrivalTransportKey:
        _handleArrivalTransportSelection(selection);
        break;

      case AppConstants.surveyPlannedStayKey:
        _handlePlannedStaySelection(selection);
        break;

      case AppConstants.surveyVisitReasonKey:
        _handleVisitReasonSelection(selection);
        break;

      case AppConstants.surveyKnowPlacesVisitKey:
        _handleKnowPlacesVisitSelection(selection);
        break;

      case AppConstants.surveyAccommodationInSMVKey:
        _handleStaySMVSelection(selection);
        break;

      case AppConstants.surveyAccommodationTypeKey:
        _handleAccommodationTypeSelection(selection);
        break;

      case AppConstants.surveyFirstVisitKey:
        _handleFirstVisitSelection(selection);
        break;

      case AppConstants.surveyHowKnownKey:
        _handleHowKnownSelection(selection);
        break;

      case AppConstants.surveyRecommendKey:
        _handleRecommendSelection(selection);
        break;
    }
  }

  void _handleAge(SurveyValue selection) {
    int index;

    if (language.english) {
      index = AppConstants.surveyAgeValuesEn.indexOf(
        selection.valueDescription,
      );
    } else {
      index = AppConstants.surveyAgeValues.indexOf(
        selection.valueDescription,
      );
    }

    context.read<SurveyModel>().userAgeRange =
        AppConstants.surveyAgeValues[index];
  }

  void _handleGenderSelection(SurveyValue selection) {
    int index;

    if (language.english) {
      index = AppConstants.surveyGenderValuesEn.indexOf(
        selection.valueDescription,
      );
    } else {
      index = AppConstants.surveyGenderValues.indexOf(
        selection.valueDescription,
      );
    }
    context.read<SurveyModel>().userGender =
        AppConstants.surveyGenderValues[index];
  }

  void _handleResidentSelection(SurveyValue selection) {
    final resident = selection.valueDescription == surveyYesValue;
    final showCountries = selection.valueDescription == surveyNoValue;

    if (showCountries) {
      context.read<SurveyModel>().showCountries = showCountries;
    } else {
      context.read<SurveyModel>().userCountry = AppConstants.spain;
      context.read<SurveyModel>().userAutonomousCommunity = AppConstants.madrid;
      context.read<SurveyModel>().showResidentData = true;
    }

    context.read<SurveyModel>().setUserResident(resident);
    context.read<SurveyModel>().residentEnabled = false;
  }

  void _handleCountrySelection(SurveyValue selection) {
    int index;

    if (language.english) {
      index = AppConstants.surveyCountriesEn.indexOf(
        selection.valueDescription,
      );
    } else {
      index = AppConstants.surveyCountries.indexOf(
        selection.valueDescription,
      );
    }

    final showAutonomousCommunities =
        selection.valueDescription == AppConstants.spain;

    context.read<SurveyModel>().userCountry =
        AppConstants.surveyCountries[index];

    if (showAutonomousCommunities) {
      context.read<SurveyModel>().showAutonomousCommunities =
          showAutonomousCommunities;
    } else {
      context.read<SurveyModel>().showArrivalTransport = true;
      context.read<SurveyModel>().showTravelWith = true;
    }

    context.read<SurveyModel>().countryEnabled = false;
  }

  void _handleTravelWithSelection(SurveyValue selection) {
    int index;

    if (language.english) {
      index = AppConstants.surveyTravelWithValuesEn
          .indexOf(selection.valueDescription);
    } else {
      index = AppConstants.surveyTravelWithValues
          .indexOf(selection.valueDescription);
    }
    context.read<SurveyModel>().userTravelWith =
        AppConstants.surveyTravelWithValues[index];
  }

  void _handlePlannedStaySelection(SurveyValue selection) {
    int index;

    if (language.english) {
      index = AppConstants.surveyPlannedStayValuesEn
          .indexOf(selection.valueDescription);
    } else {
      index = AppConstants.surveyPlannedStayValues
          .indexOf(selection.valueDescription);
    }
    context.read<SurveyModel>().userPlannedStay =
        AppConstants.surveyPlannedStayValues[index];
  }

  void _handleVisitReasonSelection(SurveyValue selection) {
    int index;

    if (language.english) {
      index = AppConstants.surveyVisitReasonValuesEn
          .indexOf(selection.valueDescription);
    } else {
      index = AppConstants.surveyVisitReasonValues
          .indexOf(selection.valueDescription);
    }

    context.read<SurveyModel>().userVisitReason =
        AppConstants.surveyVisitReasonValues[index];
  }

  void _handleArrivalTransportSelection(SurveyValue selection) {
    int index;

    if (language.english) {
      index = AppConstants.surveyArrivalTransportValuesEn
          .indexOf(selection.valueDescription);
    } else {
      index = AppConstants.surveyArrivalTransportValues
          .indexOf(selection.valueDescription);
    }

    context.read<SurveyModel>().userArrivalTransport =
        AppConstants.surveyArrivalTransportValues[index];

    context.read<SurveyModel>().showPlannedStay = true;
    context.read<SurveyModel>().showVisitReason = true;
    context.read<SurveyModel>().showVisitFeatures = true;
    context.read<SurveyModel>().transportEnabled = false;
  }

  void _handleCommunitySelection(SurveyValue selection) {
    context.read<SurveyModel>().userAutonomousCommunity =
        selection.valueDescription;
    context.read<SurveyModel>().showArrivalTransport = true;
    context.read<SurveyModel>().showTravelWith = true;
    context.read<SurveyModel>().communitiesEnabled = false;
  }

  void _handleKnowPlacesVisitSelection(SurveyValue selection) {
    bool knowPlacesVisit = selection.valueDescription == surveyYesValue;
    context.read<SurveyModel>().setUserKnowPlacesVisit(knowPlacesVisit);
  }

  void _handleStaySMVSelection(SurveyValue selection) {
    bool showAccommodationField;

    if (language.english) {
      showAccommodationField =
          selection.valueDescription == AppConstants.yesConfirmLabelEn;
    } else {
      showAccommodationField =
          selection.valueDescription == AppConstants.yesConfirmLabel;
    }

    bool userStayInSMV = selection.valueDescription == surveyYesValue;

    context.read<SurveyModel>().setUserStaySMV(userStayInSMV);
    context.read<SurveyModel>().showAccomodationType = showAccommodationField;
    context.read<SurveyModel>().stayInSMVEnabled = false;
  }

  void _handleAccommodationTypeSelection(SurveyValue selection) {
    int index;

    if (language.english) {
      index = AppConstants.surveyAcommodationTypeValuesEn.indexOf(
        selection.valueDescription,
      );
    } else {
      index = AppConstants.surveyAcommodationTypeValues.indexOf(
        selection.valueDescription,
      );
    }

    context.read<SurveyModel>().userAccommodationType =
        AppConstants.surveyAcommodationTypeValues[index];
  }

  void _handleFirstVisitSelection(SurveyValue selection) {
    bool showHowKnownField;

    if (language.english) {
      showHowKnownField =
          selection.valueDescription == AppConstants.yesConfirmLabelEn;
    } else {
      showHowKnownField =
          selection.valueDescription == AppConstants.yesConfirmLabel;
    }

    bool isUserFirstVisit = selection.valueDescription == surveyYesValue;

    context.read<SurveyModel>().setUserFirstVisit(isUserFirstVisit);
    context.read<SurveyModel>().showHowKnown = showHowKnownField;
    context.read<SurveyModel>().firstVisitEnabled = false;
  }

  void _handleHowKnownSelection(SurveyValue selection) {
    int index;

    if (language.english) {
      index = AppConstants.surveyDiscoveryMethodValuesEn
          .indexOf(selection.valueDescription);
    } else {
      index = AppConstants.surveyDiscoveryMethodValues
          .indexOf(selection.valueDescription);
    }

    context.read<SurveyModel>().userHowKnown =
        AppConstants.surveyDiscoveryMethodValues[index];
  }

  void _handleRecommendSelection(SurveyValue selection) {
    bool userIsResident = surveyModel.showResidentData;

    if (userIsResident) {
      context.read<SurveyModel>().showSubmitBtn = true;
    }

    bool userRecommend = selection.valueDescription == surveyYesValue;

    context.read<SurveyModel>().setUserRecommend(userRecommend);
    context.read<SurveyModel>().showRatingSection = true;
    context.read<SurveyModel>().showSubmitBtn = true;
  }
}
