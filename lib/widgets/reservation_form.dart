// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/session_model.dart';
import 'package:valdeiglesias/widgets/login_form.dart';

class ReservationForm extends StatefulWidget {
  ReservationForm(
      {super.key, this.restaurantId, this.hotelId, this.tourId, this.cellarId});

  final int? restaurantId;
  final int? hotelId;
  final int? tourId;
  final int? cellarId;

  @override
  State<ReservationForm> createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();
  final _peopleController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final _dateTimeOutController = TextEditingController();
  final _commentController = TextEditingController();

  late bool _dateOutEnabled;
  late LanguageModel _language;
  late SessionModel _session;
  late DateTime _first;
  late DateTime _last;
  late DateTime _dateInSelected;
  late DateTime _dateOutSelected;

  @override
  void initState() {
    super.initState();
    _first = DateTime.now();
    _last = DateTime.now().add(Duration(days: 7300));
    _dateOutEnabled = false;
  }

  @override
  Widget build(BuildContext context) {
    _language = context.watch<LanguageModel>();
    _session = context.watch<SessionModel>();

    String bookPlaceLabel = (_language.english)
        ? AppConstants.bookPlaceBtnLabelEn
        : AppConstants.bookPlaceLabel;

    String peopleNumberLabel = (_language.english)
        ? AppConstants.peopleNumberLabelEn
        : AppConstants.peopleNumberLabel;

    String dateTimeLabel = (_language.english)
        ? AppConstants.dateTimeLabelEn
        : AppConstants.dateTimeLabel;

    String dateTimeOutLabel = (_language.english)
        ? AppConstants.dateTimeOutLabelEn
        : AppConstants.dateTimeOutLabel;

    String commentLabel = (_language.english)
        ? AppConstants.commentLabelEn
        : AppConstants.commentLabel;

    String bookPlaceBtnLabel = (_language.english)
        ? AppConstants.bookPlaceBtnLabelEn
        : AppConstants.bookPlaceBtnLabel;

    if (widget.hotelId != null) {
      dateTimeLabel = (_language.english)
          ? AppConstants.dateTimeInLabelEn
          : AppConstants.dateTimeInLabel;
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: AppConstants.spacing,
              left: AppConstants.spacing,
              right: AppConstants.spacing,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                bookPlaceLabel,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppConstants.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacing),
          TextFormField(
            controller: _peopleController,
            style: TextStyle(color: AppConstants.primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return (_language.english)
                    ? AppConstants.requiredFieldMsgEn
                    : AppConstants.requiredFieldMsg;
              }

              return null;
            },
            decoration: InputDecoration(
              hintText: peopleNumberLabel,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.cardBorderRadius,
                ),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppConstants.spacing),
          TextFormField(
            controller: _dateTimeController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return (_language.english)
                    ? AppConstants.mandatoryFieldLabelEn
                    : AppConstants.mandatoryFieldLabel;
              }

              return null;
            },
            style: TextStyle(color: AppConstants.primary),
            decoration: InputDecoration(
              hintText: dateTimeLabel,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.cardBorderRadius,
                ),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.datetime,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());

              showDatePicker(
                context: context,
                firstDate: _first,
                lastDate: _last,
              ).then(
                (dateSelected) {
                  if (dateSelected != null) {
                    if (widget.hotelId == null) {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then(
                        (timeSelected) {
                          if (timeSelected != null) {
                            final dateTimeSelected = DateTime(
                              dateSelected.year,
                              dateSelected.month,
                              dateSelected.day,
                              timeSelected.hour,
                              timeSelected.minute,
                            );

                            _dateInSelected = dateTimeSelected;
                            _dateTimeController.text = DateFormat(
                              AppConstants.planDateFormat,
                            ).format(dateTimeSelected);
                          } else {
                            String message = (_language.english)
                                ? AppConstants.reservationTimeRequiredMsgEn
                                : AppConstants.reservationTimeRequiredMsg;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                              ),
                            );
                          }
                        },
                      );
                    } else if (widget.hotelId != null) {
                      _dateTimeController.text = DateFormat(
                        AppConstants.mainBasicDateFormat,
                      ).format(
                        dateSelected,
                      );
                    }

                    setState(
                      () {
                        _dateTimeOutController.text = '';
                        _dateInSelected = dateSelected;
                        _dateOutEnabled = true;
                      },
                    );
                  } else {
                    String message = (_language.english)
                        ? AppConstants.reservationDateRequiredMsgEn
                        : AppConstants.reservationDateRequiredMsg;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                      ),
                    );
                  }
                },
              );
            },
          ),
          const SizedBox(height: AppConstants.spacing),
          (widget.hotelId != null)
              ? TextFormField(
                  controller: _dateTimeOutController,
                  enabled: _dateOutEnabled,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return (_language.english)
                          ? AppConstants.mandatoryFieldLabelEn
                          : AppConstants.mandatoryFieldLabel;
                    }

                    return null;
                  },
                  style: TextStyle(color: AppConstants.primary),
                  decoration: InputDecoration(
                    hintText: dateTimeOutLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.cardBorderRadius,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.datetime,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    final firstDate = _dateInSelected.add(Duration(days: 1));

                    showDatePicker(
                      context: context,
                      currentDate: firstDate,
                      firstDate: firstDate,
                      lastDate: DateTime.now().add(
                        Duration(days: 7300),
                      ),
                    ).then((dateSelected) {
                      if (dateSelected != null) {
                        _dateOutSelected = dateSelected;
                        _dateTimeOutController.text = DateFormat(
                          AppConstants.mainBasicDateFormat,
                        ).format(
                          dateSelected,
                        );
                      } else {
                        String message = (_language.english)
                            ? AppConstants.reservationDateRequiredMsgEn
                            : AppConstants.reservationDateRequiredMsg;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                          ),
                        );
                      }
                    });
                  },
                )
              : const SizedBox(),
          const SizedBox(height: AppConstants.spacing),
          TextFormField(
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
          ),
          const SizedBox(height: AppConstants.spacing),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (_session.isActive) {
                    final resultMsg = await _makeReservation(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(resultMsg),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    final reservationMsg = (_language.english)
                        ? AppConstants.reservationMessageEn
                        : AppConstants.reservationMessage;

                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) =>
                          LoginForm(descriptionMessage: reservationMsg),
                    ).then(
                      (_) async {
                        if (_session.isActive) {
                          String loginMessage = (_language.english)
                              ? AppConstants.succesfulLoginEn
                              : AppConstants.succesfulLogin;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(loginMessage),
                              duration: Duration(seconds: 2),
                            ),
                          );

                          final resultMsg = await _makeReservation(context);
                        }
                      },
                    );
                  }
                }
              },
              icon: Icon(
                Icons.book_outlined,
                color: AppConstants.contrast,
              ),
              label: Text(
                bookPlaceBtnLabel,
                style: GoogleFonts.dmSans().copyWith(
                  color: AppConstants.contrast,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _makeReservation(BuildContext context) async {
    var reservationResponse;
    String reservationUrl = '';
    Map<String, dynamic> reservationBody = {};
    String statusMsg = (_language.english)
        ? AppConstants.reservationFailedMsgEn
        : AppConstants.reservationFailedMsg;
    var dateFormat = DateFormat(AppConstants.dateFormat);

    if (widget.restaurantId != null) {
      if (_session.credentials != null) {
        reservationUrl = AppConstants.reservationRestaurant;
        reservationBody = {
          'people': _peopleController.text,
          'date_hour': dateFormat.format(_dateInSelected),
          'commentary': _commentController.text,
          'id_restaurant': widget.restaurantId,
          'login': _session.credentials!.user,
          'password': _session.credentials!.pwd,
          'state': AppConstants.state,
        };
      }
    }

    if (widget.hotelId != null) {
      if (_session.credentials != null) {
        dateFormat = DateFormat(AppConstants.basicDateFormat);
        reservationUrl = AppConstants.reservationHotel;
        reservationBody = {
          'people': _peopleController.text,
          'date_in': dateFormat.format(_dateInSelected),
          'date_out': dateFormat.format(_dateOutSelected),
          'commentary': _commentController.text,
          'id_hotel': widget.hotelId,
          'login': _session.credentials!.user,
          'password': _session.credentials!.pwd,
          'state': AppConstants.state,
        };
      }
    }

    if (widget.tourId != null) {
      if (_session.credentials != null) {
        reservationUrl = AppConstants.reservationTour;
        reservationBody = {
          'people': int.parse(_peopleController.text),
          'date_hour': dateFormat.format(_dateInSelected),
          'commentary': _commentController.text,
          'id_tour': widget.tourId,
          'login': _session.credentials!.user,
          'password': _session.credentials!.pwd,
          'state': AppConstants.state,
        };
      }
    }

    if (widget.cellarId != null) {
      if (_session.credentials != null) {
        reservationUrl = AppConstants.reservationCellar;
        reservationBody = {
          'people': int.parse(_peopleController.text),
          'date_hour': dateFormat.format(_dateInSelected),
          'commentary': _commentController.text,
          'id_cellar': widget.cellarId,
          'login': _session.credentials!.user,
          'password': _session.credentials!.pwd,
          'state': AppConstants.state,
        };
      }
    }

    if (reservationBody.isNotEmpty) {
      var parse = Uri.parse(reservationUrl);
      var jsonEncode2 = jsonEncode(reservationBody);
      reservationResponse = await http.post(
        parse,
        headers: AppConstants.requestHeaders,
        body: jsonEncode2,
      );

      if (reservationResponse.statusCode == AppConstants.created) {
        statusMsg = (_language.english)
            ? AppConstants.reservationSuccessfulMsgEn
            : AppConstants.reservationSuccessfulMsg;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(statusMsg),
            duration: Duration(seconds: 3),
          ),
        );

        setState(
          () {
            _peopleController.clear();
            _dateTimeController.clear();
            _commentController.clear();

            if (widget.hotelId != null) {
              _dateTimeOutController.clear();
              _dateOutEnabled = false;
            }
          },
        );
      }
    }

    return statusMsg;
  }
}
