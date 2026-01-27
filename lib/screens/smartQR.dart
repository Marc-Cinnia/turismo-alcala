import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:provider/provider.dart';

class SmartQR extends StatefulWidget {
  const SmartQR({Key? key}) : super(key: key);

  @override
  State<SmartQR> createState() => _SmartQRState();
}

class _SmartQRState extends State<SmartQR> {
  MobileScannerController? _scannerController;
  bool _isScanning = false;
  String? _lastScannedCode;
  DateTime? _lastScanTime;

  @override
  void initState() {
    super.initState();
    _initializeScanner();
  }

  void _initializeScanner() {
    try {
      _scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        torchEnabled: false,
      );
      print('📷 Mobile Scanner inicializado correctamente');
    } catch (e) {
      print('❌ Error inicializando Mobile Scanner: $e');
    }
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }

  void _toggleScanner() {
    setState(() {
      _isScanning = !_isScanning;
    });
    
    if (_isScanning) {
      print('📷 Iniciando escáner...');
      _restartScanner();
    } else {
      print('⏸️ Deteniendo escáner...');
    }
  }

  void _restartScanner() {
    print('🔄 Reiniciando escáner...');
    
    // Limpiar el último código escaneado para permitir re-escaneo
    _lastScannedCode = null;
    _lastScanTime = null;
    
    // Disposar el controlador actual
    _scannerController?.dispose();
    
    // Crear un nuevo controlador
    try {
      _scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        torchEnabled: false,
      );
      print('✅ Nuevo controlador de escáner creado');
    } catch (e) {
      print('❌ Error creando nuevo controlador: $e');
    }
  }

  void _showQRCodeDialog(String code) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final language = Provider.of<LanguageModel>(context, listen: false);
        return AlertDialog(
          title: Text(
            language.english ? 'QR Code Detected' : 'Código QR Detectado',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                language.english ? 'Content:' : 'Contenido:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppConstants.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: SelectableText(
                  code,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Reiniciar el escáner para permitir nueva detección
                _restartScanner();
              },
              child: Text(language.english ? 'Close' : 'Cerrar'),
            ),
            if (_isUrl(code))
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _launchUrl(code);
                },
                child: Text(language.english ? 'Open Link' : 'Abrir Enlace'),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Limpiar historial y continuar escaneando (sin reiniciar el escáner)
                _lastScannedCode = null;
                _lastScanTime = null;
                print('🔄 Historial limpiado, continuando escaneo...');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.contrastSoft,
              ),
              child: Text(language.english ? 'Scan Again' : 'Escanear de Nuevo'),
            ),
          ],
        );
      },
    );
  }

  bool _isUrl(String text) {
    return text.startsWith('http://') || 
           text.startsWith('https://') || 
           text.startsWith('www.');
  }

  Future<void> _launchUrl(String url) async {
    try {
      print('🔗 Intentando abrir URL: $url');
      
      // Limpiar la URL
      url = url.trim();
      
      // Validar que la URL no esté vacía
      if (url.isEmpty) {
        _showErrorDialog('La URL está vacía');
        return;
      }
      
      // Agregar protocolo si no lo tiene
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        if (url.startsWith('www.')) {
          url = 'https://$url';
        } else {
          url = 'https://$url';
        }
      }
      
      print('🔗 URL procesada: $url');
      
      final Uri uri = Uri.parse(url);
      
      // Verificar que la URI es válida
      if (uri.scheme.isEmpty) {
        _showErrorDialog('URL inválida: $url');
        return;
      }
      
      // Intentar abrir con diferentes modos
      bool launched = false;
      
      // Primero intentar con externalApplication
      if (await canLaunchUrl(uri)) {
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          launched = true;
          print('✅ URL abierta con externalApplication');
        } catch (e) {
          print('⚠️ Error con externalApplication: $e');
        }
      }
      
      // Si no funcionó, intentar con platformDefault
      if (!launched) {
        try {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
          launched = true;
          print('✅ URL abierta con platformDefault');
        } catch (e) {
          print('⚠️ Error con platformDefault: $e');
        }
      }
      
      // Si aún no funcionó, intentar con inAppWebView
      if (!launched) {
        try {
          await launchUrl(uri, mode: LaunchMode.inAppWebView);
          launched = true;
          print('✅ URL abierta con inAppWebView');
        } catch (e) {
          print('⚠️ Error con inAppWebView: $e');
        }
      }
      
      if (!launched) {
        _showErrorDialog('No se pudo abrir la URL: $url\n\nVerifica que la URL sea válida y que tengas una aplicación compatible instalada.');
      }
      
    } catch (e) {
      print('❌ Error abriendo URL: $e');
      _showErrorDialog('Error al abrir la URL: $e\n\nURL: $url');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<LanguageModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          language.english ? 'QR Scanner' : 'Escáner QR',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppConstants.contrastSoft,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppConstants.backArrowColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Información sobre el escáner
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
            decoration: BoxDecoration(
              color: AppConstants.primary.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  size: 36,
                  color: AppConstants.primary,
                ),
                SizedBox(height: 8),
                Text(
                  language.english 
                    ? 'Point your camera at a QR code to scan it'
                    : 'Apunta tu cámara a un código QR para escanearlo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 15),
          
          // Botón para activar/desactivar escáner
              Semantics(
                label: _isScanning
                  ? (language.english ? 'Stop QR Scanner button' : 'Botón para detener el escáner QR')
                  : (language.english ? 'Start QR Scanner button' : 'Botón para iniciar el escáner QR'),
                button: true,
                child: ElevatedButton.icon(
                  onPressed: _toggleScanner,
                  icon: Icon(_isScanning ? Icons.stop : Icons.qr_code_scanner, size: 20),
                  label: Text(
                    _isScanning
                      ? (language.english ? 'Stop Scanner' : 'Detener Escáner')
                      : (language.english ? 'Start Scanner' : 'Iniciar Escáner'),
                    style: TextStyle(fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isScanning ? Colors.red : AppConstants.primary,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
          
          SizedBox(height: 8),
          
          // Área del escáner QR
          Expanded(
            child: Semantics(
              label: _isScanning 
                ? (language.english ? 'QR Code scanner camera view. Point camera at QR code to scan' : 'Vista de cámara del escáner QR. Apunta la cámara a un código QR para escanear')
                : (language.english ? 'QR Code scanner area. Press start button to begin scanning' : 'Área del escáner QR. Presiona el botón iniciar para comenzar a escanear'),
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 5, 20, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppConstants.primary,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: _isScanning && _scannerController != null
                      ? MobileScanner(
                          controller: _scannerController!,
                          onDetect: (capture) {
                            final List<Barcode> barcodes = capture.barcodes;
                            for (final barcode in barcodes) {
                              if (barcode.rawValue != null) {
                                final String code = barcode.rawValue!;
                                final DateTime now = DateTime.now();
                                
                                // Evitar detecciones duplicadas (solo 1 segundo de cooldown)
                                if (_lastScannedCode == code && 
                                    _lastScanTime != null && 
                                    now.difference(_lastScanTime!).inSeconds < 1) {
                                  return;
                                }
                                
                                _lastScannedCode = code;
                                _lastScanTime = now;
                                
                                print('📱 QR detectado: $code');
                                _showQRCodeDialog(code);
                                // NO detener el escáner automáticamente
                                break;
                              }
                            }
                          },
                        )
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.qr_code_scanner,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  language.english 
                                    ? 'Press "Start Scanner" to begin'
                                    : 'Presiona "Iniciar Escáner" para comenzar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
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
