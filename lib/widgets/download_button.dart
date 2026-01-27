import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:valdeiglesias/constants/app_constants.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.downloadUrl,
  });

  final String downloadUrl;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton.icon(
        onPressed: () {
          if (downloadUrl.isNotEmpty) {
            Uri toLaunch = Uri.parse(downloadUrl).replace(
              scheme: 'https',
            );
            _launchInBrowser(toLaunch);
          }
        },
        icon: const Icon(
          Icons.download_outlined,
          color: AppConstants.contrast,
        ),
        label: Text(
          AppConstants.downloadFileLabel,
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
    );
  }

  void _launchInBrowser(Uri uriToLaunch) async {
    bool launched =
        await launchUrl(uriToLaunch, mode: LaunchMode.externalApplication);

    if (!launched) {
      throw Exception('Could not launch $uriToLaunch');
    }
  }
}
