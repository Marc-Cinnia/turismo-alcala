import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/user_auth.dart';
import 'package:valdeiglesias/models/incident_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/session_model.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/image_picker_button.dart';
import 'package:valdeiglesias/widgets/incidents_map.dart';
import 'package:valdeiglesias/widgets/login_form.dart';

class Incidents extends StatefulWidget {
  @override
  State<Incidents> createState() => _IncidentsState();
}

class _IncidentsState extends State<Incidents> {
  final _incidentNameController = TextEditingController();
  final _incidentDescController = TextEditingController();
  final _reasonFieldController = TextEditingController();

  late bool _english;
  late bool _userPositionAdded;
  late LatLng? _userPosition;

  IncidentModel? _incidentModel;

  @override
  void didChangeDependencies() {
    if (_incidentModel != null && _incidentModel!.result.isNotEmpty) {
      _incidentNameController.clear();
      _incidentDescController.clear();
      _reasonFieldController.clear();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _english = context.watch<LanguageModel>().english;
    final appBarTitle =
        (_english) ? AppConstants.incidentLabelEn : AppConstants.incidentLabel;
    _incidentModel = context.watch<IncidentModel>();
    _userPositionAdded = context.watch<IncidentModel>().userPositionAdded;
    _userPosition = context.watch<IncidentModel>().userPosition;

    final session = context.watch<SessionModel>();

    final spacer = const SizedBox(height: AppConstants.spacing);
    final divider = const Divider();

    final description = Text(
      (_english)
          ? AppConstants.incidentDescriptionEn
          : AppConstants.incidentDescription,
      textAlign: TextAlign.justify,
    );

    final incidentReasonTitle = Align(
      alignment: Alignment.centerLeft,
      child:       Padding(
        padding: const EdgeInsets.only(
          top: AppConstants.spacing,
          left: AppConstants.spacing,
          right: AppConstants.spacing,
        ),
        child: Text(
          (_english)
              ? AppConstants.incidentReasonTitleEn
              : AppConstants.incidentReasonTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );

    final incidentNameTitle = Align(
      alignment: Alignment.centerLeft,
      child:       Padding(
        padding: const EdgeInsets.only(
          top: AppConstants.spacing,
          left: AppConstants.spacing,
          right: AppConstants.spacing,
        ),
        child: Text(
          (_english)
              ? AppConstants.incidentNameLabelEn
              : AppConstants.incidentNameLabel,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );

    final incidentReasonHint = (_english)
        ? AppConstants.incidentReasonHintLabelEn
        : AppConstants.incidentReasonHintLabel;

    final entries = _incidentModel!.reasons.map(
      (reason) {
        final currentLabel = (_english) ? reason.nameEn : reason.name;

        return DropdownMenuEntry(
          value: reason.id,
          label: currentLabel,
        );
      },
    ).toList();

    final incidentNameLabel = (_english)
        ? AppConstants.incidentNameHintLabelEn
        : AppConstants.incidentNameHintLabel;

    final incidentNameField = Align(
      alignment: Alignment.center,
      child: SizedBox(
        child: TextFormField(
          controller: _incidentNameController,
          style: TextStyle(color: AppConstants.primary),
          decoration: InputDecoration(
            hintText: incidentNameLabel,
            hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.primary,
                  fontWeight: FontWeight.w300,
                ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.cardBorderRadius,
              ),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppConstants.primary,
          ),
          keyboardType: TextInputType.text,
        ),
      ),
    );

    final incidentReasonField = Align(
      alignment: Alignment.center,
      child: DropdownMenu(
        controller: _reasonFieldController,
        dropdownMenuEntries: entries,
        hintText: incidentReasonHint,
        width: MediaQuery.of(context).size.width - (AppConstants.spacing * 2),
        menuHeight: AppConstants.carouselHeight,
        menuStyle: MenuStyle(),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppConstants.primary,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          ),
          hintStyle: const TextStyle(
            color: AppConstants.label,
          ),
        ),
        trailingIcon: const Icon(
          Icons.keyboard_arrow_down,
          color: AppConstants.label,
        ),
        onSelected: (value) =>
            context.read<IncidentModel>().selectReason(value),
      ),
    );

    String incidentDescLabel = (_english)
        ? AppConstants.incidentDescLabelEn
        : AppConstants.incidentDescLabel;

    final incidentDescriptionTitle = Align(
      alignment: Alignment.centerLeft,
      child:       Padding(
        padding: const EdgeInsets.only(
          top: AppConstants.spacing,
          left: AppConstants.spacing,
          right: AppConstants.spacing,
        ),
        child: Text(
          (_english)
              ? AppConstants.incidentDescriptionTitleEn
              : AppConstants.incidentDescriptionTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );

    final incidentDescriptionField = SizedBox(
      child: TextFormField(
        controller: _incidentDescController,
        style: TextStyle(color: AppConstants.primary),
        decoration: InputDecoration(
          hintText: incidentDescLabel,
          hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.primary,
                fontWeight: FontWeight.w300,
              ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.cardBorderRadius,
            ),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppConstants.primary,
        ),
        keyboardType: TextInputType.text,
      ),
    );

    final imagesTitle = (_english)
        ? AppConstants.incidentImagesTitleEn
        : AppConstants.incidentImagesTitle;

    final incidentImagesButton = ImagePickerButton(imagesTitle: imagesTitle);

    final sendIncidentLabel = (_english)
        ? AppConstants.sendIssueLabelEn
        : AppConstants.sendIssueLabel;

    final sendIssueButton = Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () {
          String message = (_english)
              ? AppConstants.incidentFieldsMissingLabelEn
              : AppConstants.incidentFieldsMissingLabel;

          if (_incidentNameController.text.isEmpty) {
            message = (_english)
                ? AppConstants.incidentNameMissingLabelEn
                : AppConstants.incidentNameMissingLabel;
            _showSnackBar(message);
          } else if (_incidentModel!.selectedReason == null) {
            message = (_english)
                ? AppConstants.incidentReasonNeededLabelEn
                : AppConstants.incidentReasonNeededLabel;
            _showSnackBar(message);
          } else if (_incidentDescController.text.isEmpty) {
            message = (_english)
                ? AppConstants.incidentDescriptionMissingLabelEn
                : AppConstants.incidentDescriptionMissingLabel;
            _showSnackBar(message);
          } else if (!_userPositionAdded) {
            message = (_english)
                ? AppConstants.incidentMapPointMissingEn
                : AppConstants.incidentMapPointMissing;
            _showSnackBar(message);
          } else if (_incidentModel!.image == null) {
            message = (_english)
                ? AppConstants.incidentImageMissingLabelEn
                : AppConstants.incidentImageMissingLabel;
            _showSnackBar(message);
          } else {
            if (session.isActive && session.credentials != null) {
              context
                  .read<IncidentModel>()
                  .setName(_incidentNameController.text);
              context
                  .read<IncidentModel>()
                  .setDescription(_incidentDescController.text);
              _sendIncident(session.credentials!);
            } else {
              final incidentAuthMsg = (_english)
                  ? AppConstants.incidentsAuthMessageEn
                  : AppConstants.incidentsAuthMessage;

              showDialog(
                context: context,
                builder: (context) => LoginForm(
                  descriptionMessage: incidentAuthMsg,
                ),
              ).then(
                (_) {
                  if (session.isActive && session.credentials != null) {
                    String loginMessage = (_english)
                        ? AppConstants.succesfulLoginEn
                        : AppConstants.succesfulLogin;

                    _showSnackBar(loginMessage);

                    context
                        .read<IncidentModel>()
                        .setName(_incidentNameController.text);
                    context
                        .read<IncidentModel>()
                        .setDescription(_incidentDescController.text);
                    _sendIncident(session.credentials!);
                  }
                },
              );
            }
          }
        },
        icon: const Icon(Icons.send_outlined, color: Colors.white),
        label: Text(
          sendIncidentLabel,
          style: GoogleFonts.dmSans().copyWith(
            color: AppConstants.primary,
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

    final incidentsMap = const IncidentsMap();

    final mainContent = (_incidentModel!.fetchingData)
        ? Center(child: LoaderBuilder.getLoader())
        : SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppConstants.spacing,
                right: AppConstants.spacing,
                bottom: AppConstants.contentBottomSpacing,
              ),
              child: Column(
                children: [
                  spacer,
                  description,
                  spacer,
                  divider,
                  spacer,
                  incidentNameTitle,
                  spacer,
                  incidentNameField,
                  spacer,
                  divider,
                  spacer,
                  incidentReasonTitle,
                  spacer,
                  incidentReasonField,
                  spacer,
                  divider,
                  spacer,
                  incidentDescriptionTitle,
                  spacer,
                  incidentDescriptionField,
                  spacer,
                  divider,
                  spacer,
                  incidentsMap,
                  spacer,
                  divider,
                  spacer,
                  incidentImagesButton,
                  spacer,
                  divider,
                  spacer,
                  sendIssueButton,
                ],
              ),
            ),
          );

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstants.backArrowColor),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppConstants.backArrowColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: DynamicTitle(
          value: appBarTitle,
          accessible: false,
        ),
        actions: ContentBuilder.getActions(),
      ),
      body: mainContent,
    );
  }

  void _sendIncident(UserAuth credentials) async {
    final message = (_english)
        ? AppConstants.incidentSendedLabelEn
        : AppConstants.incidentSendedLabel;

    if (_userPosition != null) {
      await context.read<IncidentModel>().sendIssueReport(credentials);
    }

    _showSnackBar(message);

    setState(
      () {
        _incidentNameController.clear();
        _incidentDescController.clear();
        _reasonFieldController.clear();
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
