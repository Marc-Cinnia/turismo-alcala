import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'dart:ui' as ui;

class LanguageModel extends ChangeNotifier {
  LanguageModel() {
    _setLanguage();
  }

  final preferences = SharedPreferencesAsync();

  bool _english = false;
  String _currentLanguage = AppConstants.spanish;

  bool get english => _english;
  String get currentLanguage => _currentLanguage;

  void _setLanguage() async {
    // Siempre detectar el idioma del sistema al iniciar la app
    final systemLanguage = _detectSystemLanguage();
    _english = systemLanguage == AppConstants.english;
    _currentLanguage = systemLanguage;
    
    // Guardar el idioma detectado
    await preferences.setString(
      AppConstants.languageKey,
      _currentLanguage,
    );
    
    print('🌐 Idioma configurado: $_currentLanguage');
  }

  // Detecta el idioma del sistema del dispositivo
  String _detectSystemLanguage() {
    // Obtiene el idioma del sistema
    final systemLocale = ui.PlatformDispatcher.instance.locale;
    final languageCode = systemLocale.languageCode.toLowerCase();
    
    // Debug: Imprime el idioma detectado
    print('🔍 Idioma del sistema detectado: $languageCode');
    print('🔍 Locale completo: $systemLocale');
    
    // Lista de códigos de idioma que deben usar español
    final spanishLanguageCodes = ['es', 'es-es', 'es-mx', 'es-ar', 'es-co', 'es-ve', 'es-cl', 'es-pe', 'es-ec', 'es-uy', 'es-py', 'es-bo', 'es-cr', 'es-pa', 'es-gt', 'es-hn', 'es-sv', 'es-ni', 'es-cu', 'es-pr', 'es-do'];
    
    // Lista de códigos de idioma que deben usar inglés
    final englishLanguageCodes = ['en', 'en-us', 'en-gb', 'en-ca', 'en-au', 'en-nz', 'en-ie', 'en-za', 'en-in', 'en-sg', 'en-hk', 'en-ph', 'en-my', 'en-th', 'en-id', 'en-vn', 'en-kr', 'en-jp', 'en-cn', 'en-tw', 'en-hk'];
    
    // Si el idioma del sistema es español, usar español
    if (spanishLanguageCodes.contains(languageCode)) {
      print('✅ Configurando app en ESPAÑOL');
      return AppConstants.spanish;
    }
    
    // Si el idioma del sistema es inglés, usar inglés
    if (englishLanguageCodes.contains(languageCode)) {
      print('✅ Configurando app en INGLÉS');
      return AppConstants.english;
    }
    
    // Para cualquier otro idioma, usar inglés por defecto
    print('⚠️ Idioma no reconocido ($languageCode), usando INGLÉS por defecto');
    return AppConstants.english;
  }

  void changeLanguage(String language) async {
    if (language != _currentLanguage) {      
      _english = language == AppConstants.english;
      _currentLanguage = language;
      await preferences.setString(AppConstants.languageKey, _currentLanguage);
      notifyListeners();
    }
  }
}
