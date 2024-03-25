import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ContentVideoPlayer extends StatefulWidget {
  const ContentVideoPlayer({super.key});

  @override
  State<ContentVideoPlayer> createState() => _ContentVideoPlayerState();
}

class _ContentVideoPlayerState extends State<ContentVideoPlayer> {
  late VideoPlayerController _controller;
  @override
// void initState() {
//   _controller = VideoPlayerController.networkUrl('');
// }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }
}
