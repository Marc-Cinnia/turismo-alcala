import 'package:flutter/material.dart';
import 'package:super_network_image/super_network_image.dart';
import 'package:valdeiglesias/constants/app_constants.dart';

class LoadingImage extends StatefulWidget {
  const LoadingImage({super.key});

  @override
  State<LoadingImage> createState() => _LoadingImageState();
}

class _LoadingImageState extends State<LoadingImage> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedOpacity(
        opacity: (_loaded) ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        child: SuperNetworkImage(
          url: AppConstants.loaderImageUrl,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
          onLoad: (_) => setState(() {
            _loaded = true;
          }),
        ),
      ),
    );
  }
}
