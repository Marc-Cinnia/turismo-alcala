import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/place_category.dart';
import 'package:valdeiglesias/dtos/store.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/shop_model.dart';
import 'package:valdeiglesias/screens/shop_pre_detail.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';

class ShopCategories extends StatefulWidget {
  const ShopCategories({
    super.key,
    required this.accessible,
  });

  final bool accessible;

  @override
  State<ShopCategories> createState() => _ShopCategoriesState();
}

class _ShopCategoriesState extends State<ShopCategories> {
  late LanguageModel _language;

  @override
  Widget build(BuildContext context) {
    _language = context.watch<LanguageModel>();
    final shopModel = context.watch<ShopModel>();
    final accessible = context.watch<AccessibleModel>();

    final description = (_language.english)
        ? AppConstants.whereToShopDescriptionEn
        : AppConstants.whereToShopDescription;

    final appBarTitle = (_language.english)
        ? AppConstants.whereToShopLabelEn
        : AppConstants.whereToShopLabel;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppConstants.backArrowColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: DynamicTitle(value: appBarTitle, accessible: accessible.enabled),
        actions: ContentBuilder.getActions(),
      ),
      body: Builder(
        builder: (context) {
          if (shopModel.hasData) {
            final categories = (_language.english)
                ? shopModel.categoriesEn.toList()
                : shopModel.categories.toList();

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
                        description,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacing),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _buildListItems(
                        context,
                        categories,
                        shopModel.placesToShop,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(child: LoaderBuilder.getLoader());
        },
      ),
    );
  }

  List<Widget> _buildListItems(
    BuildContext context,
    List<PlaceCategory> categories,
    List<Store> stores,
  ) {
    return List.generate(
      categories.length,
      (index) {
        final category = categories[index];
        final name = category.name;

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
                    name,
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
            final screen = ShopPreDetail(categoryId: category.id);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => screen,
              ),
            );
          },
        );
      },
    );
  }
}
