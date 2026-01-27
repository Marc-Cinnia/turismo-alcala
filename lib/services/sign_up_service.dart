import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:valdeiglesias/constants/app_constants.dart';

class SignUpService {
  static Future<Map<String, dynamic>?> registerUser(
      Map<String, dynamic> request) async {
    String url = AppConstants.registerUrl;
    String requestEncoded = jsonEncode(request);

    Map<String, dynamic>? result;

    final response = await http.post(
      Uri.parse(url),
      headers: AppConstants.requestHeaders,
      body: requestEncoded,
    );

    if (response.statusCode == AppConstants.success) {
      result = {
        AppConstants.signUpMessageKey: AppConstants.signUpSuccess,
        AppConstants.signUpMessageEnKey: AppConstants.signUpSuccessEn,
        AppConstants.signUpSuccessKey: true,
      };
    } else {
      String message = AppConstants.signUpErrorGenericMessage;
      String messageEn = AppConstants.signUpErrorGenericMessageEn;
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      Map<String, dynamic> errors = responseBody['errors'];

      final List<dynamic>? emailError = errors[AppConstants.emailKey];
      final List<dynamic>? pwdError = errors[AppConstants.passwordKey];

      final bool emailHasData = emailError != null && emailError.isNotEmpty;
      final bool pwdHasData = pwdError != null && pwdError.isNotEmpty;

      if (emailHasData) {
        message = emailError.first.toString();
      }

      if (pwdHasData) {
        message = '$message\n${pwdError.first.toString()}';
      }

      if (emailHasData || pwdHasData) {
        result = {
          AppConstants.signUpMessageKey: message,
          AppConstants.signUpMessageEnKey: message,
          AppConstants.signUpSuccessKey: false,
        };
      } else {
        result = {
          AppConstants.signUpMessageKey: message,
          AppConstants.signUpMessageEnKey: messageEn,
        };
      }
    }

    return result;
  }
}
