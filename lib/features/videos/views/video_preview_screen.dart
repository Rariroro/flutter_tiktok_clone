import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/constants/gaps.dart';
import 'package:flutter_tiktok_clone/features/videos/view_models/%08timeline_view_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends ConsumerStatefulWidget {
  final XFile video;
  final bool isPicked;

  const VideoPreviewScreen({
    super.key,
    required this.video,
    required this.isPicked,
  });

  @override
  VideoPreviewScreenState createState() => VideoPreviewScreenState();
}

class VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
  late final VideoPlayerController _videoPlayerController;

  bool _saveVideo = false;

  String _title = '';
  String _description = '';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _initVideo() async {
    _videoPlayerController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.setVolume(0);
    // await _videoPlayerController.play();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _saveToGallery() async {
    if (_saveVideo) return;

    await GallerySaver.saveVideo(widget.video.path, albumName: "TicTok Clone!");
    //await ImageGallerySaver.saveFile(widget.video.path, name: "TicTok Clone!");
    _saveVideo = true;
    setState(() {});
  }

  void _onUploadPressed() {
    ref.read(timelineProvider.notifier).uploadVideo();
  }

  void _showUploadSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 1),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              Gaps.v10,
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              Gaps.v20,
              ElevatedButton(
                onPressed: () {
                  _title = _titleController.text;
                  _description = _descriptionController.text;
                  Navigator.pop(context);
                  _onUploadPressed();
                },
                child: const Text('Upload Video'),
              ),
            ],
          ),
        ),
      ),
    );
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
          IconButton(
              onPressed: ref.watch(timelineProvider).isLoading
                  ? null
                  : _showUploadSheet,
              icon: ref.watch(timelineProvider).isLoading
                  ? const CircularProgressIndicator()
                  : const FaIcon(FontAwesomeIcons.cloudArrowUp))
        ],
      ),
      body: _videoPlayerController.value.isInitialized
          ? VideoPlayer(_videoPlayerController)
          : null,
    );
  }
}
