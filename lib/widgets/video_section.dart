import 'package:flutter/material.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/widgets/video_container.dart';

class VideoSection extends StatelessWidget {
  const VideoSection({
    super.key,
    required this.videoUrl,
  });

  final String? videoUrl;

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: AppConstants.spacing);
    Widget content = const SizedBox();

    if (videoUrl != null && videoUrl!.isNotEmpty) {
      content = Column(
        children: [
          spacer,
          Padding(
            padding: const EdgeInsets.only(
              top: AppConstants.spacing,
              left: AppConstants.spacing,
              right: AppConstants.spacing,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppConstants.videoSectionLabel,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppConstants.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          spacer,
          VideoContainer(videoUrl: videoUrl!),
          spacer,
        ],
      );
    }

    return content;
  }
}
