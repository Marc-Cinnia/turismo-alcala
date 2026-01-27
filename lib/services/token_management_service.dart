import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:valdeiglesias/services/device_info_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManagementService {
  static const String baseUrl = 'https://drupal.alcalahenares.auroracities.com';
  static const String username = 'apiuser';
  static const String password = '5@9aT8soN1Nfpx&aMGAJy!CY';
  String? _sessionCookie;

  // Hacer login y obtener cookie de sesión
  Future<void> _doLogin() async {
    print('Iniciando login...');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/login?_format=json'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': username, 'pass': password}),
      );

      if (response.statusCode == 200) {
        _sessionCookie = response.headers['set-cookie'];
        print('Login exitoso, cookie obtenida');
      } else {
        throw Exception('Error en login: ${response.statusCode}');
      }
    } catch (e) {
      print('Error haciendo login: $e');
      rethrow;
    }
  }

  // Obtener token CSRF usando la cookie de sesión
  Future<String> getSessionToken() async {
    print('Iniciando getSessionToken...');
    try {
      // Si no tenemos cookie, hacer login primero
      if (_sessionCookie == null) {
        await _doLogin();
      }

      final response = await http.get(
        Uri.parse('$baseUrl/session/token'),
        headers: {
          'Accept': 'application/vnd.api+json',
          'Cookie': _sessionCookie ?? '',
        },
      );

      if (response.statusCode == 200) {
        print('Token CSRF obtenido con éxito');
        return response.body;
      }
      throw Exception('Error al obtener token CSRF');
    } catch (e) {
      print('Error obteniendo token CSRF: $e');
      // Si falla, resetear cookie e intentar de nuevo
      _sessionCookie = null;
      rethrow;
    }
  }

  // Nuevo método para obtener el estado actual de las notificaciones
  Future<bool> getNotificationsEnabled() async {
    print('Iniciando getNotificationsEnabled...');
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('notifications_enabled'));
    return prefs.getBool('notifications_enabled') ?? false;
  }

  // Nuevo método para establecer el estado de las notificaciones
  Future<void> setNotificationsEnabled(bool enabled) async {
    print('Iniciando setNotificationsEnabled...');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
  }

  // Verificar si existe el token del dispositivo
  Future<Map<String, dynamic>?> checkDeviceToken(String deviceId) async {
    print('Iniciando checkDeviceToken...');
    try {
      // Asegurar que tenemos sesión válida
      if (_sessionCookie == null) {
        await getSessionToken();
      }

      final response = await http.get(
        Uri.parse(
            '$baseUrl/jsonapi/node/tokens?filter[field_deviceid]=$deviceId'),
        headers: {
          'Accept': 'application/vnd.api+json',
          'Content-Type': 'application/vnd.api+json',
          'Cookie': _sessionCookie ?? '',
          'Authorization':
              'Basic ' + base64Encode(utf8.encode('$username:$password')),
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          await setNotificationsEnabled(true);
          print('Token del dispositivo encontrado');
          return data['data'][0];
        }
        await setNotificationsEnabled(false);
        print('Token del dispositivo no encontrado');
        return null;
      }
      return null;
    } catch (e) {
      print('Error verificando token del dispositivo: $e');
      return null;
    }
  }

  // Crear nuevo token
  Future<bool> createToken(String language) async {
    print('Iniciando createToken...');
    try {
      // Get device info
      String? deviceId = await SaveDeviceInfoService.getUserDeviceID();
      String? deviceName = await SaveDeviceInfoService.getUserDeviceName();
      String? fcmToken = await SaveDeviceInfoService.getFCMTokenApp();

      if (deviceId == null || fcmToken == null) {
        print('Error: Could not get device info or FCM token');
        await setNotificationsEnabled(false);
        return false;
      }

      // Get session token
      final sessionToken = await getSessionToken();

      print('Verificando si existe token del dispositivo...');
      final existingDevice = await checkDeviceToken(deviceId);
      print(
          'Resultado de verificación de dispositivo existente: $existingDevice');

      if (existingDevice != null) {
        print('Token de dispositivo encontrado, eliminando...');
        await deleteToken(sessionToken, existingDevice['id']);
        print('Token existente eliminado con éxito');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/jsonapi/node/tokens'),
        headers: {
          'Accept': 'application/vnd.api+json',
          'Content-Type': 'application/vnd.api+json',
          'X-CSRF-Token': sessionToken,
          'Cookie': _sessionCookie ?? '',
          'Authorization':
              'Basic ' + base64Encode(utf8.encode('$username:$password')),
        },
        body: json.encode({
          "data": {
            "type": "node--tokens",
            "attributes": {
              "title": deviceName ?? "Token Dispositivo",
              "field_deviceid": {"value": deviceId},
              "field_token": {"value": fcmToken},
              "field_langcode": {"value": language}
            }
          }
        }),
      );

      final success = response.statusCode == 201;
      await setNotificationsEnabled(success);
      if (success) {
        print('Token creado con éxito');
      } else {
        print('Error creando token: ${response.statusCode}');
        // Log the error response for debugging purposes
      }
      return success;
    } catch (e) {
      print('Error creando token: $e');
      // Log the error for debugging purposes
      await setNotificationsEnabled(false);
      return false;
    }
  }

  // Eliminar token
  Future<bool> deleteToken(
    String sessionToken, // Mantenemos el parámetro pero no lo usamos
    String tokenId,
  ) async {
    print('Iniciando deleteToken...');
    try {
      final result = await _deleteTokenFromServer(sessionToken, tokenId);
      if (result) {
        await setNotificationsEnabled(false);
        print('Token eliminado con éxito');
      }
      return result;
    } catch (e) {
      print('Error eliminando token: $e');
      return false;
    }
  }

  // Método privado para la eliminación real del token
  Future<bool> _deleteTokenFromServer(
      String sessionToken, String tokenId) async {
    print('Iniciando _deleteTokenFromServer...');

    final response = await http.delete(
      Uri.parse('$baseUrl/jsonapi/node/tokens/$tokenId'),
      headers: {
        'Accept': 'application/vnd.api+json',
        'Content-Type': 'application/vnd.api+json',
        'X-CSRF-Token': sessionToken,
        'Cookie': _sessionCookie ?? '',
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$username:$password')),
      },
    );

    return response.statusCode == 204;
  }
}
