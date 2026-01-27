import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/achievments_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/reward_list.dart';

class Achievments extends StatefulWidget {
  const Achievments({super.key});

  @override
  State<Achievments> createState() => _AchievmentsState();
}

class _AchievmentsState extends State<Achievments> {
  late AchievmentsModel _achievments;
  late bool _accessible;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _accessible = Provider.of<AccessibleModel>(context).enabled;
  }

  @override
  Widget build(BuildContext context) {
    final english = context.watch<LanguageModel>().english;
    final title = (english)
        ? AppConstants.achievmentsLabelEn
        : AppConstants.achievmentsLabel;

    _achievments = context.watch<AchievmentsModel>();

    return Scaffold(
      appBar: AppBar(
        title: DynamicTitle(value: title, accessible: _accessible),
        actions: ContentBuilder.getActions(),
        iconTheme: IconThemeData(color: AppConstants.backArrowColor),
      ),
      body: FutureBuilder(
        future: _getRegisteredBeacons(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const SingleChildScrollView(
              child: RewardList(),
            );
          }

          return Center(
            child: LoaderBuilder.getLoader(),
          );
        },
      ),
    );
  }

  Future<List<dynamic>> _getRegisteredBeacons() async {
    final asyncPrefs = SharedPreferencesAsync();
    final savedBeacons = await asyncPrefs.getString(
      AppConstants.beaconsRegisteredKey,
    );

    if (savedBeacons != null) {
      List<dynamic> beacons = jsonDecode(savedBeacons);

      if (beacons.isNotEmpty) {
        context.read<AchievmentsModel>().detectedBeacons = beacons.length;
        return beacons;
      }
    }

    return [];
  }
}
