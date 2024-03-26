import 'package:arcjoga_frontend/helpers.dart';
import 'package:arcjoga_frontend/models/course_content.dart';
import 'package:arcjoga_frontend/providers/user_provider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ContentVideoPlayer extends StatefulWidget {
  final CourseContent content;
  const ContentVideoPlayer({
    super.key,
    required this.content,
  });

  @override
  State<ContentVideoPlayer> createState() => _ContentVideoPlayerState();
}

class _ContentVideoPlayerState extends State<ContentVideoPlayer> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _isControllerInitialized = false;
  bool _hasWatchedContent = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers(widget.content.videoUrl);
  }

  void _initializeControllers(String videoUrl) {
    _controller?.dispose();
    _chewieController?.dispose();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller!.initialize().then((_) {
      _controller!.addListener(_videoPlayListener);
      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        aspectRatio: _controller!.value.aspectRatio,
        autoPlay: false,
        looping: false,
      );

      setState(() {
        _isControllerInitialized = true;
      });
    });
  }

  void _videoPlayListener() {
    if (_controller!.value.isPlaying && !_hasWatchedContent) {
      _hasWatchedContent = true;
      _handleWatchContent();
    }
  }

  @override
  void didUpdateWidget(covariant ContentVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.content.videoUrl != oldWidget.content.videoUrl) {
      _isControllerInitialized = false;
      _initializeControllers(widget.content.videoUrl);
    }
  }

  void _handleWatchContent() async {
    var isLoggedIn = await Provider.of<UserProvider>(
      context,
      listen: false,
    ).isUserLoggedIn();

    if (isLoggedIn) {
      var data = {
        'contentId': widget.content.id,
      };

      CustomResponse response = await Helpers.sendRequest(
        context,
        'user/watchContent',
        method: 'post',
        body: data,
        requireToken: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isControllerInitialized) {
      return const CircularProgressIndicator();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 250,
        child: _chewieController != null
            ? Chewie(
                controller: _chewieController!,
              )
            : const SizedBox(),
      ),
    );
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}
