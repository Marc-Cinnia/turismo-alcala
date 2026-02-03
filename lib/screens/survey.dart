import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/survey_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/widgets/rating_survey_stars_bar.dart';
import 'package:valdeiglesias/widgets/value_selector.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';

class Survey extends StatefulWidget {
  const Survey({super.key});

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _residentController = TextEditingController();
  final _countryController = TextEditingController();
  final _communitiesController = TextEditingController();
  final _travelWithController = TextEditingController();
  final _transportController = TextEditingController();
  final _plannedStayController = TextEditingController();
  final _visitReasonController = TextEditingController();
  final _knowPlacesController = TextEditingController();
  final _stayInSMVController = TextEditingController();
  final _accommodationController = TextEditingController();
  final _howKnownController = TextEditingController();
  final _firstVisitController = TextEditingController();
  final _recommendController = TextEditingController();

  late LanguageModel language;
  late AccessibleModel accessible;
  late SurveyModel surveyModel;

  late bool _ageEnabled;
  late bool _genderEnabled;
  late bool _residentEnabled;
  late bool _countryEnabled;
  late bool _communitiesEnabled;
  late bool _travelWithEnabled;
  late bool _transportEnabled;
  late bool _plannedStayEnabled;
  late bool _visitReasonEnabled;
  late bool _knowPlacesEnabled;
  late bool _stayInSMVEnabled;
  late bool _accommodationEnabled;
  late bool _howKnownEnabled;
  late bool _firstVisitEnabled;
  late bool _recommendEnabled;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ageEnabled = Provider.of<SurveyModel>(context).ageEnabled;
    _genderEnabled = Provider.of<SurveyModel>(context).genderEnabled;
    _residentEnabled = Provider.of<SurveyModel>(context).residentEnabled;
    _knowPlacesEnabled = Provider.of<SurveyModel>(context).knowPlacesEnabled;
    _stayInSMVEnabled = Provider.of<SurveyModel>(context).stayInSMVEnabled;
    _accommodationEnabled =
        Provider.of<SurveyModel>(context).accommodationEnabled;
    _howKnownEnabled = Provider.of<SurveyModel>(context).howKnownEnabled;
    _firstVisitEnabled = Provider.of<SurveyModel>(context).firstVisitEnabled;
    _recommendEnabled = Provider.of<SurveyModel>(context).recommendEnabled;
    _countryEnabled = Provider.of<SurveyModel>(context).countryEnabled;
    _communitiesEnabled = Provider.of<SurveyModel>(context).communitiesEnabled;
    _travelWithEnabled = Provider.of<SurveyModel>(context).travelWithEnabled;
    _transportEnabled = Provider.of<SurveyModel>(context).transportEnabled;
    _plannedStayEnabled = Provider.of<SurveyModel>(context).plannedStayEnabled;
    _visitReasonEnabled = Provider.of<SurveyModel>(context).visitReasonEnabled;
    _knowPlacesEnabled = Provider.of<SurveyModel>(context).knowPlacesEnabled;
    _stayInSMVEnabled = Provider.of<SurveyModel>(context).stayInSMVEnabled;
    _accommodationEnabled =
        Provider.of<SurveyModel>(context).accommodationEnabled;
    _howKnownEnabled = Provider.of<SurveyModel>(context).howKnownEnabled;
    _firstVisitEnabled = Provider.of<SurveyModel>(context).firstVisitEnabled;
    _recommendEnabled = Provider.of<SurveyModel>(context).recommendEnabled;
  }

  @override
  Widget build(BuildContext context) {
    language = context.watch<LanguageModel>();
    accessible = context.watch<AccessibleModel>();
    surveyModel = context.watch<SurveyModel>();

    const spacer = SizedBox(height: AppConstants.spacing);
    const vSpacer = SizedBox(width: AppConstants.spacing);
    const divider = Divider(thickness: 2.0);

    final appBarTitle = (language.english)
        ? AppConstants.surveyTitleEn
        : AppConstants.surveyTitle;

    final descSubtitle = (language.english)
        ? AppConstants.surveyDescSubtitleEn
        : AppConstants.surveyDescSubtitle;

    final description = (language.english)
        ? AppConstants.surveyDescriptionEn
        : AppConstants.surveyDescription;

    final subtitle = Padding(
      padding: const EdgeInsets.only(
        top: AppConstants.spacing,
        left: AppConstants.spacing,
        right: AppConstants.spacing,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          descSubtitle,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: AppConstants.primary),
        ),
      ),
    );

    final descriptionSection = Padding(
      padding: const EdgeInsets.only(
        top: AppConstants.spacing,
        left: AppConstants.spacing,
        right: AppConstants.spacing,
      ),
      child: Text(
        description,
        textAlign: TextAlign.justify,
      ),
    );

    final generalName = (language.english)
        ? AppConstants.surveyGeneralInfoEn
        : AppConstants.surveyGeneralInfo;

    final visitInfoName = (language.english)
        ? AppConstants.surveyVisitInfoEn
        : AppConstants.surveyVisitInfo;

    Widget visitInfo = const SizedBox();

    final ageLabel =
        (language.english) ? AppConstants.surveyAgeEn : AppConstants.surveyAge;

    final genderLabel = (language.english)
        ? AppConstants.surveyGenderEn
        : AppConstants.surveyGender;

    final residenceLabel = (language.english)
        ? AppConstants.surveyResidenceEn
        : AppConstants.surveyResidence;

    final ageValues = (language.english)
        ? AppConstants.surveyAgeValuesEn
        : AppConstants.surveyAgeValues;

    final genderValues = (language.english)
        ? AppConstants.surveyGenderValuesEn
        : AppConstants.surveyGenderValues;

    final residenceValues = (language.english)
        ? AppConstants.surveyYesNoValuesEn
        : AppConstants.surveyYesNoValues;

    final country = (language.english)
        ? AppConstants.surveyCountryEn
        : AppConstants.surveyCountry;

    final countryValues = (language.english)
        ? AppConstants.surveyCountriesEn
        : AppConstants.surveyCountries;

    final autCommunitiesLabel = (language.english)
        ? AppConstants.surveyAutCommunitiesEn
        : AppConstants.surveyAutCommunities;

    final autCommunities = (language.english)
        ? AppConstants.surveyAutonomousCommunitiesEn
        : AppConstants.surveyAutonomousCommunities;

    final travelWithLabel = (language.english)
        ? AppConstants.surveyTravelWithQuestionEn
        : AppConstants.surveyTravelWithQuestion;

    final travelWithValues = (language.english)
        ? AppConstants.surveyTravelWithValuesEn
        : AppConstants.surveyTravelWithValues;

    final arrivalTransportLabel = (language.english)
        ? AppConstants.surveyTransportationEn
        : AppConstants.surveyTransportation;

    final arrivalTransportValues = (language.english)
        ? AppConstants.surveyArrivalTransportValuesEn
        : AppConstants.surveyArrivalTransportValues;

    final plannedStayLabel = (language.english)
        ? AppConstants.surveyPlannedStayEn
        : AppConstants.surveyPlannedStay;

    final plannedStayValues = (language.english)
        ? AppConstants.surveyPlannedStayValuesEn
        : AppConstants.surveyPlannedStayValues;

    final visitReasonLabel = (language.english)
        ? AppConstants.surveyVisitReasonEn
        : AppConstants.surveyVisitReason;

    final visitReasonValues = (language.english)
        ? AppConstants.surveyVisitReasonValuesEn
        : AppConstants.surveyVisitReasonValues;

    final knowPlacesToVisitLabel = (language.english)
        ? AppConstants.surveyPlannedVisitQuestionEn
        : AppConstants.surveyPlannedVisitQuestion;

    final knowPlacesToVisitValues = (language.english)
        ? AppConstants.surveyYesNoValuesEn
        : AppConstants.surveyYesNoValues;

    final willStayInSanMartinLabel = (language.english)
        ? AppConstants.surveyWillStayHereQuestionEn
        : AppConstants.surveyWillStayHereQuestion;

    final willStayInSanMartinValues = (language.english)
        ? AppConstants.surveyYesNoValuesEn
        : AppConstants.surveyYesNoValues;

    final accommodationTypeLabel = (language.english)
        ? AppConstants.surveyAccommodationTypeEn
        : AppConstants.surveyAccommodationType;

    final howKnownLabel = (language.english)
        ? AppConstants.surveyHowKnownEn
        : AppConstants.surveyHowKnown;

    final howKnownValues = (language.english)
        ? AppConstants.surveyDiscoveryMethodValuesEn
        : AppConstants.surveyDiscoveryMethodValues;

    final acommodationTypeValues = (language.english)
        ? AppConstants.surveyAcommodationTypeValuesEn
        : AppConstants.surveyAcommodationTypeValues;

    final firstVisitLabel = (language.english)
        ? AppConstants.surveyFirstVisitEn
        : AppConstants.surveyFirstVisit;

    final firstVisitValues = (language.english)
        ? AppConstants.surveyYesNoValuesEn
        : AppConstants.surveyYesNoValues;

    final recommendLabel = (language.english)
        ? AppConstants.surveyRecommendEn
        : AppConstants.surveyRecommend;

    final recommendValues = (language.english)
        ? AppConstants.surveyYesNoValuesEn
        : AppConstants.surveyYesNoValues;

    final ratingLabel = (language.english)
        ? AppConstants.surveyRatingEn
        : AppConstants.surveyRating;

    final ageRangeField = Row(
      children: [
        SurveyLabel(label: ageLabel),
        vSpacer,
        ValueSelector(
          values: ageValues,
          valueKey: AppConstants.surveyAgeKey,
          controller: _ageController,
          enabled: _ageEnabled,
        ),
      ],
    );

    final genderField = Row(
      children: [
        SurveyLabel(label: genderLabel),
        vSpacer,
        ValueSelector(
          values: genderValues,
          valueKey: AppConstants.surveyGenderKey,
          controller: _genderController,
          enabled: _genderEnabled,
        ),
      ],
    );

    final residentField = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SurveyLabel(label: residenceLabel),
        vSpacer,
        ValueSelector(
          values: residenceValues,
          valueKey: AppConstants.surveyResidentKey,
          controller: _residentController,
          enabled: _residentEnabled,
        ),
      ],
    );

    final countryField = (surveyModel.showCountries)
        ? Row(
            children: [
              SurveyLabel(label: country),
              vSpacer,
              ValueSelector(
                values: countryValues,
                valueKey: AppConstants.surveyCountryKey,
                controller: _countryController,
                enabled: _countryEnabled,
              ),
            ],
          )
        : const SizedBox();

    final autCommunitiesField = (surveyModel.showAutonomousCommunities)
        ? Row(
            children: [
              SurveyLabel(label: autCommunitiesLabel),
              vSpacer,
              ValueSelector(
                values: autCommunities,
                valueKey: AppConstants.surveyAutCommunityKey,
                controller: _communitiesController,
                enabled: _communitiesEnabled,
              ),
            ],
          )
        : const SizedBox();

    final travelWithField = (surveyModel.showTravelWith)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SurveyLabel(label: travelWithLabel),
              vSpacer,
              ValueSelector(
                values: travelWithValues,
                valueKey: AppConstants.surveyTravelWithKey,
                controller: _travelWithController,
                enabled: _travelWithEnabled,
              ),
            ],
          )
        : const SizedBox();

    final arrivalTransportField = (surveyModel.showArrivalTransport)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SurveyLabel(label: arrivalTransportLabel),
              vSpacer,
              ValueSelector(
                values: arrivalTransportValues,
                valueKey: AppConstants.surveyArrivalTransportKey,
                controller: _transportController,
                enabled: _transportEnabled,
              ),
            ],
          )
        : const SizedBox();

    final plannedStayField = (surveyModel.showPlannedStay)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SurveyLabel(label: plannedStayLabel),
              vSpacer,
              ValueSelector(
                values: plannedStayValues,
                valueKey: AppConstants.surveyPlannedStayKey,
                controller: _plannedStayController,
                enabled: _plannedStayEnabled,
              ),
            ],
          )
        : const SizedBox();

    final visitReasonField = (surveyModel.showVisitReason)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SurveyLabel(label: visitReasonLabel),
              vSpacer,
              ValueSelector(
                values: visitReasonValues,
                valueKey: AppConstants.surveyVisitReasonKey,
                controller: _visitReasonController,
                enabled: _visitReasonEnabled,
              ),
            ],
          )
        : const SizedBox();

    final knowPlacesToVisitField = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SurveyLabel(label: knowPlacesToVisitLabel),
        vSpacer,
        ValueSelector(
          values: knowPlacesToVisitValues,
          valueKey: AppConstants.surveyKnowPlacesVisitKey,
          controller: _knowPlacesController,
          enabled: _knowPlacesEnabled,
        ),
      ],
    );

    final willStaySMVField = (!surveyModel.showResidentData)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SurveyLabel(label: willStayInSanMartinLabel),
              vSpacer,
              ValueSelector(
                values: willStayInSanMartinValues,
                valueKey: AppConstants.surveyAccommodationInSMVKey,
                controller: _stayInSMVController,
                enabled: _stayInSMVEnabled,
              ),
            ],
          )
        : const SizedBox();

    final accommodationTypeField = (surveyModel.showAccomodationType)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SurveyLabel(label: accommodationTypeLabel),
              vSpacer,
              ValueSelector(
                values: acommodationTypeValues,
                valueKey: AppConstants.surveyAccommodationTypeKey,
                controller: _accommodationController,
                enabled: _accommodationEnabled,
              ),
            ],
          )
        : const SizedBox();

    final howKnownField = (surveyModel.showHowKnown)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SurveyLabel(label: howKnownLabel),
              vSpacer,
              ValueSelector(
                values: howKnownValues,
                valueKey: AppConstants.surveyHowKnownKey,
                controller: _howKnownController,
                enabled: _howKnownEnabled,
              ),
            ],
          )
        : const SizedBox();

    final firstVisitField = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SurveyLabel(label: firstVisitLabel),
        vSpacer,
        ValueSelector(
          values: firstVisitValues,
          valueKey: AppConstants.surveyFirstVisitKey,
          controller: _firstVisitController,
          enabled: _firstVisitEnabled,
        ),
      ],
    );

    final recommendField = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SurveyLabel(label: recommendLabel),
        vSpacer,
        ValueSelector(
          values: recommendValues,
          valueKey: AppConstants.surveyRecommendKey,
          controller: _recommendController,
          enabled: _recommendEnabled,
        ),
      ],
    );

    final tourismOfferLabel = (language.english)
        ? AppConstants.surveyTourismOfferEn
        : AppConstants.surveyTourismOffer;

    final tourismInformationLabel = (language.english)
        ? AppConstants.surveyTourismInformationEn
        : AppConstants.surveyTourismInformation;

    final cleanlinessMaintenanceLabel = (language.english)
        ? AppConstants.surveyCleanlinessMaintenanceEn
        : AppConstants.surveyCleanlinessMaintenance;

    final commerceServiceLabel = (language.english)
        ? AppConstants.surveyCommerceServiceEn
        : AppConstants.surveyCommerceService;

    final transportAccessibilityLabel = (language.english)
        ? AppConstants.surveyTransportAccessibilityEn
        : AppConstants.surveyTransportAccessibility;

    final safetyLabel = (language.english)
        ? AppConstants.surveySafetyEn
        : AppConstants.surveySafety;

    final touristSignageLabel = (language.english)
        ? AppConstants.surveyTouristSignageEn
        : AppConstants.surveyTouristSignage;

    final ratingSection = (surveyModel.showRatingSection)
        ? SurveySection(
            name: ratingLabel,
            content: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        tourismOfferLabel,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    RatingSurveyStarsBar(
                      aspectKey: AppConstants.surveyTourismOfferKey,
                    ),
                  ],
                ),
                spacer,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        tourismInformationLabel,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    RatingSurveyStarsBar(
                      aspectKey: AppConstants.surveyTourismInformationKey,
                    ),
                  ],
                ),
                spacer,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        cleanlinessMaintenanceLabel,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    RatingSurveyStarsBar(
                      aspectKey: AppConstants.surveyCleanlinessMaintenanceKey,
                    ),
                  ],
                ),
                spacer,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        commerceServiceLabel,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    RatingSurveyStarsBar(
                      aspectKey: AppConstants.surveyCommerceServiceKey,
                    ),
                  ],
                ),
                spacer,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        transportAccessibilityLabel,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    RatingSurveyStarsBar(
                      aspectKey: AppConstants.surveyTransportAccessibilityKey,
                    ),
                  ],
                ),
                spacer,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        safetyLabel,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    RatingSurveyStarsBar(
                      aspectKey: AppConstants.surveySafetyKey,
                    ),
                  ],
                ),
                spacer,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        touristSignageLabel,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    RatingSurveyStarsBar(
                        aspectKey: AppConstants.surveyTouristSignageKey),
                  ],
                ),
              ],
            ),
          )
        : const SizedBox();

    final sendSurveyLabel = (language.english)
        ? AppConstants.surveySendLabelEn
        : AppConstants.surveySendLabel;

    final restartSurveyLabel = (language.english)
        ? AppConstants.restartSurveyEn
        : AppConstants.restartSurvey;

    final submitButton = (surveyModel.showSubmitBtn)
        ? Flexible(
            child: ElevatedButton.icon(
              onPressed: () async {
                print('🔘 [SURVEY] Botón de envío presionado');
                bool ageProvided = surveyModel.userAgeRange.isNotEmpty;
                bool genderProvided = surveyModel.userGender.isNotEmpty;

                bool countryProvided = surveyModel.userCountry.isNotEmpty;

                bool mainValuesProvided =
                    ageProvided && genderProvided && countryProvided;

                String message = '';

                if (mainValuesProvided) {
                  if (surveyModel.showRatingSection) {
                    if (!surveyModel.ratingFieldsFilled()) {
                      message = (language.english)
                          ? AppConstants.surveyRatingMissingMsgEn
                          : AppConstants.surveyRatingMissingMsg;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                        ),
                      );
                    } else {
                      _submitSurvey(context);
                    }
                  } else {
                    _submitSurvey(context);
                  }
                } else {
                  message = (language.english)
                      ? AppConstants.surveyIncompleteFieldsMsgEn
                      : AppConstants.surveyIncompleteFieldsMsg;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.send_outlined,
                color: Colors.white,
              ),
              label: Text(
                sendSurveyLabel,
                style: GoogleFonts.dmSans().copyWith(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  AppConstants.contrast,
                ),
              ),
            ),
          )
        : const SizedBox();

    final surveyActions = OverflowBar(
      alignment: MainAxisAlignment.end,
      spacing: 8.0,
      children: [
        TextButton(
            onPressed: () {
              context.read<SurveyModel>().restart();
              setState(
                () {
                  _ageController.clear();
                  _genderController.clear();
                  _residentController.clear();
                  _countryController.clear();
                  _communitiesController.clear();
                  _travelWithController.clear();
                  _transportController.clear();
                  _plannedStayController.clear();
                  _visitReasonController.clear();
                  _knowPlacesController.clear();
                  _stayInSMVController.clear();
                  _accommodationController.clear();
                  _howKnownController.clear();
                  _firstVisitController.clear();
                  _recommendController.clear();

                  _ageEnabled = context.read<SurveyModel>().ageEnabled = true;
                  _genderEnabled =
                      context.read<SurveyModel>().genderEnabled = true;
                  _residentEnabled =
                      context.read<SurveyModel>().residentEnabled = true;
                  _countryEnabled =
                      context.read<SurveyModel>().countryEnabled = true;
                  _communitiesEnabled =
                      context.read<SurveyModel>().communitiesEnabled = true;
                  _travelWithEnabled =
                      context.read<SurveyModel>().travelWithEnabled = true;
                  _transportEnabled =
                      context.read<SurveyModel>().transportEnabled = true;
                  _plannedStayEnabled =
                      context.read<SurveyModel>().plannedStayEnabled = true;
                  _visitReasonEnabled =
                      context.read<SurveyModel>().visitReasonEnabled = true;
                  _knowPlacesEnabled =
                      context.read<SurveyModel>().knowPlacesEnabled = true;
                  _stayInSMVEnabled =
                      context.read<SurveyModel>().stayInSMVEnabled = true;
                  _accommodationEnabled =
                      context.read<SurveyModel>().accommodationEnabled = true;
                  _howKnownEnabled =
                      context.read<SurveyModel>().howKnownEnabled = true;
                  _firstVisitEnabled =
                      context.read<SurveyModel>().firstVisitEnabled = true;
                  _recommendEnabled =
                      context.read<SurveyModel>().recommendEnabled = true;
                },
              );
            },
            child: Text(restartSurveyLabel)),
        submitButton,
      ],
    );

    final general = SurveySection(
      name: generalName,
      content: Column(
        children: [
          ageRangeField,
          spacer,
          genderField,
          spacer,
          residentField,
          spacer,
          countryField,
          spacer,
          autCommunitiesField,
          spacer,
          travelWithField,
          spacer,
          arrivalTransportField,
        ],
      ),
    );

    if (surveyModel.showResidentData) {
      visitInfo = SurveySection(
        name: visitInfoName,
        content: Builder(
          builder: (context) {
            Widget sectionContent = const SizedBox();

            sectionContent = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                plannedStayField,
                spacer,
                visitReasonField,
                spacer,
                willStaySMVField,
                spacer,
                recommendField,
              ],
            );

            return sectionContent;
          },
        ),
      );
    }

    if (surveyModel.showVisitFeatures) {
      visitInfo = SurveySection(
        name: visitInfoName,
        content: Builder(
          builder: (context) {
            final sectionContent = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                plannedStayField,
                spacer,
                visitReasonField,
                spacer,
                knowPlacesToVisitField,
                spacer,
                willStaySMVField,
                spacer,
                accommodationTypeField,
                spacer,
                firstVisitField,
                spacer,
                howKnownField,
                spacer,
                recommendField,
              ],
            );

            return sectionContent;
          },
        ),
      );
    }

    final mainContent = Column(
      children: [
        subtitle,
        spacer,
        descriptionSection,
        spacer,
        divider,
        spacer,
        general,
        spacer,
        visitInfo,
        spacer,
        ratingSection,
        spacer,
        surveyActions,
      ],
    );

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppConstants.backArrowColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: DynamicTitle(
          value: appBarTitle,
          accessible: accessible.enabled,
        ),
        actions: ContentBuilder.getActions(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
            left: AppConstants.spacing,
            right: AppConstants.spacing,
            top: AppConstants.spacing,
            bottom: AppConstants.contentBottomSpacing,
          ),
          child: mainContent,
        ),
      ),
    );
  }

  void _submitSurvey(BuildContext context) async {
    print('🔄 [SURVEY] Iniciando envío de encuesta...');
    
    // Mostrar diálogo de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  (language.english)
                      ? 'Sending survey...'
                      : 'Enviando encuesta...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      final resultMsg = await context.read<SurveyModel>().submitSurvey();
      print('🔄 [SURVEY] Resultado: $resultMsg');

      // Cerrar diálogo de carga
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (resultMsg != null) {
        print('✅ [SURVEY] Mostrando diálogo de éxito');
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            final titleText = (language.english)
                ? AppConstants.surveyTitleDialogEn
                : AppConstants.surveyTitleDialog;
            final descriptionText = (language.english)
                ? AppConstants.surveyDescriptionDialogEn
                : AppConstants.surveyDescriptionDialog;

            return AlertDialog(
              title: Text(titleText),
              content: Text(
                descriptionText,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.primary,
                    ),
              ),
              actions: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await context.read<SurveyModel>().setSurveyAnswered(true);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  label: Text(
                    (language.english)
                        ? AppConstants.acceptEn
                        : AppConstants.accept,
                    style: GoogleFonts.dmSans().copyWith(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      AppConstants.contrast,
                    ),
                  ),
                ),
              ],
            );
          },
        ).then((_) => Navigator.of(context).popUntil((route) => route.isFirst));
      } else {
        print('❌ [SURVEY] No se recibió respuesta del servidor');
        // Mostrar mensaje de error si no hay resultado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              (language.english)
                  ? 'Error submitting survey. Please try again.'
                  : 'Error al enviar la encuesta. Por favor, inténtalo de nuevo.',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      print('❌ [SURVEY] Excepción en _submitSurvey: $e');
      // Cerrar diálogo de carga si aún está abierto
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (language.english)
                ? 'Error submitting survey. Please check your connection and try again.'
                : 'Error al enviar la encuesta. Por favor, verifica tu conexión e inténtalo de nuevo.',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}

class SurveyLabel extends StatelessWidget {
  const SurveyLabel({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        softWrap: true,
        maxLines: 4,
      ),
    );
  }
}

class SurveySection extends StatelessWidget {
  const SurveySection({
    super.key,
    required this.name,
    required this.content,
  });

  final String name;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: AppConstants.shortSpacing);
    const divider = Divider(thickness: 2.0);

    final sectionTitle = Text(
      name,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppConstants.primary,
          ),
    );

    return Card(
      color: AppConstants.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionTitle,
                      spacer,
                      divider,
                      content,
                    ],
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
