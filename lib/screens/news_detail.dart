import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/news_item.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/utils/website_launcher.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/empty_gallery.dart';
import 'package:valdeiglesias/widgets/gallery.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail({
    super.key,
    required this.item,
    required this.itemEn,
    required this.accessible,
  });

  final NewsItem item;
  final NewsItem itemEn;

  final bool accessible;

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  late NewsItem _itemToDisplay;

  @override
  Widget build(BuildContext context) {
    const spacer = const SizedBox(height: AppConstants.spacing);
    const horizontalSpacer = const SizedBox(width: AppConstants.spacing);
    final language = context.watch<LanguageModel>();
    _itemToDisplay = (language.english) ? widget.itemEn : widget.item;

    final newsMoreInfoTitle = (language.english)
        ? AppConstants.newsMoreInfoTitleEn
        : AppConstants.newsMoreInfoTitle;

    final websiteLabel = (language.english)
        ? AppConstants.websiteLabelEn
        : AppConstants.websiteLabel;

    final smvSource = (language.english)
        ? AppConstants.smvNewsSourceEn
        : AppConstants.smvNewsSource;

    Widget gallery = const SizedBox();

    if (_itemToDisplay.imageUrls.isNotEmpty) {
      gallery = Gallery(
        imageUrls: List.generate(
          _itemToDisplay.imageUrls.length,
          (index) => _itemToDisplay.imageUrls[index],
        ),
      );
    }

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
          value: _itemToDisplay.title,
          accessible: widget.accessible,
        ),
        centerTitle: true,
        actions: ContentBuilder.getActions(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppConstants.spacing,
            right: AppConstants.spacing,
            top: AppConstants.spacing,
            bottom: AppConstants.contentBottomSpacing,
          ),
          child: Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.cardBorderRadius,
                  ),
                  child: SuperNetworkImage(
                    url: _itemToDisplay.mainImageUrl,
                    height: AppConstants.carouselHeight,
                    fit: BoxFit.fitHeight,
                    placeholderBuilder: () => Center(
                      child: LoaderBuilder.getLoader(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppConstants.spacing,
                    bottom: AppConstants.spacing,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('${_itemToDisplay.created} $smvSource'),
                      ),
                      spacer,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _itemToDisplay.subtitle,
                          style: _subtitle(context),
                        ),
                      ),
                      spacer,
                      Text(
                        (widget.accessible)
                            ? _itemToDisplay.shortDescription
                            : _itemToDisplay.longDescription,
                        style: (widget.accessible)
                            ? Theme.of(context).textTheme.bodyLarge
                            : Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.justify,
                      ),
                      spacer,
                      _getDownloadButton(_itemToDisplay.pdfUrl),
                      const Divider(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          newsMoreInfoTitle,
                          style: _subtitle(context),
                        ),
                      ),
                      spacer,
                      Row(
                        children: [
                          const Icon(
                            Icons.link_rounded,
                            color: AppConstants.lessContrast,
                          ),
                          horizontalSpacer,
                          GestureDetector(
                            child: Text(
                              websiteLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppConstants.lessContrast),
                            ),
                            onTap: () => WebsiteLauncher.launchWebsite(
                              _itemToDisplay.websiteUrl,
                            ),
                          ),
                          horizontalSpacer,
                        ],
                      ),
                      spacer,
                      gallery,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _subtitle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(color: AppConstants.primary);
  }

  Widget _getDownloadButton(String pdfUrl) {
    if (pdfUrl.isNotEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton.icon(
          onPressed: () => WebsiteLauncher.launchWebsite(_itemToDisplay.pdfUrl),
          label: Text(
            AppConstants.downloadFileLabel,
            style: GoogleFonts.dmSans().copyWith(
                color: AppConstants.contrast,
                fontSize: 15.0,
                fontWeight: FontWeight.w500),
          ),
          icon: const Icon(
            Icons.download_outlined,
            color: AppConstants.contrast,
          ),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
        ),
      );
    }

    return const SizedBox();
  }
}
