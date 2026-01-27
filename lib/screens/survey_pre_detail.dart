import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/variable_survey.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/survey_model.dart';
import 'package:valdeiglesias/screens/survey.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/utils/website_launcher.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';

class SurveyPreDetail extends StatefulWidget {
  SurveyPreDetail({super.key});

  @override
  State<SurveyPreDetail> createState() => _SurveyPreDetailState();
}

class _SurveyPreDetailState extends State<SurveyPreDetail> {
  final Set<String> surveyTypes = {};
  final Set<String> surveyTypesEn = {};

  late bool english;
  late VariableSurvey? variableSurvey;

  String variableSurveyNameEn = '';
  String variableSurveyName = '';

  @override
  Widget build(BuildContext context) {
    final showVariableSurvey =
        context.watch<SurveyModel>().variableSurveyFetched;
    final showFixedSurvey = context.watch<SurveyModel>().showFixedSurvey;
    final accessible = context.watch<AccessibleModel>().enabled;
    final surveyAnswered = context.watch<SurveyModel>().surveyAnswered;

    Widget mainContent = const SizedBox();
    Set<Widget> surveyCategories;

    english = context.watch<LanguageModel>().english;
    variableSurvey = context.watch<SurveyModel>().variableSurvey;

    if (!surveyAnswered) {
      if (showFixedSurvey || showVariableSurvey) {
        if (showFixedSurvey) {
          surveyTypes.add(AppConstants.surveyFixedLabel);
          surveyTypesEn.add(AppConstants.surveyFixedLabel);
        }

        if (showVariableSurvey && variableSurvey != null) {
          variableSurveyName = variableSurvey!.name;
          variableSurveyNameEn = variableSurvey!.nameEn;

          if (variableSurveyName.isNotEmpty &&
              variableSurveyNameEn.isNotEmpty) {
            surveyTypes.add(variableSurveyName);
            surveyTypesEn.add(variableSurveyNameEn);
          }
        }

        if (english) {
          surveyCategories =
              _buildListItems(context, surveyTypesEn.toList()).toSet();
        } else {
          surveyCategories =
              _buildListItems(context, surveyTypes.toList()).toSet();
        }

        mainContent = Padding(
          padding: const EdgeInsets.only(top: AppConstants.spacing),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppConstants.shortSpacing,
                right: AppConstants.shortSpacing,
                bottom: AppConstants.contentBottomSpacing,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: surveyCategories.toList(),
              ),
            ),
          ),
        );
      } else {
        mainContent = Center(
          child: LoaderBuilder.getLoader(),
        );
      }
    } else {
      final noSurveyMsg =
          (english) ? AppConstants.noSurveyLabelEn : AppConstants.noSurveyLabel;
      mainContent = Center(
        child: Text(
          noSurveyMsg,
          textAlign: TextAlign.center,
        ),
      );
    }

    String title = (english)
        ? AppConstants.surveyScreenTitleEn
        : AppConstants.surveyScreenTitle;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppConstants.backArrowColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: DynamicTitle(
          value: title,
          accessible: accessible,
        ),
        actions: ContentBuilder.getActions(),
      ),
      body: mainContent,
    );
  }

  List<Widget> _buildListItems(
    BuildContext context,
    List<String> labels,
  ) {
    return List.generate(
      labels.length,
      (index) {
        return GestureDetector(
          child: Card(
            color: AppConstants.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.cardBorderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.cardSpacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    labels[index],
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: AppConstants.primary),
                  ),
                  const SizedBox(
                    width: 30.0,
                    child: Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: AppConstants.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            if (english) {
              if (labels[index] == AppConstants.surveyFixedLabelEn) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Survey(),
                  ),
                );
              }

              if (variableSurveyNameEn != null &&
                  labels[index] == variableSurveyNameEn) {
                if (variableSurvey != null) {
                  String url = variableSurvey!.linkEn;
                  WebsiteLauncher.launchWebsite(url);
                }
              }
            } else {
              if (labels[index] == AppConstants.surveyFixedLabel) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Survey(),
                  ),
                );
              }

              // Si el label pulsado fue el de encuesta variable, redirigir
              // al usuario al website proporcionado por la API aquí.
              if (labels[index] == variableSurveyName) {
                if (variableSurvey != null) {
                  String url = variableSurvey!.link;
                  WebsiteLauncher.launchWebsite(url);
                }
              }
            }
          },
        );
      },
    );
  }
}
