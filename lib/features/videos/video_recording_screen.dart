import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constants/gaps.dart';
import 'package:flutter_tiktok_clone/constants/sizes.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  bool _hasPermission = false;
  bool _deniedPermission = false;

  late final CameraController _cameraController;

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();
  }

  Future<void> initPermission() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;

      await initCamera();
      setState(() {});
    } else {
      _deniedPermission = true;

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: !_hasPermission || !_cameraController.value.isInitialized
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _deniedPermission
                        ? const Text(
                            "Require camera and microphone permission...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Sizes.size20,
                            ),
                          )
                        : const Text(
                            "Initializing...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Sizes.size20,
                            ),
                          ),
                    Gaps.v20,
                    const CircularProgressIndicator.adaptive(),
                  ],
                )
              : Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    CameraPreview(_cameraController),
                  ],
                ),
        ),
      ),
    );
  }
}
