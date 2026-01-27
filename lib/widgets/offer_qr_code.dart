import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/offer.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/session_model.dart';

class OfferQRCode extends StatelessWidget {
  const OfferQRCode({
    super.key,
    required this.offer,
  });

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final english = context.watch<LanguageModel>().english;
    final session = context.watch<SessionModel>();

    final spacer = const SizedBox(height: AppConstants.spacing);

    final qrCodeLabel = (english)
        ? AppConstants.offerQRCodeLabelEn
        : AppConstants.offerQRCodeLabel;

    final side = MediaQuery.of(context).size.width;

    String qrCodeUrl = '';

    if (session.isActive) {
      qrCodeUrl =
          '${AppConstants.checkOffer}/${offer.offerId}/${session.credentials!.userId}';
    }

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(qrCodeLabel),
        ),
        spacer,
        SizedBox(
          width: side,
          height: side,
          child: QrImageView(
            data: qrCodeUrl,
          ),
        ),
      ],
    );
  }
}
