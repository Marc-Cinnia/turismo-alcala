import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/document_item.dart';

class DocumentModel extends ChangeNotifier {
  DocumentModel() {
    _fetchDocuments();
  }

  final List<DocumentItem> _documents = [];

  bool _dataFetched = false;

  bool get hasData => _dataFetched;

  List<DocumentItem> get items => _documents;

  /// Fetch the documents data
  void _fetchDocuments() async {
    final response = await http.get(Uri.parse(AppConstants.documentsUrl));

    if (response.statusCode == AppConstants.success) {
      List<dynamic> body = jsonDecode(response.body);

      for (var item in body) {
        String title = '';
        String imageUrl = '';
        String documentLink = '';

        // Extract title
        if (item[AppConstants.titleKey] != null && 
            (item[AppConstants.titleKey] as List).isNotEmpty) {
          title = item[AppConstants.titleKey][0][AppConstants.valueKey] ?? '';
        }

        // Extract image URL
        if (item['field_document_image'] != null && 
            (item['field_document_image'] as List).isNotEmpty) {
          imageUrl = item['field_document_image'][0][AppConstants.urlKey] ?? '';
        }

        // Extract document link (PDF URL)
        if (item['field_document_link'] != null && 
            (item['field_document_link'] as List).isNotEmpty) {
          documentLink = item['field_document_link'][0]['uri'] ?? '';
        }

        if (title.isNotEmpty) {
          _documents.add(
            DocumentItem(
              title: title,
              imageUrl: imageUrl,
              documentLink: documentLink,
            ),
          );
        }
      }
    }
    _dataFetched = _documents.isNotEmpty;
    notifyListeners();
  }
}
