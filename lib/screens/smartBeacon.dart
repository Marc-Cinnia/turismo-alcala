import 'package:flutter/material.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/beacon/beacon_service.dart';
import 'package:valdeiglesias/beacon/beacons.dart';
import 'package:url_launcher/url_launcher.dart';

class SmartBeacon extends StatefulWidget {
  const SmartBeacon({Key? key}) : super(key: key);

  @override
  State<SmartBeacon> createState() => _SmartBeaconState();
}

class _SmartBeaconState extends State<SmartBeacon> {

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<LanguageModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          language.english ? 'Smart Beacon' : 'Beacon Inteligente',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                // Forzar actualización de la lista
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<VibracomBeaconInfo>>(
        future: _getDetectedBeacons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppConstants.primary,
                  ),
                  SizedBox(height: 20),
                  Text(
                    language.english 
                      ? 'Loading detected beacons...'
                      : 'Cargando beacons detectados...',
                    style: TextStyle(
                      color: AppConstants.primary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: AppConstants.primary,
                  ),
                  SizedBox(height: 20),
                  Text(
                    language.english 
                      ? 'Error loading beacons'
                      : 'Error cargando beacons',
                    style: TextStyle(
                      color: AppConstants.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          final beacons = snapshot.data ?? [];

          if (beacons.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bluetooth_searching,
                    size: 80,
                    color: AppConstants.primary,
                  ),
                  SizedBox(height: 20),
                  Text(
                    language.english 
                      ? 'No beacons detected yet'
                      : 'Aún no se han detectado beacons',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppConstants.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    language.english 
                      ? 'Make sure Bluetooth is enabled and you are near a beacon'
                      : 'Asegúrate de que Bluetooth esté activado y estés cerca de un beacon',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.primary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                color: AppConstants.primary.withOpacity(0.1),
                child: Row(
                  children: [
                    Icon(
                      Icons.bluetooth_connected,
                      color: AppConstants.primary,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        language.english 
                          ? '${beacons.length} beacon${beacons.length == 1 ? '' : 's'} detected'
                          : '${beacons.length} beacon${beacons.length == 1 ? '' : 's'} detectado${beacons.length == 1 ? '' : 's'}',
                        style: TextStyle(
                          color: AppConstants.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final beaconService = BeaconService();
                        await beaconService.clearRegisteredBeacons();
                        setState(() {
                          // Forzar actualización de la UI
                        });
                      },
                      icon: Icon(
                        Icons.refresh,
                        color: AppConstants.primary,
                      ),
                      tooltip: language.english 
                        ? 'Refresh beacons' 
                        : 'Actualizar beacons',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 100), // Agregar padding inferior para el menú
                  itemCount: beacons.length,
                  itemBuilder: (context, index) {
                    final beacon = beacons[index];
                    return _buildBeaconCard(beacon, language.english);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<List<VibracomBeaconInfo>> _getDetectedBeacons() async {
    try {
      final beaconService = BeaconService();
      final beacons = beaconService.getRegisteredBeacons();
      return beacons;
    } catch (e) {
      print('Error obteniendo beacons: $e');
      return [];
    }
  }

  Widget _buildBeaconCard(VibracomBeaconInfo beacon, bool english) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.bluetooth,
                    color: AppConstants.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        beacon.title.isNotEmpty ? beacon.title : (english ? 'Beacon' : 'Beacon'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    english ? 'Active' : 'Activo',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (beacon.text.isNotEmpty) ...[
              SizedBox(height: 12),
              Text(
                beacon.text,
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.primary.withOpacity(0.8),
                ),
              ),
            ],
            if (beacon.iconUrl.isNotEmpty) ...[
              SizedBox(height: 12),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(beacon.iconUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
            if (beacon.link.isNotEmpty) ...[
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _openResource(beacon.link),
                icon: Icon(Icons.open_in_new, size: 16),
                label: Text(
                  english ? 'Open Resource' : 'Abrir Recurso',
                  style: TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openResource(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } else {
        print('No se pudo abrir la URL: $url');
        // Intentar abrir en el navegador como fallback
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error al abrir la URL: $e');
    }
  }
}
