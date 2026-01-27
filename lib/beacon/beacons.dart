class VibracomBeacon {
  late int minor, major;
  late DateTime notified;
  VibracomBeacon(this.major, this.minor, this.notified);
}

class VibracomBeaconInfo {
  final VibracomBeacon vBeacon;
  final String title;
  final String text;
  final String iconUrl;
  final String link;

  VibracomBeaconInfo(
    this.vBeacon,
    this.title,
    this.text,
    this.iconUrl,
    this.link,
  );

  @override
  String toString() {
    return '''
    Beacon Info:
      Major: ${vBeacon.major}
      Minor: ${vBeacon.minor}
      Título: $title
      Texto: $text
      Icon URL: $iconUrl
      Link: $link
    ''';
  }
}

class VibracomBeacons {
  final Map<String, DateTime> _lastNotificationTime = {};
  static const Duration _minimumTimeBetweenNotifications =
      Duration(minutes: 30);

  var beaconList = <VibracomBeacon>{};

  bool addBeacon(VibracomBeacon beacon) {
    final beaconKey = '${beacon.major}-${beacon.minor}';
    final now = DateTime.now();

    // Verificar si ya se ha notificado este beacon
    if (_lastNotificationTime.containsKey(beaconKey)) {
      final lastNotification = _lastNotificationTime[beaconKey]!;
      final timeSinceLastNotification = now.difference(lastNotification);

      // Si no ha pasado suficiente tiempo, no notificar
      if (timeSinceLastNotification < _minimumTimeBetweenNotifications) {
        print(
            '⏳ Tiempo insuficiente desde última notificación: ${timeSinceLastNotification.inSeconds} segundos');
        return false;
      }
    }

    // Actualizar tiempo de última notificación y retornar true para notificar
    print('✅ Beacon elegible para notificación');
    _lastNotificationTime[beaconKey] = now;
    return true;
  }

  // Método para depuración
  void printLastNotifications() {
    print('\n📋 Estado de notificaciones:');
    _lastNotificationTime.forEach((key, time) {
      final difference = DateTime.now().difference(time);
      print(
          'Beacon $key: Última notificación hace ${difference.inSeconds} segundos');
    });
  }
}

class VibracomBeaconsInfo {
  var beaconList = <VibracomBeaconInfo>[];
  final Set<String> _uuids = {};

  Set<String> get uuids => _uuids;

  void addUuid(String? uuid) {
    if (uuid != null && uuid.isNotEmpty) {
      _uuids.add(uuid);
    }
  }

  void clearUuids() {
    _uuids.clear();
  }

  // Ens diu si tenim el beacon donat d'alta.
  VibracomBeaconInfo? findBeacon(VibracomBeacon vBeacon) {
    print('''
🔍 Buscando beacon en lista registrada:
   Major buscado: ${vBeacon.major}
   Minor buscado: ${vBeacon.minor}
   Total beacons registrados: ${beaconList.length}
  ''');

    for (var item in beaconList) {
      print('''
   Comparando con:
   Major: ${item.vBeacon.major}
   Minor: ${item.vBeacon.minor}
    ''');

      if (item.vBeacon.minor == vBeacon.minor &&
          item.vBeacon.major == vBeacon.major) {
        print('✅ Beacon encontrado en la lista!');
        return item;
      }
    }

    print('❌ Beacon no encontrado en la lista registrada');
    return null;
  }
}
