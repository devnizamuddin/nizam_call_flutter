import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/video_call_controller.dart';

class VideoCallView extends GetView<VideoCallController> {
  const VideoCallView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VideoCallView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VideoCallView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
