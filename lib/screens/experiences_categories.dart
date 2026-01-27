import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/experience_categories_data.dart';
import 'package:valdeiglesias/dtos/experience_item.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/experience_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/screens/experience_detail.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/filter_menu.dart';
import 'package:valdeiglesias/widgets/wishlist_button.dart'; //Funcionalidad de estrella deshabilitada

class ExperiencesCategories extends StatefulWidget {
  const ExperiencesCategories({
    super.key,
    required this.accessible,
  });

  final bool accessible;

  @override
  State<ExperiencesCategories> createState() => _ExperiencesCategoriesState();
}

class _ExperiencesCategoriesState extends State<ExperiencesCategories> {
  final allCategoriesId = 0;
  final ExperienceModel model = ExperienceModel();

  ExperienceCategoriesData? _screenData;

  late bool _dataFetched;
  late bool _accessible;
  late List<ExperienceItem> _experiences;
  late List<ExperienceItem> _experiencesEn;
  late LanguageModel _language;

  @override
  void initState() {
    _experiences = _getExperiences(allCategoriesId);
    _experiencesEn = _getExperiencesEn(allCategoriesId);
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _accessible = Provider.of<AccessibleModel>(context).enabled;
  }

  @override
  Widget build(BuildContext context) {
    _language = context.watch<LanguageModel>();
    _screenData = context.watch<ExperienceModel>().screenData;
    _dataFetched = context.watch<ExperienceModel>().hasData;

    if (_screenData != null && _experiences.isEmpty && _experiencesEn.isEmpty) {
      _experiences.addAll(_screenData?.places ?? []);
      _experiencesEn.addAll(_screenData?.placesEn ?? []);
    }

    final title = (_language.english)
        ? AppConstants.experienceTitleEn
        : AppConstants.experienceTitle;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppConstants.backArrowColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: DynamicTitle(value: title, accessible: widget.accessible),
        actions: ContentBuilder.getActions(),
      ),
      body: Builder(
        builder: (context) {
          if (_dataFetched) {
            final experienceDescription = (_language.english)
                ? AppConstants.experienceDescriptionEn
                : AppConstants.experienceDescription;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacing),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppConstants.spacing,
                        left: AppConstants.spacing,
                        right: AppConstants.spacing,
                      ),
                      child: Text(
                        experienceDescription,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacing),
                    FilterMenu(
                      categories: _screenData?.categories ?? {},
                      onSelected: (categoryId) => setState(
                        () {
                          _experiences = _getExperiences(categoryId);
                          _experiencesEn = _getExperiencesEn(categoryId);
                        },
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacing),
                    Column(
                      children: _buildItems(
                        context,
                        _experiences,
                        _experiencesEn,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: LoaderBuilder.getLoader());
          }
        },
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context, List<ExperienceItem> items,
      List<ExperienceItem> itemsEn) {
    final experiences = (_language.english) ? itemsEn : items;

    return List.generate(
      experiences.length,
      (index) {
        final experience = experiences[index];
        final experienceEn = _experiencesEn[index];

        final thumbnailImage = (_accessible)
            ? const SizedBox()
            : GestureDetector(
                onTap: () => _showDetail(context, experience, experienceEn),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.thumbnailBorderRadius,
                  ),
                  child: SizedBox(
                    width: AppConstants.thumbnailWidth,
                    height: AppConstants.thumbnailHeight,
                    child: Image.network(
                      experience.mainImageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );

        return Card(
          color: AppConstants.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.cardSpacing),
            child: Builder(builder: (context) {
              final textPadding =
                  const EdgeInsets.all(AppConstants.shortSpacing);

              final descriptionSection = (_accessible)
                  ? const SizedBox()
                  : Padding(
                      padding: textPadding,
                      child: Text(
                        experience.shortDescription!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );

              final actionsSection = (_accessible)
                  ? Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        width: 30.0,
                        child: GestureDetector(
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: AppConstants.primary,
                          ),
                          onTap: () {},
                        ),
                      ),
                    )
                  // Funcionalidad de estrella deshabilitada
                  
                  : WishlistButton(
                      place: experience,
                      isTextButton: false,
                    );

              return Row(
                children: [
                  thumbnailImage,
                  Expanded(
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: AppConstants.cardSpacing,
                          right: AppConstants.cardSpacing,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: textPadding,
                              child: Text(
                                experience.placeName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppConstants.primary,
                                    ),
                              ),
                            ),
                            descriptionSection,
                          ],
                        ),
                      ),
                      onTap: () =>
                          _showDetail(context, experience, experienceEn),
                    ),
                  ),
                  actionsSection,
                ],
              );
            }),
          ),
        );
      },
    );
  }

  void _showDetail(
      BuildContext context, ExperienceItem item, ExperienceItem itemEn) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExperienceDetail(
          experience: item,
          experienceEn: itemEn,
          accessible: widget.accessible,
        ),
      ),
    );
  }

  List<ExperienceItem> _getExperiences(int categoryId) {
    List<ExperienceItem> filteredExperiences = _screenData?.places ?? [];

    if (categoryId != 0) {
      filteredExperiences = _screenData?.places
              .where((experience) => experience.categoryId == categoryId)
              .toList() ??
          [];
    }

    return filteredExperiences;
  }

  List<ExperienceItem> _getExperiencesEn(int categoryId) {
    List<ExperienceItem> filteredExperiencesEn = _screenData?.placesEn ?? [];

    if (categoryId != 0) {
      filteredExperiencesEn = _screenData?.placesEn
              .where((experience) => experience.categoryId == categoryId)
              .toList() ??
          [];
    }

    return filteredExperiencesEn;
  }
}
