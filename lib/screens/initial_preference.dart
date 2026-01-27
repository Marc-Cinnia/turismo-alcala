// COMENTADO: Pantalla de preferencia de modo accesible deshabilitada
/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/card_model.dart';
import 'package:valdeiglesias/models/plan_model.dart';
import 'package:valdeiglesias/models/section_model.dart';
import 'package:valdeiglesias/models/slogan_model.dart';
import 'package:valdeiglesias/screens/accessible_home.dart';
import 'package:valdeiglesias/screens/home.dart';

class InitialPreference extends StatefulWidget {
  const InitialPreference({super.key});

  @override
  State<InitialPreference> createState() => _InitialPreferenceState();
}

class _InitialPreferenceState extends State<InitialPreference> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppConstants.accessiblePreferenceLabel,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text(AppConstants.accessibleYesLabel),
                onPressed: () {
                  _setAccessible(true);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => SloganModel(),
                        child: const AccessibleHome(),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text(AppConstants.accessibleNoLabel),
                onPressed: () {
                  _setAccessible(false);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                            create: (context) => CardModel(),
                          ),
                          ChangeNotifierProvider(
                            create: (context) => SloganModel(),
                          ),
                          ChangeNotifierProvider(
                            create: (context) => SectionModel(),
                          ),
                          ChangeNotifierProvider(
                            create: (context) => PlanModel(),
                          ),
                        ],
                        child: const Home(),
                      ),
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

  void _setAccessible(bool accessible) async {
    final asyncPrefs = SharedPreferencesAsync();
    await asyncPrefs.setBool(AppConstants.accessibleKey, accessible);
    Provider.of<AccessibleModel>(context, listen: false).enabled = accessible;
  }
}
*/
