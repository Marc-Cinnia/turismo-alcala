import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/personalization_model.dart';

class PersonalizationService {
  static Future<void> fetchPersonalizationData(
    PersonalizationModel model, 
    bool isEnglish
  ) async {
    model.setLoading(true);
    model.setError(null);

    try {
      final String url = isEnglish 
          ? AppConstants.sloganEn 
          : AppConstants.slogan;

      final response = await http.get(
        Uri.parse(url),
        headers: AppConstants.requestHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        if (data.isNotEmpty) {
          final personalizationData = data[0];
          
          // Extract social media URLs
          model.setFacebookUrl(personalizationData['field_personalization_facebook']?[0]?['value']);
          model.setInstagramUrl(personalizationData['field_personalization_instagram']?[0]?['value']);
          model.setTwitterUrl(personalizationData['field_personalization_twitter']?[0]?['value']);
          model.setYoutubeUrl(personalizationData['field_personalization_youtube']?[0]?['value']);
          model.setLinkedinUrl(personalizationData['field_personalization_linkedin']?[0]?['value']);
          
          // Extract other personalization data
          model.setSlogan(personalizationData['field_personalization_eslogan']?[0]?['value']);
          model.setWelcomeTitle(personalizationData['field_personalization_wtitle']?[0]?['value']);
          model.setWelcomeDescription(personalizationData['field_personalization_wdescrip']?[0]?['value']);
          model.setWelcomeFeatured(personalizationData['field_personalization_wfeatured']?[0]?['value']);
          
          // Extract images
          final welcomeImageData = personalizationData['field_personalization_wimage']?[0];
          if (welcomeImageData != null) {
            model.setWelcomeImage(welcomeImageData['url']);
          }
          
          final loadingImageData = personalizationData['field_personalization_loading']?[0];
          if (loadingImageData != null) {
            model.setLoadingImage(loadingImageData['url']);
          }
          
          final footerImageData = personalizationData['field_personalization_footer']?[0];
          if (footerImageData != null) {
            model.setFooterImage(footerImageData['url']);
          }
        }
      } else {
        model.setError('Error al cargar los datos de personalización: ${response.statusCode}');
      }
    } catch (e) {
      model.setError('Error de conexión: $e');
    } finally {
      model.setLoading(false);
    }
  }
}
