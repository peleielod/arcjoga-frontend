import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class UserCamera extends StatefulWidget {
  const UserCamera({super.key});

  @override
  State<UserCamera> createState() => _UserCameraState();
}

class _UserCameraState extends State<UserCamera> {
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
      );

      await _controller?.initialize();
      setState(() {});
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: 150,
      height: 400,
      child: CameraPreview(_controller!),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
