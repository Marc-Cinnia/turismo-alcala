import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/store.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/shop_model.dart';
import 'package:valdeiglesias/screens/shop_detail.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/wishlist_button.dart'; //Funcionalidad de estrella deshabilitada

/// Pre-Detail Screen for "Where to shop" section
class ShopPreDetail extends StatefulWidget {
  const ShopPreDetail({
    super.key,
    required this.categoryId,
  });

  final int categoryId;

  @override
  State<ShopPreDetail> createState() => _ShopPreDetailState();
}

class _ShopPreDetailState extends State<ShopPreDetail> {
  late LanguageModel _language;
  late ShopModel _shopModel;
  late bool _accessible;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _accessible = Provider.of<AccessibleModel>(context).enabled;
  }

  @override
  Widget build(BuildContext context) {
    const spacer = const SizedBox(height: AppConstants.spacing);

    _language = context.watch<LanguageModel>();
    _shopModel = context.watch<ShopModel>();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _shopModel.filterByCategory(widget.categoryId),
    );

    final appBarTitle = (_language.english)
        ? AppConstants.whereToShopLabelEn
        : AppConstants.whereToShopLabel;

    final description = (_language.english)
        ? AppConstants.whereToShopDescriptionEn
        : AppConstants.whereToShopDescription;

    final stores = _shopModel.placesToShop;

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
          value: appBarTitle,
          accessible: _accessible,
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
                ),
              ),
              spacer,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _buildListItems(context, stores),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildListItems(BuildContext context, List<Store> stores) {
    return List.generate(
      stores.length,
      (index) {
        final store = stores[index];

        final storeName =
            (_language.english) ? store.placeNameEn : store.placeName;

        String description = '';

        if (store.longDescription != null) {
          description = store.longDescription!;
        }

        if (_language.english) {
          if (store.longDescriptionEn != null) {
            description = store.longDescriptionEn!;
          }
          if (_accessible) {
            if (store.shortDescriptionEn != null) {
              description = store.shortDescriptionEn!;
            }
          }
        } else {
          if (store.longDescription != null) {
            description = store.longDescription!;
          }

          if (_accessible) {
            if (store.shortDescription != null) {
              description = store.shortDescription!;
            }
          }
        }

        final thumbnailImage = (_accessible)
            ? const SizedBox()
            : GestureDetector(
                onTap: () => _showDetail(context, store),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.thumbnailBorderRadius,
                  ),
                  child: SuperNetworkImage(
                    url: store.mainImageUrl,
                    width: AppConstants.thumbnailWidth,
                    height: AppConstants.thumbnailHeight,
                    fit: BoxFit.fitHeight,
                    placeholderBuilder: () =>
                        Center(child: LoaderBuilder.getLoader()),
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
                        description,
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
                      place: store,
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
                          bottom: 8.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: textPadding,
                              child: Text(
                                storeName,
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
                      onTap: () => _showDetail(context, store),
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

  void _showDetail(BuildContext context, Store store) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShopDetail(item: store, accessible: _accessible),
      ),
    );
  }
}
