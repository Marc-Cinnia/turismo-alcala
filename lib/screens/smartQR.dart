import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class SmartQR extends StatefulWidget {
  const SmartQR({Key? key}) : super(key: key);

  @override
  State<SmartQR> createState() => _SmartQRState();
}

class _SmartQRState extends State<SmartQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  String? _lastScannedCode;
  DateTime? _lastScanTime;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    try {
      final status = await Permission.camera.status;
      if (status.isGranted) {
        setState(() {
          _hasPermission = true;
        });
      } else if (status.isDenied) {
        final result = await Permission.camera.request();
        if (result.isGranted) {
          setState(() {
            _hasPermission = true;
          });
        } else {
          setState(() {
            _hasPermission = false;
          });
        }
      } else {
        setState(() {
          _hasPermission = false;
        });
      }
    } catch (e) {
      print('❌ Error verificando permisos de cámara: $e');
      setState(() {
        _hasPermission = false;
      });
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller?.pauseCamera();
    }
    _controller?.resumeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (!mounted) return;
      
      try {
        final String? code = scanData.code;
        if (code != null && code.isNotEmpty) {
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
          
          // Pausar el escáner mientras se muestra el diálogo
          _controller?.pauseCamera();
          
          // Mostrar el diálogo
          _showQRCodeDialog(code);
        }
      } catch (e) {
        print('❌ Error procesando código QR: $e');
      }
    });
  }

  void _showPermissionDialog() {
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permiso de cámara requerido'),
        content: Text('Esta aplicación necesita acceso a la cámara para escanear códigos QR. Por favor, otorga el permiso en la configuración de la aplicación.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Abrir configuración'),
          ),
        ],
      ),
    );
  }

  void _showQRCodeDialog(String code) {
    if (!mounted) return;
    
    try {
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
                  // Reanudar el escáner
                  _controller?.resumeCamera();
                },
                child: Text(language.english ? 'Close' : 'Cerrar'),
              ),
              if (_isUrl(code))
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _launchUrl(code);
                    // Reanudar el escáner
                    _controller?.resumeCamera();
                  },
                  child: Text(language.english ? 'Open Link' : 'Abrir Enlace'),
                ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Limpiar historial y continuar escaneando
                  _lastScannedCode = null;
                  _lastScanTime = null;
                  _controller?.resumeCamera();
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
    } catch (e) {
      print('❌ Error mostrando diálogo QR: $e');
      // Reanudar el escáner en caso de error
      _controller?.resumeCamera();
    }
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
          
          // Área del escáner QR
          Expanded(
            child: Semantics(
              label: _hasPermission
                ? (language.english ? 'QR Code scanner camera view. Point camera at QR code to scan' : 'Vista de cámara del escáner QR. Apunta la cámara a un código QR para escanear')
                : (language.english ? 'QR Code scanner area. Camera permission required' : 'Área del escáner QR. Se requiere permiso de cámara'),
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
                  child: _hasPermission
                      ? QRView(
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                          overlay: QrScannerOverlayShape(
                            borderColor: AppConstants.primary,
                            borderRadius: 10,
                            borderLength: 30,
                            borderWidth: 10,
                            cutOutSize: 250,
                          ),
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
                                  Icons.camera_alt_outlined,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  language.english
                                      ? 'Camera permission required'
                                      : 'Se requiere permiso de cámara',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    _checkPermissions();
                                    if (!_hasPermission) {
                                      _showPermissionDialog();
                                    }
                                  },
                                  child: Text(language.english ? 'Grant Permission' : 'Otorgar Permiso'),
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
