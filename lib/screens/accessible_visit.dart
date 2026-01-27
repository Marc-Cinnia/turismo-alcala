import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/slogan_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/widgets/sections.dart';

class AccessibleVisit extends StatefulWidget {
  const AccessibleVisit({super.key});

  @override
  State<AccessibleVisit> createState() => _AccessibleVisitState();
}

class _AccessibleVisitState extends State<AccessibleVisit> {
  late bool english;

  @override
  Widget build(BuildContext context) {
    english = context.watch<LanguageModel>().english;

    final slogan = (english)
        ? context.watch<SloganModel>().valueEn
        : context.watch<SloganModel>().value;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstants.backArrowColor),
        title: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              const SizedBox(
                width: AppConstants.logoWidth,
                child: Image(
                  image: AssetImage('assets/app_logo.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(width: AppConstants.shortSpacing),
              SizedBox(
                width: 120.0,
                child: Text(
                  AppConstants.smvLabel,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppConstants.primary,
                      ),
                ),
              ),
            ],
          ),
        ),
        actions: ContentBuilder.getActions(),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppConstants.shortSpacing,
                right: AppConstants.shortSpacing,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      slogan,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppConstants.lessContrast,
                                fontWeight: FontWeight.w900,
                                // fontSize: 29.0,
                              ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacing),
                  Sections(
                    accessible: true,
                    english: english,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
