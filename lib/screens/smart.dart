import 'package:flutter/material.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/screens/smartQR.dart';
import 'package:valdeiglesias/screens/smartBeacon.dart';

class Smart extends StatelessWidget {
  const Smart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<LanguageModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          language.english ? 'Smart Features' : 'Funciones Inteligentes',
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
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Información sobre las funciones inteligentes
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppConstants.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.smart_toy,
                    size: 48,
                    color: AppConstants.primary,
                  ),
                  SizedBox(height: 12),
                  Text(
                    language.english 
                      ? 'Choose a smart feature to use'
                      : 'Elige una función inteligente para usar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 30),
            
        // Botón QR Scanner
        Semantics(
          label: language.english 
            ? 'QR Scanner button. Tap to scan QR codes with your camera'
            : 'Botón Escáner QR. Toca para escanear códigos QR con tu cámara',
          button: true,
          child: _buildSmartButton(
            context: context,
            language: language,
            icon: Icons.qr_code_scanner,
            title: language.english ? 'QR Scanner' : 'Escáner QR',
            subtitle: language.english
              ? 'Scan QR codes with your camera'
              : 'Escanear códigos QR con tu cámara',
            onTap: () {
              print('🔗 Navegando a SmartQR...');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SmartQR(),
                ),
              );
            },
          ),
        ),
            
            SizedBox(height: 20),
            
        // Botón Smart Beacon
        Semantics(
          label: language.english 
            ? 'Smart Beacon button. Tap to detect nearby beacons and get information'
            : 'Botón Beacon Inteligente. Toca para detectar beacons cercanos y obtener información',
          button: true,
          child: _buildSmartButton(
            context: context,
            language: language,
            icon: Icons.bluetooth_searching,
            title: language.english ? 'Smart Beacon' : 'Beacon Inteligente',
            subtitle: language.english
              ? 'Detect nearby beacons and get information'
              : 'Detectar beacons cercanos y obtener información',
            onTap: () {
              print('🔗 Navegando a SmartBeacon...');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SmartBeacon(),
                ),
              );
            },
          ),
        ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSmartButton({
    required BuildContext context,
    required LanguageModel language,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppConstants.primary.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppConstants.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                size: 30,
                color: AppConstants.primary,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppConstants.primary,
            ),
          ],
        ),
      ),
    );
  }
}