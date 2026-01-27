import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/rating_model.dart';
import 'package:valdeiglesias/models/session_model.dart';
import 'package:valdeiglesias/widgets/login_form.dart';
import 'package:valdeiglesias/widgets/rating_stars_bar.dart';

class RatingPanel extends StatefulWidget {
  const RatingPanel({
    super.key,
    this.restaurantId,
    this.hotelId,
    this.shopId,
    this.tourId,
    this.cellarId,
    this.drupalId,
    this.drupalType,
  });

  final int? restaurantId;
  final int? hotelId;
  final int? shopId;
  final int? drupalId;
  final int? tourId;
  final int? cellarId;
  final String? drupalType;

  @override
  State<RatingPanel> createState() => _RatingPanelState();
}

class _RatingPanelState extends State<RatingPanel> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();

  late SessionModel _session;
  late RatingModel _rate;
  late LanguageModel _language;

  @override
  Widget build(BuildContext context) {
    final spacer = const SizedBox(height: AppConstants.spacing);
    final shortSpacer = const SizedBox(height: AppConstants.shortSpacing);
    final divider = const Divider();

    _language = context.watch<LanguageModel>();
    _rate = context.watch<RatingModel>();
    _session = context.watch<SessionModel>();

    final textTitle = Text(
      (_language.english)
          ? AppConstants.ratingTitleEn
          : AppConstants.ratingTitle,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppConstants.primary,
            fontWeight: FontWeight.w600,
          ),
    );

    final textCTA = Text(
      (_language.english)
          ? AppConstants.ratingCTALabelEn
          : AppConstants.ratingCTALabel,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppConstants.primary,
          ),
    );

    String commentLabel = (_language.english)
        ? AppConstants.commentLabelEn
        : AppConstants.commentLabel;

    final ratingBar = RatingStarsBar();

    final commentField = TextFormField(
      controller: _commentController,
      style: TextStyle(color: AppConstants.primary),
      decoration: InputDecoration(
        hintText: commentLabel,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.cardBorderRadius,
          ),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.text,
    );

    final rateButtonLabel = (_language.english)
        ? AppConstants.rateButtonLabelEn
        : AppConstants.rateButtonLabel;

    final ratingNeededMsg = (_language.english)
        ? AppConstants.ratingNeededLabelEn
        : AppConstants.ratingNeededLabel;

    final rateButton = Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (_rate.userRating != 0) {
            if (_session.isActive) {
              _makeReview();
            } else {
              final message = (_language.english)
                  ? AppConstants.ratingMessageEn
                  : AppConstants.ratingMessage;

              showDialog(
                context: context,
                builder: (context) => LoginForm(
                  descriptionMessage: message,
                ),
              ).then(
                (loginStatus) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(loginStatus),
                    ),
                  );

                  if (_session.isActive) {
                    _makeReview();
                  }
                },
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(ratingNeededMsg),
              ),
            );
          }
        },
        icon: const Icon(
          Icons.send_outlined,
          color: Colors.white,
        ),
        label: Text(
          rateButtonLabel,
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
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        spacer,
        divider,
        shortSpacer,
        Align(
          alignment: Alignment.centerLeft,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppConstants.shortSpacing,
                right: AppConstants.shortSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textTitle,
                  spacer,
                  textCTA,
                  ratingBar,
                  spacer,
                  commentField,
                  spacer,
                  rateButton,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _makeReview() async {
    final ratingSubmittedMsg = (_language.english)
        ? AppConstants.ratingSubmittedLabelEn
        : AppConstants.ratingSubmittedLabel;

    String comment = _commentController.text;
    String dateTime = DateFormat(AppConstants.dateFormat).format(
      DateTime.now(),
    );

    if (_session.credentials != null) {
      Map<String, dynamic> ratingBody = {
        "rating": _rate.userRating,
        "comment": comment,
        "date_hour": dateTime,
        "id_restaurant": widget.restaurantId,
        "id_hotel": widget.hotelId,
        "id_shop": widget.shopId,
        "id_tour": widget.tourId,
        "id_cellar": widget.cellarId,
        "id_drupal": widget.drupalId,
        "type_drupal": widget.drupalType,
        "login": _session.credentials!.user,
        "password": _session.credentials!.pwd,
      };

      String request = jsonEncode(ratingBody);

      final ratingResponse = await http.post(
        Uri.parse(AppConstants.ratingApi),
        headers: AppConstants.requestHeaders,
        body: request,
      );

      if (ratingResponse.statusCode == AppConstants.created) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ratingSubmittedMsg),
          ),
        );
        context.read<RatingModel>().clear();
        setState(() => _commentController.clear());
      }
    }
  }
}
