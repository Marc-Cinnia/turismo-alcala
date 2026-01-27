import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';

class VideoContainer extends StatefulWidget {
  const VideoContainer({
    super.key,
    required this.videoUrl,
  });

  final String videoUrl;

  @override
  State<VideoContainer> createState() => _VideoContainerState();
}

class _VideoContainerState extends State<VideoContainer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayer;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _initializeVideoPlayer = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayer,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              const SizedBox(height: AppConstants.spacing),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: () => setState(
                    () {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    },
                  ),
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: AppConstants.contrast,
                  ),
                  label: Text(
                    _controller.value.isPlaying
                        ? AppConstants.pauseVideoLabel
                        : AppConstants.playVideoLabel,
                    style: GoogleFonts.dmSans().copyWith(
                      color: AppConstants.contrast,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(child: LoaderBuilder.getLoader());
        }
      },
    );
  }
}
