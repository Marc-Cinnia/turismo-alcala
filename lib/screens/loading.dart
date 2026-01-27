import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/card_model.dart';
import 'package:valdeiglesias/models/plan_model.dart';
import 'package:valdeiglesias/models/section_model.dart';
import 'package:valdeiglesias/models/slogan_model.dart';
import 'package:valdeiglesias/screens/accessible_home.dart';
import 'package:valdeiglesias/screens/home.dart';
// import 'package:valdeiglesias/screens/initial_preference.dart'; // COMENTADO: Pantalla de preferencias deshabilitada
import 'package:valdeiglesias/screens/survey.dart';
import 'package:valdeiglesias/widgets/loading_image.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late AccessibleModel _accessible;

  @override
  Widget build(BuildContext context) {
    _accessible = context.watch<AccessibleModel>();

    Future.delayed(
      const Duration(seconds: 5),
      () {
        // COMENTADO: Siempre ir directamente a la pantalla principal sin mostrar preferencias
        _setHomeScreen();
        /*
        if (_accessible.preferenceAssigned) {
          _setHomeScreen();
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => InitialPreference(),
            ),
          );
        }
        */
      },
    );

    return Scaffold(
      body: Center(
        child: LoadingImage(),
      ),
    );
  }

  void _setHomeScreen() {
    if (mounted) {
      Widget screen;

      if (_accessible.enabled) {
        screen = MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => PlanModel(),
            ),
          ],
          child: const AccessibleHome(),
        );
      } else {
        screen = MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => CardModel(),
            ),
            ChangeNotifierProvider(
              create: (context) => PlanModel(),
            ),
          ],
          child: const Home(),
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    }
  }
}
