import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/journey_point.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
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
import 'package:valdeiglesias/screens/sign_up_screen.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/widgets/login_form.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late LanguageModel _language;
  late SessionModel _session;
  late AccessibleModel _accessibleModel;
  bool _notificationsEnabled = true; // Valor inicial

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

  bool _planUploaded = false;
  List<JourneyPoint?> _userPlan = [];
  List<JourneyPoint?> _apiPlan = [];
  List<JourneyPoint> _placesToAdd = [];

  final divider = const Divider(height: 2.0);
  final spacer = const SizedBox(height: AppConstants.spacing);

  @override
  void initState() {
    super.initState();
    print('🚀 initState - Cargando estado de notificaciones...');
    _loadNotificationState();
  }

  Future<void> _loadNotificationState() async {
    print('🔍 _loadNotificationState - Cargando desde archivo local...');
    
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/notifications_enabled.txt');
      
      if (await file.exists()) {
        final content = await file.readAsString();
        final savedState = content.trim() == 'true';
        print('🔍 Estado guardado en archivo: $savedState');
        print('🔍 Contenido del archivo: "$content"');
        
        if (mounted) {
          setState(() {
            _notificationsEnabled = savedState;
          });
          print('🔍 Estado actualizado: $_notificationsEnabled');
        }
      } else {
        print('🔍 Archivo no existe, usando valor por defecto: true');
        if (mounted) {
          setState(() {
            _notificationsEnabled = true;
          });
        }
      }
    } catch (e) {
      print('🔍 Error cargando estado: $e');
      if (mounted) {
        setState(() {
          _notificationsEnabled = true;
        });
      }
    }
  }


  Future<void> _toggleNotifications(bool value) async {
    print('🔄 _toggleNotifications - Iniciando cambio a: $value');
    
    // Actualizar estado local primero
    setState(() {
      _notificationsEnabled = value;
    });
    print('🔍 Estado local actualizado: $_notificationsEnabled');
    
    // Guardar en archivo local
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/notifications_enabled.txt');
      await file.writeAsString(value.toString());
      print('✅ Estado guardado en archivo: $value');
      
      // Verificar que se guardó correctamente
      final content = await file.readAsString();
      print('🔍 Verificación archivo: $content');
    } catch (e) {
      print('🔍 Error guardando en archivo: $e');
    }
    
    // También guardar en SharedPreferences como backup
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    print('🔍 Backup en SharedPreferences: $value');
    
    if (value) {
      // Si se activan las notificaciones
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_language.english 
            ? 'Notifications enabled - Restart app to apply changes'
            : 'Notificaciones activadas - Reinicia la app para aplicar cambios'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // Si se desactivan las notificaciones
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_language.english 
            ? 'Notifications disabled - Restart app to apply changes'
            : 'Notificaciones desactivadas - Reinicia la app para aplicar cambios'),
          backgroundColor: AppConstants.primary,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _language = context.watch<LanguageModel>();
    _session = context.watch<SessionModel>();
    _accessibleModel = context.watch<AccessibleModel>();
    _userPlan = context.watch<PlanModel>().journeyPoints;
    _planUploaded = context.watch<PlanModel>().planUploaded;

    _cellars = context.watch<CellarModel>().cellars;
    _restaurants = context.watch<EatModel>().placesToEat;
    _experiences = context.watch<ExperienceModel>().items;
    _guidedTours = context.watch<GuidedToursModel>().tours;
    _places = context.watch<VisitModel>().placesToVisit;
    _routes = context.watch<RouteModel>().routes;
    _events = context.watch<ScheduleModel>().eventSchedule;
    _stores = context.watch<ShopModel>().placesToShop;
    _hotels = context.watch<SleepModel>().placesToRest;

    final accessibleLabel = (_language.english)
        ? AppConstants.accessibleModeSettingsLabelEn
        : AppConstants.accessibleModeSettingsLabel;

    final enableAccessibleLabel = (_language.english)
        ? AppConstants.enableAccessibleSettingsLabelEn
        : AppConstants.enableAccessibleSettingsLabel;

    final loginLabel = (_language.english)
        ? AppConstants.loginSettingsLabelEn
        : AppConstants.loginSettingsLabel;

    final loginDescription = (_language.english)
        ? AppConstants.loginDescSettingsLabelEn
        : AppConstants.loginDescSettingsLabel;

    return Scaffold(
      appBar: AppBar(
        actions: ContentBuilder.getActions(),
        iconTheme: IconThemeData(color: AppConstants.backArrowColor),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing),
          child: Column(
          children: [
            /*SettingsSection(
              title: accessibleLabel,
              subtitle: enableAccessibleLabel,
              preferenceName: AppConstants.accessibleKey,
              onChanged: (value) {
                _showConfirmDialog(value, context);
              },
              enabled: _accessibleModel.enabled,
            ),*/
             SettingsSection(
               key: ValueKey('notifications_$_notificationsEnabled'),
               title: _language.english ? 'Notifications' : 'Notificaciones',
               subtitle: _language.english 
                   ? 'Enable or disable push notifications'
                   : 'Activar o desactivar las notificaciones push',
               preferenceName: 'notifications_enabled',
               onChanged: (value) {
                 _toggleNotifications(value);
               },
               enabled: _notificationsEnabled,
             ),
            LocationBeaconsSection(),
            SettingsSection(
              title: loginLabel,
              subtitle: loginDescription,
              onChanged: (value) => _showModal(value, context),
              enabled: _session.isActive,
            ),
            SignUpSection(),
            // Espacio adicional al final para que el menú inferior no tape el contenido
            const SizedBox(height: 100),
          ],
        ),
      ),
      ),
    );
  }

  void _showConfirmDialog(bool switchValue, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            (_language.english)
                ? AppConstants.restartDialogTitleEn
                : AppConstants.restartDialogTitle,
          ),
          content: Text(
            (_language.english)
                ? AppConstants.restartContentEn
                : AppConstants.restartContent,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                (_language.english)
                    ? AppConstants.cancelEn
                    : AppConstants.cancel,
                style: GoogleFonts.dmSans().copyWith(
                  color: AppConstants.contrast,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Colors.white,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _setAccessiblePreference(
                !_accessibleModel.enabled,
              ),
              icon: const Icon(Icons.info_outline, color: Colors.white),
              label: Text(
                (_language.english)
                    ? AppConstants.restartEn
                    : AppConstants.restart,
                style: GoogleFonts.dmSans().copyWith(
                  color: const Color.fromARGB(255, 255, 255, 255),
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
    );
  }

  void _setAccessiblePreference(bool value) => _accessibleModel.setPreference(
        value,
      );

  void _showModal(bool switchValue, BuildContext context) {
    if (_session.isActive) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final dialogTitle = (_language.english)
              ? AppConstants.logoutSettingsLabelEn
              : AppConstants.logoutSettingsLabel;

          final dialogContent = (_language.english)
              ? AppConstants.logoutContentLabelEn
              : AppConstants.logoutContentLabel;

          final cancelLabel =
              (_language.english) ? AppConstants.cancelEn : AppConstants.cancel;

          final proceedLabel = (_language.english)
              ? AppConstants.closeSessionEn
              : AppConstants.closeSession;

          return AlertDialog(
            title: Text(dialogTitle),
            content: Text(
              dialogContent,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  cancelLabel,
                  style: GoogleFonts.dmSans().copyWith(
                    color: AppConstants.contrast,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<SessionModel>().logoutUser();
                  Navigator.pop(context);
                },
                child: Text(
                  proceedLabel,
                  style: GoogleFonts.dmSans().copyWith(
                    color: AppConstants.contrast,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ).then(
        (_) {
          if (!_session.isActive) {
            final logoutStatus = (_language.english)
                ? AppConstants.logoutMsgEn
                : AppConstants.logoutMsg;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(logoutStatus)),
            );

            if (_planUploaded) {
              final planSavedMsg = (_language.english)
                  ? AppConstants.planUploadedMsgEn
                  : AppConstants.planUploadedMsg;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(planSavedMsg),
                ),
              );
            }
          }
        },
      );
    } else {
      showDialog<List<JourneyPoint>?>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          String description = (_language.english)
              ? AppConstants.loginSettingsMessageEn
              : AppConstants.loginSettingsMessage;

          return LoginForm(descriptionMessage: description);
        },
      ).then(
        (apiPlan) async {
          if (apiPlan != null) {
            String message = '';

            if (_userPlan.isNotEmpty && apiPlan.isNotEmpty) {
              _apiPlan.clear();
              _apiPlan.addAll(apiPlan);
              _showReplacePlanDialog();
            } else if (apiPlan.isNotEmpty) {
              await _addCloudPlan(apiPlan);
            }

            if (_session.isActive) {
              message = (_language.english)
                  ? AppConstants.succesfulLoginEn
                  : AppConstants.succesfulLogin;
            } else {
              message = (_language.english)
                  ? AppConstants.failedLoginEn
                  : AppConstants.failedLogin;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        },
      );
    }
  }

  void _showReplacePlanDialog() async {
    String? actionSelected = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final dialogTitle = (_language.english)
            ? AppConstants.planDialogTitleEn
            : AppConstants.planDialogTitle;

        final dialogDescription = (_language.english)
            ? AppConstants.planDialogDescEn
            : AppConstants.planDialogDesc;

        return AlertDialog(
          title: Text(dialogTitle),
          content: Text(
            dialogDescription,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.primary,
                ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, AppConstants.keepLocalPlan),
              child: Text(
                (_language.english)
                    ? AppConstants.planKeepDeviceLabelEn
                    : AppConstants.planKeepDeviceLabel,
                style: GoogleFonts.dmSans().copyWith(
                  color: AppConstants.contrast,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, AppConstants.replacePlan),
              child: Text(
                (_language.english)
                    ? AppConstants.planCloudReplaceLabelEn
                    : AppConstants.planCloudReplaceLabel,
                style: GoogleFonts.dmSans().copyWith(
                  color: AppConstants.contrast,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (actionSelected != null) {
      Map<String, String>? resultMsgs = null;

      switch (actionSelected) {
        case AppConstants.keepLocalPlan:
          resultMsgs = await _backupUserPlan(_userPlan);
          break;

        case AppConstants.replacePlan:
          resultMsgs = await _addCloudPlan(_apiPlan);
          break;
      }

      if (resultMsgs != null) {
        String message = (_language.english)
            ? resultMsgs[AppConstants.planResultMsgEn]!
            : resultMsgs[AppConstants.planResultMsg]!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      }
    }
  }

  Future<Map<String, String>?> _backupUserPlan(List<JourneyPoint?> plan) async {
    if (plan.isNotEmpty && _session.credentials != null) {
      return await context
          .read<PlanModel>()
          .backupPlan(plan, _session.credentials!);
    }

    return null;
  }

  Future<Map<String, String>?> _addCloudPlan(List<JourneyPoint?> plan) async {
    Map<String, String>? resultMsgs;

    if (_placesToAdd.isNotEmpty) {
      _placesToAdd.clear();
    }

    for (final apiPlace in plan) {
      if (apiPlace != null) {
        final type = apiPlace.placeType;
        Place? placeFiltered;

        switch (type) {
          case AppConstants.placeApiType:
            placeFiltered = _filterPlace(apiPlace);
            break;

          case AppConstants.experienceApiType:
            placeFiltered = _filterExperience(apiPlace);
            break;

          case AppConstants.eventApiType:
            placeFiltered = _filterEvent(apiPlace);
            break;

          case AppConstants.routeApiType:
            placeFiltered = _filterRoute(apiPlace);
            break;

          case AppConstants.eatApiType:
            placeFiltered = _filterRestaurant(apiPlace);
            break;

          case AppConstants.sleepApiType:
            placeFiltered = _filterHotel(apiPlace);
            break;

          case AppConstants.shopApiType:
            placeFiltered = _filterShop(apiPlace);
            break;

          case AppConstants.cellarApiType:
            placeFiltered = _filterCellar(apiPlace);
            break;

          case AppConstants.tourApiType:
            placeFiltered = _filterTour(apiPlace);
            break;
        }

        _addJourneyPoint(placeFiltered, apiPlace);
      }
    }

    if (_placesToAdd.isNotEmpty) {
      resultMsgs = await context.read<PlanModel>().addAllToPlan(_placesToAdd);
    }

    return resultMsgs;
  }

  void _addJourneyPoint(Place? place, JourneyPoint planPlace) {
    if (place != null && place.placeId != null) {
      planPlace.id = place.placeId!;
      planPlace.placeName = place.placeName;
      planPlace.placeLatitude = place.latitude;
      planPlace.placeLongitude = place.longitude;

      if (!_placesToAdd.contains(planPlace)) {
        _placesToAdd.add(planPlace);
      }
    }
  }

  Place? _filterPlace(JourneyPoint apiPlace) {
    if (_places.isNotEmpty) {
      return _places.firstWhere(
        (place) {
          if (place.placeId != null) {
            return place.placeId! == apiPlace.id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterExperience(JourneyPoint apiPlace) {
    if (_experiences.isNotEmpty) {
      return _experiences.firstWhere(
        (place) {
          if (place.placeId != null) {
            return place.placeId! == apiPlace.id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterEvent(JourneyPoint apiPlace) {
    if (_events.isNotEmpty) {
      return _events.firstWhere(
        (event) {
          if (event.placeId != null) {
            return event.placeId! == apiPlace.id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterRoute(JourneyPoint apiPlace) {
    if (_routes.isNotEmpty) {
      return _routes.firstWhere(
        (route) {
          if (route.placeId != null) {
            return route.placeId! == apiPlace.id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterRestaurant(JourneyPoint apiPlace) {
    if (_restaurants.isNotEmpty) {
      return _restaurants.firstWhere(
        (restaurant) {
          if (restaurant.placeId != null) {
            return restaurant.placeId! == apiPlace.id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterHotel(JourneyPoint apiPlace) {
    if (_hotels.isNotEmpty) {
      return _hotels.firstWhere(
        (hotel) {
          if (hotel.placeId != null) {
            return hotel.placeId! == apiPlace.id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterShop(JourneyPoint apiPlace) {
    if (_stores.isNotEmpty) {
      return _stores.firstWhere(
        (store) {
          if (store.placeId != null) {
            return store.placeId! == apiPlace.id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterCellar(JourneyPoint apiPlace) {
    if (_cellars.isNotEmpty) {
      return _cellars.firstWhere(
        (cellar) {
          if (cellar.placeId != null) {
            return cellar.placeId! == apiPlace.id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }

  Place? _filterTour(JourneyPoint apiPlace) {
    if (_guidedTours.isNotEmpty) {
      return _guidedTours.firstWhere(
        (tour) {
          if (tour.placeId != null) {
            return tour.placeId! == apiPlace.id;
          }
          return false;
        },
        orElse: null,
      );
    }

    return null;
  }
}

class SignUpSection extends StatelessWidget {
  const SignUpSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageModel>();

    final title = (language.english)
        ? AppConstants.signUpUserTitleEn
        : AppConstants.signUpUserTitle;

    final description = (language.english)
        ? AppConstants.signUpUserDescriptionEn
        : AppConstants.signUpUserDescription;

    final signupLabel = (language.english)
        ? AppConstants.signUpLabelEn
        : AppConstants.signUpLabel;

    return Padding(
      padding: const EdgeInsets.all(
        AppConstants.spacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppConstants.contrast),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.cardBorderRadius,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppConstants.shortSpacing,
                bottom: AppConstants.shortSpacing,
              ),
              child: ListTile(
                title: Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                trailing: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen();
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.app_registration_outlined,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  label: Text(
                    signupLabel,
                    style: GoogleFonts.dmSans().copyWith(
                      color: const Color.fromARGB(255, 255, 255, 255),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationBeaconsSection extends StatelessWidget {
  const LocationBeaconsSection({super.key});

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageModel>();
    
    final title = language.english 
        ? 'Location and Beacons' 
        : 'Ubicación y Beacons';
    
    final subtitle = language.english
        ? 'Location and beacon configuration'
        : 'Configuración de la ubicación y beacons';
    
    final explanationTitle = language.english
        ? 'To receive notifications from nearby beacons:'
        : 'Para recibir notificaciones de los beacons cercanos:';
    
    final option1 = language.english
        ? 'With "Allow when using the app": You will receive notifications only when the app is open'
        : 'Con "Permitir en usar la app": Recibirás notificaciones solo con la app abierta';
    
    final option2 = language.english
        ? 'With "Allow always": You will receive notifications even in the background'
        : 'Con "Permitir siempre": Recibirás notificaciones incluso en segundo plano';
    
    final note = language.english
        ? 'For the best functioning of the app, review and grant all necessary permissions.'
        : 'Para el mejor funcionamiento de la app, revisa y concede todos los permisos necesarios.';
    
    final permissionsTitle = language.english
        ? 'Necessary permissions:'
        : 'Permisos necesarios:';
    
    final locationPermission = language.english
        ? 'Location'
        : 'Ubicación';
    
    final bluetoothPermission = 'Bluetooth';
    
    final notificationsPermission = language.english
        ? 'Notifications'
        : 'Notificaciones';
    
    final buttonText = language.english
        ? 'Review all permissions'
        : 'Revisar todos los permisos';

    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
                  color: AppConstants.contrast,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.cardBorderRadius,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    explanationTitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBulletPoint(option1, context),
                  const SizedBox(height: 8),
                  _buildBulletPoint(option2, context),
                  const SizedBox(height: 16),
                  Text(
                    note,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    permissionsTitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBulletPoint(locationPermission, context),
                  const SizedBox(height: 4),
                  _buildBulletPoint(bluetoothPermission, context),
                  const SizedBox(height: 4),
                  _buildBulletPoint(notificationsPermission, context),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _openAppSettings,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          AppConstants.contrast,
                        ),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: GoogleFonts.dmSans().copyWith(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class SettingsSection extends StatefulWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onChanged,
    required this.enabled,
    this.preferenceName,
  });

  final String title;
  final String subtitle;
  final String? preferenceName;
  final void Function(bool) onChanged;
  final bool enabled;

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        AppConstants.spacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppConstants.contrast),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.cardBorderRadius,
              ),
            ),
            child: ListTile(
              title: Text(
                widget.subtitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Switch(
                value: widget.enabled,
                onChanged: (value) {
                  print('🔧 Switch - Valor recibido: $value, Estado actual: ${widget.enabled}');
                  widget.onChanged(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
