import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/plan_main_content.dart';

class Plan extends StatefulWidget {
  const Plan({super.key});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  late bool _accessible;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _accessible = Provider.of<AccessibleModel>(context).enabled;
  }


  @override
  Widget build(BuildContext context) {
    final english = context.watch<LanguageModel>().english;

    final appBarTitle =
        (english) ? AppConstants.myPlanLabelEn : AppConstants.myPlanLabel;

    return Scaffold(
      appBar: AppBar(
        title: DynamicTitle(value: appBarTitle, accessible: _accessible),
        actions: ContentBuilder.getActions(),
        iconTheme: IconThemeData(color: AppConstants.backArrowColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.shortSpacing),
        child: Center(
          child: const SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: PlanMainContent(),
          ),
        ),
      ),
    );
  }
}
