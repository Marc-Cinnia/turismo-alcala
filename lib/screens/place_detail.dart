import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/models/cellar_model.dart';
import 'package:valdeiglesias/models/eat_model.dart';
import 'package:valdeiglesias/models/experience_model.dart';
import 'package:valdeiglesias/models/guided_tours_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/models/schedule_model.dart';
import 'package:valdeiglesias/models/shop_model.dart';
import 'package:valdeiglesias/models/sleep_model.dart';
import 'package:valdeiglesias/models/visit_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/utils/website_launcher.dart';
import 'package:valdeiglesias/widgets/detail_main_image.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/gallery.dart';
import 'package:valdeiglesias/widgets/rating_panel.dart';
import 'package:valdeiglesias/widgets/video_section.dart';
import 'package:valdeiglesias/widgets/wishlist_button.dart';

class PlaceDetail extends StatefulWidget {
  const PlaceDetail({
    super.key,
    required this.place,
    required this.placeEn,
    required this.accessible,
  });

  final Place place;
  final Place placeEn;
  final bool accessible;

  @override
  State<PlaceDetail> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  Widget imageContainer = const SizedBox();
  Widget subtitleSection = const SizedBox();
  Widget descriptionSection = const SizedBox();
  Widget videoSection = const SizedBox();
  Widget wishlistButton = const SizedBox();
  Widget contactSection = const SizedBox();
  Widget phoneNumber = const SizedBox();
  Widget website = const SizedBox();
  Widget address = const SizedBox();
  Widget mainContent = const Center(
    child: Text(AppConstants.valueNotAvailable),
  );
  Widget spacer = const SizedBox(height: AppConstants.spacing);
  Widget divider = const Divider();

  late String placeName;
  late String? subtitle;
  late String? description;
  late String? videoUrl;
  late String? phone;
  late String? websiteUrl;
  late String? addressDesc;
  late Widget mainImage;

  // Places used for plan:
  late List<Place> _cellars;
  late List<Place> _restaurants;
  late List<Place> _experiences;
  late List<Place> _guidedTours;
  late List<Place> _places;
  late List<Place> _routes;
  late List<Place> _events;
  late List<Place> _stores;
  late List<Place> _hotels;

  late LanguageModel _language;

  @override
  void initState() {
    mainImage = (widget.place.mainImageUrl != null)
        ? DetailMainImage(imageUrl: widget.place.mainImageUrl!)
        : const SizedBox();

    description = widget.place.longDescription;
    videoUrl = widget.place.videoUrl;
    phone = widget.place.phoneNumber;
    websiteUrl = widget.place.websiteUrl;
    addressDesc = widget.place.address;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _language = context.watch<LanguageModel>();

    _cellars = context.watch<CellarModel>().cellars;
    _restaurants = context.watch<EatModel>().placesToEat;
    _experiences = context.watch<ExperienceModel>().items;
    _guidedTours = context.watch<GuidedToursModel>().tours;
    _places = context.watch<VisitModel>().placesToVisit;
    _routes = context.watch<RouteModel>().routes;
    _events = context.watch<ScheduleModel>().eventSchedule;
    _stores = context.watch<ShopModel>().placesToShop;
    _hotels = context.watch<SleepModel>().placesToRest;

    placeName = (_language.english)
        ? widget.placeEn.placeNameEn
        : widget.place.placeName;
    subtitle =
        (_language.english) ? widget.placeEn.subtitle : widget.place.subtitle;

    _setSubtitle(subtitle);
    _setDescription();
    // _setWishlistButton(); // COMENTADO: Funcionalidad de estrella deshabilitada
    _setVideoSection(videoUrl);
    _setContactSection();
    _setMainContent();

    return Scaffold(
      appBar: AppBar(
        leading: Semantics(
          label: 'Botón para volver a la lista de lugares',
          hint: 'Toca para regresar a la lista de lugares',
          button: true,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppConstants.backArrowColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Semantics(
          label: 'Título del lugar: $placeName',
          child: DynamicTitle(
            value: placeName,
            accessible: widget.accessible,
          ),
        ),
        centerTitle: true,
        actions: ContentBuilder.getActions(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppConstants.spacing,
            right: AppConstants.spacing,
            top: AppConstants.spacing,
            bottom: AppConstants.contentBottomSpacing,
          ),
          child: Center(child: mainContent),
        ),
      ),
    );
  }

  void _setSubtitle(String? subtitle) {
    if (subtitle != null && subtitle.isNotEmpty) {
      subtitleSection = Padding(
        padding: const EdgeInsets.only(bottom: AppConstants.spacing),
        child:         Padding(
          padding: const EdgeInsets.only(
            top: AppConstants.spacing,
            left: AppConstants.spacing,
            right: AppConstants.spacing,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppConstants.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      );
    }
  }

  void _setDescription() {
    description = (widget.accessible)
        ? (_language.english)
            ? widget.placeEn.shortDescriptionEn
            : widget.place.shortDescription
        : (_language.english)
            ? widget.placeEn.longDescription
            : widget.place.longDescription;

    descriptionSection = Padding(
      padding: const EdgeInsets.only(
        top: AppConstants.spacing,
        left: AppConstants.spacing,
        right: AppConstants.spacing,
      ),
      child: Text(
        description!,
        style: (widget.accessible)
            ? Theme.of(context).textTheme.bodyLarge
            : Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.justify,
      ),
    );
  }

  // COMENTADO: Funcionalidad de estrella deshabilitada
  /*
  void _setWishlistButton() => wishlistButton = WishlistButton(
        place: widget.place,
        isTextButton: true,
      );
  */

  void _setVideoSection(String? videoUrl) {
    videoSection = const SizedBox();

    if (videoUrl != null) {
      VideoSection(videoUrl: videoUrl);
    }
  }

  void _setContactSection() {
    final title = (_language.english)
        ? AppConstants.contactSectionTitleEn
        : AppConstants.contactSectionTitle;

    contactSection = Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppConstants.spacing,
            left: AppConstants.spacing,
            right: AppConstants.spacing,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: AppConstants.primary),
            ),
          ),
        ),
        spacer,
        Column(
          children: [
            _getPhoneNumber(phone),
            _getWebsite(websiteUrl),
            _getAddress(addressDesc),
          ],
        ),
      ],
    );
  }

  void _setMainContent() {
    Widget map = const SizedBox();
    Widget gallery = const SizedBox();

    if (widget.place.latitude != null && widget.place.longitude != null) {
      map = SizedBox(
        height: AppConstants.mapHeight,
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  widget.place.latitude!,
                  widget.place.longitude!,
                ),
                initialZoom: AppConstants.mapInitialZoom,
              ),
              children: [
                TileLayer(
                  urlTemplate: AppConstants.urlTemplate,
                  userAgentPackageName: AppConstants.userAgentPackageName,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                          widget.place.latitude!, widget.place.longitude!),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: AppConstants.contrast,
                        size: AppConstants.markerSize,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (widget.place.imageUrls != null && widget.place.imageUrls!.isNotEmpty) {
      gallery = Gallery(imageUrls: widget.place.imageUrls!);
    }

    final ratingPanel = RatingPanel(
      drupalId: widget.place.placeId,
      drupalType: AppConstants.drupalPlace,
    );

    mainContent = Column(
      children: [
        Semantics(
          label: 'Imagen principal del lugar $placeName',
          child: mainImage,
        ),
        spacer,
        Semantics(
          label: 'Subtítulo del lugar',
          child: subtitleSection,
        ),
        spacer,
        Semantics(
          label: 'Descripción del lugar: $description',
          child: descriptionSection,
        ),
        spacer,
        Semantics(
          label: 'Botón para agregar a favoritos',
          child: wishlistButton,
        ),
        spacer,
        divider,
        spacer,
        Semantics(
          label: 'Información de contacto del lugar',
          child: contactSection,
        ),
        spacer,
        divider,
        spacer,
        Semantics(
          label: 'Mapa de ubicación del lugar',
          child: map,
        ),
        spacer,
        Semantics(
          label: 'Video del lugar',
          child: videoSection,
        ),
        spacer,
        Semantics(
          label: 'Galería de imágenes del lugar',
          child: gallery,
        ),
        Semantics(
          label: 'Panel de calificaciones y reseñas del lugar',
          child: ratingPanel,
        ),
      ],
    );
  }

  Widget _getPhoneNumber(String? phone) {
    if (phone != null && phone.isNotEmpty) {
      phoneNumber = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.phone,
            color: AppConstants.primary,
          ),
          const SizedBox(width: AppConstants.spacing),
          Text(widget.place.phoneNumber!),
        ],
      );
    }

    return phoneNumber;
  }

  Widget _getWebsite(String? websiteUrl) {
    if (websiteUrl != null && websiteUrl.isNotEmpty) {
      website = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            child: const Icon(
              Icons.link_rounded,
              color: AppConstants.lessContrast,
            ),
            onTap: () => WebsiteLauncher.launchWebsite(
              widget.place.websiteUrl!,
            ),
          ),
          const SizedBox(width: AppConstants.spacing),
          GestureDetector(
            child: Text(
              AppConstants.websiteLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppConstants.lessContrast,
                  ),
            ),
            onTap: () => WebsiteLauncher.launchWebsite(
              widget.place.websiteUrl!,
            ),
          ),
        ],
      );
    }

    return website;
  }

  Widget _getAddress(String? addressDesc) {
    if (addressDesc != null && addressDesc.isNotEmpty) {
      address = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_searching_outlined,
            color: AppConstants.primary,
          ),
          const SizedBox(width: AppConstants.spacing),
          Expanded(
            child: Text(
              addressDesc,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            ),
          ),
        ],
      );
    }

    return address;
  }

  Place? _getPlace(Place place) {
    Place? placeFiltered;

    switch (place.placeType) {
      case AppConstants.placeApiType:
        placeFiltered = _filterPlace(place);
        break;

      case AppConstants.experienceApiType:
        placeFiltered = _filterExperience(place);
        break;

      case AppConstants.eventApiType:
        placeFiltered = _filterEvent(place);
        break;

      case AppConstants.routeApiType:
        placeFiltered = _filterRoute(place);
        break;

      case AppConstants.eatApiType:
        placeFiltered = _filterRestaurant(place);
        break;

      case AppConstants.sleepApiType:
        placeFiltered = _filterHotel(place);
        break;

      case AppConstants.shopApiType:
        placeFiltered = _filterShop(place);
        break;

      case AppConstants.cellarApiType:
        placeFiltered = _filterCellar(place);
        break;

      case AppConstants.tourApiType:
        placeFiltered = _filterTour(place);
        break;
    }

    return placeFiltered;
  }

  Place? _filterPlace(Place planPlace) {
    if (_places.isNotEmpty) {
      return _places.firstWhere(
        (place) {
          if (place.placeId != null) {
            return place.placeId! == planPlace.placeId;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterExperience(Place experience) {
    if (_experiences.isNotEmpty) {
      return _experiences.firstWhere(
        (place) {
          if (place.placeId != null) {
            return place.placeId! == experience.placeId;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterEvent(Place planEvent) {
    if (_events.isNotEmpty) {
      return _events.firstWhere(
        (event) {
          if (event.placeId != null) {
            return event.placeId! == planEvent.placeId;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterRoute(Place planRoute) {
    if (_routes.isNotEmpty) {
      return _routes.firstWhere(
        (route) {
          if (route.placeId != null) {
            return route.placeId! == planRoute.placeId;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterRestaurant(Place planRestaurant) {
    if (_restaurants.isNotEmpty) {
      return _restaurants.firstWhere(
        (restaurant) {
          if (restaurant.placeId != null) {
            return restaurant.placeId! == planRestaurant.placeId;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterHotel(Place planHotel) {
    if (_hotels.isNotEmpty) {
      return _hotels.firstWhere(
        (hotel) {
          if (hotel.placeId != null) {
            return hotel.placeId! == planHotel.placeId;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterShop(Place planStore) {
    if (_stores.isNotEmpty) {
      return _stores.firstWhere(
        (store) {
          if (store.placeId != null) {
            return store.placeId! == planStore.placeId;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterCellar(Place planCellar) {
    if (_cellars.isNotEmpty) {
      return _cellars.firstWhere(
        (cellar) {
          if (cellar.placeId != null) {
            return cellar.placeId! == planCellar.placeId;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterTour(Place place) {
    if (_guidedTours.isNotEmpty) {
      return _guidedTours.firstWhere(
        (tour) {
          if (tour.placeId != null) {
            return tour.placeId! == place.placeId;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }
}
