import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../config/app_config.dart';
import '../controllers/video_call_controller.dart';

class VideoCallView extends GetView<VideoCallController> {
  const VideoCallView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(alignment: AlignmentDirectional.topEnd, children: [
        Column(
          children: [
            // Container for the local video
            Expanded(
              child: Container(
                  height: 240,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Obx(
                    () => Center(child: _localPreview()),
                  )),
            ),
            const SizedBox(height: 10),
            // Button Row
            Obx(
              () => Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isJoined.value
                          ? null
                          : () => {controller.join()},
                      child: const Text('Join'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isJoined.value
                          ? () => {controller.leave()}
                          : null,
                      child: const Text('Leave'),
                    ),
                  ),
                ],
              ),
            )
            // Button Row ends
          ],
        ),
        //Container for the Remote video
        Positioned(
          right: 24,
          top: 24,
          child: Container(
              height: 128,
              width: 128,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Obx(
                () => Center(child: _remoteVideo()),
              )),
        ),
      ]),
    ));
  }

  // Display local video preview
  Widget _localPreview() {
    if (controller.isJoined.value) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: controller.agoraEngine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    }
  }

// Display remote user's video
  Widget _remoteVideo() {
    if (controller.remoteUid.value != 0) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: controller.agoraEngine,
          canvas: VideoCanvas(uid: controller.remoteUid.value),
          connection:
              const RtcConnection(channelId: AppConfig.AGORA_CHANNEL_ID),
        ),
      );
    } else {
      String msg = '';
      if (controller.isJoined.value) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }
}
