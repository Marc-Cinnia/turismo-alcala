import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/incident_model.dart';
import 'package:valdeiglesias/models/language_model.dart';

class ImagePickerButton extends StatefulWidget {
  const ImagePickerButton({
    super.key,
    required this.imagesTitle,
  });

  final String imagesTitle;

  @override
  State<ImagePickerButton> createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  final ImagePicker _picker = ImagePicker();

  late LanguageModel _language;
  late bool _reportSent;

  File? _capturedImage;

  void _pickImage() async {
    XFile? pickedFile;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final pickFromCamera = (_language.english)
            ? AppConstants.pickFromCameraEn
            : AppConstants.pickFromCamera;

        final pickFromGallery = (_language.english)
            ? AppConstants.pickFromGalleryEn
            : AppConstants.pickFromGallery;

        final cameraButton = ElevatedButton.icon(
          onPressed: () async {
            pickedFile = await _picker.pickImage(source: ImageSource.camera);
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.camera,
            color: AppConstants.contrast,
          ),
          label: Text(
            pickFromCamera,
            style: GoogleFonts.dmSans().copyWith(
              color: AppConstants.contrast,
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
        );

        final galleryButton = ElevatedButton.icon(
          onPressed: () async {
            pickedFile = await _picker.pickImage(source: ImageSource.gallery);
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.browse_gallery_outlined,
            color: AppConstants.contrast,
          ),
          label: Text(
            pickFromGallery,
            style: GoogleFonts.dmSans().copyWith(
              color: AppConstants.contrast,
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
        );

        final dialogTitle = (_language.english)
            ? AppConstants.pickImageTitleEn
            : AppConstants.pickImageTitle;

        final dialogDescription = (_language.english)
            ? AppConstants.pickImageDescEn
            : AppConstants.pickImageDesc;

        return AlertDialog(
          title: Text(dialogTitle),
          content: Text(
            dialogDescription,
            style: TextStyle(
              color: AppConstants.primary,
              fontWeight: FontWeight.w200,
            ),
          ),
          actions: [
            cameraButton,
            galleryButton,
          ],
        );
      },
    ).then(
      (_) async {
        if (pickedFile != null) {
          String path = pickedFile?.path ?? '';
          final file = File(path);

          if (path.isNotEmpty) {
            setState(() => _capturedImage = file);
            final bytes = await file.readAsBytes();
            final mimeType = _getMimeType(path);
            final base64Image = 'data:$mimeType;base64,${base64Encode(bytes)}';
            context.read<IncidentModel>().setImage(base64Image);
          }
        }
      },
    );
  }

  String _getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();

    // Mapear la extensión al MIME type
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'gif':
        return 'image/gif';
      default:
        return 'application/octet-stream'; // Tipo genérico
    }
  }

  @override
  Widget build(BuildContext context) {
    _language = context.watch<LanguageModel>();
    _reportSent = context.watch<IncidentModel>().reportSent;

    final vSpacer = const SizedBox(width: AppConstants.shortSpacing);

    Widget imagePreview = const SizedBox();

    if (_capturedImage != null && !_reportSent) {
      imagePreview = ClipRRect(
        borderRadius: BorderRadius.circular(
          AppConstants.thumbnailBorderRadius,
        ),
        child: Image.file(
          _capturedImage!,
          height: AppConstants.previewWidth,
          width: AppConstants.previewHeight,
          fit: BoxFit.cover,
        ),
      );
    }

    final imagePickerButton = Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () => _pickImage(),
        icon: Icon(
          Icons.attach_file_outlined,
          color: AppConstants.contrast,
        ),
        label: Text(
          widget.imagesTitle,
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
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        width: constraints.maxWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            imagePreview,
            vSpacer,
            imagePickerButton,
          ],
        ),
      ),
    );
  }
}
