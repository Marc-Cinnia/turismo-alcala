import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/variable_survey.dart';

class SurveyModel extends ChangeNotifier {
  SurveyModel() {
    _setSurveys();
  }

  bool _showSurvey = false;
  bool _showCountries = false;
  bool _showAutonomousCommunities = false;
  bool _showResidentData = false;
  bool _showArrivalTransport = false;
  bool _showTravelWith = false;
  bool _showVisitFeatures = false;
  bool _showPlannedStay = false;
  bool _showVisitReason = false;
  bool _showAccomodationType = false;
  bool _showHowKnown = false;
  bool _showRatingSection = false;
  bool _showSubmitBtn = false;
  bool _variableSurveyFetched = false;
  bool _showFixedSurvey = false;
  bool _surveyAnswered = false;
  bool _surveyCleared = false;
  bool _ageEnabled = true;
  bool _genderEnabled = true;
  bool _residentEnabled = true;
  bool _countryEnabled = true;
  bool _communitiesEnabled = true;
  bool _travelWithEnabled = true;
  bool _transportEnabled = true;
  bool _plannedStayEnabled = true;
  bool _visitReasonEnabled = true;
  bool _knowPlacesEnabled = true;
  bool _stayInSMVEnabled = true;
  bool _accommodationEnabled = true;
  bool _howKnownEnabled = true;
  bool _firstVisitEnabled = true;
  bool _recommendEnabled = true;

  int _userResident = 0;
  int _userRecommend = 0;

  int? _userKnowPlacesVisit;
  int? _userStaySMV;
  int? _userFirstVisit;

  String _userAgeRange = '';
  String _userGender = '';
  String _userCountry = '';

  String? _userAutonomousCommunity;
  String? _userTravelWith;
  String? _userArrivalTransport;
  String? _userPlannedStay;
  String? _userAccommodationType;
  String? _userHowKnown;
  String? _userVisitReason;

  // Rating Fields
  int? _tourismOffer;
  int? _tourismInformation;
  int? _cleanlinessMaintenance;
  int? _commerceService;
  int? _transportAccessibility;
  int? _safety;
  int? _touristSignage;

  VariableSurvey? _variableSurvey;

  int get userResident => _userResident;
  int get userRecommend => _userRecommend;

  int? get userKnowPlacesVisit => _userKnowPlacesVisit;
  int? get userStaySMV => _userStaySMV;
  int? get userFirstVisit => _userFirstVisit;

  String get userAgeRange => _userAgeRange;
  String get userGender => _userGender;
  String get userCountry => _userCountry;
  String? get userAutonomousCommunity => _userAutonomousCommunity;
  String? get userArrivalTransport => _userArrivalTransport;
  String? get userPlannedStay => _userPlannedStay;
  String? get userTravelWith => _userTravelWith;
  String? get userVisitReason => _userVisitReason;
  String? get userAccommodationType => _userAccommodationType;
  String? get userHowKnown => _userHowKnown;

  bool get showSurvey => _showSurvey;
  bool get showCountries => _showCountries;
  bool get showAutonomousCommunities => _showAutonomousCommunities;
  bool get showResidentData => _showResidentData;
  bool get showArrivalTransport => _showArrivalTransport;
  bool get showTravelWith => _showTravelWith;
  bool get showVisitFeatures => _showVisitFeatures;
  bool get showPlannedStay => _showPlannedStay;
  bool get showVisitReason => _showVisitReason;
  bool get showAccomodationType => _showAccomodationType;
  bool get showHowKnown => _showHowKnown;
  bool get showRatingSection => _showRatingSection;
  bool get showSubmitBtn => _showSubmitBtn;
  bool get variableSurveyFetched => _variableSurveyFetched;
  bool get showFixedSurvey => _showFixedSurvey;
  bool get surveyAnswered => _surveyAnswered;
  bool get surveyCleared => _surveyCleared;
  bool get ageEnabled => _ageEnabled;
  bool get genderEnabled => _genderEnabled;
  bool get residentEnabled => _residentEnabled;
  bool get countryEnabled => _countryEnabled;
  bool get communitiesEnabled => _communitiesEnabled;
  bool get travelWithEnabled => _travelWithEnabled;
  bool get transportEnabled => _transportEnabled;
  bool get plannedStayEnabled => _plannedStayEnabled;
  bool get visitReasonEnabled => _visitReasonEnabled;
  bool get knowPlacesEnabled => _knowPlacesEnabled;
  bool get stayInSMVEnabled => _stayInSMVEnabled;
  bool get accommodationEnabled => _accommodationEnabled;
  bool get howKnownEnabled => _howKnownEnabled;
  bool get firstVisitEnabled => _firstVisitEnabled;
  bool get recommendEnabled => _recommendEnabled;

  void set ageEnabled(bool enabled) {
    _ageEnabled = enabled;
  }

  void set genderEnabled(bool enabled) {
    _genderEnabled = enabled;
  }

  void set residentEnabled(bool enabled) {
    _residentEnabled = enabled;
    notifyListeners();
  }

  void set countryEnabled(bool enabled) {
    _countryEnabled = enabled;
    notifyListeners();
  }

  void set communitiesEnabled(bool enabled) {
    _communitiesEnabled = enabled;
    notifyListeners();
  }

  void set travelWithEnabled(bool enabled) {
    _travelWithEnabled = enabled;
    notifyListeners();
  }

  void set transportEnabled(bool enabled) {
    _transportEnabled = enabled;
    notifyListeners();
  }

  void set plannedStayEnabled(bool enabled) {
    _plannedStayEnabled = enabled;
    notifyListeners();
  }

  void set visitReasonEnabled(bool enabled) {
    _visitReasonEnabled = enabled;
    notifyListeners();
  }

  void set knowPlacesEnabled(bool enabled) {
    _knowPlacesEnabled = enabled;
    notifyListeners();
  }

  void set stayInSMVEnabled(bool enabled) {
    _stayInSMVEnabled = enabled;
    notifyListeners();
  }

  void set accommodationEnabled(bool enabled) {
    _accommodationEnabled = enabled;
    notifyListeners();
  }

  void set howKnownEnabled(bool enabled) {
    _howKnownEnabled = enabled;
    notifyListeners();
  }

  void set firstVisitEnabled(bool enabled) {
    _firstVisitEnabled = enabled;
    notifyListeners();
  }

  void set recommendEnabled(bool enabled) {
    _recommendEnabled = enabled;
    notifyListeners();
  }

  VariableSurvey? get variableSurvey => _variableSurvey;

  bool ratingFieldsFilled() {
    return _tourismOffer != null &&
        _tourismInformation != null &&
        _cleanlinessMaintenance != null &&
        _commerceService != null &&
        _transportAccessibility != null &&
        _safety != null &&
        _touristSignage != null;
  }

  void set surveyCleared(bool cleared) {
    _surveyCleared = cleared;
    notifyListeners();
  }

  void set showSurvey(bool mustShowSurvey) {
    _showSurvey = mustShowSurvey;
    notifyListeners();
  }

  void set showCountries(bool mustShowCountries) {
    if (mustShowCountries != _showCountries) {
      _showCountries = mustShowCountries;
      notifyListeners();
    }
  }

  void set showAutonomousCommunities(bool showAutonomousCommunities) {
    if (showAutonomousCommunities != _showAutonomousCommunities) {
      _showAutonomousCommunities = showAutonomousCommunities;
      notifyListeners();
    }
  }

  void set showArrivalTransport(bool showArrivalTransport) {
    if (showArrivalTransport != _showArrivalTransport) {
      _showArrivalTransport = showArrivalTransport;
      notifyListeners();
    }
  }

  void set showPlannedStay(bool showPlannedStay) {
    if (_showPlannedStay != showPlannedStay) {
      _showPlannedStay = showPlannedStay;
      notifyListeners();
    }
  }

  void set showVisitReason(bool showVisitReason) {
    if (_showVisitReason != showVisitReason) {
      _showVisitReason = showVisitReason;
      notifyListeners();
    }
  }

  void set showTravelWith(bool showTravelWith) {
    if (showTravelWith != _showTravelWith) {
      _showTravelWith = showTravelWith;
      notifyListeners();
    }
  }

  void set showVisitFeatures(bool showVisitFeatures) {
    if (_showVisitFeatures != showVisitFeatures) {
      _showVisitFeatures = showVisitFeatures;
      notifyListeners();
    }
  }

  void set showResidentData(bool showResidentData) {
    _showResidentData = showResidentData;
    notifyListeners();
  }

  void set showAccomodationType(bool showAccomodationType) {
    _showAccomodationType = showAccomodationType;
    notifyListeners();
  }

  void set showHowKnown(bool howKnown) {
    _showHowKnown = howKnown;
    notifyListeners();
  }

  void set showRatingSection(bool showRatingSection) {
    _showRatingSection = showRatingSection;
    notifyListeners();
  }

  void set showSubmitBtn(bool showSubmitBtn) {
    if (_showSubmitBtn != showSubmitBtn) {
      _showSubmitBtn = showSubmitBtn;
      notifyListeners();
    }
  }

  void set userAgeRange(String ageRange) {
    _userAgeRange = ageRange;
    notifyListeners();
  }

  void set userGender(String gender) {
    _userGender = gender;
    notifyListeners();
  }

  void set userCountry(String country) {
    _userCountry = country;
  }

  void set userTravelWith(String? travelWith) {
    _userTravelWith = travelWith;
    notifyListeners();
  }

  void set userArrivalTransport(String? arrivalTransport) {
    _userArrivalTransport = arrivalTransport;
  }

  void set userAutonomousCommunity(String? autonomousCommunity) {
    if (autonomousCommunity != null) {
      _userAutonomousCommunity = autonomousCommunity;
    }
  }

  Future<void> setSurveyAnswered(bool answered) async {
    if (_surveyAnswered != answered) {
      final prefs = SharedPreferencesAsync();
      await prefs.setBool(AppConstants.surveyAnsweredKey, answered);
      _surveyAnswered = answered;
      notifyListeners();
    }
  }

  void setUserResident(bool resident) {
    _userResident = (resident) ? 1 : 0;
  }

  void set userPlannedStay(String? plannedStay) {
    _userPlannedStay = plannedStay;
    notifyListeners();
  }

  void setUserKnowPlacesVisit(bool? knowPlacesVisit) {
    if (knowPlacesVisit != null) {
      _userKnowPlacesVisit = (knowPlacesVisit) ? 1 : 0;
      notifyListeners();
    }
  }

  void set userVisitReason(String? visitReason) {
    _userVisitReason = visitReason;
    notifyListeners();
  }

  void setUserRecommend(bool recommend) {
    _userRecommend = (recommend) ? 1 : 0;
    notifyListeners();
  }

  void setUserStaySMV(bool stayInSMV) {
    _userStaySMV = (stayInSMV) ? 1 : 0;
  }

  void set userAccommodationType(String? accommodationType) {
    _userAccommodationType = accommodationType;
    notifyListeners();
  }

  void setUserFirstVisit(bool firstVisit) {
    _userFirstVisit = (firstVisit) ? 1 : 0;
    notifyListeners();
  }

  void set userHowKnown(String? howKnown) {
    _userHowKnown = howKnown;
    notifyListeners();
  }

  void evaluateAspect(String aspectKey, int rating) {
    switch (aspectKey) {
      case AppConstants.surveyTourismOfferKey:
        _tourismOffer = rating;
        break;

      case AppConstants.surveyTourismInformationKey:
        _tourismInformation = rating;
        break;

      case AppConstants.surveyCleanlinessMaintenanceKey:
        _cleanlinessMaintenance = rating;
        break;

      case AppConstants.surveyCommerceServiceKey:
        _commerceService = rating;
        break;

      case AppConstants.surveyTransportAccessibilityKey:
        _transportAccessibility = rating;
        break;

      case AppConstants.surveySafetyKey:
        _safety = rating;
        break;

      case AppConstants.surveyTouristSignageKey:
        _touristSignage = rating;
        break;
    }
  }

  Future<Map<String, String>?> submitSurvey() async {
    Map<String, String>? result;

    Map<String, dynamic> request = {
      AppConstants.surveyAgeKey: _userAgeRange,
      AppConstants.surveyGenderKey: _userGender,
      AppConstants.surveyResidentKey: _userResident,
      AppConstants.surveyCountryKey: _userCountry,
      AppConstants.surveyAutCommunityKey: _userAutonomousCommunity,
      AppConstants.surveyTravelWithKey: _userTravelWith,
      AppConstants.surveyArrivalTransportKey: _userArrivalTransport,
      AppConstants.surveyPlannedStayKey: _userPlannedStay,
      AppConstants.surveyVisitReasonKey: _userVisitReason,
      AppConstants.surveyKnowPlacesVisitKey: _userKnowPlacesVisit,
      AppConstants.surveyAccommodationInSMVKey: _userStaySMV,
      AppConstants.surveyAccommodationTypeKey: _userAccommodationType,
      AppConstants.surveyFirstVisitKey: _userFirstVisit,
      AppConstants.surveyHowKnownKey: _userHowKnown,
      AppConstants.surveyRecommendKey: _userRecommend,
      AppConstants.surveyTourismOfferKey: _tourismOffer,
      AppConstants.surveyTourismInformationKey: _tourismInformation,
      AppConstants.surveyCleanlinessMaintenanceKey: _cleanlinessMaintenance,
      AppConstants.surveyCommerceServiceKey: _commerceService,
      AppConstants.surveyTransportAccessibilityKey: _transportAccessibility,
      AppConstants.surveySafetyKey: _safety,
      AppConstants.surveyTouristSignageKey: _touristSignage,
      AppConstants.surveyCreatedAtKey:
          DateFormat(AppConstants.dateFormat).format(
        DateTime.now(),
      ),
    };

    final jsonRequest = jsonEncode(request);
    print('📤 [SURVEY] Enviando encuesta a: ${AppConstants.surveyUrl}');
    print('📤 [SURVEY] Datos: $jsonRequest');
    
    try {
      final response = await http.post(
        Uri.parse(AppConstants.surveyUrl),
        headers: AppConstants.requestHeaders,
        body: jsonRequest,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          print('⏱️ [SURVEY] Timeout al enviar la encuesta');
          throw Exception('Timeout: La petición tardó demasiado tiempo');
        },
      );

      print('📥 [SURVEY] Respuesta del servidor: ${response.statusCode}');
      print('📥 [SURVEY] Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == AppConstants.created) {
        result = {
          AppConstants.surveyResultKey: AppConstants.surveySubmitted,
          AppConstants.surveyResultEnKey: AppConstants.surveySubmittedEn,
        };
        setSurveyAnswered(true);
        print('✅ [SURVEY] Encuesta enviada con éxito');
      } else {
        print('❌ [SURVEY] Error: Status code ${response.statusCode}');
        print('❌ [SURVEY] Respuesta: ${response.body}');
      }
    } catch (e) {
      print('❌ [SURVEY] Excepción al enviar: $e');
      // Re-lanzar la excepción para que pueda ser manejada en la UI
      rethrow;
    }

    return result;
  }

  void _setSurveys() async {
    final response = await http.get(Uri.parse(AppConstants.variableSurveyUrl));
    final asyncPrefs = SharedPreferencesAsync();

    if (response.statusCode == AppConstants.success) {
      final responseBody = jsonDecode(response.body);
      final Map<String, dynamic>? data = responseBody[AppConstants.dataKey];

      bool? surveyAlreadyAnswered =
          await asyncPrefs.getBool(AppConstants.surveyAnsweredKey);

      if (surveyAlreadyAnswered != null) {
        _surveyAnswered = surveyAlreadyAnswered;
      }

      if (_surveyAnswered) {
        _showFixedSurvey = false;
      } else {
        _showFixedSurvey = true;
      }

      if (data != null && data.isNotEmpty) {
        final String name = data[AppConstants.nameEs];
        final String nameEn = data[AppConstants.nameEn];
        final String link = data[AppConstants.linkEs];
        final String linkEn = data[AppConstants.linkEn];

        _variableSurvey = VariableSurvey(
          name: name,
          nameEn: nameEn,
          link: link,
          linkEn: linkEn,
        );
        _variableSurveyFetched = true;
      }

      notifyListeners();
    }
  }

  void restart() {
    _showCountries = false;
    _showAutonomousCommunities = false;
    _showResidentData = false;
    _showArrivalTransport = false;
    _showTravelWith = false;
    _showVisitFeatures = false;
    _showPlannedStay = false;
    _showVisitReason = false;
    _showAccomodationType = false;
    _showHowKnown = false;
    _showRatingSection = false;
    _showSubmitBtn = false;

    _userResident = 0;
    _userRecommend = 0;
    _userKnowPlacesVisit = null;
    _userStaySMV = null;
    _userFirstVisit = null;

    _userAgeRange = '';
    _userGender = '';
    _userCountry = '';

    _userAutonomousCommunity = null;
    _userTravelWith = null;
    _userArrivalTransport = null;
    _userPlannedStay = null;
    _userAccommodationType = null;
    _userHowKnown = null;
    _userVisitReason = null;

    // Rating Fields
    _tourismOffer = null;
    _tourismInformation = null;
    _cleanlinessMaintenance = null;
    _commerceService = null;
    _transportAccessibility = null;
    _safety = null;
    _touristSignage = null;

    _surveyCleared = true;

    notifyListeners();
  }

  void clear() {
    _surveyCleared = false;
    _ageEnabled = true;
    _genderEnabled = true;
    _residentEnabled = true;
    _countryEnabled = true;
    _communitiesEnabled = true;
    _travelWithEnabled = true;
    _transportEnabled = true;
    _plannedStayEnabled = true;
    _visitReasonEnabled = true;
    _knowPlacesEnabled = true;
    _stayInSMVEnabled = true;
    _accommodationEnabled = true;
    _howKnownEnabled = true;
    _firstVisitEnabled = true;
    _recommendEnabled = true;
    print('clear');
  }
}
