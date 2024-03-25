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
  bool _isSelfieMode = false;
  late FlashMode _flashMode;

  late CameraController _cameraController;

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }
    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();

    _flashMode = _cameraController.value.flashMode;
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

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFalshmode) async {
    await _cameraController.setFlashMode(newFalshmode);
    _flashMode = newFalshmode;
    setState(() {});
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
                  alignment: Alignment.center,
                  children: [
                    CameraPreview(_cameraController),
                    Positioned(
                      top: Sizes.size20,
                      right: Sizes.size20,
                      child: Column(
                        children: [
                          IconButton(
                            color: Colors.white,
                            onPressed: _toggleSelfieMode,
                            icon: const Icon(
                              Icons.cameraswitch,
                            ),
                          ),
                          Gaps.v10,
                          videoFlashmodeButton(
                              FlashMode.off, Icons.flash_off_rounded),
                          Gaps.v10,
                          videoFlashmodeButton(
                              FlashMode.always, Icons.flash_on_rounded),
                          Gaps.v10,
                          videoFlashmodeButton(
                              FlashMode.auto, Icons.flash_auto_rounded),
                          Gaps.v10,
                          videoFlashmodeButton(
                              FlashMode.torch, Icons.flashlight_on_rounded),
                          /*  Gaps.v10,
                          IconButton(
                            color: _flashMode == FlashMode.auto
                                ? Colors.amber.shade200
                                : Colors.white,
                            onPressed: () => _setFlashMode(FlashMode.auto),
                            icon: const Icon(
                              Icons.flash_auto_rounded,
                            ),
                          ),
                          Gaps.v10,
                          IconButton(
                            color: _flashMode == FlashMode.torch
                                ? Colors.amber.shade200
                                : Colors.white,
                            onPressed: () => _setFlashMode(FlashMode.torch),
                            icon: const Icon(
                              Icons.flashlight_on_rounded,
                            ),
                          ), */
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  IconButton videoFlashmodeButton(FlashMode flashMode, IconData iconData) {
    return IconButton(
      color: _flashMode == flashMode ? Colors.amber.shade200 : Colors.white,
      onPressed: () => _setFlashMode(flashMode),
      icon: Icon(
        iconData,
      ),
    );
  }
}
