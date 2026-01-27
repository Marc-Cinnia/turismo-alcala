import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/journey_point.dart';
import 'package:valdeiglesias/dtos/user_auth.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/plan_model.dart';
import 'package:valdeiglesias/models/session_model.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.descriptionMessage,
  });

  final String descriptionMessage;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _userLabel = 'Usuario';
  final _pwdLabel = 'Contraseña';
  final _userController = TextEditingController();
  final _pwdController = TextEditingController();

  late LanguageModel _language;
  late SessionModel _session;

  List<JourneyPoint>? _apiPlan = [];

  @override
  Widget build(BuildContext context) {
    _session = context.watch<SessionModel>();
    _language = context.watch<LanguageModel>();

    final loginDialogTitle = (_language.english)
        ? AppConstants.loginDialogTitleEn
        : AppConstants.loginDialogTitle;

    final loginSemanticLabel = (_language.english)
        ? AppConstants.loginSemanticLabelEn
        : AppConstants.loginSemanticLabel;

    final loginLabel = (_language.english)
        ? AppConstants.loginSettingsLabelEn
        : AppConstants.loginSettingsLabel;

    return AlertDialog(
      semanticLabel: loginSemanticLabel,
      title: Text(loginDialogTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.descriptionMessage,
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: AppConstants.spacing,
            ),
            TextFormField(
              controller: _userController,
              decoration: InputDecoration(hintText: _userLabel),
              validator: (user) {
                if (user == null || user.isEmpty) {
                  return 'Campo "$_userLabel" obligatorio';
                }

                return null;
              },
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(
              height: AppConstants.spacing,
            ),
            TextFormField(
              controller: _pwdController,
              obscureText: true,
              decoration: InputDecoration(hintText: _pwdLabel),
              validator: (pwd) {
                if (pwd == null || pwd.isEmpty) {
                  return 'Campo "$_pwdLabel" obligatorio';
                }

                return null;
              },
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(
              height: AppConstants.spacing,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Text(
            AppConstants.cancel,
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
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final userAuth = UserAuth(
                user: _userController.text,
                pwd: _pwdController.text,
              );

              _session.loginUser(userAuth).then(
                (_) async {
                  if (_session.isActive) {
                    if (_session.credentials != null) {
                      _apiPlan = await context
                          .read<PlanModel>()
                          .fetchUserPlan(_session.credentials!);
                    }
                  }

                  Navigator.pop(
                    context,
                    _apiPlan,
                  );
                },
              );
            }
          },
          icon: const Icon(
            Icons.login_outlined,
            color: Colors.white,
          ),
          label: Text(
            loginLabel,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
    );
  }
}
