import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:super_network_image/super_network_image.dart';

import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/achievments_model.dart';
import 'package:valdeiglesias/models/card_model.dart';
import 'package:valdeiglesias/models/cellar_model.dart';
import 'package:valdeiglesias/models/eat_model.dart';
import 'package:valdeiglesias/models/experience_model.dart';
import 'package:valdeiglesias/models/filter_model.dart';
import 'package:valdeiglesias/models/guided_tours_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/map_model.dart';
import 'package:valdeiglesias/models/personalization_model.dart';
import 'package:valdeiglesias/models/plan_model.dart';
import 'package:valdeiglesias/models/rating_model.dart';
import 'package:valdeiglesias/models/route_model.dart';
import 'package:valdeiglesias/models/schedule_model.dart';
import 'package:valdeiglesias/models/section_model.dart';
import 'package:valdeiglesias/models/session_model.dart';
import 'package:valdeiglesias/models/shop_model.dart';
import 'package:valdeiglesias/models/sleep_model.dart';
import 'package:valdeiglesias/models/slogan_model.dart';
import 'package:valdeiglesias/models/static_banner_model.dart';
import 'package:valdeiglesias/models/survey_model.dart';
import 'package:valdeiglesias/models/visit_model.dart';
import 'package:valdeiglesias/models/document_model.dart';
import 'package:valdeiglesias/services/api_service.dart';
import 'package:valdeiglesias/services/notification_service.dart';
import 'package:valdeiglesias/services/device_info_service.dart';
import 'package:valdeiglesias/services/token_management_service.dart';
import 'package:valdeiglesias/beacon/beacon_service.dart';
import 'package:valdeiglesias/beacon/notifi_service.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/screens/home.dart';
import 'package:valdeiglesias/screens/loading.dart';
import 'package:valdeiglesias/screens/smart.dart';
import 'package:valdeiglesias/screens/smartQR.dart';
import 'package:valdeiglesias/screens/smartBeacon.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> initializeNotifications() async {
  try {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    // print('Estado actual de notificaciones: ${settings.authorizationStatus}');

    // Siempre solicitar permisos si no están autorizados
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      // print('Solicitando permisos de notificaciones...');
      NotificationSettings newSettings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      // print(
      //     'Nuevo estado de notificaciones: ${newSettings.authorizationStatus}');

      if (newSettings.authorizationStatus == AuthorizationStatus.authorized) {
        //await _setupNotifications();
      }
    } else {
      // print('Notificaciones ya autorizadas, configurando...');
    }
  } catch (e) {
    // print('Error initializing notifications: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var status = await Permission.bluetooth.request();

  // print("status 1 $status");

  status = await Permission.bluetoothConnect.request();
  // print("status 2 $status");

  status = await Permission.bluetoothScan.request();
  // print("status 3 $status");

  // Verificar si las notificaciones están habilitadas desde archivo local
  bool notificationsEnabled = true;
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/notifications_enabled.txt');
    
    if (await file.exists()) {
      final content = await file.readAsString();
      notificationsEnabled = content.trim() == 'true';
      print('🔍 Main - Estado desde archivo: $notificationsEnabled');
    } else {
      print('🔍 Main - Archivo no existe, usando true por defecto');
    }
  } catch (e) {
    print('🔍 Main - Error leyendo archivo: $e, usando true por defecto');
  }
  
  // Siempre solicitar permisos del sistema
  status = await Permission.notification.request();
  // print("status notification $status");

  // Solo inicializar servicios de notificación si están habilitadas EN LA APP
  if (notificationsEnabled) {
    print('🔍 Main - Inicializando servicios de notificación');
    // Inicializar servicios de notificación solo si están habilitadas
    await NotifiService.init();

    // Configurar el listener de notificaciones aquí
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationsService().showFlutterNotification(message);
    });

    await LocalNotificationsService().pushNotificationListener();

    // INITIALIZE LOCAL NOTIFICATION
    LocalNotificationsService().initializeNotifications();
  } else {
    print('🔍 Main - Servicios de notificación DESHABILITADOS');
  }

  // Solicitar permiso de cámara
  status = await Permission.camera.request();
  // print("status camera $status");

  // SAVING USER INFORMATION
  await SaveDeviceInfoService.saveDeviceInfo();

  // Inicializar servicios
  final apiService = ApiService();
  BeaconService? beaconService;

  // Inicializar el servicio de API
  apiService.startService();

  // Inicializar el servicio de beacons solo si las notificaciones están habilitadas
  if (notificationsEnabled) {
    beaconService = BeaconService();
    await beaconService.initialize();
  }

  // Suscribirse a cambios de idioma para actualizar los beacons
  apiService.languageStream.listen((String language) async {
    if (beaconService != null) {
      await beaconService.updateBeaconsFromApi();
    }
  });

  _createOrUpdateToken('es');

  // SuperNetworkImageCache config
  SuperNetworkImageCache.configure(
    duration: const Duration(days: 7),
  );
  runApp(const MyApp());
}

Future<void> _createOrUpdateToken(String language) async {
  final tokenService = TokenManagementService();
  await tokenService.createToken(language);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dmSans = GoogleFonts.dmSans();
    final inter = GoogleFonts.inter();

    // Tamaño mínimo estándar para la app (360x640 dp es un tamaño común)
    const double minWidth = 360.0;
    const double minHeight = 640.0;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SloganModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CardModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SloganModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SectionModel(),
        ),
        ChangeNotifierProvider<PlanModel>(
          create: (context) => PlanModel(),
        ),
        ChangeNotifierProvider<LanguageModel>(
          create: (context) => LanguageModel(),
        ),
        ChangeNotifierProvider<VisitModel>(
          create: (context) => VisitModel(),
        ),
        ChangeNotifierProvider<StaticBannerModel>(
          create: (context) => StaticBannerModel(),
        ),
        ChangeNotifierProvider<FilterModel>(
          create: (context) => FilterModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => RatingModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SessionModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AccessibleModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => RouteModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ShopModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SleepModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SurveyModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CellarModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => EatModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExperienceModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => GuidedToursModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ScheduleModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AchievmentsModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => MapModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PersonalizationModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DocumentModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appTitle,
        routes: {
          AppConstants.root: (_) => const Loading(),
          AppConstants.home: (_) => const Home(),
          '/smart': (_) => const Smart(),
          '/smartQR': (_) => const SmartQR(),
          '/smartBeacon': (_) => const SmartBeacon(), 
        },
        theme: ThemeData(
          primaryColor: AppConstants.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.contrast,
            brightness: Brightness.light,
          ),
          useMaterial3: false,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                const Color.fromRGBO(4, 134, 170, 1),
              ),
              textStyle: WidgetStateProperty.all<TextStyle>(
                dmSans.copyWith(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(10.0),
              ),
              elevation: WidgetStateProperty.all<double>(0.0),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
              ),
            ),
          ),
          scaffoldBackgroundColor: AppConstants.backgroundColor,
          textTheme: Theme.of(context).textTheme.copyWith(
              displaySmall: dmSans.copyWith(
                fontSize: 32.0,
                color: const Color.fromRGBO(70, 162, 85, 1.0),
                fontWeight: FontWeight.bold,
              ),
              headlineLarge: dmSans.copyWith(
                color: const Color.fromRGBO(70, 162, 85, 1.0),
                fontWeight: FontWeight.w900,
              ),
              headlineMedium: dmSans.copyWith(
                color: AppConstants.primary,
              ),
              headlineSmall: inter.copyWith(
                color: AppConstants.primary,
                fontWeight: FontWeight.w900,
              ),
              titleLarge: dmSans.copyWith(
                color: AppConstants.primary,
                fontWeight: FontWeight.bold,
              ),
              titleMedium: dmSans.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              titleSmall: dmSans.copyWith(
                color: Colors.white,
              ),
              bodyLarge: dmSans.copyWith(color: AppConstants.primary),
              bodyMedium: dmSans.copyWith(
                color: AppConstants.primary,
              ),
              bodySmall: dmSans.copyWith(
                color: AppConstants.primary,
                fontSize: 13.0,
              )),
          appBarTheme: AppBarTheme(
            color: const Color.fromRGBO(4, 134, 170, 1), // #B8223D 
            elevation: 0.0,
            toolbarHeight: 80.0,
            titleTextStyle: dmSans.copyWith(
              color: AppConstants.title,
              fontWeight: FontWeight.w600,
              fontSize: AppConstants.appBarTextSize,
            ),
            centerTitle: true,
            actionsIconTheme: const IconThemeData(color: AppConstants.primary),
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es'),
          Locale('en'),
        ],
        builder: (context, child) {
          // Obtener el tamaño real del dispositivo
          final mediaQuery = MediaQuery.of(context);
          final screenWidth = mediaQuery.size.width;
          final screenHeight = mediaQuery.size.height;

          // Calcular el tamaño efectivo (usar el máximo entre el real y el mínimo)
          final effectiveWidth = screenWidth < minWidth ? minWidth : screenWidth;
          final effectiveHeight = screenHeight < minHeight ? minHeight : screenHeight;

          // Limitar el escalado de texto para evitar overflow
          // textScaleFactor máximo de 1.2 (permite un 20% más grande que el estándar)
          final maxTextScaleFactor = 1.2;
          final textScaleFactor = mediaQuery.textScaleFactor > maxTextScaleFactor 
              ? maxTextScaleFactor 
              : mediaQuery.textScaleFactor;

          // Crear un MediaQuery con el tamaño efectivo y el escalado de texto limitado
          final adjustedMediaQuery = mediaQuery.copyWith(
            size: Size(effectiveWidth, effectiveHeight),
            textScaleFactor: textScaleFactor,
          );

          return MediaQuery(
            data: adjustedMediaQuery,
            child: child!,
          );
        },
      ),
    );
  }
}
