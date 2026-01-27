import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:super_network_image/super_network_image.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../widgets/museal_place_bottom_sheet.dart';
import '../widgets/language_selector.dart';
import '../constants/app_constants.dart';
import '../models/language_model.dart';

// Función auxiliar para extraer valores de forma segura de los campos del lugar
// Maneja diferentes formatos de datos que pueden venir de la API
String getValue(dynamic field) {
  if (field == null) return ''; // Si el campo es nulo, devuelve cadena vacía
  if (field is List && field.isNotEmpty) {
    // Si es una lista con elementos, extrae el valor del primer elemento
    if (field[0] is Map) {
      // Para imágenes, buscar la URL directamente
      if (field[0]['url'] != null) {
        return field[0]['url'].toString();
      }
      // Para otros campos, buscar el valor
      if (field[0]['value'] != null) {
        return field[0]['value'].toString();
      }
    }
    return '';
  }
  if (field is Map && field['value'] != null) {
    // Si es un mapa con un campo 'value', extrae ese valor
    return field['value'].toString();
  }
  return '';
}

// Página principal que contiene el mapa de Alcalá de Henares
class MusealPage extends StatefulWidget {
  const MusealPage({super.key});

  @override
  State<MusealPage> createState() => _MusealPageState();
}

// Estado de la página del mapa
class _MusealPageState extends State<MusealPage> {
  // Controlador del mapa para manipular la vista
  final MapController _mapController = MapController();

  // Variables para la ubicación actual del usuario
  LatLng? _currentLocation;
  Timer? _locationTimer;
  bool _isLocationEnabled = false;

  // Límites geográficos de la zona de Alcalá de Henares que se muestra
  final LatLngBounds alcalaBounds = LatLngBounds(
    const LatLng(40.48246945985403, -3.3739781406686253), // Esquina suroeste
    const LatLng(40.48218468360424, -3.3688626878008407), // Esquina noreste
  );

  // Polígono que define la zona visible (área no oscurecida del mapa)
  late List<LatLng> visibleHole;

  // Lista de pines personalizados que se muestran en el mapa
  final List<LatLng> customPins = [];

  @override
  void initState() {
    super.initState();
    // Inicializa el polígono visible con coordenadas específicas de Alcalá
    // Por defecto, usa un rectángulo basado en alcalaBounds (en sentido horario)
    visibleHole = [
      LatLng(40.48246945985403, -3.3739781406686253), // Esquina inferior izquierda
      LatLng(40.48078515407561, -3.3728162635199426), // Esquina inferior derecha
      LatLng(40.48218468360424, -3.3688626878008407), // Esquina superior derecha
      LatLng(40.4839357631234, -3.370052860028945),   // Esquina superior izquierda
    ];
    
    // Establece los pines iniciales para los 5 itinerarios del museal
    setCustomPins([
      const LatLng(40.483500, -3.373000), // Itinerario 1a - VIA COMPLUTENSE MURALLA (centro del área verde)
      const LatLng(40.481547565650466, -3.3731284037538423), // Itinerario 1b - VIA COMPLUTENSE - C/ ANDRES SABORIT
      const LatLng(40.480788707550204, -3.370811547475487), // Itinerario 2 - CARDENAL SANDOVAL Y ROJAS - SAN JUAN - PLAZA SANTOS NIÑOS - CARDENAL CISNEROS
      const LatLng(40.48309124575193, -3.3708409805327118), // Itinerario 3 - C/ SAN BERNARDO
      const LatLng(40.47971243743543, -3.3684918154519), // Itinerario 4 - JARDIN DE LAS PALABRAS
    ]);
    
    // Inicializa la geolocalización - DESHABILITADO
    // _initializeLocation();
  }

  @override
  void dispose() {
    // Limpia el timer de ubicación cuando se destruye el widget
    _locationTimer?.cancel();
    super.dispose();
  }

  // Inicializa la geolocalización y solicita permisos
  Future<void> _initializeLocation() async {
    // Solicita permisos de ubicación
    final permission = await Permission.location.request();
    
    if (permission == PermissionStatus.granted) {
      // Verifica si los servicios de ubicación están habilitados
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      
      if (serviceEnabled) {
        setState(() {
          _isLocationEnabled = true;
        });
        
        // Obtiene la ubicación inicial
        await _getCurrentLocation();
        
        // Inicia el timer para actualizar la ubicación cada 10 segundos
        _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
          _getCurrentLocation();
        });
      } else {
        setState(() {
          _isLocationEnabled = false;
        });
      }
    } else {
      setState(() {
        _isLocationEnabled = false;
      });
    }
  }

  // Obtiene la ubicación actual del usuario
  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error obteniendo ubicación: $e');
    }
  }

  // Actualiza el polígono visible con cualquier lista de coordenadas
  void updateVisibleHole(List<LatLng> points) {
    setState(() {
      visibleHole = points;
    });
  }

  // Establece una lista completa de pines personalizados
  void setCustomPins(List<LatLng> points) {
    setState(() {
      customPins
        ..clear()        // Limpia los pines existentes
        ..addAll(points); // Añade los nuevos pines
    });
  }

  // Añade un pin personalizado individual
  void addCustomPin(LatLng point) {
    setState(() {
      customPins.add(point);
    });
  }

  // Es el promedio de todas las coordenadas del polígono
  LatLng get visibleHoleCentroid {
    double sumLat = 0; // Suma de latitudes
    double sumLng = 0; // Suma de longitudes
    for (final p in visibleHole) {
      sumLat += p.latitude;
      sumLng += p.longitude;
    }
    return LatLng(sumLat / visibleHole.length, sumLng / visibleHole.length);
  }

  // Calcula el rectángulo que contiene todo el polígono visible
  // Devuelve los valores mínimos y máximos de latitud y longitud
  ({double minLat, double maxLat, double minLng, double maxLng}) get visibleHoleBounds {
    double minLat = double.infinity;  // Latitud mínima
    double maxLat = -double.infinity; // Latitud máxima
    double minLng = double.infinity;  // Longitud mínima
    double maxLng = -double.infinity; // Longitud máxima
    
    // Recorre todos los puntos para encontrar los límites
    for (final p in visibleHole) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    return (minLat: minLat, maxLat: maxLat, minLng: minLng, maxLng: maxLng);
  }

  // Calcula el centro exacto del rectángulo que contiene el polígono
  // Útil para dividir el área en 4 partes iguales visualmente
  LatLng get visibleHoleBoxCenter {
    final b = visibleHoleBounds;
    return LatLng(
      (b.minLat + b.maxLat) / 2, // Centro vertical
      (b.minLng + b.maxLng) / 2, // Centro horizontal
    );
  }

  // Determina el itinerario basado en la posición del pin en la lista
  int getZoneNumber(LatLng pin) {
    // Busca el índice del pin en la lista de pines personalizados
    final index = customPins.indexOf(pin);
    
    // Asigna el itinerario basado en el índice del pin
    if (index == 0) {
      return 1; // Itinerario 1a - VIA COMPLUTENSE MURALLA
    } else if (index == 1) {
      return 2; // Itinerario 1b - VIA COMPLUTENSE - C/ ANDRES SABORIT
    } else if (index == 2) {
      return 3; // Itinerario 2 - CARDENAL SANDOVAL Y ROJAS - SAN JUAN - PLAZA SANTOS NIÑOS - CARDENAL CISNEROS
    } else if (index == 3) {
      return 4; // Itinerario 3 - C/ SAN BERNARDO
    } else if (index == 4) {
      return 5; // Itinerario 4 - JARDIN DE LAS PALABRAS
    } else {
      return 1; // Por defecto, Itinerario 1a
    }
  }

  // Obtiene el nombre del itinerario basado en el número
  String _getItineraryName(int itineraryNumber) {
    switch (itineraryNumber) {
      case 1:
        return 'Itinerario 1a - VIA COMPLUTENSE MURALLA';
      case 2:
        return 'Itinerario 1b - VIA COMPLUTENSE - C/ ANDRES SABORIT';
      case 3:
        return 'Itinerario 2 - CARDENAL SANDOVAL Y ROJAS - SAN JUAN - PLAZA SANTOS NIÑOS - CARDENAL CISNEROS';
      case 4:
        return 'Itinerario 3 - C/ SAN BERNARDO';
      case 5:
        return 'Itinerario 4 - JARDIN DE LAS PALABRAS';
      default:
        return 'Itinerario ${itineraryNumber}';
    }
  }

  // Obtiene la etiqueta del pin basada en el número del itinerario
  String _getItineraryPinLabel(int itineraryNumber) {
    switch (itineraryNumber) {
      case 1:
        return '1a';
      case 2:
        return '1b';
      case 3:
        return '2';
      case 4:
        return '3';
      case 5:
        return '4';
      default:
        return '${itineraryNumber}';
    }
  }

  // Maneja el evento de tocar un pin en el mapa
  // Navega a la página de zona correspondiente
  void onTapPin(LatLng pin) {
    final zoneNumber = getZoneNumber(pin);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ZonePage(zoneNumber: zoneNumber, center: pin),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Museal'),
        backgroundColor: const Color.fromRGBO(4, 134, 170, 1),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppConstants.backArrowColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          const LanguageSelector(),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Widget principal del mapa
          FlutterMap(
        mapController: _mapController,
        options: MapOptions(
              // Configuración inicial del mapa
              initialCenter: alcalaBounds.center, // Centro inicial
              initialZoom: 16.0,                  // Nivel de zoom inicial 
              maxZoom: 20,                        // Zoom máximo permitido
              minZoom: 3,                         // Zoom mínimo permitido
              initialRotation: 0,               // Rotación inicial del mapa (sin rotación)
              cameraConstraint: CameraConstraint.contain(bounds: alcalaBounds), // Limita la vista a los bounds
          interactionOptions: const InteractionOptions(
                // Permite zoom con pellizco, doble toque y rueda del ratón
            flags: InteractiveFlag.pinchZoom |
                InteractiveFlag.doubleTapZoom |
                InteractiveFlag.scrollWheelZoom,
          ),
        ),
        children: [
              // Capa de tiles (imágenes del mapa)
          TileLayer(
                urlTemplate: AppConstants.urlTemplate,
            userAgentPackageName: AppConstants.userAgentPackageName,
          ),
              // Capa de marcadores (pines con etiquetas de zona)
          MarkerLayer(
                rotate: true, // Los marcadores rotan con el mapa
            markers: customPins
                    .asMap()
                    .entries
                    .map((entry) {
                      final p = entry.value;
                      
                      return Marker(
                        point: p,           // Posición del marcador
                        width: 80,          // Ancho del marcador aumentado
                        height: 90,         // Alto del marcador aumentado
                      child: GestureDetector(
                          onTap: () => onTapPin(p), // Acción al tocar el pin
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Pin principal más grande
                            const Icon(
                          Icons.location_on,
                              color: const Color.fromRGBO(4, 134, 170, 1),
                              size: 60,
                            ),
                            // Etiqueta de itinerario centrada en el pin
                            Center(
                              child: Semantics(
                                label: _getItineraryName(entry.key + 1),
                                hint: 'Toca para explorar este itinerario',
                                button: true,
                                child: Text(
                                  _getItineraryPinLabel(entry.key + 1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 2,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      );
                    })
                .toList(),
          ),
          // Pin de ubicación actual del usuario - OCULTO
          /*
          if (_currentLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentLocation!,
                  width: 40,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(4, 134, 170, 1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(4, 134, 170, 1),
                          blurRadius: 8,
                          spreadRadius: 2,
          ),
        ],
          ),
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          */
        ],
          ),
          // Overlay que dibuja las líneas de división del mapa
          IgnorePointer(
            child: CustomPaint(
              painter: _CenterSplitPainter(), // Pintor personalizado para las líneas
              size: Size.infinite,
            ),
          ),
          // Indicador de estado de ubicación - COMENTADO
          /*
          Positioned(
            top: 50,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isLocationEnabled ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isLocationEnabled ? Icons.my_location : Icons.location_off,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isLocationEnabled ? 'GPS' : 'Sin GPS',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          */
        ],
      ),
    );
  }
}

// Pintor personalizado que dibuja las líneas de división del mapa
class _CenterSplitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Las líneas son invisibles - no se dibuja nada
    // Esto mantiene la funcionalidad pero sin mostrar las líneas
  }

  @override
  // No necesita repintar a menos que cambien las dimensiones
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Página de zona que muestra un mapa con lugares específicos de una zona
class ZonePage extends StatefulWidget {
  final int zoneNumber; // Número de la zona (1-4)
  final LatLng center; // Centro del mapa donde se enfoca la vista
  const ZonePage({super.key, required this.zoneNumber, required this.center});

  @override
  State<ZonePage> createState() => _ZonePageState();
}

// Estado de la página de zona
class _ZonePageState extends State<ZonePage> {
  final MapController _detailController = MapController(); // Controlador del mapa de detalle
  List<Map<String, dynamic>> _places = []; // Lista de lugares cargados desde la API
  
  // Variables para la ubicación actual del usuario
  LatLng? _currentLocation;
  Timer? _locationTimer;
  bool _isLocationEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPlaces(); // Carga los lugares al inicializar la página
    // _initializeLocation(); // Inicializa la geolocalización - DESHABILITADO
    
    // Escucha cambios de idioma para recargar los lugares
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final languageModel = Provider.of<LanguageModel>(context, listen: false);
      languageModel.addListener(_onLanguageChanged);
    });
  }

  @override
  void dispose() {
    // Limpia el timer de ubicación cuando se destruye el widget
    _locationTimer?.cancel();
    
    // Remueve el listener de idioma
    final languageModel = Provider.of<LanguageModel>(context, listen: false);
    languageModel.removeListener(_onLanguageChanged);
    
    super.dispose();
  }

  // Método que se ejecuta cuando cambia el idioma
  void _onLanguageChanged() {
    _loadPlaces(); // Recarga los lugares con el nuevo idioma
  }

  // Obtiene el título del itinerario basado en el número
  String _getItineraryTitle(int itineraryNumber) {
    switch (itineraryNumber) {
      case 1:
        return 'Itinerario 1a - VIA COMPLUTENSE MURALLA';
      case 2:
        return 'Itinerario 1b - VIA COMPLUTENSE - C/ ANDRES SABORIT';
      case 3:
        return 'Itinerario 2 - CARDENAL SANDOVAL Y ROJAS';
      case 4:
        return 'Itinerario 3 - C/ SAN BERNARDO';
      case 5:
        return 'Itinerario 4 - JARDIN DE LAS PALABRAS';
      default:
        return 'Itinerario ${itineraryNumber}';
    }
  }

  // Obtiene el polígono de la zona del itinerario
  List<LatLng> _getItineraryPolygon(int itineraryNumber) {
    switch (itineraryNumber) {
      case 1: // Itinerario 1a - VIA COMPLUTENSE MURALLA
        return [
          const LatLng(40.48203546622983, -3.3745609631793756), // Esquina inferior izquierda
          const LatLng(40.48401292192857, -3.3745609631793756), // Esquina superior izquierda
          const LatLng(40.48401292192857, -3.3704298523808434), // Esquina superior derecha
          const LatLng(40.48203546622983, -3.3704298523808434), // Esquina inferior derecha
        ];
      case 2: // Itinerario 1b - VIA COMPLUTENSE - C/ ANDRES SABORIT
        return [
          const LatLng(40.48231216504342, -3.3740351500958052), // Esquina superior izquierda
          const LatLng(40.48231216504342, -3.372454433569269),   // Esquina superior derecha (misma latitud)
          const LatLng(40.480691410189785, -3.372454433569269), // Esquina inferior derecha (misma longitud)
          const LatLng(40.480691410189785, -3.3740351500958052), // Esquina inferior izquierda (misma latitud)
        ];
      case 3: // Itinerario 2 - CARDENAL SANDOVAL Y ROJAS
        return [
          const LatLng(40.48162924477175, -3.3725388900133466), // Esquina superior izquierda
          const LatLng(40.48162924477175, -3.368815984029615),   // Esquina superior derecha (misma latitud)
          const LatLng(40.480139936187435, -3.368815984029615), // Esquina inferior derecha (misma longitud)
          const LatLng(40.480139936187435, -3.3725388900133466), // Esquina inferior izquierda (misma latitud)
        ];
      case 4: // Itinerario 3 - C/ SAN BERNARDO
        return [
          const LatLng(40.481913692188655, -3.368880223980963), // Esquina superior izquierda
          const LatLng(40.48359340540929, -3.368880223980963),  // Esquina superior derecha
          const LatLng(40.48359340540929, -3.3705243838820436), // Esquina inferior derecha
          const LatLng(40.481913692188655, -3.3705243838820436), // Esquina inferior izquierda
        ];
      case 5: // Itinerario 4 - JARDIN DE LAS PALABRAS
        return [
          const LatLng(40.479964257564895, -3.369501270653255), // Esquina superior izquierda
          const LatLng(40.479964257564895, -3.36726788788028),   // Esquina superior derecha (misma latitud)
          const LatLng(40.47904715047293, -3.36726788788028),   // Esquina inferior derecha (misma longitud)
          const LatLng(40.47904715047293, -3.369501270653255), // Esquina inferior izquierda (misma latitud)
        ];
      default:
        return [];
    }
  }

  // Carga los lugares desde la API de Alcalá de Henares
  Future<void> _loadPlaces() async {
    try {
      // Obtiene el idioma actual del provider
      final languageModel = Provider.of<LanguageModel>(context, listen: false);
      final currentLanguage = languageModel.currentLanguage;
      
      // Selecciona el endpoint apropiado basado en el idioma
      final apiEndpoint = currentLanguage == AppConstants.english 
          ? 'https://drupal.alcalahenares.auroracities.com/museal_en'
          : 'https://drupal.alcalahenares.auroracities.com/museal_es';
      
      // Realiza una petición GET a la API de lugares
      final response = await http.get(
        Uri.parse(apiEndpoint),
      );
      
      // Si la respuesta es exitosa (código 200)
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _places = data.cast<Map<String, dynamic>>(); // Convierte los datos a la lista de lugares
        });
      }
    } catch (e) {
      // En caso de error, no hace nada
    }
  }

  // Muestra el bottom sheet con información del lugar seleccionado
  void _showPlaceBottomSheet(BuildContext context, Map<String, dynamic> place) {
    const borderRadius = Radius.circular(AppConstants.borderRadius);
    const sheetBorderRadius = BorderRadius.only(
      topLeft: borderRadius,
      topRight: borderRadius,
    );

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true, // Permite que el bottom sheet crezca hacia arriba
      shape: const RoundedRectangleBorder(
        borderRadius: sheetBorderRadius,
      ),
      builder: (context) => PlaceBottomSheet(place: place),
    );
  }

  // Inicializa la geolocalización y solicita permisos
  Future<void> _initializeLocation() async {
    // Solicita permisos de ubicación
    final permission = await Permission.location.request();
    
    if (permission == PermissionStatus.granted) {
      // Verifica si los servicios de ubicación están habilitados
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      
      if (serviceEnabled) {
      setState(() {
          _isLocationEnabled = true;
        });
        
        // Obtiene la ubicación inicial
        await _getCurrentLocation();
        
        // Inicia el timer para actualizar la ubicación cada 10 segundos
        _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
          _getCurrentLocation();
        });
      } else {
        setState(() {
          _isLocationEnabled = false;
        });
      }
    } else {
      setState(() {
        _isLocationEnabled = false;
      });
    }
  }

  // Obtiene la ubicación actual del usuario
  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error obteniendo ubicación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de navegación superior
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstants.backArrowColor),
        leading: Semantics(
          label: 'Botón para volver al mapa principal desde el itinerario ${widget.zoneNumber}',
          hint: 'Toca para regresar al mapa general donde puedes ver todos los itinerarios',
          button: true,
          child: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppConstants.backArrowColor),
            onPressed: () {
              Navigator.pop(context); // Regresa a la página anterior
            },
          ),
        ),
        title: Text(_getItineraryTitle(widget.zoneNumber)),
        backgroundColor: const Color.fromRGBO(4, 134, 170, 1), // Color de fondo azul personalizado
        foregroundColor: Colors.white,      // Color del texto blanco
        actions: [
          const LanguageSelector(),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Widget principal del mapa de detalle
          FlutterMap(
        mapController: _detailController,
        options: MapOptions(
              initialCenter: widget.zoneNumber == 1
                  ? const LatLng(40.4835241940687, -3.3724954077801095) // Centro movido más hacia abajo para posicionar la línea inferior en el borde
                  : widget.zoneNumber == 2
                      ? const LatLng(40.4815277875, -3.3732675) // Centro del rectángulo del Itinerario 1b
                      : widget.zoneNumber == 3
                          ? const LatLng(40.48088459047959, -3.3706774370214808) // Centro del rectángulo del Itinerario 2
                          : widget.zoneNumber == 4 
                              ? const LatLng(40.48275354854847, -3.369702303931003) // Centro exacto del rectángulo del Itinerario 3
                              : widget.zoneNumber == 5
                                  ? const LatLng(40.47950570401941, -3.3683845792667675) // Centro del rectángulo del Itinerario 4
                                  : widget.center, // Centro en la ubicación seleccionada para otros itinerarios
              initialZoom: widget.zoneNumber == 1
                  ? 17.4  // Zoom ajustado para que las esquinas inferiores coincidan con la pantalla
                  : widget.zoneNumber == 2
                      ? 18.3  // Zoom más alto para ver solo el rectángulo del Itinerario 1b
                      : widget.zoneNumber == 3
                          ? 17.4  // Zoom reducido para ver el rectángulo del Itinerario 2
                          : widget.zoneNumber == 4 
                              ? 17.8  // Zoom exacto para ver el rectángulo completo del Itinerario 3
                              : widget.zoneNumber == 5
                                  ? 18.2  // Zoom alto para ver más cerca el Itinerario 4
                                  : 16.5, // Zoom normal para otros itinerarios
              maxZoom: 20,                 // Zoom máximo
              minZoom: widget.zoneNumber == 1
                  ? 17.4  // Zoom mínimo igual al inicial para el Itinerario 1a
                  : widget.zoneNumber == 2
                      ? 18.3  // Zoom mínimo igual al inicial para el Itinerario 1b
                      : widget.zoneNumber == 3
                          ? 17.4  // Zoom mínimo igual al inicial para el Itinerario 2
                          : widget.zoneNumber == 4 
                              ? 17.8  // Zoom mínimo igual al inicial para el Itinerario 3
                              : widget.zoneNumber == 5
                                  ? 18.2  // Zoom mínimo igual al inicial para el Itinerario 4
                                  : 17.0, // Zoom mínimo normal para otros itinerarios
              initialRotation: 0,        // Rotación inicial (sin rotación)
              cameraConstraint: CameraConstraint.unconstrained(), // Sin restricciones para permitir zoom libre en todos los itinerarios
          interactionOptions: const InteractionOptions(
                // Permite zoom y movimiento del mapa para poder hacer zoom en todas las partes
            flags: InteractiveFlag.pinchZoom |
                InteractiveFlag.pinchMove |
                InteractiveFlag.doubleTapZoom |
                InteractiveFlag.scrollWheelZoom |
                InteractiveFlag.drag |
                InteractiveFlag.flingAnimation,
          ),
        ),
        children: [
              // Capa de tiles (imágenes del mapa)
          TileLayer(
                urlTemplate: AppConstants.urlTemplate,
            userAgentPackageName: AppConstants.userAgentPackageName,
          ),
              // Capa de polígono de la zona del itinerario (comentado para quitar el recuadro)
          // PolygonLayer(
          //   polygons: [
          //     Polygon(
          //       points: _getItineraryPolygon(widget.zoneNumber),
          //       color: const Color.fromRGBO(23, 48, 80, 0.3), // Color azul semitransparente
          //       borderColor: const Color.fromRGBO(4, 134, 170, 1), // Borde azul sólido
          //       borderStrokeWidth: 3.0,
          //     ),
          //   ],
          // ),
              // Capa de marcadores
          MarkerLayer(
            markers: _places.map((place) {
                  try {
                        // Extrae las coordenadas del lugar
                    final location = place['field_museal_location'];
                    if (location != null && location is List && location.isNotEmpty) {
                      final locData = location[0];
                      if (locData != null && locData['lat'] != null && locData['lng'] != null) {
                        return Marker(
                          rotate: true,
                          point: LatLng(locData['lat'].toDouble(), locData['lng'].toDouble()),
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap: () {
                                  _showPlaceBottomSheet(context, place); // Muestra el bottom sheet al tocar
                            },
                            child: Semantics(
                              label: 'Escultura: ${getValue(place['title']).isNotEmpty ? getValue(place['title']) : 'Sin nombre'}',
                              hint: 'Toca para ver detalles de la escultura',
                              button: true,
                            child: const Icon(Icons.location_on, color: Color.fromRGBO(4, 134, 170, 1), size: 28),
                            ),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    print('Error procesando lugar: $e');
                  }
                  return null;
                }).where((marker) => marker != null).cast<Marker>().toList(),
          ),
          // Pin de ubicación actual del usuario - OCULTO
          /*
          if (_currentLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentLocation!,
                  width: 40,
                  height: 40,
              child: Container(
                decoration: BoxDecoration(
                      color: Color.fromRGBO(4, 134, 170, 1),
                      shape: BoxShape.circle,
                      border: Border.all(
                  color: Colors.white,
                        width: 3,
                      ),
                  boxShadow: [
                    BoxShadow(
                          color: Color.fromRGBO(4, 134, 170, 1),
                      blurRadius: 8,
                          spreadRadius: 2,
                    ),
                  ],
                ),
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: 20,
                            ),
                          ),
                        ),
              ],
                        ),
          */
                      ],
                    ),
          // Indicador de estado de ubicación - COMENTADO
          /*
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isLocationEnabled ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isLocationEnabled ? Icons.my_location : Icons.location_off,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isLocationEnabled ? 'GPS' : 'Sin GPS',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          */
        ],
      ),
    );
  }
}


// Página que muestra los detalles completos de un lugar específico
class PlaceDetailPage extends StatefulWidget {
  final Map<String, dynamic> place; // Datos del lugar seleccionado
  
  const PlaceDetailPage({super.key, required this.place});

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  Map<String, dynamic>? _currentPlace;
  bool _isLoading = false;
  String? _lastLoadedLanguage;
  static Map<String, List<dynamic>> _cachedData = {};

  @override
  void initState() {
    super.initState();
    _currentPlace = widget.place;
    
    // Carga inicial inmediata con datos existentes
    _loadPlaceDataIfNeeded();
    
    // Escucha cambios de idioma
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final languageModel = Provider.of<LanguageModel>(context, listen: false);
      languageModel.addListener(_onLanguageChanged);
    });
  }

  @override
  void dispose() {
    // Remueve el listener de idioma
    final languageModel = Provider.of<LanguageModel>(context, listen: false);
    languageModel.removeListener(_onLanguageChanged);
    super.dispose();
  }

  // Método que se ejecuta cuando cambia el idioma
  void _onLanguageChanged() {
    _loadPlaceDataIfNeeded(); // Recarga los datos con el nuevo idioma
  }

  // Carga los datos solo si es necesario (optimizado)
  Future<void> _loadPlaceDataIfNeeded() async {
    final languageModel = Provider.of<LanguageModel>(context, listen: false);
    final currentLanguage = languageModel.english ? 'en' : 'es';
    
    // Si ya tenemos los datos en el idioma correcto, no recargar
    if (_lastLoadedLanguage == currentLanguage && _currentPlace != null) {
      return;
    }
    
    // Si tenemos datos en caché, usarlos inmediatamente
    if (_cachedData.containsKey(currentLanguage)) {
      final placeId = getValue(widget.place['nid']);
      final foundPlace = _cachedData[currentLanguage]!.firstWhere(
        (place) => getValue(place['nid']) == placeId,
        orElse: () => widget.place,
      );
      
      setState(() {
        _currentPlace = foundPlace;
        _lastLoadedLanguage = currentLanguage;
      });
      return;
    }
    
    // Solo mostrar loading si no tenemos datos
    if (_currentPlace == null) {
      setState(() {
        _isLoading = true;
      });
    }
    
    try {
      // Carga todos los lugares en el idioma actual
      final apiEndpoint = currentLanguage == 'en' 
          ? 'https://drupal.alcalahenares.auroracities.com/museal_en'
          : 'https://drupal.alcalahenares.auroracities.com/museal_es';
      
      final response = await http.get(
        Uri.parse(apiEndpoint),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Guardar en caché
        _cachedData[currentLanguage] = data;
        
        // Busca el lugar específico por ID
        final placeId = getValue(widget.place['nid']);
        final foundPlace = data.firstWhere(
          (place) => getValue(place['nid']) == placeId,
          orElse: () => widget.place,
        );
        
        setState(() {
          _currentPlace = foundPlace;
          _lastLoadedLanguage = currentLanguage;
          _isLoading = false;
        });
      } else {
        // Si falla la carga, usa los datos originales
        setState(() {
          _currentPlace = widget.place;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error cargando datos del lugar: $e');
      // Si hay error, usa los datos originales
      setState(() {
        _currentPlace = widget.place;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si está cargando, muestra un indicador de carga
    if (_isLoading || _currentPlace == null) {
      return Scaffold(
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Extrae los datos del lugar de forma segura
    final title = getValue(_currentPlace!['title']) != '' ? getValue(_currentPlace!['title']) : 'Sin título';
    final description = getValue(_currentPlace!['field_museal_description']); // Descripción del lugar
    final address = getValue(_currentPlace!['field_museal_address']);         // Dirección
    final material = getValue(_currentPlace!['field_museal_material']);       // Material de construcción
    final measures = getValue(_currentPlace!['field_museal_measures']);       // Medidas
    final year = getValue(_currentPlace!['field_museal_year']);              // Año de construcción
    final sculptureInfo = getValue(_currentPlace!['field_museal_info_sculpture']); // Información de la escultura
    final mainImage = getValue(_currentPlace!['field_museal_main_image']);    // Imagen principal
    final reference = getValue(_currentPlace!['field_museal_reference']);     // Referencia bibliográfica
    final web = getValue(_currentPlace!['field_museal_web']);                // Enlace web
    
    // Obtiene la ID del lugar para el enlace de compartir
    final placeId = getValue(_currentPlace!['nid']) != '' ? getValue(_currentPlace!['nid']) : '1';
    
    // Extrae las coordenadas del lugar
    double? latitude;
    double? longitude;
    if (_currentPlace!['field_museal_location'] != null && _currentPlace!['field_museal_location'] is List && _currentPlace!['field_museal_location'].isNotEmpty) {
      final location = _currentPlace!['field_museal_location'][0];
      if (location is Map) {
        latitude = location['lat']?.toDouble();
        longitude = location['lng']?.toDouble();
      }
    }
    
    return Consumer<LanguageModel>(
      builder: (context, languageModel, child) {
        return Scaffold(
          body: Column(
        children: [
          // Header azul con flecha de volver, título y botón compartir
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(4, 134, 170, 1), // Color azul personalizado
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                // Fila con botón de volver y selector de idiomas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón de volver (encima del título)
                    Semantics(
                      label: 'Botón para volver al itinerario desde los detalles de esta escultura',
                      hint: 'Toca para regresar al itinerario donde encontraste esta escultura',
                      button: true,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: AppConstants.backArrowColor,
                          size: 28,
                        ),
                      ),
                    ),
                    // Selector de idiomas
                    const LanguageSelector(),
                  ],
                ),
              const SizedBox(height: 8),
                // Título
                Semantics(
                  label: 'Título del lugar: $title',
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
              ),
              const SizedBox(height: 16),
                // Botón compartir
                Align(
                  alignment: Alignment.centerLeft,
                  child: Consumer<LanguageModel>(
                    builder: (context, languageModel, child) {
                      final shareText = languageModel.english 
                          ? AppConstants.shareLabelEn 
                          : AppConstants.shareLabel;
                      
                      return Semantics(
                        label: 'Compartir ${title.isNotEmpty ? title : 'esta escultura'}',
                        hint: 'Toca para compartir el enlace de esta escultura por WhatsApp, email, SMS u otras aplicaciones',
                        button: true,
                        enabled: true,
                        focusable: true,
                        child: ElevatedButton.icon(
                          onPressed: () => _sharePlace(context, title, placeId),
                          icon: const Icon(Icons.share, color: Color.fromRGBO(4, 134, 170, 1)),
                          label: Text(
                            shareText,
                            style: const TextStyle(color: Color.fromRGBO(4, 134, 170, 1)),
                          ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Contenido principal en una sola columna
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 125), // Padding inferior para evitar el menú
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen principal (ahora dentro del scroll)
                  if (mainImage.isNotEmpty) ...[
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Altura adaptativa: más alta para verticales, más ancha para horizontales
                        final imageHeight = constraints.maxWidth * 1.4; // 120% del ancho para que las verticales se vean más grandes
                        return Container(
                          width: double.infinity,
                          height: imageHeight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SuperNetworkImage(
                              url: mainImage,
                              fit: BoxFit.contain, // Muestra la imagen completa sin recortar
                              placeholderBuilder: () => Container(
                                height: imageHeight,
                                color: Colors.grey.shade300,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Información de la escultura (destacada)
            if (sculptureInfo.isNotEmpty) ...[
                    Semantics(
                      label: 'Información destacada: $sculptureInfo',
                      child: Text(
                sculptureInfo,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.justify,
                      ),
              ),
              const SizedBox(height: 16),
            ],

                  // Descripción
                  if (description.isNotEmpty) ...[
                    Semantics(
                      label: 'Descripción: $description',
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.justify,
                      ),
              ),
              const SizedBox(height: 16),
            ],
            
                  // Referencia bibliográfica
                  if (reference.isNotEmpty || web.isNotEmpty) ...[
                    if (reference.isNotEmpty) ...[
                      Text(
                        reference,
                        style: const TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
              ),
              const SizedBox(height: 8),
                    ],
                    if (web.isNotEmpty) ...[
                      GestureDetector(
                        onTap: () => _launchUrl(web),
                        child: Text(
                          web,
                          style: const TextStyle(
                            fontSize: 13,
                            color:Color.fromRGBO(4, 134, 170, 1),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                  
                  // Características
                  if (year.isNotEmpty || material.isNotEmpty || measures.isNotEmpty) ...[
                    Semantics(
                      label: 'Características del lugar',
                      child: const Text(
                        'Características',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.grey),
              const SizedBox(height: 8),
                    
                    if (year.isNotEmpty)
                      _buildInfoItem(Icons.calendar_today, year),
                    if (material.isNotEmpty)
                      _buildInfoItem(Icons.category, material),
                    if (measures.isNotEmpty)
                      _buildInfoItem(Icons.straighten, measures),
                    
                    const SizedBox(height: 20),
                  ],
                  
                  // Información
                  if (address.isNotEmpty) ...[
                    Semantics(
                      label: 'Información del lugar',
                      child: const Text(
                        'Información',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 8),
                    
                    _buildInfoItem(Icons.location_on, address),
                    
                    const SizedBox(height: 20),
                  ],
                  
                  // Mapa del lugar
                  if (latitude != null && longitude != null) ...[
                    Semantics(
                      label: 'Ubicación del lugar en el mapa',
                      child: const Text(
                        'Ubicación',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
              ),
              const SizedBox(height: 8),
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(latitude, longitude),
                            initialZoom: 16.0,
                            interactionOptions: const InteractionOptions(
                              flags: InteractiveFlag.all,
                            ),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.museal',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(latitude, longitude),
                                  width: 30,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Color.fromRGBO(4, 134, 170, 1),
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // Si no hay coordenadas, mostrar mensaje
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_off, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'Ubicación no disponible',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ],
          ),
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  // Método auxiliar para construir elementos de información (estilo lista)
  Widget _buildInfoItem(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Color.fromRGBO(4, 134, 170, 1), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para compartir el lugar
  void _sharePlace(BuildContext context, String title, String placeId) async {
    // Obtener el idioma actual de la app
    final languageModel = Provider.of<LanguageModel>(context, listen: false);
    final isEnglish = languageModel.english;
    
    // Construye el enlace con la ID del lugar y el idioma correcto
    final languageSuffix = isEnglish ? 'en' : 'es';
    final shareUrl = 'https://drupal.alcalahenares.auroracities.com/web/index_$languageSuffix.html?id=$placeId';
    
    try {
      // Texto del mensaje de compartir
      final shareText = isEnglish 
          ? 'Check out this sculpture: $title'
          : 'Mira esta escultura: $title';
      
      // Comparte el enlace usando el selector del sistema
      await Share.share(
        '$shareText\n\n$shareUrl',
        subject: title,
      );
    } catch (e) {
      // Si hay error, muestra mensaje
      final errorMessage = isEnglish 
          ? 'Error sharing link:'
          : 'Error al compartir enlace:';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$errorMessage $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Método para abrir URLs
  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      
      // Intentar abrir directamente sin verificar canLaunchUrl
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched) {
        // Si falla, intentar con modo por defecto
        launched = await launchUrl(uri);
      }
      
      if (!launched) {
        // Si falla, intentar con modo platformDefault
        launched = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      }
      
      if (!launched) {
        throw Exception('No se pudo abrir la URL después de intentar todos los modos');
      }
    } catch (e) {
      throw Exception('Error al abrir URL: $e');
    }
  }
}
