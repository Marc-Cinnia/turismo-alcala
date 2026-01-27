import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/news_item.dart';
import 'package:valdeiglesias/utils/content_validator.dart';
import 'package:valdeiglesias/utils/date_formatter.dart';

class NewsModel extends ChangeNotifier {
  NewsModel() {
    _fetchNews();
  }

  final List<NewsItem> _news = [];
  final List<NewsItem> _newsEn = [];

  bool _dataFetched = false;

  bool get hasData => _dataFetched;

  List<NewsItem> get items => _news;
  List<NewsItem> get itemsEn => _newsEn;

  /// Fetch the news data
  void _fetchNews() async {
    final response = await http.get(Uri.parse(AppConstants.currentNews));
    final responseEn = await http.get(Uri.parse(AppConstants.currentNewsEn));

    if (response.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(response.body);

      for (var item in body) {
        _news.add(
          NewsItem(
            mainImageUrl: ContentValidator.url(
              item[AppConstants.newsImage],
            ),
            title: ContentValidator.value(
              item[AppConstants.titleKey],
            ),
            subtitle: ContentValidator.value(
              item[AppConstants.newsSubtitle],
            ),
            shortDescription: ContentValidator.value(
              item[AppConstants.newsShortDesc],
            ),
            longDescription: ContentValidator.value(
              item[AppConstants.newsLongDesc],
            ),
            created: _getFormattedDate(
              ContentValidator.value(item[AppConstants.newsCreatedAt]),
            ),
            websiteUrl: ContentValidator.value(
              item[AppConstants.newsWebsiteUrl],
            ),
            imageUrls: ContentValidator.imageUrls(
              item[AppConstants.newsImageGallery] ?? [],
            ),
            pdfUrl: ContentValidator.url(item[AppConstants.newsPdfUrl]),
          ),
        );
      }
    }

    if (responseEn.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(responseEn.body);

      for (var item in body) {
        _newsEn.add(
          NewsItem(
            mainImageUrl: ContentValidator.url(
              item[AppConstants.newsImage],
            ),
            title: ContentValidator.value(
              item[AppConstants.titleKey],
            ),
            subtitle: ContentValidator.value(
              item[AppConstants.newsSubtitle],
            ),
            shortDescription: ContentValidator.value(
              item[AppConstants.newsShortDesc],
            ),
            longDescription: ContentValidator.value(
              item[AppConstants.newsLongDesc],
            ),
            created: _getFormattedDate(
              ContentValidator.value(item[AppConstants.newsCreatedAt]),
            ),
            websiteUrl: ContentValidator.value(
              item[AppConstants.newsWebsiteUrl],
            ),
            imageUrls: ContentValidator.imageUrls(
              item[AppConstants.newsImageGallery] ?? [],
            ),
            pdfUrl: ContentValidator.url(item[AppConstants.newsPdfUrl]),
          ),
        );
      }
    }
    _dataFetched = _news.isNotEmpty && _newsEn.isNotEmpty;
    notifyListeners();
  }

  String _getFormattedDate(String date) {
    final dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}
