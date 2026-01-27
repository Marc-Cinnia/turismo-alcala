import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/slogan_model.dart';
import 'package:valdeiglesias/models/personalization_model.dart';
import 'package:valdeiglesias/services/personalization_service.dart';
import 'package:valdeiglesias/screens/survey.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/widgets/carousel.dart';
import 'package:valdeiglesias/widgets/static_banner.dart';
import 'package:valdeiglesias/widgets/sections.dart';

class Visit extends StatefulWidget {
  const Visit({super.key});
  @override
  State<Visit> createState() => _VisitState();
}

class _VisitState extends State<Visit> {
  late bool english;

  @override
  void initState() {
    final prefs = SharedPreferencesAsync();

    prefs.getBool(AppConstants.surveyAnsweredKey).then(
      (answered) {
        if (context.mounted) {
          if (answered == null || !answered) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                final dialogTitle = (english)
                    ? AppConstants.surveyDialogTitleEn
                    : AppConstants.surveyDialogTitle;

                final dialogDesc = (english)
                    ? AppConstants.surveyDialogDescEn
                    : AppConstants.surveyDialogDesc;

                return AlertDialog(
                  title: Text(dialogTitle),
                  content: Text(
                    dialogDesc,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.primary,
                        ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        (english) ? AppConstants.cancelEn : AppConstants.cancel,
                        style: GoogleFonts.dmSans().copyWith(
                          color: AppConstants.contrast,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => Survey(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.check,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      label: Text(
                        (english)
                            ? AppConstants.surveyAnswerLabelEn
                            : AppConstants.surveyAnswerLabel,
                        style: GoogleFonts.dmSans().copyWith(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          AppConstants.contrast,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
    );

    // Cargar datos de personalización
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final personalizationModel = context.read<PersonalizationModel>();
      PersonalizationService.fetchPersonalizationData(personalizationModel, english);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    english = context.watch<LanguageModel>().english;
    final slogan = (english)
        ? context.watch<SloganModel>().valueEn
        : context.watch<SloganModel>().value;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstants.backArrowColor),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Semantics(
              label: 'Logo de la aplicación Valdeiglesias',
              child: const SizedBox(
                width: 55.0,
                child: Image(
                  image: AssetImage(AppConstants.smvLogoPath),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Semantics(
              label: 'Título de la aplicación: ${AppConstants.smvLabel}',
              child: SizedBox(
                width: 120.0,
                child: Text(
                  AppConstants.smvLabel,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                ),
              ),
            ),
          ],
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
                      Semantics(
                        label: 'Slogan principal: $slogan',
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            slogan,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppConstants.lessContrast,
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacing),
                      Semantics(
                        label: 'Carrusel de imágenes destacadas',
                        child: const Carousel(),
                      ),
                      const SizedBox(height: AppConstants.spacing),
                      /*Semantics(
                        label: 'Banner informativo',
                        child: const StaticBanner(),
                      ),*/
                      const SizedBox(height: AppConstants.spacing),
                      Semantics(
                        label: 'Secciones de lugares para visitar',
                        child: Sections(
                          accessible: false,
                          english: english,
                        ),
                      ),
                      Semantics(
                        label: 'Redes sociales',
                        child: _buildSocialMediaSection(),
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

  Widget _buildSocialMediaSection() {
    return Consumer<PersonalizationModel>(
      builder: (context, personalizationModel, child) {
        return Container(
          padding: const EdgeInsets.all(AppConstants.spacing),
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 23, 48, 80),
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          ),
          child: Column(
            children: [
              Text(
                english ? 'Follow us on social media' : 'Síguenos en redes sociales',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color.fromARGB(255, 23, 48, 80),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.shortSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (personalizationModel.facebookUrl != null)
                    _buildSocialMediaButton(
                      imagePath: 'assets/icons/facebook.png',
                      label: 'Facebook',
                      onTap: () => _openSocialMedia(personalizationModel.facebookUrl!),
                    ),
                  if (personalizationModel.instagramUrl != null)
                    _buildSocialMediaButton(
                      imagePath: 'assets/icons/instaBlue.png',
                      label: 'Instagram',
                      onTap: () => _openSocialMedia(personalizationModel.instagramUrl!),
                    ),
                  if (personalizationModel.youtubeUrl != null)
                    _buildSocialMediaButton(
                      imagePath: 'assets/icons/yt.png',
                      label: 'YouTube',
                      onTap: () => _openSocialMedia(personalizationModel.youtubeUrl!),
                    ),
                  if (personalizationModel.twitterUrl != null)
                    _buildSocialMediaButton(
                      imagePath: 'assets/icons/x.png',
                      label: 'Twitter',
                      onTap: () => _openSocialMedia(personalizationModel.twitterUrl!),
                    ),
                  if (personalizationModel.linkedinUrl != null)
                    _buildSocialMediaButton(
                      imagePath: 'assets/icons/linkedin.png',
                      label: 'LinkedIn',
                      onTap: () => _openSocialMedia(personalizationModel.linkedinUrl!),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSocialMediaButton({
    IconData? icon,
    String? imagePath,
    required String label,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 23, 48, 80),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: imagePath != null
              ? Image.asset(
                  imagePath,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                )
              : Icon(
                  icon!,
                  color: AppConstants.contrast,
                  size: 24,
                ),
        ),
      ),
    );
  }

  void _openSocialMedia(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } else {
        print('No se pudo abrir la URL: $url');
        // Intentar abrir en el navegador como fallback
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error al abrir la URL: $e');
    }
  }
}
