import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/news_item.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/news_model.dart';
import 'package:valdeiglesias/screens/news_detail.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/wishlist_button.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  late bool _accessible;
  late LanguageModel _language;
  late NewsModel _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _language = Provider.of<LanguageModel>(context);
    _accessible = Provider.of<AccessibleModel>(context).enabled;
    _model = Provider.of<NewsModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    final title =
        (_language.english) ? AppConstants.newsTitleEn : AppConstants.newsTitle;

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
          accessible: _accessible,
        ),
        actions: ContentBuilder.getActions(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppConstants.shortSpacing,
            right: AppConstants.shortSpacing,
            bottom: AppConstants.contentBottomSpacing,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppConstants.spacing),
              Builder(
                builder: (context) {
                  if (_model.hasData) {
                    final news =
                        (_language.english) ? _model.itemsEn : _model.items;

                    return Column(
                      children: _buildItems(context, news),
                    );
                  }

                  return Center(child: _getLoader(AppConstants.primary));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context, List<NewsItem> news) {
    return List.generate(
      news.length,
      (index) {
        final thumbnailImage = (_accessible)
            ? const SizedBox()
            : GestureDetector(
                onTap: () => _showDetail(
                  context,
                  _model.items[index],
                  _model.itemsEn[index],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.thumbnailBorderRadius,
                  ),
                  child: SuperNetworkImage(
                    url: news[index].mainImageUrl,
                    height: AppConstants.thumbnailHeight,
                    width: AppConstants.thumbnailWidth,
                    fit: BoxFit.fitHeight,
                    placeholderBuilder: () => Center(
                      child: LoaderBuilder.getLoader(),
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
                  : const SizedBox();

              final descriptionSection = (_accessible)
                  ? const SizedBox()
                  : Text(
                      (_accessible)
                          ? news[index].shortDescription
                          : news[index].longDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
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
                            Text(
                              news[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppConstants.primary,
                                  ),
                            ),
                            descriptionSection,
                          ],
                        ),
                      ),
                      onTap: () => _showDetail(
                        context,
                        _model.items[index],
                        _model.itemsEn[index],
                      ),
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

  Widget _getLoader(Color color) => CircularProgressIndicator(color: color);

  void _showDetail(BuildContext context, NewsItem news, NewsItem newsEn) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewsDetail(
          item: news,
          itemEn: newsEn,
          accessible: _accessible,
        ),
      ),
    );
  }
}
