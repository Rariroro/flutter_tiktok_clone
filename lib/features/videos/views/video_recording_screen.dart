import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constants/gaps.dart';
import 'package:flutter_tiktok_clone/constants/sizes.dart';
import 'package:flutter_tiktok_clone/features/videos/views/video_preview_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = "postVideo";
  static const String routeURL = "/upload";

  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _deniedPermission = false;
  bool _isSelfieMode = false;

  late final bool _noCamera = kDebugMode && Platform.isIOS;

  //zoom기능
  double _maxZoomLevel = 1.0;
  double _currentZoomLevel = 1.0;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _buttonAnimation =
      Tween(begin: 1.0, end: 1.3).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late FlashMode _flashMode;

  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    if (!_noCamera) {
      initPermission();
    } else {
      setState(() {
        _hasPermission = true;
      });
    }
    WidgetsBinding.instance.addObserver(this);
    _progressAnimationController.addListener(
      () {
        setState(() {});
      },
    );
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _buttonAnimationController.dispose();
    if (!_noCamera) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  bool _prepareDispose = false;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_noCamera) return;
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _prepareDispose = true;
      setState(() {});
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _prepareDispose = false;
      await initCamera();
      setState(() {});
    }
  }

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

    await _cameraController.prepareForVideoRecording(); //iOS에서만 필요

    _maxZoomLevel = await _cameraController.getMaxZoomLevel();

    _flashMode = _cameraController.value.flashMode;
    setState(() {});
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

  Future<void> _startRecording(TapDownDetails _) async {
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController.stopVideoRecording();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: false,
        ),
      ),
    );
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (video == null) return;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: true,
        ),
      ),
    );
  }

  void _onZoomDrag(DragUpdateDetails details) {
    // print(details.delta.dy);
    //print("aa${details.delta.dy * -1}");

    late double zoomDelta = (details.delta.dy * -0.01);

    _currentZoomLevel += zoomDelta;
    _currentZoomLevel = _currentZoomLevel.clamp(1.0, _maxZoomLevel);
    _cameraController.setZoomLevel(_currentZoomLevel);
    //setState(() {});

    //  if (zoomDrag <= _maxZoomLevel) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: !_hasPermission
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
                    if (!_prepareDispose &&
                        ((!_noCamera) && _cameraController.value.isInitialized))
                      CameraPreview(_cameraController),
                    const Positioned(
                      top: Sizes.size40,
                      left: Sizes.size20,
                      child: CloseButton(
                        color: Colors.white,
                      ),
                    ),
                    if (!_noCamera)
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
                    Positioned(
                      bottom: Sizes.size40,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onPanUpdate: _onZoomDrag,
                            onPanEnd: (details) => _stopRecording(),
                            onTapDown: _startRecording,
                            onTapUp: (details) => _stopRecording(),
                            child: ScaleTransition(
                              scale: _buttonAnimation,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: Sizes.size80 + Sizes.size14,
                                    height: Sizes.size80 + Sizes.size14,
                                    child: CircularProgressIndicator(
                                      color: Colors.red.shade400,
                                      strokeWidth: Sizes.size6,
                                      value: _progressAnimationController.value,
                                    ),
                                  ),
                                  Container(
                                    width: Sizes.size80,
                                    height: Sizes.size80,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red.shade400),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: IconButton(
                                  onPressed: _onPickVideoPressed,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.image,
                                    color: Colors.white,
                                  )),
                            ),
                          )
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
