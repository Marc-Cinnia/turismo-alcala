import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/place.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/cellar_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/screens/cellar_detail.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/wishlist_button.dart'; // Funcionalidad de estrella deshabilitada

class CellarPreDetail extends StatefulWidget {
  const CellarPreDetail({super.key});

  @override
  State<CellarPreDetail> createState() => _CellarPreDetailState();
}

class _CellarPreDetailState extends State<CellarPreDetail> {
  late AccessibleModel _accessible;
  late CellarModel cellar;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _accessible = Provider.of<AccessibleModel>(context);
    cellar = Provider.of<CellarModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    final style = (_accessible.enabled)
        ? appBarTheme.titleTextStyle?.copyWith(color: AppConstants.primary)
        : appBarTheme.titleTextStyle;
    final english = context.watch<LanguageModel>().english;

    final appBarTitle =
        (english) ? AppConstants.cellarLabelEn : AppConstants.cellarLabel;

    final description = (english)
        ? AppConstants.cellarDescriptionEn
        : AppConstants.cellarDescription;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppConstants.backArrowColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          appBarTitle,
          style: style,
        ),
        actions: ContentBuilder.getActions(),
      ),
      body: SingleChildScrollView(
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
                  description,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: AppConstants.spacing),
              Builder(
                builder: (context) {
                  if (cellar.cellars.isNotEmpty) {
                    return Column(
                      children: (_accessible.enabled)
                          ? _buildAccessibleItems(
                              context,
                              cellar.cellars,
                              english,
                            )
                          : _buildListItems(
                              context,
                              cellar.cellars,
                              english,
                            ),
                    );
                  }

                  return Center(
                    child: LoaderBuilder.getLoader(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildListItems(
    BuildContext context,
    List<Place> items,
    bool english,
  ) {
    return List.generate(
      items.length,
      (index) {
        final name = items[index].placeName;
        String? description = (english)
            ? items[index].shortDescriptionEn
            : items[index].shortDescription;

        final nameField = (description != null)
            ? Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppConstants.primary,
                    ),
              )
            : const SizedBox();

        return Card(
          color: AppConstants.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          ),
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.cardSpacing),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _showDetail(context, items[index]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppConstants.thumbnailBorderRadius,
                      ),
                      child: SuperNetworkImage(
                        url: items[index].mainImageUrl!,
                        width: AppConstants.thumbnailWidth,
                        fit: BoxFit.fitWidth,
                        placeholderBuilder: () => Center(
                          child: LoaderBuilder.getLoader(),
                        ),
                      ),
                    ),
                  ),
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
                            nameField,
                            const SizedBox(height: AppConstants.shortSpacing),
                            Text(
                              description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      onTap: () => _showDetail(context, items[index]),
                    ),
                  ),
                  //  Funcionalidad de estrella deshabilitada
                  WishlistButton(
                    place: items[index],
                    isTextButton: false,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildAccessibleItems(
    BuildContext context,
    List<Place> items,
    bool english,
  ) {
    return List.generate(
      items.length,
      (index) {
        return Card(
          color: AppConstants.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          ),
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.cardSpacing),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: AppConstants.cardSpacing,
                          right: AppConstants.cardSpacing,
                        ),
                        child: Text(
                          items[index].placeName,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppConstants.primary,
                                  ),
                        ),
                      ),
                      onTap: () => _showDetail(context, items[index]),
                    ),
                  ),
                  Align(
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDetail(BuildContext context, Place place) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CellarDetail(cellar: place),
      ),
    );
  }
}
