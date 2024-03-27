import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends StatefulWidget {
  final XFile video;
  final bool isPicked;

  const VideoPreviewScreen({
    super.key,
    required this.video,
    required this.isPicked,
  });

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late final VideoPlayerController _videoPlayerController;

  bool _saveVideo = false;

  Future<void> _initVideo() async {
    _videoPlayerController = VideoPlayerController.file(
      File(widget.video.path),
    );
    await _videoPlayerController.initialize();

    await _videoPlayerController.setLooping(true);

    await _videoPlayerController.play();

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initVideo();
  }

  Future<void> _saveToGallery() async {
    if (_saveVideo) return;

    await GallerySaver.saveVideo(widget.video.path, albumName: "TicTok Clone!");
    //await ImageGallerySaver.saveFile(widget.video.path, name: "TicTok Clone!");
    _saveVideo = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Preview video'),
        actions: [
          if (!widget.isPicked)
            IconButton(
              onPressed: _saveToGallery,
              icon: FaIcon(_saveVideo
                  ? FontAwesomeIcons.check
                  : FontAwesomeIcons.download),
            ),
        ],
      ),
      body: _videoPlayerController.value.isInitialized
          ? VideoPlayer(_videoPlayerController)
          : null,
    );
  }
}
