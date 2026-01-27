import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/services/sign_up_service.dart';
import 'package:valdeiglesias/utils/content_builder.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers:
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pwdController = TextEditingController();
  final _pwdConfirmController = TextEditingController();

  final outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      AppConstants.cardBorderRadius,
    ),
    borderSide: BorderSide.none,
  );
  final spacer = const SizedBox(height: AppConstants.spacing);

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageModel>();
    final title = (language.english)
        ? AppConstants.signUpUserTitleEn
        : AppConstants.signUpUserTitle;

    // Headings for fields:
    final nameTitle = (language.english)
        ? AppConstants.signUpNameLabelEn
        : AppConstants.signUpNameLabel;
    final lastNameTitle = (language.english)
        ? AppConstants.signUpLastNameLabelEn
        : AppConstants.signUpLastNameLabel;
    final emailTitle = (language.english)
        ? AppConstants.signUpEmailLabelEn
        : AppConstants.signUpEmailLabel;
    final phoneTitle = (language.english)
        ? AppConstants.signUpPhoneLabelEn
        : AppConstants.signUpPhoneLabel;
    final passwordTitle = (language.english)
        ? AppConstants.signUpPwdLabelEn
        : AppConstants.signUpPwdLabel;
    final passwordConfirmTitle = (language.english)
        ? AppConstants.signUpPwdConfLabelEn
        : AppConstants.signUpPwdConfLabel;
    final registerLabel = (language.english)
        ? AppConstants.signUpSubmitLabelEn
        : AppConstants.signUpSubmitLabel;

    final signUpButton = OverflowBar(
      alignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {}
          },
          icon: const Icon(
            Icons.send_outlined,
            color: Colors.white,
          ),
          label: Text(
            registerLabel,
            style: GoogleFonts.dmSans().copyWith(
              color: Colors.white,
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

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(title),
        centerTitle: true,
        actions: ContentBuilder.getActions(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: AppConstants.spacing,
          top: AppConstants.spacing,
          right: AppConstants.spacing,
          bottom: AppConstants.contentBottomSpacing,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    nameTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppConstants.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                spacer,
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: AppConstants.primary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      final message = (language.english)
                          ? AppConstants.requiredFieldMsgEn
                          : AppConstants.requiredFieldMsg;

                      return message;
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    border: outlineInputBorder,
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.text,
                ),
                spacer,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    lastNameTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppConstants.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                spacer,
                TextFormField(
                  controller: _lastNameController,
                  style: TextStyle(color: AppConstants.primary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      final message = (language.english)
                          ? AppConstants.requiredFieldMsgEn
                          : AppConstants.requiredFieldMsg;

                      return message;
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    border: outlineInputBorder,
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.text,
                ),
                spacer,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    emailTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppConstants.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                spacer,
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: AppConstants.primary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      final message = (language.english)
                          ? AppConstants.requiredFieldMsgEn
                          : AppConstants.requiredFieldMsg;

                      return message;
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    border: outlineInputBorder,
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                spacer,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    phoneTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppConstants.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                spacer,
                TextFormField(
                  controller: _phoneController,
                  style: TextStyle(color: AppConstants.primary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      final message = (language.english)
                          ? AppConstants.requiredFieldMsgEn
                          : AppConstants.requiredFieldMsg;

                      return message;
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    border: outlineInputBorder,
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.number,
                ),
                spacer,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    passwordTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppConstants.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                spacer,
                TextFormField(
                  controller: _pwdController,
                  obscureText: true,
                  style: TextStyle(color: AppConstants.primary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      final message = (language.english)
                          ? AppConstants.requiredFieldMsgEn
                          : AppConstants.requiredFieldMsg;

                      return message;
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    border: outlineInputBorder,
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                spacer,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    passwordConfirmTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppConstants.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                spacer,
                TextFormField(
                  obscureText: true,
                  controller: _pwdConfirmController,
                  style: TextStyle(color: AppConstants.primary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      final message = (language.english)
                          ? AppConstants.requiredFieldMsgEn
                          : AppConstants.requiredFieldMsg;

                      return message;
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    border: outlineInputBorder,
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                spacer,
                OverflowBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> request = {
                            'name': _nameController.text,
                            'surname': _lastNameController.text,
                            'email': _emailController.text,
                            'phone': _phoneController.text,
                            'password': _pwdController.text,
                            'password_confirmation': _pwdConfirmController.text,
                          };

                          final Map<String, dynamic>? result =
                              await SignUpService.registerUser(
                            request,
                          );

                          if (result != null) {
                            final message = (language.english)
                                ? result[AppConstants.signUpMessageEnKey]!
                                : result[AppConstants.signUpMessageKey]!;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                              ),
                            );

                            if (result[AppConstants.signUpSuccessKey]) {
                              _clearFields();
                            }
                          }
                        }
                      },
                      icon: const Icon(
                        Icons.app_registration_outlined,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      label: Text(
                        registerLabel,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _clearFields() {
    setState(
      () {
        _nameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _pwdController.clear();
        _pwdConfirmController.clear();
      },
    );
  }
}
