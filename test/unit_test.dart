// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiktok_clone/features/videos/models/video_model.dart';

void main() {
  test("Test Video Model Constructor", () {
    final video = VideoModel(
      id: "id",
      title: "title",
      description: "description",
      fileUrl: "fileUrl",
      thumbnailUrl: "thumbnailUrl",
      creatorUid: "creatorUid",
      creator: "creator",
      likes: 1,
      comments: 1,
      createdAt: 1,
    );
  });
}
