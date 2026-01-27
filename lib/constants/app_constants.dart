import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:valdeiglesias/dtos/place_category.dart';

import 'package:valdeiglesias/models/app_model.dart';
import 'package:valdeiglesias/models/cellar_model.dart';
import 'package:valdeiglesias/models/eat_model.dart';
import 'package:valdeiglesias/models/experience_model.dart';
import 'package:valdeiglesias/models/guided_tours_model.dart';
import 'package:valdeiglesias/models/schedule_model.dart';
import 'package:valdeiglesias/models/visit_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/models/shop_model.dart';
import 'package:valdeiglesias/models/sleep_model.dart';
import 'package:valdeiglesias/models/valdeiglesias_model.dart';
import 'package:valdeiglesias/screens/eat_categories.dart';
import 'package:valdeiglesias/screens/experiences_categories.dart';
import 'package:valdeiglesias/screens/guided_tours_pre_detail.dart';
import 'package:valdeiglesias/screens/home.dart';
import 'package:valdeiglesias/screens/incidents.dart';
import 'package:valdeiglesias/screens/map_screen.dart';
import 'package:valdeiglesias/screens/news.dart';
import 'package:valdeiglesias/screens/places_categories_screen.dart';
import 'package:valdeiglesias/screens/plan.dart';
import 'package:valdeiglesias/screens/practical_information.dart';
import 'package:valdeiglesias/screens/routes.dart';
import 'package:valdeiglesias/screens/schedule.dart';
import 'package:valdeiglesias/screens/settings.dart';
import 'package:valdeiglesias/screens/shop_categories.dart';
import 'package:valdeiglesias/screens/sleep_categories.dart';
import 'package:valdeiglesias/screens/survey.dart';
import 'package:valdeiglesias/screens/survey_pre_detail.dart';
import 'package:valdeiglesias/screens/valdeiglesias.dart';
import 'package:valdeiglesias/screens/cellar_pre_detail.dart';
import 'package:valdeiglesias/screens/museal.dart';
import 'package:valdeiglesias/screens/smart.dart';
import 'package:valdeiglesias/screens/smartBeacon.dart';
import 'package:valdeiglesias/screens/smartQR.dart';
import 'package:valdeiglesias/screens/documents.dart';
import 'package:valdeiglesias/widgets/menu_item.dart';

class AppConstants {
  static const String appTitle = 'Alcalá de Henares';

  // Dimensions used in the whole app
  static const double borderRadius = 20.0;
  static const double cardBorderRadius = 10.0;
  static const double cardElevation = 4.0;
  static const double thumbnailBorderRadius = 8.0;
  static const double shortSpacing = 6.0;
  static const double spacing = 16.0;
  static const double contentBottomSpacing = 120.0;
  static const double cardSpacing = 12.0;
  static const double carouselHeight = 300.0;
  static const double bannerHeight = 70.0;
  static const double thumbnailWidth = 100.0;
  static const double thumbnailHeight = 80.0;
  static const double previewWidth = 200.0;
  static const double previewHeight = 180.0;
  static const double menuSide = 110.0;
  static const double mapHeight = 400.0;
  static const double logoWidth = 60.0;
  static const double mapFloatingButtonPadding = 80.0;
  static const double mapBottomSheetImgHeight = 200.0;
  static const double appBarTextSize = 17.0;
  static const double selectorFontSize = 14.0;

  // Colors of the app:
  static const Color primary = Color.fromRGBO(0, 0, 0, 1);
  static const Color title = Color.fromRGBO(255, 255, 255, 1);
  static const Color label = Color.fromRGBO(0, 0, 0, 0.702);
  static const Color contrast = /*Color.fromRGBO(255, 100, 62, 1.0); */ Color.fromRGBO(4, 134, 170, 1);
  static const Color contrastSoft =  Color.fromRGBO(4, 134, 170, 1);
  static const Color minimumContrast = Color.fromRGBO(255, 228, 220, 1.0);
  static const Color lessContrast = Color.fromRGBO(0, 0, 0, 1);
  static const Color cardColor = Color.fromRGBO(247, 247, 247, 1.0);
  static const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
  static const Color backArrowColor = Color.fromRGBO(255, 255, 255, 1.0); 
  static const Color parkingAvailable = const Color.fromRGBO(8, 164, 68, 1.0);
  static const Color parkingWarningColor =
      const Color.fromRGBO(255, 243, 205, 1.0);
  // static const Color parkingFullColor = const Color.fromRGBO(228, 215, 218, 1.0);
  static final Color parkingFullColor = const Color.fromARGB(255, 0, 0, 0);

  // Response codes:
  static const int success = 200;
  static const int created = 201;

  // Request hard-coded values:
  static const int state = 0;

  // Keys for JSON Deserialization:
  static const String titleKey = 'title';
  static const String valueKey = 'value';
  static const String nameKey = 'name';
  static const String phoneKey = 'phone_number';
  static const String phone2Key = 'phone_number2';
  static const String emailKey = 'email';
  static const String subtitleKey = 'field_featured_subtitle';
  static const String expirationKey = 'field_featured_expiration_date';
  static const String bannerLinkKey = 'field_featured_link';
  static const String bannerNavLinkKey = 'field_static_link';
  static const String bannerExpirationDate = 'field_static_expiration_date';
  static const String urlKey = 'url';
  static const String targetIdKey = 'target_id';
  static const String targetTypeKey = 'target_type';
  static const String targetUuidKey = 'target_uuid';
  static const String idKey = 'tid';
  static const String nIdKey = 'nid';
  static const String uIdKey = 'uid';
  static const String dataKey = 'data';
  static const String addressKey = 'address';
  static const String websiteKey = 'web';
  static const String igKey = 'instagram';
  static const String fbKey = 'facebook';
  static const String twitterKey = 'twitter';
  static const String offersKey = 'offer';
  static const String imageGalleryKey = 'image_gallery';
  static const String longDescriptionEsKey = 'long_description_es';
  static const String longDescriptionEnKey = 'long_description_en';
  static const String placeMainImage = 'field_place_main_image';
  static const String placeShortDescription = 'field_place_short_description';
  static const String placeLongDescription = 'field_place_long_description';
  static const String placeLocation = 'field_place_location';
  static const String placeGallery = 'field_place_image_gallery';
  static const String placePhoneNumber = 'field_place_phone_number';
  static const String placeVideo = 'field_place_video';
  static const String placeWebsite = 'field_place_web';
  static const String placeAddress = 'field_place_address';
  static const String placeSubtitle = 'field_place_subtitle';
  static const String placeCategory = 'field_place_category';
  static const String experienceCategory = 'field_exp_category';
  static const String experienceVideo = 'field_exp_video';
  static const String placeLatitude = 'lat';
  static const String placeLongitude = 'lng';
  static const String placeLongitude2 = 'lon';
  static const String sectionRoute = 'field_section_phone_page';
  static const String valdeiglesiasMainImage = 'field_valdeiglesias_main_image';
  static const String valdeiglesiasTitle1 = 'field_valdeiglesias_title1';
  static const String valdeiglesiasTitle2 = 'field_valdeiglesias_title2';
  static const String valdeiglesiasTitle3 = 'field_valdeiglesias_title3';
  static const String valdeiglesiasTitle4 = 'field_valdeiglesias_title4';
  static const String guidedToursMainImage = 'field_tour_main_image';
  static const String guidedToursLongDesc = 'field_tour_long_description';
  static const String guidedToursShortDesc = 'field_tour_short_description';
  static const String guidedToursPhone = 'field_tour_phone_number';
  static const String guidedToursPhone2 = 'field_tour_phone_number2';
  static const String guidedToursEmail = 'field_tour_email';
  static const String guidedToursWebsite = 'field_tour_web';
  static const String guidedToursGallery = 'field_tour_image_gallery';
  static const String valdeiglesiasParagraph1 =
      'field_valdeiglesias_description1';
  static const String valdeiglesiasParagraph2 =
      'field_valdeiglesias_description2';
  static const String valdeiglesiasParagraph3 =
      'field_valdeiglesias_description3';
  static const String valdeiglesiasParagraph4 =
      'field_valdeiglesias_description4';
  static const String valdeiglesiasGallery = 'field_valdeiglesias_imagegallery';
  static const String routeMainImage = 'field_route_main_image';
  static const String routeShortDesc = 'field_route_short_description';
  static const String routeLongDesc = 'field_route_long_description';
  static const String routeTypeId = 'field_route_type';
  static const String circuitTypeId = 'field_route_circuit_type';
  static const String distance = 'field_route_distance';
  static const String travelTimeInHours = 'field_route_hour';
  static const String travelTimeInMins = 'field_route_minutes';
  static const String difficulty = 'field_route_difficulty';
  static const String maximumAltitude = 'field_route_maximum_altitude';
  static const String minimumAltitude = 'field_route_minimum_altitude';
  static const String positiveElevation = 'field_route_positive_elevation';
  static const String negativeElevation = 'field_route_negative_elevation';
  static const String routeLocation = 'field_route_location';
  static const String routeGallery = 'field_route_image_gallery';
  static const String routePointsField = 'field_point';
  static const String routeKml = 'field_route_kml';
  static const String routeInfoLabel = 'Información';
  static const String routeInfoLabelEn = 'Information';
  static const String routeStartLocationLabel =
      'Ubicación donde empieza la ruta';
  static const String routeStartLocationLabelEn =
      'Location where starts this route';
  static const String routeTypeLabel = 'Tipo de Ruta:';
  static const String routeTypeLabelEn = 'Route Type:';
  
  // Filtro de categorías de rutas
  static const String routeCategoryFilterLabel = 'Selecciona una categoría para ver las rutas filtradas.';
  static const String routeCategoryFilterLabelEn = 'Select a category in order to see the routes filtered.';
  static const String routeCircuitTypeLabel = 'Tipo de Circuito:';
  static const String routeCircuitTypeLabelEn = 'Circuit Type:';
  static const String routeDistanceLabel = 'Distancia:';
  static const String routeDistanceLabelEn = 'Distance:';
  static const String routeTravelTimeLabel = 'Tiempo de Recorrido:';
  static const String routeTravelTimeLabelEn = 'Travel Time:';
  static const String routeHoursLabel = 'horas';
  static const String routeHoursLabelEn = 'hours';
  static const String routeMinutesLabel = 'minutos';
  static const String routeMinutesLabelEn = 'minutes';
  static const String routeDifficultyLabel = 'Dificultad técnica:';
  static const String routeDifficultyLabelEn = 'Technical difficulty:';
  static const String routeMaxAltitudeLabel = 'Altitud máxima:';
  static const String routeMaxAltitudeLabelEn = 'Maximum Altitude:';
  static const String routeMinAltitudeLabel = 'Altitud mínima:';
  static const String routeMinAltitudeLabelEn = 'Minimum Altitude:';
  static const String routePosElevationLabel = 'Desnivel positivo:';
  static const String routePosElevationLabelEn = 'Positive Elevation Gain:';
  static const String routeNegElevationLabel = 'Desnivel Negativo:';
  static const String routeNegElevationLabelEn = 'Negative Elevation Gain:';
  static const String routePointsSectionTitle =
      'Puntos destacados del recorrido';
  static const String routePointsSectionTitleEn = 'Highlights of the route';
  static const String routePointsActionLabel = 'Ver detalle';
  static const String routePointsActionLabelEn = 'View details';
  static const String routePointsEmptyLabel =
      'No se encontraron puntos asociados a esta ruta.';
  static const String routePointsEmptyLabelEn =
      'There are no additional points for this route.';
  static const String routePointFallbackTitle = 'Punto del recorrido';
  static const String routePointFallbackDescription =
      'Descubre más detalles en la página oficial de este punto.';
  static const String scheduleSubtitle = 'field_event_subtitle';
  static const String scheduleShortDesc = 'field_event_short_description';
  static const String scheduleAddress = 'field_event_address';
  static const String scheduleStartDate = 'field_event_start_date';
  static const String scheduleEndDate = 'field_event_end_date';
  static const String scheduleMainImage = 'field_event_main_image';
  static const String scheduleLongDescription = 'field_event_long_description';
  static const String scheduleLocation = 'field_event_location';
  static const String scheduleImageGallery = 'field_event_image_gallery';
  static const String schedulePdf = 'field_event_pdf';
  static const String experienceMainImage = 'field_exp_main_image';
  static const String experienceShortDesc = 'field_exp_short_description';
  static const String experienceLongDesc = 'field_exp_long_description';
  static const String experienceLocation = 'field_exp_location';
  static const String experiencePhoneNumber = 'field_exp_phone_number';
  static const String experienceWebsiteUrl = 'field_exp_web';
  static const String experienceAddress = 'field_exp_address';
  static const String experienceGallery = 'field_exp_image_gallery';
  static const String newsImage = 'field_news_image';
  static const String newsShortDesc = 'field_news_short_description';
  static const String newsLongDesc = 'field_news_long_description';
  static const String newsSubtitle = 'field_news_subtitle';
  static const String newsCreatedAt = 'created';
  static const String newsWebsiteUrl = 'field_news_link';
  static const String newsImageGallery = 'field_news_image_gallery';
  static const String newsPdfUrl = 'field_news_pdf';
  static const String staticBannerUrl = 'field_static_mobile_image';
  static const String staticBannerDesktopUrl = 'field_static_desktop_image';
  static const String parkingId = 'field_parking_id';
  static const String parkingDescriptionField = 'field_parking_description';
  static const String parkingLink = 'field_parking_link';
  static const String parkingLocation = 'field_parking_location';
  static const String parkingPay = 'pay_link';
  static const String parkingCapacity = 'field_parking_capacity';
  static const String informationMainImage = 'field_information_main_image';
  static const String informationDescription = 'field_information_description1';
  static const String informationGallery = 'field_information_image_gallery';
  static const String informationTitle1 = 'field_information_title1';
  static const String idHotelKey = 'id_hotel';
  static const String idRestaurantKey = 'id_restaurant';
  static const String idShopKey = 'id_shop';
  static const String mainImageKey = 'main_image';
  static const String shortDescEs = 'short_description_es';
  static const String shortDescEn = 'short_description_en';
  static const String longDescEs = 'long_description_es';
  static const String longDescEn = 'long_description_en';
  static const String idDataKey = 'id';
  static const String categoryKey = 'category';
  static const String nameEs = 'name_es';
  static const String nameEn = 'name_en';
  static const String linkEs = 'link_es';
  static const String linkEn = 'link_en';
  static const String placeScheduleEn = 'schedule_en';
  static const String placeSchedule = 'schedule_es';
  static const String userKey = 'user';
  static const String passwordKey = 'password';
  static const String passwordLoginKey = 'pwd';
  static const String imageKey = 'image';
  static const String startDateKey = 'start_date';
  static const String endDateKey = 'end_date';
  static const String singleUseKey = 'single_use';
  static const String shortTitleKey = 'short_title';
  static const String longTitleKey = 'long_title';
  static const String longTitleKeyEs = 'long_title_es';
  static const String longTitleKeyEn = 'long_title_en';
  static const String totalPlacesKey = 'total_places';
  static const String freePlacesKey = 'free_places';
  static const String canReserveKey = 'can_reserve';
  static const String holidaysKey = 'holidays';
  static const String datehourKey = 'datehour';
  static const String typeKey = 'type';
  static const String spain = 'España';
  static const String madrid = 'Madrid';
  static const String mandatoryFieldLabel = 'Campo Obligatorio';
  static const String mandatoryFieldLabelEn = 'Mandatory Field';
  // Open Street Map Integration Values
  static const String urlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String userAgentPackageName = 'org.cinnia.alcala';
  static const String drupalBaseUrl = 'https://drupal.alcalahenares.auroracities.com';
  static const String nodeJsonFormat = '?_format=json';

  // Data endpoints:
  static const String banner =
      'https://drupal.alcalahenares.auroracities.com/featured_es';
  static const String bannerEn =
      'https://drupal.alcalahenares.auroracities.com/featured_en';
  static const String slogan =
      'https://drupal.alcalahenares.auroracities.com/personalization_es';
  static const String sloganEn =
      'https://drupal.alcalahenares.auroracities.com/personalization_en';
  static const String sections =
      'https://drupal.alcalahenares.auroracities.com/section_es';
  static const String sectionsEn =
      'https://drupal.alcalahenares.auroracities.com/section_en';
  static const String places =
      'https://drupal.alcalahenares.auroracities.com/place_es';
  static const String placesEn =
      'https://drupal.alcalahenares.auroracities.com/place_en';
  static const String smdv =
      'https://drupal.alcalahenares.auroracities.com/valdeiglesias_es';
  static const String smdvEn =
      'https://drupal.alcalahenares.auroracities.com/valdeiglesias_en';
  static const String paths =
      'https://drupal.alcalahenares.auroracities.com/route_es';
  static const String pathsEn =
      'https://drupal.alcalahenares.auroracities.com/route_en';
  static const String routeType =
      'https://drupal.alcalahenares.auroracities.com/routetype_es';
  static const String routeTypeEn =
      'https://drupal.alcalahenares.auroracities.com/routetype_en';
  static const String circuitType =
      'https://drupal.alcalahenares.auroracities.com/circuittype_es';
  static const String circuitTypeEn =
      'https://drupal.alcalahenares.auroracities.com/circuittype_en';
  static const String difficultyType =
      'https://drupal.alcalahenares.auroracities.com/difficulty_es';
  static const String difficultyTypeEn =
      'https://drupal.alcalahenares.auroracities.com/difficulty_en';
  static const String currentSchedule =
      'https://drupal.alcalahenares.auroracities.com/event_es';
  static const String currentScheduleEn =
      'https://drupal.alcalahenares.auroracities.com/event_en';
  static const String experiences =
      'https://drupal.alcalahenares.auroracities.com/exp_es';
  static const String experiencesEn =
      'https://drupal.alcalahenares.auroracities.com/exp_en';
  static const String currentNews =
      'https://drupal.alcalahenares.auroracities.com/news_es';
  static const String currentNewsEn =
      'https://drupal.alcalahenares.auroracities.com/news_en';
  static const String whereToSleep =
      'https://alcalahenares.auroracities.com/api/hotel';
  static const String whereToEat =
      'https://alcalahenares.auroracities.com/api/restaurant';
  static const String whereToShop =
      'https://alcalahenares.auroracities.com/api/shop';
  static const String beacons =
      'https://drupal.alcalahenares.auroracities.com/beacon_es';
  static const String categories =
      'https://drupal.alcalahenares.auroracities.com/category_es';
  static const String categoriesEn =
      'https://drupal.alcalahenares.auroracities.com/category_en';
  static const String experienceCategories =
      'https://drupal.alcalahenares.auroracities.com/expcategory_es';
  static const String experienceCategoriesEn =
      'https://drupal.alcalahenares.auroracities.com/expcategory_en';
  static const String loaderImageUrl =
      'https://drupal.alcalahenares.auroracities.com/sites/default/files/2025-09/Spalsh02.jpg';
  static const String googleDirectionsUrl =
      'https://www.google.com/maps/dir/?api=1';
  static const String login = 'https://alcalahenares.auroracities.com/api/login';
  static const String reservationRestaurant =
      'https://alcalahenares.auroracities.com/api/reservation_restaurant';
  static const String reservationHotel =
      'https://alcalahenares.auroracities.com/api/reservation_hotel';
  static const String reservationTour =
      'https://alcalahenares.auroracities.com/api/reservation_tour';
  static const String reservationCellar =
      'https://alcalahenares.auroracities.com/api/reservation_cellar';
  static const String toursUrl = 'https://alcalahenares.auroracities.com/api/tour';
  static const String parkingsUrl =
      'https://alcalahenares.auroracities.com/api/parking';
  static const String staticBannerEs =
      'https://drupal.alcalahenares.auroracities.com/static_es';
  static const String myPlanApi =
      'https://alcalahenares.auroracities.com/api/myplan';
  static const String ratingApi =
      'https://alcalahenares.auroracities.com/api/rating';
  static const String checkOffer =
      'https://alcalahenares.auroracities.com/profesional/promociones/validar';
  static const String practicalInfo =
      'https://drupal.alcalahenares.auroracities.com/information_es';
  static const String practicalInfoEn =
      'https://drupal.alcalahenares.auroracities.com/information_en';
  static const String incidentReasons =
      'https://alcalahenares.auroracities.com/api/reason';
  static const String incident =
      'https://alcalahenares.auroracities.com/api/incident';
  static const String surveyUrl =
      'https://alcalahenares.auroracities.com/api/surveyapp';
  static const String cellarUrl =
      'https://alcalahenares.auroracities.com/api/cellar';
  static const String registerUrl =
      'https://alcalahenares.auroracities.com/api/register';
  static const String variableSurveyUrl =
      'https://alcalahenares.auroracities.com/api/survey_variable';
  static const String documentsUrl =
      'https://drupal.alcalahenares.auroracities.com/documents_es';

  static const String basicDateFormat = 'yyyy-MM-dd';
  static const String mainBasicDateFormat = 'dd-MM-yyyy';
  static const String dateFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String planDateFormat = 'dd/MM/yyyy - HH:mm';

  // Paths for various assets required by the app
  static const String smvLogoPath = 'assets/app_logo.png';
  static const String hotelMarkerPath = 'assets/icons/hotel.png';
  static const String placeMarkerPath = 'assets/icons/place.png';
  static const String eatMarkerPath = 'assets/icons/restaurant.png';
  static const String shopMarkerPath = 'assets/icons/shop.png';
  static const String experiencesMarkerPath = 'assets/icons/exp.png';
  static const String routeMarkerPath = 'assets/icons/route.png';
  static const String scheduleMarkerPath = 'assets/icons/event.png';
  static const String cellarMarkerPath = 'assets/icons/cellar.png';
  static const String tourMarkerPath = 'assets/icons/tour.png';
  static const String parkingMarkerPath = 'assets/icons/parking-marker.png';

  // Route hardcoded paths:
  static const String root = '/';
  static const String valdeiglesias = '/valdeiglesias';
  static const String visit = '/visitar';
  static const String eat = '/comer';
  static const String sleep = '/dormir';
  static const String shop = '/comprar';
  static const String routes = '/rutas';
  static const String schedule = '/agenda';
  static const String experience = '/experiencias';
  static const String news = '/noticias';
  static const String home = '/home';
  static const String map = '/mapa';
  static const String info = '/informacion';
  static const String plan = '/plan';
  static const String settings = '/settings';
  static const String guidedVisits = '/visitas';
  static const String incidents = '/incident';
  static const String parking = '/parking';
  static const String cellar = '/bodegas';
  static const String survey = '/survey';
  static const String museal = '/museal';
  static const String smart = '/smart';
  static const String smartQR = '/smartQR';
  static const String smartBeacon = '/smartBeacon';
  static const String documents = '/documentos';

  // Place types mapped from API:
  static const String placeApiType = 'place';
  static const String routeApiType = 'route';
  static const String eatApiType = 'eat';
  static const String sleepApiType = 'sleep';
  static const String eventApiType = 'event';
  static const String experienceApiType = 'exp';
  static const String tourApiType = 'tour';
  static const String cellarApiType = 'cellar';
  static const String shopApiType = 'shop';

  // List of paths used for map Screen.
  static const List<String> mapRoutePaths = [
    visit,
    routes,
    eat,
    sleep,
    shop,
    experience,
    schedule,
    cellar,
    guidedVisits,
  ];

  // Screen widgets for navigation
  static Map<String, Widget> screens = {
    valdeiglesias: const Valdeiglesias(accessible: false),
    visit: const PlacesCategoriesScreen(accessible: false),
    eat: EatCategories(accessible: false),
    sleep: SleepCategories(accessible: false),
    shop: const ShopCategories(accessible: false),
    routes: Routes(accessible: false),
    schedule: const Schedule(accessible: false),
    experience: const ExperiencesCategories(accessible: false),
    news: const News(),
    home: const Home(),
    map: const MapScreen(),
    info: const PracticalInformation(),
    plan: const Plan(),
    settings: const Settings(),
    guidedVisits: GuidedToursPreDetail(accessible: false),
    incidents: Incidents(),
    cellar: const CellarPreDetail(),
    survey: SurveyPreDetail(),
    museal: const MusealPage(),
    smart: const Smart(),
    smartQR: const SmartQR(),
    smartBeacon: const SmartBeacon(),
    documents: const Documents(),
  };

  static Map<String, Widget> accessibleScreens = {
    valdeiglesias: const Valdeiglesias(accessible: true),
    visit: const PlacesCategoriesScreen(accessible: true),
    eat: EatCategories(accessible: true),
    sleep: SleepCategories(accessible: true),
    shop: const ShopCategories(accessible: true),
    routes: Routes(accessible: true),
    schedule: const Schedule(accessible: true),
    experience: const ExperiencesCategories(accessible: true),
    news: const News(),
    home: const Home(),
    map: const MapScreen(),
    info: const PracticalInformation(),
    plan: const Plan(),
    settings: const Settings(),
    guidedVisits: GuidedToursPreDetail(accessible: true),
    incidents: Incidents(),
    cellar: const CellarPreDetail(),
    survey: const Survey(),
    museal: const MusealPage(),
    smart: const Smart(),
    smartQR: const SmartQR(),
    smartBeacon: const SmartBeacon(),
    documents: const Documents(),
  };

  // Models for each section
  static Map<String, ChangeNotifier> models = {
    valdeiglesias: ValdeiglesiasModel(),
  };

  // Endpoints for Map Screen
  static Map<String, String> mapScreenEndpoints = {
    visit: AppConstants.places,
    routes: AppConstants.paths,
    eat: AppConstants.whereToEat,
    sleep: AppConstants.whereToSleep,
    shop: AppConstants.whereToShop,
    experience: AppConstants.experiences,
    schedule: AppConstants.currentSchedule,
    cellar: AppConstants.cellarUrl,
    guidedVisits: AppConstants.toursUrl,
  };

  // English endpoints for Map Screen
  static Map<String, String> mapScreenEndpointsEn = {
    visit: AppConstants.placesEn,
    routes: AppConstants.pathsEn,
    eat: AppConstants.whereToEat,
    sleep: AppConstants.whereToSleep,
    shop: AppConstants.whereToShop,
    experience: AppConstants.experiencesEn,
    schedule: AppConstants.currentScheduleEn,
    cellar: AppConstants.cellarUrl,
    guidedVisits: AppConstants.toursUrl,
  };

  // Models for map screen
  static Map<String, AppModel> mapScreenModels = {
    visit: VisitModel(),
    routes: RouteModel(),
    eat: EatModel(),
    sleep: SleepModel(),
    shop: ShopModel(),
    experience: ExperienceModel(),
    schedule: ScheduleModel(),
    cellar: CellarModel(),
    guidedVisits: GuidedToursModel(),
  };

  /// A map containing the paths to the marker icons for the map.
  ///
  /// This map associates a string key with the path to the corresponding
  /// marker icon asset image. It is used to display different marker icons
  /// on the map based on the type of place.
  ///
  /// Example:
  ///   {
  ///     'restaurant': 'assets/icons/restaurant_marker.png',
  ///     'hotel': 'assets/icons/hotel_marker.png',
  ///   }
  static Map<String, String> mapMarkerIconPaths = {
    visit: placeMarkerPath,
    eat: eatMarkerPath,
    sleep: hotelMarkerPath,
    shop: shopMarkerPath,
    experience: experiencesMarkerPath,
    schedule: scheduleMarkerPath,
    routes: routeMarkerPath,
    cellar: cellarMarkerPath,
    guidedVisits: tourMarkerPath,
  };

  static Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
  };

  static const smvCentralLocation = LatLng(
    40.4848731,
    -3.3714429,
  );

  // Const data for maps:
  static const double mapInitialZoom = 17.0;
  static const double mapMediumZoom = 14.0;
  static const double mapShortZoom = 11.0;
  static const double markerSize = 30.0;
  static const String mapTitleEn =
      'Select a point on the map to report the incident';
  static const String mapTitle =
      'Selecciona un punto en el mapa para reportar la incidencia';

  // Map of months for dates processing:
  static const Map<int, String> months = {
    1: 'Enero',
    2: 'Febrero',
    3: 'Marzo',
    4: 'Abril',
    5: 'Mayo',
    6: 'Junio',
    7: 'Julio',
    8: 'Agosto',
    9: 'Septiembre',
    10: 'Octubre',
    11: 'Noviembre',
    12: 'Diciembre',
  };

  static const Map<int, String> monthsEn = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };

  static final categoryAll = PlaceCategory(id: 0, name: allItemsLabelEs);
  static final categoryAllEn = PlaceCategory(id: 0, name: allItemsLabel);

  // Hard-coded values for some widgets in screens:
  static const String experienceTitle = 'Experiencias Recomendadas';
  static const String experienceTitleEn = 'Recommended Experiences';
  static const String experienceDescription =
      'Vive las mejores experiencias en Alcalá de Henares, desde actividades al aire libre hasta eventos culturales. ¡Haz de tu visita algo inolvidable!';
  static const String experienceDescriptionEn =
      'Experience the best of Alcalá de Henares, from outdoor activities to cultural events. Make your visit unforgettable!';
  static const String contactSectionTitle = 'Contacto';
  static const String contactSectionTitleEn = 'Contact';
  static const String smvNewsSource =
      'Ayuntamiento de Alcalá de Henares';
  static const String smvNewsSourceEn =
      'Alcalá de Henares City Council';
  static const String connectorWord = 'de';
  static const String newsMoreInfoTitle = 'Más información';
  static const String newsMoreInfoTitleEn = 'More Info';
  static const String newsTitle = 'Noticias';
  static const String newsTitleEn = 'News';
  static const String documentsTitle = 'Documentos';
  static const String documentsTitleEn = 'Documents';
  static const String websiteLabel = 'Página web';
  static const String websiteLabelEn = 'Website';
  static const String valueNotAvailable = 'Información No disponible';
  static const String valueNotAvailableEn = 'Data not available';
  static const String addToMyPlanLabel = 'Añadir a mi plan';
  static const String addToMyPlanLabelEn = 'Add to my plan';
  static const String addedToMyPlanLabel = 'Lugar agregado a mi plan';
  static const String addedToMyPlanLabelEn = 'Place added to my plan';
  static const String removedFromMyPlanLabel =
      'Has eliminado un sitio de tu plan';
  static const String removedFromMyPlanLabelEn =
      'You have removed a site from your plan';
  static const String selectPlanDateLabel = 'Selecciona el día de tu visita';
  static const String selectPlanDateLabelEn = 'Select the date of your visit';
  static const String selectPlanTimeLabel = 'Selecciona la hora de tu visita';
  static const String selectPlanTimeLabelEn = 'Select the hour of your visit';
  static const String invalidTimeErrorMsg =
      'La hora seleccionada no es válida. Por favor, elige otra.';
  static const String invalidTimeErrorMsgEn =
      'The selected time is not valid. Please choose another';
  static const String whereToSleepLabel = '¿Dónde Dormir?';
  static const String whereToSleepLabelEn = 'Where to Sleep';
  static const String whereToEatLabel = '¿Dónde Comer?';
  static const String whereToEatLabelEn = 'Where to Eat?';
  static const String whereToShopLabel = '¿Dónde Comprar?';
  static const String whereToShopLabelEn = 'Where To Shop?';
  static const String eventsTitleLabel = 'Agenda';
  static const String eventsTitleLabelEn = 'Events';
  static const String playVideoLabel = 'Reproducir';
  static const String pauseVideoLabel = 'Pausar';
  static const String whereToShopDescription =
      'Explora nuestras tiendas y mercados locales, llenos de productos artesanales, recuerdos y especialidades de la región.';
  static const String whereToShopDescriptionEn =
      'Explore our local shops and markets, filled with handcrafted products, souvenirs, and regional specialties.';
  static const String whereToSleepDescription =
      'Encuentra alojamientos acogedores y con encanto, perfectos para hacer de tu estancia en Alcalá de Henares una experiencia inolvidable.';
  static const String whereToSleepDescriptionEn =
      'Find cozy and charming accommodations, perfect for making your stay in Alcalá de Henares an unforgettable experience.';
  static const String activeOffersLabel = 'Ofertas activas';
  static const String activeOffersLabelEn = 'Active Offers';
  static const String imagesGalleryLabel = 'Galería de imágenes';
  static const String imagesGalleryLabelEn = 'Images Gallery';
  static const String videoSectionLabel = 'Video';
  static const String galleryNotAvailableLabel = 'No hay imágenes para mostrar';
  static const String galleryNotAvailableLabelEn = 'Images not available';
  static const String downloadFileLabel = 'Descargar PDF';
  static const String downloadKMLLabel = 'Descargar KML';
  static const String downloadKMLLabelEn = 'Download KML';
  static const String locNotAvailableLabel =
      'Ubicación en el mapa no disponible';
  static const String galleryLabel = 'Galería de Imágenes';
  static const String galleryLabelEn = 'Images gallery';
  static const String myPlanLabel = 'Mi plan';
  static const String myPlanLabelEn = 'My plan';
  static const String smvLabel = 'ALCALÁ DE HENARES';
  static const String visitLabel = '¿Qué visitar?';
  static const String visitLabelEn = 'What to Visit';
  static const String toursLabel = 'Visitas Guiadas';
  static const String toursLabelEn = 'Guided Tours';
  static const String parkingLabel = 'Dónde Aparcar';
  static const String parkingLabelEn = 'Where to Park';
  static const String incidentLabel = 'Incidencias';
  static const String incidentLabelEn = 'Incidents';
  static const String cellarLabel = 'Bodegas';
  static const String cellarLabelEn = 'Cellars';
  static const String incidentNameLabel = 'Nombre de la incidencia';
  static const String incidentNameLabelEn = 'Incident name';
  static const String incidentReasonTitle = 'Motivo de la incidencia';
  static const String incidentReasonTitleEn = 'Incident Reason';
  static const String incidentDescriptionTitle = 'Breve Descripción';
  static const String incidentDescriptionTitleEn = 'Short Description';
  static const String incidentImagesTitle = 'Adjuntar Imagen';
  static const String incidentImagesTitleEn = 'Attach Image';
  static const String pickFromGallery = 'Seleccionar desde mi galería';
  static const String pickFromGalleryEn = 'Select from my gallery';
  static const String pickFromCamera = 'Capturar desde cámara';
  static const String pickFromCameraEn = 'Capture from camera';
  static const String pickImageTitle = 'Selecciona una imagen';
  static const String pickImageTitleEn = 'Select an image';
  static const String pickImageDesc =
      'Elige una opción para cargar una imagen desde tu dispositivo.';
  static const String pickImageDescEn =
      'Choose an option to upload an image from your device.';
  static const String incidentGeoreferenceTitle = 'Enviar localización';
  static const String incidentGeoreferenceTitleEn = 'Send Location';
  static const String addLocationLabel = 'Obtener Ubicación Actual';
  static const String addLocationLabelEn = 'Get Current Location';
  static const String locationAdded = '¡Ubicación obtenida con éxito!';
  static const String locationAddedEn = 'Location successfully fetched!';
  static const String georeferenceSectionTitle = 'Georreferenciación';
  static const String georeferenceSectionTitleEn = 'Location';
  static const String routesTitle = 'Rutas';
  static const String routesTitleEn = 'Routes';
  static const String allItemsLabel = 'All';
  static const String allItemsLabelEs = 'Todos';
  static const String serviceFilterLabelEs = 'Filtrar';
  static const String serviceFilterLabelEn = 'Filter';
  static const String applyFiltersLabel = 'Aplicar Filtros';
  static const String applyFiltersLabelEn = 'Apply Filters';
  static const String clearFiltersLabel = 'Eliminar Filtros';
  static const String clearFiltersLabelEn = 'Clear Filters';
  static const String modalDetailLabel = 'Ver detalle';
  static const String modalDetailLabelEn = 'View details';
  static const String modalArriveLabel = 'Cómo llegar';
  static const String modalArriveLabelEn = 'Get Directions';
  static const String visitDescription =
      'Descubre los puntos de interés que hacen de Alcalá de Henares un lugar lleno de historia, cultura y naturaleza. ¡Ven y explora los rincones más fascinantes de este destino único!';
  static const String visitDescriptionEn =
      'Discover the must-see spots that make Alcalá de Henares a place full of history, culture, and nature. Come and explore the most fascinating corners of this unique destination!';
  static const String whereToEatDescription =
      'Descubre los mejores restaurantes y bares de Alcalá de Henares, donde tradición y modernidad se encuentran para ofrecerte platos únicos.';
  static const String whereToEatDescriptionEn =
      'Discover the best restaurants and bars in Alcalá de Henares, where tradition and modernity come together to offer you unforgettable flavors.';
  static const String routesDescription =
      'Explora Alcalá de Henares a pie o en bicicleta y disfruta de rutas rodeadas de naturaleza';
  static const String routesDescriptionEn =
      'Explore Alcalá de Henares on foot or by bike and enjoy trails surrounded by nature.';
  static const String guidedToursDescription =
      'Descubre Alcalá de Henares de la mano de expertos, con recorridos únicos que te sumergirán en su historia, cultura y rincones más emblemáticos.';
  static const String guidedToursDescriptionEn =
      'Discover Alcalá de Henares with expert guides, through unique tours that immerse you in its history, culture, and most iconic spots';
  static const String incidentDescription =
      'Reporta incidencias en la vía pública de forma rápida y sencilla. Envía una descripción detallada y fotos georreferenciadas para contribuir a mejorar Alcalá de Henares';
  static const String incidentDescriptionEn =
      'Report public incidents quickly and easily. Send a detailed description and geotagged photos to help improve Alcalá de Henares.';
  static const String parkingDescription =
      'Accede en tiempo real a los aparcamientos disponibles en Alcalá de Henares. Olvídate de dar vueltas innecesarias y ahorra tiempo. ¡Encuentra, aparca y disfruta de tu día sin preocupaciones!';
  static const String parkingDescriptionEn =
      'Get real-time access to available parking spots in Alcalá de Henares. No more unnecessary driving—save time and park with ease. Find your spot, park, and enjoy your day stress-free!';
  static const String cellarDescription =
      'Sumérgete en la tradición vinícola de uno de los rincones con más encanto de Madrid. Recorre sus bodegas, conoce sus historias y déjate cautivar por los aromas y sabores de sus vinos únicos.';
  static const String cellarDescriptionEn =
      'Immerse yourself in the winemaking tradition of one of the most charming corners of Madrid. Tour its cellars, learn their stories, and be captivated by the aromas and flavors of their unique wines.';
  static const String parkingCapacityLabel = 'Capacidad del aparcamiento';
  static const String parkingCapacityLabelEn = 'Parking capacity';
  static const String occupancyPercentageLabel = 'Porcentaje de ocupación';
  static const String occupancyPercentageLabelEn = 'Occupancy rate';
  static const String parkingPaymentLabel = 'Reservar';
  static const String parkingPaymentLabelEn = 'Reserve';
  static const String parkingSpotLabel = 'Plazas Libres';
  static const String parkingSpotLabelEn = 'Parking Available Spots';
  static const String parkingFreeLabel = 'Gratuito';
  static const String parkingFreeLabelEn = 'Free';
  static const String parkingPaidLabel = 'De Pago';
  static const String parkingPaidLabelEn = 'Paid';
  static const String parkingPriceLabel = 'Precio';
  static const String parkingPriceLabelEn = 'Price';
  static const String servicesFilterItemsDesc = 'Servicios';
  static const String servicesFilterItemsDescEn = 'Services';
  static const String placesFilterItemsDesc = 'Sitios de interés';
  static const String placesFilterItemsDescEn = 'Interest places';
  static const String spanish = 'ES';
  static const String english = 'EN';
  static const String accessiblePreferenceLabel =
      '¿Quieres activar la versión accesible para personas con dificultades visuales?';
  static const String accessibleYesLabel = 'Sí';
  static const String accessibleNoLabel = 'No';
  static const String yesConfirmLabel = 'Sí';
  static const String yesConfirmLabelEn = 'Yes';
  static const String noConfirmLabel = 'No';
  static const String noConfirmLabelEn = 'No';
  static const String accessibleKey = 'accessible';
  static const String languageKey = 'language';
  static const String notificationsKey = 'notifications';
  static const String bluetoothKey = 'bluetooth';
  static const String servicesKey = 'services';
  static const String planKey = 'plan';
  static const String notificationSettingsLabel = 'Notificaciones';
  static const String notificationSettingsLabelEn = 'Notifications';
  static const String bluetoothSettingsLabel = 'Bluetooth';
  static const String bluetoothSettingsLabelEn = 'Bluetooth';
  static const String loginSettingsLabel = 'Iniciar sesión';
  static const String loginSettingsLabelEn = 'Login';
  static const String logoutSettingsLabel = 'Cerrar Sesión';
  static const String logoutSettingsLabelEn = 'Log Out';
  static const String logoutContentLabel = '¿Deseas cerrar sesión?';
  static const String logoutContentLabelEn = 'Do you want to log out?';
  static const String accessibleModeSettingsLabel = 'Modo Accesible';
  static const String accessibleModeSettingsLabelEn = 'Accessible Mode';
  static const String enablenotifSettingsLabel = 'Habilitar Notificaciones';
  static const String enablenotifSettingsLabelEn = 'Enable Notifications';
  static const String enableBtSettingsLabel =
      'Bluetooth para detección de Beacons';
  static const String enableBtSettingsLabelEn =
      'Bluetooth for beacons detection';
  static const String loginDescSettingsLabel = 'Sesión iniciada';
  static const String loginDescSettingsLabelEn = 'Session Active';
  static const String enableAccessibleSettingsLabel = 'Modo Accesible';
  static const String enableAccessibleSettingsLabelEn = 'Accessible Mode';
  static const String accessiblePreferenceKey = 'accessibleMode';
  static const String planEmptyPlacesLabel =
      'Cuando agregues algunos sitios de interés a tu plan de viaje, aparecerán aquí';
  static const String planEmptyPlacesLabelEn =
      'When you add some points of interest to your travel plan, they will appear here';
  static const String placeAddedMsg = '¡Has agregado un nuevo lugar a tu plan!';
  static const String placeAddedMsgEn =
      'You have added a new place to your plan!';
  static const String planRemoveTitle = 'Eliminar del plan';
  static const String planRemoveTitleEn = 'Remove from plan';
  static const String planRemoveConfirmation =
      '¿Deseas eliminar éste lugar de tu plan?';
  static const String planRemoveConfirmationEn =
      'Do you want to remove this place from your plan?';
  static const String planEditHelpText =
      'Selecciona la nueva fecha de tu visita';
  static const String planEditHelpTextEn = 'Select the new date of your visit.';
  static const String planEditMsg = '¡Has modificado tu plan!';
  static const String planEditMsgEn = 'You have updated your plan!';
  static const String planTimeRequiredMsg =
      'Es necesario seleccionar una hora nueva de visita';
  static const String planTimeRequiredMsgEn =
      'It is necessary to select a new visit time.';
  static const String planDateRequiredMsg =
      'Es necesario seleccionar una nueva fecha de visita';
  static const String planDateRequiredMsgEn =
      'It is necessary to select a new visit date.';
  static const String reservationMessage =
      'Para realizar reservas, es necesario iniciar sesión:';
  static const String reservationMessageEn =
      'To make reservations, you need to log in:';
  static const String reservationTimeRequiredMsg =
      'Se requiere seleccionar una hora para reservar';
  static const String reservationTimeRequiredMsgEn = 'You must select a time';
  static const String reservationDateRequiredMsg =
      'Se requiere seleccionar una fecha para reservar';
  static const String reservationDateRequiredMsgEn =
      'You must select a date to make a reservation';
  static const String incidentsAuthMessage =
      'Para reportar incidencias, es necesario iniciar sesión:';
  static const String incidentsAuthMessageEn =
      'To report incidents, you need to log in:';
  static const String offersMessage =
      'Para usar ofertas es necesario iniciar sesión:';
  static const String offersMessageEn = 'To use offers you need to log in:';
  static const String surveyTitle = 'Encuesta Turística';
  static const String surveyTitleEn = 'Tourism Survey';
  static const String surveyScreenTitle = 'Encuestas de Turismo';
  static const String surveyScreenTitleEn = 'Tourism Surveys';
  static const String surveyDescSubtitle = 'Mejoremos juntos el turismo local';
  static const String surveyDescSubtitleEn = 'Help us improve local tourism';
  static const String surveyDescription =
      'Te invitamos a responder una breve encuesta para ayudarnos a mejorar la oferta turística de Alcalá de Henares. Tus respuestas serán tratadas de forma anónima y confidencial.';
  static const String surveyDescriptionEn =
      'We kindly invite you to answer a short survey to help us enhance the tourism offer in Alcalá de Henares. Your responses will be treated anonymously and confidentially.';
  static const String surveyGeneralInfo = 'Datos Generales';
  static const String surveyGeneralInfoEn = 'General Information';
  static const String surveyVisitInfo = 'Características de la visita';
  static const String surveyVisitInfoEn = 'Visit Details';
  static const String surveySelectHint = 'Selecciona';
  static const String surveySelectHintEn = 'Select';
  static const String surveyResidence =
      '¿Eres residente de Alcalá de Henares?';
  static const String surveyResidenceEn =
      'Are you a resident of Alcalá de Henares?';
  static const String surveyAge = 'Edad';
  static const String surveyAgeEn = 'Age';
  static const String surveyGender = 'Sexo';
  static const String surveyGenderEn = 'Gender';
  static const String surveyCountry = 'País';
  static const String surveyCountryEn = 'Country';
  static const String surveyAutCommunities = 'Comunidad Autónoma';
  static const String surveyAutCommunitiesEn = 'Autonomous Community';
  static const String surveyTransportation =
      '¿Cómo llegaste a Alcalá de Henares?';
  static const String surveyTransportationEn =
      'How did you get to Alcalá de Henares?';
  static const String surveyFirstTime =
      '¿Primera visita a Alcalá de Henares?';
  static const String surveyFirstTimeEn =
      'First visit to Alcalá de Henares?';
  static const String surveyPlannedStay = 'Tiempo de estancia estimado';
  static const String surveyPlannedStayEn = 'Planned length of stay';
  static const String surveyVisitReason = 'Motivo de la visita';
  static const String surveyVisitReasonEn = 'Reason for the visit';
  static const String surveyDiscoveryMethod =
      '¿Cómo supiste de Alcalá de Henares?';
  static const String surveyDiscoveryMethodEn =
      'Where did you hear about Alcalá de Henares?';
  static const String surveyPlannedVisitQuestion =
      '¿Sabes qué lugares visitarás?';
  static const String surveyPlannedVisitQuestionEn =
      'Do you know which places you’ll visit?';
  static const String surveyRecommend =
      '¿Recomiendas Alcalá de Henares?';
  static const String surveyRecommendEn =
      'Would you recommend Alcalá de Henares?';
  static const String surveyTravelWithQuestion = '¿Con quién viajas?';
  static const String surveyTravelWithQuestionEn =
      'Who are you traveling with?';
  static const String surveyWillStayHereQuestion =
      '¿Te alojarás en Alcalá de Henares?';
  static const String surveyWillStayHereQuestionEn =
      'Will you stay in Alcalá de Henares?';
  static const String surveyAccommodationType = '¿Dónde te alojarás?';
  static const String surveyAccommodationTypeEn = 'Where will you stay?';
  static const String surveyFirstVisit =
      '¿Es tu primera visita a Alcalá de Henares?';
  static const String surveyFirstVisitEn =
      'Is this your first visit to Alcalá de Henares?';
  static const String surveyHowKnown =
      '¿Cómo te enteraste sobre Alcalá de Henares?';
  static const String surveyHowKnownEn =
      'How did you find out about Alcalá de Henares?';
  static const String surveyRating =
      'Evalúa los siguientes aspectos de Alcalá de Henares.';
  static const String surveyRatingEn =
      'Rate the following aspects of Alcalá de Henares.';
  static const String surveyTourismOffer = 'Oferta Turística';
  static const String surveyTourismOfferEn = 'Tourism Offer';
  static const String surveyTourismInformation = 'Información Turística';
  static const String surveyTourismInformationEn = 'Tourism Information';
  static const String surveyCleanlinessMaintenance = 'Limpieza y mantenimiento';
  static const String surveyCleanlinessMaintenanceEn =
      'Cleanliness and Maintenance';
  static const String surveyCommerceService = 'Atención En Comercios';
  static const String surveyCommerceServiceEn = 'Customer Service in Shops';
  static const String surveyTransportAccessibility =
      'Transporte y Accesibilidad';
  static const String surveyTransportAccessibilityEn =
      'Transport and Accessibility';
  static const String surveySafety = 'Seguridad';
  static const String surveySafetyEn = 'Safety';
  static const String surveyTouristSignage = 'Señalización Turística';
  static const String surveyTouristSignageEn = 'Tourist Signage';
  static const String surveySendLabel = 'Enviar Encuesta';
  static const String surveySendLabelEn = 'Submit Survey';
  static const String surveyIncompleteFieldsMsg =
      'Es necesario proporcionar los valores requeridos para continuar';
  static const String surveyIncompleteFieldsMsgEn =
      'It is necessary to provide the required values to continue';
  static const String surveyRatingMissingMsg =
      'Por favor, valora todos los aspectos antes de continuar.';
  static const String surveyRatingMissingMsgEn =
      'Please rate all aspects before continuing.';
  static const String surveySubmitted = '¡Encuesta enviada con éxito!';
  static const String surveySubmittedEn = 'Survey successfully submitted!';
  static const String surveyTitleDialog = '¡Gracias por tu tiempo!';
  static const String surveyTitleDialogEn = 'Thank you for your time!';
  static const String surveyDescriptionDialog =
      'Tu opinión nos ayuda a mejorar la experiencia de nuestros visitantes y el desarrollo turístico del municipio';
  static const String surveyDescriptionDialogEn =
      'Your feedback helps us improve the experience of our visitors and the tourism development of the municipality';
  static const String noSurveyLabel =
      'No hay encuestas disponibles. Por favor intenta más tarde.';
  static const String noSurveyLabelEn =
      'No surveys available. Please try later.';
  static const String restartSurvey = 'Reiniciar Encuesta';
  static const String restartSurveyEn = 'Restart Survey';

  // Survey Keys
  static const String surveyAgeKey = 'age';
  static const String surveyGenderKey = 'gender';
  static const String surveyResidentKey = 'resident';
  static const String surveyCountryKey = 'country';
  static const String surveyRecommendKey = 'recommend';
  static const String surveyAutCommunityKey = 'community';
  static const String surveyTravelWithKey = 'travel_with';
  static const String surveyArrivalTransportKey = 'transport_mode';
  static const String surveyPlannedStayKey = 'stay_duration';
  static const String surveyVisitReasonKey = 'visit_reason';
  static const String surveyKnowPlacesVisitKey = 'places_visit';
  static const String surveyAccommodationInSMVKey = 'accommodation_in_smv';
  static const String surveyAccommodationTypeKey = 'accommodation_type';
  static const String surveyFirstVisitKey = 'first_visit';
  static const String surveyHowKnownKey = 'how_known';
  static const String surveyTourismOfferKey = 'tourism_offer';
  static const String surveyTourismInformationKey = 'tourism_information';
  static const String surveyCleanlinessMaintenanceKey =
      'cleanliness_maintenance';
  static const String surveyCommerceServiceKey = 'commerce_service';
  static const String surveyTransportAccessibilityKey =
      'transport_accessibility';
  static const String surveySafetyKey = 'safety';
  static const String surveyTouristSignageKey = 'tourist_signage';
  static const String surveyCreatedAtKey = 'created_at';
  static const String surveyResultKey = 'result';
  static const String surveyResultEnKey = 'result_en';
  static const String surveyAnsweredKey = 'surveyAnswered';

  static const List<String> surveyAgeValues = [
    'Menor de 18 años',
    'Entre 18 y 30 años',
    'Entre 31 y 45 años',
    'Entre 46 y 60 años',
    'Más de 60 años',
  ];

  static const List<String> surveyAgeValuesEn = [
    'Under 18 years old',
    'Between 18 and 30 years old',
    'Between 31 and 45 years old',
    'Between 46 and 60 years old',
    'Over 60 years old',
  ];

  static const List<String> surveyGenderValues = [
    'Hombre',
    'Mujer',
    'Prefiero no decir',
  ];

  static const List<String> surveyGenderValuesEn = [
    'Male',
    'Female',
    'Prefer not to say',
  ];

  static const List<String> surveyResidencePlaceValues = [
    'Comunidad autónoma',
    'País',
    'Alcalá de Henares',
  ];

  static const List<String> surveyResidencePlaceValuesEn = [
    'Autonomous Community',
    'Country',
    'Alcalá de Henares',
  ];

  static const List<String> surveyCountries = [
    'Afganistán',
    'Albania',
    'Alemania',
    'Andorra',
    'Angola',
    'Antigua y Barbuda',
    'Arabia Saudita',
    'Argelia',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaiyán',
    'Bahamas',
    'Bangladés',
    'Barbados',
    'Baréin',
    'Bélgica',
    'Belice',
    'Benín',
    'Bielorrusia',
    'Birmania',
    'Bolivia',
    'Bosnia y Herzegovina',
    'Botsuana',
    'Brasil',
    'Brunéi',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Bután',
    'Cabo Verde',
    'Camboya',
    'Camerún',
    'Canadá',
    'Catar',
    'Chad',
    'Chile',
    'China',
    'Chipre',
    'Colombia',
    'Comoras',
    'Corea del Norte',
    'Corea del Sur',
    'Costa de Marfil',
    'Costa Rica',
    'Croacia',
    'Cuba',
    'Dinamarca',
    'Dominica',
    'Ecuador',
    'Egipto',
    'El Salvador',
    'Emiratos Árabes Unidos',
    'Eritrea',
    'Eslovaquia',
    'Eslovenia',
    'España',
    'Estados Unidos',
    'Estonia',
    'Esuatini',
    'Etiopía',
    'Filipinas',
    'Finlandia',
    'Fiyi',
    'Francia',
    'Gabón',
    'Gambia',
    'Georgia',
    'Ghana',
    'Granada',
    'Grecia',
    'Guatemala',
    'Guyana',
    'Guinea',
    'Guinea-Bisáu',
    'Guinea Ecuatorial',
    'Haití',
    'Honduras',
    'Hungría',
    'India',
    'Indonesia',
    'Irak',
    'Irán',
    'Irlanda',
    'Islandia',
    'Islas Marshall',
    'Islas Salomón',
    'Israel',
    'Italia',
    'Jamaica',
    'Japón',
    'Jordania',
    'Kazajistán',
    'Kenia',
    'Kirguistán',
    'Kiribati',
    'Kuwait',
    'Laos',
    'Lesoto',
    'Letonia',
    'Líbano',
    'Liberia',
    'Libia',
    'Liechtenstein',
    'Lituania',
    'Luxemburgo',
    'Madagascar',
    'Malasia',
    'Malaui',
    'Maldivas',
    'Malí',
    'Malta',
    'Marruecos',
    'Mauricio',
    'Mauritania',
    'México',
    'Micronesia',
    'Moldavia',
    'Mónaco',
    'Mongolia',
    'Montenegro',
    'Mozambique',
    'Namibia',
    'Nauru',
    'Nepal',
    'Nicaragua',
    'Níger',
    'Nigeria',
    'Noruega',
    'Nueva Zelanda',
    'Omán',
    'Países Bajos',
    'Pakistán',
    'Palaos',
    'Panamá',
    'Papúa Nueva Guinea',
    'Paraguay',
    'Perú',
    'Polonia',
    'Portugal',
    'Reino Unido',
    'República Centroafricana',
    'República Checa',
    'República del Congo',
    'República Democrática del Congo',
    'República Dominicana',
    'Ruanda',
    'Rumanía',
    'Rusia',
    'Samoa',
    'San Cristóbal y Nieves',
    'San Marino',
    'San Vicente y las Granadinas',
    'Santa Lucía',
    'Santo Tomé y Príncipe',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leona',
    'Singapur',
    'Siria',
    'Somalia',
    'Sri Lanka',
    'Sudáfrica',
    'Sudán',
    'Sudán del Sur',
    'Suecia',
    'Suiza',
    'Surinam',
    'Tailandia',
    'Tanzania',
    'Tayikistán',
    'Timor Oriental',
    'Togo',
    'Tonga',
    'Trinidad y Tobago',
    'Túnez',
    'Turkmenistán',
    'Turquía',
    'Tuvalu',
    'Ucrania',
    'Uganda',
    'Uruguay',
    'Uzbekistán',
    'Vanuatu',
    'Vaticano',
    'Venezuela',
    'Vietnam',
    'Yemen',
    'Yibuti',
    'Zambia',
    'Zimbabue',
  ];

  static const List<String> surveyCountriesEn = [
    'Afghanistan',
    'Albania',
    'Germany',
    'Andorra',
    'Angola',
    'Antigua and Barbuda',
    'Saudi Arabia',
    'Algeria',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bangladesh',
    'Barbados',
    'Bahrain',
    'Belgium',
    'Belize',
    'Benin',
    'Belarus',
    'Myanmar',
    'Bolivia',
    'Bosnia and Herzegovina',
    'Botswana',
    'Brazil',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Bhutan',
    'Cape Verde',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Qatar',
    'Chad',
    'Chile',
    'China',
    'Cyprus',
    'Colombia',
    'Comoros',
    'North Korea',
    'South Korea',
    'Ivory Coast',
    'Costa Rica',
    'Croatia',
    'Cuba',
    'Denmark',
    'Dominica',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'United Arab Emirates',
    'Eritrea',
    'Slovakia',
    'Slovenia',
    'Spain',
    'United States',
    'Estonia',
    'Eswatini',
    'Ethiopia',
    'Philippines',
    'Finland',
    'Fiji',
    'France',
    'Gabon',
    'Gambia',
    'Georgia',
    'Ghana',
    'Grenada',
    'Greece',
    'Guatemala',
    'Guyana',
    'Guinea',
    'Guinea-Bissau',
    'Equatorial Guinea',
    'Haiti',
    'Honduras',
    'Hungary',
    'India',
    'Indonesia',
    'Iraq',
    'Iran',
    'Ireland',
    'Iceland',
    'Marshall Islands',
    'Solomon Islands',
    'Israel',
    'Italy',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kyrgyzstan',
    'Kiribati',
    'Kuwait',
    'Laos',
    'Lesotho',
    'Latvia',
    'Lebanon',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Madagascar',
    'Malaysia',
    'Malawi',
    'Maldives',
    'Mali',
    'Malta',
    'Morocco',
    'Mauritius',
    'Mauritania',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Mozambique',
    'Namibia',
    'Nauru',
    'Nepal',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'Norway',
    'New Zealand',
    'Oman',
    'Netherlands',
    'Pakistan',
    'Palau',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Poland',
    'Portugal',
    'United Kingdom',
    'Central African Republic',
    'Czech Republic',
    'Republic of the Congo',
    'Democratic Republic of the Congo',
    'Dominican Republic',
    'Rwanda',
    'Romania',
    'Russia',
    'Samoa',
    'Saint Kitts and Nevis',
    'San Marino',
    'Saint Vincent and the Grenadines',
    'Saint Lucia',
    'Sao Tome and Principe',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Syria',
    'Somalia',
    'Sri Lanka',
    'South Africa',
    'Sudan',
    'South Sudan',
    'Sweden',
    'Switzerland',
    'Suriname',
    'Thailand',
    'Tanzania',
    'Tajikistan',
    'East Timor',
    'Togo',
    'Tonga',
    'Trinidad and Tobago',
    'Tunisia',
    'Turkmenistan',
    'Turkey',
    'Tuvalu',
    'Ukraine',
    'Uganda',
    'Uruguay',
    'Uzbekistan',
    'Vanuatu',
    'Vatican',
    'Venezuela',
    'Vietnam',
    'Yemen',
    'Djibouti',
    'Zambia',
    'Zimbabwe',
  ];

  static const List<String> surveyAutonomousCommunities = [
    'Andalucía',
    'Aragón',
    'Asturias',
    'Baleares',
    'Canarias',
    'Cantabria',
    'Castilla-La Mancha',
    'Castilla y León',
    'Cataluña',
    'Extremadura',
    'Galicia',
    'La Rioja',
    'Madrid',
    'Murcia',
    'Navarra',
    'País Vasco',
    'Valencia',
  ];

  static const List<String> surveyAutonomousCommunitiesEn = [
    'Andalusia',
    'Aragon',
    'Asturias',
    'Balearic Islands',
    'Canary Islands',
    'Cantabria',
    'Castilla-La Mancha',
    'Castile and León',
    'Catalonia',
    'Extremadura',
    'Galicia',
    'La Rioja',
    'Madrid',
    'Murcia',
    'Navarre',
    'Basque Country',
    'Valencian Community',
  ];

  static const List<String> surveyTransportValues = [
    'Vehículo Privado',
    'Autobus',
    'Taxi',
  ];

  static const List<String> surveyTransportValuesEn = [
    'Private Vehicle',
    'Bus',
    'Taxi',
  ];

  static const List<String> surveyYesNoValues = [
    'Sí',
    'No',
  ];

  static const List<String> surveyYesNoValuesEn = [
    'Yes',
    'No',
  ];

  static const List<String> surveyPlannedStayValues = [
    '1 día',
    '2 días',
    '3 días',
    'Más de una semana',
  ];

  static const List<String> surveyPlannedStayValuesEn = [
    '1 day',
    '2 days',
    '3 days',
    'More than a week',
  ];

  static const List<String> surveyVisitReasonValues = [
    'Turismo',
    'Deporte',
    'Ocio y Bienestar',
    'Negocios',
  ];

  static const List<String> surveyVisitReasonValuesEn = [
    'Tourism',
    'Sports',
    'Leisure and Wellness',
    'Business',
  ];

  static const List<String> surveyDiscoveryMethodValues = [
    'Redes Sociales',
    'Blogs',
    'Agencias de Viajes',
    'Amigos',
    'Web',
    'Aplicación',
  ];

  static const List<String> surveyDiscoveryMethodValuesEn = [
    'Social Media',
    'Blogs',
    'Travel Agencies',
    'Friends',
    'Web',
    'Application',
  ];

  static const List<String> surveyPlannedVisitQuestionLabelValues = [
    'Social Media',
    'Blogs',
    'Travel Agencies',
    'Friends',
    'Web',
    'Application',
  ];

  static const List<String> surveyTravelWithValues = [
    'A solas',
    'Con mi pareja',
    'Con mi familia',
    'Con amigo(s)',
  ];

  static const List<String> surveyTravelWithValuesEn = [
    'Alone',
    'With my partner',
    'With my family',
    'With friend(s)',
  ];

  static const List<String> surveyArrivalTransportValues = [
    'Vehículo Privado',
    'Autobus',
    'Taxi',
  ];

  static const List<String> surveyArrivalTransportValuesEn = [
    'Private Vehicle',
    'Bus',
    'Taxi',
  ];

  static const List<String> surveyAcommodationTypeValues = [
    'Hotel',
    'Casa Rural',
    'Camping',
    'Casa de amigos',
  ];

  static const List<String> surveyAcommodationTypeValuesEn = [
    'Hotel',
    'Rural House',
    'Camping',
    'Friend\'s House',
  ];

  static const String surveyFixedLabel = 'Encuesta de Satisfacción';
  static const String surveyFixedLabelEn = 'Satisfaction Survey';
  static const String surveyDialogTitle = '¡Tu opinión mejora la experiencia!';
  static const String surveyDialogTitleEn =
      'Your opinion enhances the experience!';
  static const String surveyDialogDesc =
      'Responde una breve encuesta y ayúdanos a hacer del turismo una experiencia aún mejor. ¡Solo te tomará un momento!';
  static const String surveyDialogDescEn =
      'Answer a brief survey and help us make tourism even better. It’ll only take a moment!';
  static const String surveyAnswerLabel = 'Responder';
  static const String surveyAnswerLabelEn = 'Answer';

  static const String planDialogTitle = 'Tienes un plan guardado en tu cuenta';
  static const String planDialogTitleEn =
      'You have a saved plan in your account';
  static const String planDialogDesc =
      'Hemos detectado que tienes un plan guardado en tu cuenta, pero también has guardado sitios de forma local en este dispositivo. ¿Cuál deseas conservar?';
  static const String planDialogDescEn =
      'We detected that you have a saved plan in your account, but you also have locally saved sites on this device. Which one do you want to keep?';
  static const String planUploadedMsg = 'Tu plan ha sido guardado con éxito';
  static const String planUploadedMsgEn =
      'Your plan has been successfully saved';
  static const String planKeepDeviceLabel = 'Plan Local';
  static const String planKeepDeviceLabelEn = 'Local Plan';
  static const String planCloudReplaceLabel = 'Plan en la nube';
  static const String planCloudReplaceLabelEn = 'Cloud Plan';
  static const String planResultMsg = 'resultMsg';
  static const String planResultMsgEn = 'resultMsgEn';

  static const String keepLocalPlan = 'localPlan';
  static const String replacePlan = 'replacePlan';

  static const String ratingMessage =
      'Para realizar valoraciones, es necesario iniciar sesión:';
  static const String ratingMessageEn = 'To make reviews, you need to log in:';
  static const String loginSettingsMessage =
      'Inicia sesión para enviar reseñas, consultar ofertas y reservar visitas';
  static const String loginSettingsMessageEn =
      'Log in to submit reviews, get offers and book visits.';
  static const String reservationSuccessfulMsg = '¡Reservación exitosa!';
  static const String reservationSuccessfulMsgEn = 'Successful reservation!';
  static const String reservationFailedMsg =
      'No fue posible realizar la reservación';
  static const String reservationFailedMsgEn = 'Successful reservation!';

  static const String addToPlanLoginMessage =
      'Para agregar sitios a tu plan, es necesario iniciar sesión:';
  static const String addToPlanLoginMessageEn =
      'To make reservations, you need to log in:';
  static const String noVacationDataLabel =
      'No hay días de vacaciones disponibles';
  static const String noVacationDataLabelEn =
      'There are no vacation days available.';
  static const String vacationDataLabel = 'Días de vacaciones';
  static const String vacationDataLabelEn = 'Vacation days';
  static const String ratingTitle = '¡Comparte Tu Valoración!';
  static const String ratingTitleEn = 'Share Your Review!';
  static const String ratingCTALabel = 'Califica tu experiencia';
  static const String ratingCTALabelEn = 'Rate Your Experience';
  static const String rateButtonLabel = 'Enviar valoración';
  static const String rateButtonLabelEn = 'Send your rate';
  static const String ratingNeededLabel =
      'Por favor, selecciona una puntuación entre 1 y 5 estrellas antes de enviar tu valoración.';
  static const String ratingNeededLabelEn =
      'Please select a rating between 1 and 5 stars before submitting.';
  static const String ratingSubmittedLabel =
      '¡Valoración enviada con éxito! Gracias por tu opinión.';
  static const String ratingSubmittedLabelEn =
      'Rating submitted successfully! Thank you for your feedback.';

  static const String noResultsLabel = 'Sin resultados';
  static const String noResultsLabelEn = 'No Results';
  static const String noResultsDescLabel =
      'Parece que no hay resultados que coincidan con los filtros que elegiste. ¡Intenta cambiar algunos filtros y seguro encuentras lo que buscas!';
  static const String noResultsDescLabelEn =
      'It looks like there are no results matching the filters you selected. Try adjusting some filters and you\'ll surely find what you\'re looking for!';
  static const String loginDialogTitle = 'Iniciar sesión';
  static const String loginDialogTitleEn = 'Login';
  static const String signUpUserTitle = 'Registro de Usuario';
  static const String signUpUserTitleEn = 'User Registration';
  static const String signUpUserDescription = 'Crea tu cuenta ahora';
  static const String signUpUserDescriptionEn = 'Create your account now';
  static const String signUpLabel = 'Registrarse';
  static const String signUpNameLabel = 'Nombre';
  static const String signUpNameLabelEn = 'Name';
  static const String signUpLastNameLabel = 'Apellido';
  static const String signUpLastNameLabelEn = 'Last Name';
  static const String signUpLabelEn = 'Sign Up';
  static const String signUpEmailLabel = 'Email';
  static const String signUpEmailLabelEn = 'Email';
  static const String signUpPhoneLabel = 'Teléfono';
  static const String signUpPhoneLabelEn = 'Phone number';
  static const String signUpPwdLabel = 'Contraseña';
  static const String signUpPwdLabelEn = 'Password';
  static const String signUpPwdConfLabel = 'Confirmar Contraseña';
  static const String signUpPwdConfLabelEn = 'Password Confirmation';
  static const String signUpSubmitLabel = 'Registrar Usuario';
  static const String signUpSubmitLabelEn = 'Register User';
  static const String signUpSuccess = 'Usuario registrado exitosamente';
  static const String signUpSuccessEn = 'User successfully registered';
  static const String signUpMessageKey = 'message_es';
  static const String signUpMessageEnKey = 'message_en';
  static const String signUpSuccessKey = 'success';
  static const String signUpErrorGenericMessage =
      'Ocurrió un error al registrar el usuario. Por favor, inténtalo de nuevo.';
  static const String signUpErrorGenericMessageEn =
      'An error occurred while registering the user. Please try again.';
  static const String loginSemanticLabel = 'Dialogo modal de inicio de sesion';
  static const String loginSemanticLabelEn = 'Login modal dialog';
  static const String shareLabel = 'Compartir';
  static const String shareLabelEn = 'Share';
  static const String openingLinkLabel = 'Abriendo enlace...';
  static const String openingLinkLabelEn = 'Opening link...';
  static const String errorOpeningLinkLabel = 'Error al abrir el enlace:';
  static const String errorOpeningLinkLabelEn = 'Error opening link:';
  static const String loginKey = 'login';
  static const String userIdKey = 'id_user';
  static const String userDataKey = 'userData';
  static const String userIdLoginKey = 'userId';
  static const String pwdKey = 'password';
  static const String succesfulLogin = '¡Sesión iniciada con éxito!';
  static const String succesfulLoginEn = 'Login Successful!';
  static const String failedLogin =
      'Sesión no iniciada. Valida tus credenciales e inténtalo nuevamente';
  static const String failedLoginEn =
      'Login failed. Please check your credentials and try again.';
  static const String requiredFieldMsg = 'Campo obligatorio';
  static const String requiredFieldMsgEn = 'Required field';
  static const String logoutMsg = 'Has cerrado la sesión';
  static const String logoutMsgEn = 'You have logged out';
  static const String offerStartDateLabel = 'Inicio de la Oferta';
  static const String offerStartDateLabelEn = 'Offer Start Date';
  static const String offerEndDateLabel = 'Fin de la Oferta';
  static const String offerEndDateLabelEn = 'Offer End Date';
  static const String offerQRCodeLabel = 'CÓDIGO DE LA PROMOCIÓN';
  static const String offerQRCodeLabelEn = 'OFFER QR CODE';

  // Hotels & Restaurants booking labels:
  static const String scheduleTitle = 'Horario y Vacaciones';
  static const String scheduleTitleEn = 'Opening Hours & Holidays';
  static const String peopleNumberLabel = 'Número de personas';
  static const String peopleNumberLabelEn = 'Number of people';
  static const String dateTimeLabel = 'Fecha y hora';
  static const String dateTimeLabelEn = 'Date and time';
  static const String dateTimeInLabel = 'Fecha de ingreso';
  static const String dateTimeInLabelEn = 'Check-in Date ';
  static const String dateTimeOutLabel = 'Fecha de salida';
  static const String dateTimeOutLabelEn = 'Check-out Date';
  static const String bookPlaceLabel = 'Reservar';
  static const String bookPlaceLabelEn = 'Book';
  static const String bookPlaceBtnLabel = 'Realizar reservación';
  static const String bookPlaceBtnLabelEn = 'Book';
  static const String commentLabel = 'Comentario (Opcional)';
  static const String commentLabelEn = 'Comment (Optional)';
  static const String incidentDescLabel = 'Describe brevemente la incidencia';
  static const String incidentDescLabelEn =
      'Briefly describe the issue you want to report.';
  static const String incidentNameHintLabel =
      'Proporciona un nombre para tu reporte';
  static const String incidentNameHintLabelEn =
      'Provide a name for your report';
  static const String incidentReasonHintLabel = 'Selecciona un motivo';
  static const String incidentReasonHintLabelEn = 'Select a reason';
  static const String sendIssueLabel = 'Enviar Incidencia';
  static const String sendIssueLabelEn = 'Send Incident Report';
  static const String incidentReasonNeededLabel =
      'Selecciona un motivo de incidencia.';
  static const String incidentReasonNeededLabelEn =
      'Select an incident reason from the dropdown.';
  static const String incidentFieldsMissingLabel =
      'Por favor, completa todos los campos del formulario antes de enviar la incidencia';
  static const String incidentFieldsMissingLabelEn =
      'Please complete all fields in the form before submitting the incident';
  static const String incidentNameMissingLabel =
      'Por favor, introduce un nombre para tu incidencia';
  static const String incidentNameMissingLabelEn =
      'Please enter a name for your incident';
  static const String incidentDescriptionMissingLabel =
      'Por favor, introduce una descripción de la incidencia encontrada';
  static const String incidentDescriptionMissingLabelEn =
      'Please enter a description of the incident you found';
  static const String incidentMapPointMissing =
      'Por favor, selecciona un punto en el mapa';
  static const String incidentMapPointMissingEn =
      'Please select a point on the map';
  static const String incidentImageMissingLabel =
      'Por favor, proporciona una imagen de la incidencia encontrada';
  static const String incidentImageMissingLabelEn =
      'Please provide an image of the issue found.';
  static const String incidentSendedLabel =
      '¡Tu reporte ha sido enviado correctamente!';
  static const String incidentSendedLabelEn =
      'Your report has been successfully submitted!';

  // Rewards screen hard-coded data:
  static const String noviceExplorer = 'Explorador Novato';
  static const String noviceExplorerEn = 'Novice Explorer';
  static const String noviceExplorerDesc =
      'Has detectado tu primer beacon. ¡El viaje apenas comienza!';
  static const String noviceExplorerDescEn =
      'You have detected your first beacon. The journey is just beginning!';
  static const String beaconHunter = 'Cazador de Beacons';
  static const String beaconHunterEn = 'Beacon hunter';
  static const String beaconHunterDesc =
      'Has encontrado 5 beacons. ¡Sigue explorando!';
  static const String beaconHunterDescEn =
      'You have found 5 beacons. Keep exploring!';
  static const String tirelessTraveller = 'Viajero Incansable';
  static const String tirelessTravellerEn = 'Tireless Traveller';
  static const String tirelessTravellerDesc =
      'Has detectado 10 beacons. ¡Nada te detiene!';
  static const String tirelessTravellerDescEn =
      'You have detected 10 beacons. Nothing can stop you!';
  static const String masterSignal = 'Señal Maestra';
  static const String masterSignalEn = 'Master Signal';
  static const String masterSignalDesc =
      'Has detectado 25 beacons en total. ¡Tu radar es imparable!';
  static const String masterSignalDescEn =
      'You have detected 20 beacons in total. Your radar is unstoppable!';
  static const String expertTracker = 'Rastreador Experto';
  static const String expertTrackerEn = 'Expert Tracker';
  static const String expertTrackerDesc =
      '50 beacons detectados. Tus pasos dejan huella.';
  static const String expertTrackerDescEn =
      '50 detected beacons. Your footprints are everywhere.';
  static const String localLegend = 'Leyenda Local';
  static const String localLegendEn = 'Local Legend';
  static const String localLegendDesc =
      '75 beacons encontrados. Eres parte del lugar.';
  static const String localLegendDescEn =
      '75 beacons found. You\'re part of the landscape now.';
  static const String territoryMaster = 'Maestro del Territorio';
  static const String territoryMasterEn = 'Master of the Territory';
  static const String territoryMasterDesc =
      '¡Has detectado todos los beacons disponibles! Tu mapa está completo.';
  static const String territoryMasterDescEn =
      'You\'ve detected every available beacon! Your map is complete.';
  static const String beaconsApiName = 'beacon';
  static const String beaconsEn = 'en';
  static const String beaconsEs = 'es';
  static const String beaconsRegisteredKey = 'registeredBeacons';

  // Alert messages:
  static const String restartDialogTitle = 'Reiniciar app';
  static const String restartDialogTitleEn = 'Restart app';
  static const String restartContent =
      'Para que los cambios aplicados surtan efecto, es necesario reiniciar la app';
  static const String restartContentEn =
      'To apply the changes, please restart the app';
  static const String cancel = 'Cancelar';
  static const String cancelEn = 'Cancel';
  static const String accept = 'Aceptar';
  static const String acceptEn = 'Ok';
  static const String restart = 'Reiniciar';
  static const String restartEn = 'Restart';
  static const String closeSession = 'Cerrar sesión';
  static const String closeSessionEn = 'Log out';
  static const String sectionPlacesKey = 'sectionPlaces';
  static const String sectionPlacesKeyEn = 'sectionPlacesEn';
  static const String videoKey = 'video';

  // Horizontal menu labels:
  static Map<int, Widget> menuItems = {
    0: MenuItem(
      icon: Icons.explore_outlined,
      label: AppConstants.visitMenuLabel,
      selected: false,
      onTap: () {},
    ),
    1: MenuItem(
      icon: Icons.map_outlined,
      label: AppConstants.mapMenuLabel,
      selected: false,
      onTap: () {},
    ),
    2: MenuItem(
      icon: Icons.list_outlined,
      label: AppConstants.planMenuLabel,
      selected: false,
      onTap: () {},
    ),
    3: MenuItem(
      icon: Icons.settings_outlined,
      label: AppConstants.settingsMenuLabel,
      selected: false,
      onTap: () {},
    ),
    4: MenuItem(
      icon: Icons.settings_outlined,
      label: AppConstants.settingsMenuLabel,
      selected: false,
      onTap: () {},
    ),
  };

  // Place types for use in whole app
  static Map<String, String> placeTypes = {
    placeApiType: 'Sitio de interés',
    eatApiType: 'Restaurante',
    sleepApiType: 'Alojamiento / Hotel',
    routeApiType: 'Ruta',
    eventApiType: 'Evento',
    experienceApiType: 'Experiencia',
    tourApiType: 'Visita guiada',
    cellarApiType: 'Bodega',
    shopApiType: 'Comercio',
  };

  static Map<String, String> placeTypesEn = {
    placeApiType: 'Place of interest',
    eatApiType: 'Restaurant',
    sleepApiType: 'Hotel',
    routeApiType: 'Route',
    eventApiType: 'Event',
    experienceApiType: 'Experience',
    tourApiType: 'Tour',
    cellarApiType: 'Cellar',
    shopApiType: 'Store',
  };

  static const String visitMenuLabel = 'Visitar';
  static const String visitMenuLabelEn = 'Visit';
  static const String mapMenuLabel = 'Mapa';
  static const String mapMenuLabelEn = 'Map';
  static const String achievmentsLabel = 'Logros';
  static const String achievmentsLabelEn = 'Rewards';
  static const String planMenuLabel = 'Mi plan';
  static const String planMenuLabelEn = 'My plan';
  static const String searchMenuLabel = 'Buscar';
  static const String searchMenuLabelEn = 'Search';
  static const String settingsMenuLabel = 'Ajustes';
  static const String settingsMenuLabelEn = 'Settings';

  // Types used for rating request body:
  static const String drupalPlace = 'place';
  static const String drupalRoute = 'route';
  static const String drupalTour = 'tour';
  static const String drupalExperience = 'exp';
  static const String drupalEvent = 'event';

  static const String planPlaceNameKey = 'placeName';
  static const String planPlaceLatKey = 'placeLatitude';
  static const String planPlaceLonKey = 'placeLongitude';
  static const String planVisitDateKey = 'visitDate';
  static const String planVisitTimeKey = 'visitTime';
  static const String planPlaceTypeKey = 'placeType';
}
