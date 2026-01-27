import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/accessible_model.dart';
import 'package:valdeiglesias/models/document_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  late bool _accessible;
  late LanguageModel _language;
  late DocumentModel _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _language = Provider.of<LanguageModel>(context);
    _accessible = Provider.of<AccessibleModel>(context).enabled;
    _model = Provider.of<DocumentModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    final title = (_language.english)
        ? AppConstants.documentsTitleEn
        : AppConstants.documentsTitle;

    return Scaffold(
      extendBody: true,
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.shortSpacing,
            AppConstants.spacing,
            AppConstants.shortSpacing,
            0.0,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Builder(
                        builder: (context) {
                          if (_model.hasData) {
                            return _buildDocumentsGrid(context, _model.items);
                          }
                          return Center(child: LoaderBuilder.getLoader());
                        },
                      ),
                      // Espacio adicional para evitar que el menú tape el contenido
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentsGrid(BuildContext context, List documents) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        return GestureDetector(
          onTap: () => _openDocument(document.documentLink),
          child: Card(
            elevation: AppConstants.cardElevation,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppConstants.borderRadius),
              ),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.cardBorderRadius,
                  ),
                  child: document.imageUrl.isNotEmpty
                      ? SizedBox.expand(
                          child: SuperNetworkImage(
                            url: document.imageUrl,
                            fit: BoxFit.cover,
                            placeholderBuilder: () => Center(
                              child: LoaderBuilder.getLoader(),
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: AppConstants.cardColor,
                          child: const Icon(
                            Icons.description,
                            size: 50,
                            color: AppConstants.contrast,
                          ),
                        ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.shortSpacing),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(AppConstants.cardBorderRadius),
                        bottomRight: Radius.circular(AppConstants.cardBorderRadius),
                      ),
                    ),
                    child: Text(
                      document.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openDocument(String url) async {
    if (url.isEmpty) {
      print('URL del documento vacía');
      return;
    }

    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('No se pudo abrir la URL: $url');
        // Intentar abrir en el navegador como fallback
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error al abrir el documento: $e');
      // Mostrar un mensaje al usuario si es necesario
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _language.english
                  ? 'Error opening document'
                  : 'Error al abrir el documento',
            ),
          ),
        );
      }
    }
  }
}
